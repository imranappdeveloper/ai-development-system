#!/usr/bin/env bash
# ai-pr-review-notify.sh — parse AFK review output; post PR flag + issue one-liner

_ai_pr_review_count_bugs() {
  local review_file="$1"
  local count
  [[ -f "$review_file" ]] || { echo 0; return; }
  count="$(grep -cE '^### Issue [0-9]+ -- Severity: bug$' "$review_file" 2>/dev/null || true)"
  echo "${count:-0}"
}

_ai_pr_review_recommendation() {
  local review_file="$1"
  local bugs="$2"
  local rec=""

  if [[ -f "$review_file" ]]; then
    rec="$(awk '
      /^### Recommendation/ { show=1; next }
      show && /^### / { exit }
      show && /^## / { exit }
      show && NF { print; exit }
    ' "$review_file" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if [[ -z "$rec" ]]; then
      rec="$(grep -E '^(✅|⚠️).*(Safe to merge|Fix before merge)' "$review_file" | head -1 | sed 's/^[[:space:]]*//')"
    fi
  fi

  if [[ "$bugs" -gt 0 ]]; then
    echo "⚠️ Fix before merge"
  elif [[ -n "$rec" ]]; then
    if [[ "$rec" == *"Fix before merge"* ]] || [[ "$rec" == *"⚠️"* ]]; then
      echo "⚠️ Fix before merge"
    elif [[ "$rec" == *"Safe to merge"* ]] || [[ "$rec" == *"✅"* ]]; then
      echo "✅ Safe to merge"
    else
      echo "$rec"
    fi
  else
    echo "✅ Safe to merge"
  fi
}

_ai_pr_review_issue_body() {
  local pr_url="$1"
  local ai_line="$2"
  cat <<EOF
> *Task complete — PR ready for review.*

${pr_url}

AI review: ${ai_line}

Submit the PENDING review on the PR Files tab when ready.

Human: merge when ready. Agent queue continues — dependents unblocked.
EOF
}

_ai_pr_review_post_notifications() {
  local issue="$1"
  local pr_number="$2"
  local pr_url="$3"
  local review_file="${4:-}"
  local skipped="${5:-false}"

  local bugs=0 ai_line body

  if [[ "$skipped" == "true" ]]; then
    ai_line="skipped — please review manually"
    gh pr comment "$pr_number" --body "⚠️ **AI review skipped** — please review this PR manually." >/dev/null
  else
    bugs="$(_ai_pr_review_count_bugs "$review_file")"
    ai_line="$(_ai_pr_review_recommendation "$review_file" "$bugs")"
    if [[ "$bugs" -gt 0 ]]; then
      gh pr comment "$pr_number" --body "⚠️ **AI review: fix before merge** — ${bugs} bug(s) found. See the PENDING review on the Files tab." >/dev/null
    fi
  fi

  body="$(_ai_pr_review_issue_body "$pr_url" "$ai_line")"
  gh issue comment "$issue" --body "$body" >/dev/null

  echo "bugs=${bugs} ai_review=${ai_line}"
}