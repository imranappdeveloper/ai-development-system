#!/usr/bin/env bash
# afk-state-sync.sh — AFK issue label / PR state recovery (deterministic)

_afk_sync_issue_labels() {
  local json="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.labels[].name' <<<"$json" 2>/dev/null | tr '\n' ' '
    return
  fi
  gh issue view --json labels -q '.labels[].name' <<<"$json" 2>/dev/null || echo ""
}

_afk_sync_pr_state() {
  local issue_num="$1"
  local pr_json
  if [[ -n "${AFK_SYNC_PR_FIXTURE:-}" ]]; then
    # fixture format per issue: OPEN|MERGED|CLOSED|NONE
    local key="issue_${issue_num}"
    local val
    val="$(grep -E "^${key}=" "$AFK_SYNC_PR_FIXTURE" 2>/dev/null | cut -d= -f2- || echo NONE)"
    echo "$val"
    return
  fi
  pr_json="$(gh pr list --search "closes #${issue_num}" --state all \
    --json number,state,mergedAt,headRefName,url --limit 5 2>/dev/null || echo '[]')"
  if command -v jq >/dev/null 2>&1; then
    local state
    state="$(jq -r '.[0].state // "NONE"' <<<"$pr_json")"
    if [[ "$state" == "MERGED" ]]; then
      echo "MERGED"
    elif [[ "$state" == "OPEN" ]]; then
      echo "OPEN"
    elif [[ "$state" == "CLOSED" ]]; then
      echo "CLOSED"
    else
      echo "NONE"
    fi
    return
  fi
  if grep -q '"state":"OPEN"' <<<"$pr_json" 2>/dev/null; then echo "OPEN"
  elif grep -q '"state":"MERGED"' <<<"$pr_json" 2>/dev/null; then echo "MERGED"
  elif grep -q '"state":"CLOSED"' <<<"$pr_json" 2>/dev/null; then echo "CLOSED"
  else echo "NONE"
  fi
}

_afk_sync_has_label() {
  local labels="$1"
  local want="$2"
  grep -qwF "$want" <<<"$labels"
}

_afk_sync_plan_action() {
  local labels="$1"
  local pr_state="$2"
  local actions=()

  if _afk_sync_has_label "$labels" "done"; then
    case "$pr_state" in
      OPEN|MERGED) actions+=("noop:done-ok") ;;
      CLOSED) actions+=("reopen:remove-done,add-ready-for-agent,comment-pr-closed-unmerged") ;;
      NONE) actions+=("noop:done-no-pr") ;;
    esac
  elif _afk_sync_has_label "$labels" "pr-open"; then
    case "$pr_state" in
      OPEN|MERGED) actions+=("repair:add-done,remove-pr-open") ;;
      *) actions+=("noop:pr-open-no-matching-pr") ;;
    esac
  elif _afk_sync_has_label "$labels" "in-progress"; then
    case "$pr_state" in
      OPEN|MERGED) actions+=("repair:add-done,remove-in-progress") ;;
      NONE) actions+=("recover:remove-in-progress,add-ready-for-agent,comment-stuck") ;;
      CLOSED) actions+=("recover:remove-in-progress,add-ready-for-agent,comment-stuck") ;;
    esac
  else
    actions+=("noop:no-sync-labels")
  fi

  local IFS=';'
  echo "${actions[*]}"
}

_afk_sync_apply_action() {
  local issue_num="$1"
  local action="$2"
  local apply="${3:-false}"

  case "$action" in
    noop:*)
      echo "  #$issue_num: ${action#noop:}"
      ;;
    reopen:*|repair:*|recover:*)
      echo "  #$issue_num: ${action%%:*} — ${action#*:}"
      if [[ "$apply" == "true" ]]; then
        case "$action" in
          reopen:*)
            gh issue edit "$issue_num" --remove-label done --add-label ready-for-agent
            gh issue comment "$issue_num" --body "PR closed unmerged — re-run work"
            ;;
          repair:add-done,remove-pr-open)
            gh issue edit "$issue_num" --add-label done --remove-label pr-open
            ;;
          repair:add-done,remove-in-progress)
            gh issue edit "$issue_num" --add-label done --remove-label in-progress
            ;;
          recover:remove-in-progress,add-ready-for-agent,comment-stuck)
            gh issue edit "$issue_num" --remove-label in-progress --add-label ready-for-agent
            gh issue comment "$issue_num" --body "Recovered stuck in-progress — no open PR found. Re-run work-to-pr-v2."
            ;;
          *)
            echo "WARN: unhandled apply action: $action" >&2
            ;;
        esac
      fi
      ;;
    *)
      echo "  #$issue_num: unknown action $action" >&2
      ;;
  esac
}

_afk_sync_run() {
  local issues_csv="$1"
  local apply="${2:-false}"
  local done_ok=0 reopened=0 recovered=0

  echo "State sync:"
  IFS=',' read -ra ISSUE_ARR <<<"$issues_csv"
  for raw in "${ISSUE_ARR[@]}"; do
    local n="${raw// /}"
    [[ -z "$n" ]] && continue
    local labels pr_state action plan
    if [[ -n "${AFK_SYNC_LABEL_FIXTURE:-}" && -f "$AFK_SYNC_LABEL_FIXTURE" ]]; then
      labels="$(grep -E "^issue_${n}=" "$AFK_SYNC_LABEL_FIXTURE" | cut -d= -f2- || echo "")"
    else
      labels="$(gh issue view "$n" --json labels -q '.labels[].name' 2>/dev/null | tr '\n' ' ')"
    fi
    pr_state="$(_afk_sync_pr_state "$n")"
    plan="$(_afk_sync_plan_action "$labels" "$pr_state")"
    IFS=';' read -ra acts <<<"$plan"
    for act in "${acts[@]}"; do
      [[ -z "$act" ]] && continue
      _afk_sync_apply_action "$n" "$act" "$apply"
      case "$act" in
        noop:done-ok|noop:done-no-pr) done_ok=$((done_ok + 1)) ;;
        reopen:*) reopened=$((reopened + 1)) ;;
        recover:*) recovered=$((recovered + 1)) ;;
      esac
    done
  done
  echo "State sync summary: ${done_ok} done (ok), ${reopened} reopened, ${recovered} recovered stuck in-progress"
}