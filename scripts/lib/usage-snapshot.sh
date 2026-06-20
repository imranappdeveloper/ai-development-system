#!/usr/bin/env bash
# usage-snapshot.sh — telemetry, snapshots, feedback paths, anomaly detection
# Source from usage-feedback.sh or agent shell hooks.

USAGE_FEEDBACK_VERSION="1.0"

_usage_project_root() {
  echo "${USAGE_PROJECT_ROOT:-$(pwd)}"
}

_usage_os_home() {
  if [[ -n "${AI_DEV_OS_HOME_RESOLVED:-}" && -d "${AI_DEV_OS_HOME_RESOLVED}" ]]; then
    echo "${AI_DEV_OS_HOME_RESOLVED}"
  elif [[ -n "${AI_DEV_OS_HOME:-}" && -d "${AI_DEV_OS_HOME}" ]]; then
    echo "${AI_DEV_OS_HOME}"
  else
    echo ""
  fi
}

_usage_rollup_dir() {
  local os_home
  os_home="$(_usage_os_home)"
  if [[ -n "$os_home" ]]; then
    echo "$os_home/.usage"
  else
    echo "${HOME}/.ai-dev-os/usage"
  fi
}

_usage_telemetry_dir() {
  echo "$(_usage_project_root)/work/telemetry"
}

_usage_feedback_dir() {
  echo "$(_usage_project_root)/work/feedback"
}

_usage_snapshots_dir() {
  echo "$(_usage_feedback_dir)/snapshots"
}

_usage_ensure_dirs() {
  mkdir -p "$(_usage_telemetry_dir)" "$(_usage_feedback_dir)" "$(_usage_snapshots_dir)" "$(_usage_rollup_dir)"
}

_usage_ts() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

_usage_date_slug() {
  date -u +%Y-%m-%d
}

_usage_project_slug() {
  basename "$(_usage_project_root)"
}

_usage_config_int() {
  local key="$1"
  local default="$2"
  local project yaml val
  project="$(_usage_project_root)"
  yaml="$project/ai-dev-os.yaml"
  if [[ -f "$yaml" ]]; then
    val="$(grep -E "^[[:space:]]*${key}:[[:space:]]*[0-9]+" "$yaml" 2>/dev/null \
      | grep -E "feedback:|nudge_" -B5 2>/dev/null | tail -1 | sed 's/.*:[[:space:]]*//' || true)"
    # simpler: read feedback block keys
    val="$(awk -v k="$key" '
      /^feedback:/{f=1; next}
      f && /^[a-zA-Z#]/{f=0}
      f && $1 == k":" {gsub(/^[^:]*:[[:space:]]*/,""); print; exit}
    ' "$yaml" 2>/dev/null || true)"
    if [[ -n "$val" && "$val" =~ ^[0-9]+$ ]]; then
      echo "$val"
      return
    fi
  fi
  echo "$default"
}

_usage_next_feedback_id() {
  local dir entries today n
  dir="$(_usage_feedback_dir)"
  today="$(date -u +%Y%m%d)"
  entries="$(grep -c "\"id\":\"FB-${today}-" "$dir/entries.jsonl" 2>/dev/null || echo 0)"
  n=$((entries + 1))
  printf 'FB-%s-%03d' "$today" "$n"
}

_usage_append_jsonl() {
  local file="$1"
  local line="$2"
  mkdir -p "$(dirname "$file")"
  printf '%s\n' "$line" >>"$file"
}

_usage_json_bool() {
  [[ "${1:-false}" == "true" || "${1:-false}" == "1" || "${1:-false}" == "yes" ]] && echo "true" || echo "false"
}

_usage_json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/}"
  printf '%s' "$s"
}

# metrics: grill_questions partial_footer_count lock_doc_approved issues_published
#          prs_opened needs_info_count spec_review_retries queued_at_start
#          afk_stalled task_run_crash
_usage_detect_anomalies() {
  local grill_q="${1:-0}"
  local partial="${2:-0}"
  local lock_ok="${3:-true}"
  local prs="${4:-0}"
  local needs_info="${5:-0}"
  local spec_retry="${6:-0}"
  local queued="${7:-0}"
  local afk_stalled="${8:-false}"
  local crash="${9:-false}"
  local threshold
  threshold="$(_usage_config_int nudge_grill_questions 8)"

  local anomalies=()
  if [[ "$afk_stalled" == "true" || "$afk_stalled" == "1" ]]; then anomalies+=("afk_stall"); fi
  if [[ "${needs_info:-0}" -gt 0 ]]; then anomalies+=("needs_info"); fi
  if [[ "$crash" == "true" || "$crash" == "1" ]]; then anomalies+=("task_run_crash"); fi
  if [[ "$lock_ok" != "true" && "$lock_ok" != "1" && "$lock_ok" != "yes" ]]; then anomalies+=("grill_abandoned"); fi
  if [[ "${partial:-0}" -gt 0 ]]; then anomalies+=("partial_footer"); fi
  if [[ "${grill_q:-0}" -gt "$threshold" ]]; then anomalies+=("grill_questions_high"); fi
  if [[ "${spec_retry:-0}" -gt 0 ]]; then anomalies+=("spec_review_retry"); fi
  if [[ "${queued:-0}" -gt 0 && "${prs:-0}" -eq 0 ]]; then anomalies+=("afk_zero_prs"); fi

  if [[ ${#anomalies[@]} -gt 0 ]]; then
    local IFS=,
    echo "${anomalies[*]}"
  fi
}

_usage_anomalies_to_json_array() {
  local csv="${1:-}"
  if [[ -z "$csv" ]]; then
    echo "[]"
    return
  fi
  local IFS=,
  local parts=($csv)
  local out="["
  local i part
  for i in "${!parts[@]}"; do
    part="${parts[$i]}"
    [[ $i -gt 0 ]] && out+=","
    out+="\"$part\""
  done
  out+="]"
  echo "$out"
}

_usage_record_event() {
  local event_type="$1"
  local skill="${2:-}"
  local milestone="${3:-}"
  local extra="${4:-{}}"
  _usage_ensure_dirs
  local ts slug line
  ts="$(_usage_ts)"
  slug="$(_usage_project_slug)"
  line="{\"ts\":\"$ts\",\"event_type\":\"$(_usage_json_escape "$event_type")\",\"skill\":\"$(_usage_json_escape "$skill")\",\"milestone\":\"$(_usage_json_escape "$milestone")\",\"project_slug\":\"$(_usage_json_escape "$slug")\",\"extra\":$extra}"
  _usage_append_jsonl "$(_usage_telemetry_dir)/events.jsonl" "$line"
}

_usage_write_snapshot() {
  local milestone="$1"
  local grill_q="${2:-0}"
  local partial="${3:-0}"
  local lock_ok="${4:-true}"
  local prs="${5:-0}"
  local needs_info="${6:-0}"
  local spec_retry="${7:-0}"
  local queued="${8:-0}"
  local afk_stalled="${9:-false}"
  local crash="${10:-false}"
  local duration_sec="${11:-0}"
  local skills_csv="${12:-}"
  local issues_published="${13:-0}"

  _usage_ensure_dirs
  local ts date_slug slug anomalies anomaly_json nudge snap_id snap_path
  ts="$(_usage_ts)"
  date_slug="$(_usage_date_slug)"
  slug="$(_usage_project_slug)"
  anomalies="$(_usage_detect_anomalies "$grill_q" "$partial" "$lock_ok" "$prs" "$needs_info" "$spec_retry" "$queued" "$afk_stalled" "$crash")"
  anomaly_json="$(_usage_anomalies_to_json_array "$anomalies")"
  nudge="false"
  [[ -n "$anomalies" ]] && nudge="true"

  snap_id="${date_slug}-${milestone}-${slug}"
  snap_path="$(_usage_snapshots_dir)/${snap_id}.md"

  cat >"$snap_path" <<EOF
# Usage Snapshot — ${milestone}

| Field | Value |
|-------|-------|
| ts | ${ts} |
| milestone | ${milestone} |
| project | ${slug} |
| duration_sec | ${duration_sec} |
| skills | ${skills_csv:-—} |
| grill_questions | ${grill_q} |
| partial_footer_count | ${partial} |
| lock_doc_approved | $(_usage_json_bool "$lock_ok") |
| issues_published | ${issues_published:-0} |
| prs_opened | ${prs} |
| needs_info_count | ${needs_info} |
| spec_review_retries | ${spec_retry} |
| nudge | ${nudge} |

## Anomalies

$(if [[ -n "$anomalies" ]]; then echo "$anomalies" | tr ',' '\n' | sed 's/^/- /'; else echo "- none"; fi)

## Summary

$( _usage_snapshot_summary "$milestone" "$grill_q" "$partial" "$prs" "$needs_info" "$anomalies" )
EOF

  local event_line
  event_line="{\"ts\":\"$ts\",\"event_type\":\"milestone_snapshot\",\"milestone\":\"$(_usage_json_escape "$milestone")\",\"skill\":null,\"project_slug\":\"$(_usage_json_escape "$slug")\",\"duration_sec\":${duration_sec},\"metrics\":{\"grill_questions\":${grill_q},\"partial_footer_count\":${partial},\"lock_doc_approved\":$(_usage_json_bool "$lock_ok"),\"issues_published\":${issues_published:-0},\"prs_opened\":${prs},\"needs_info_count\":${needs_info},\"spec_review_retries\":${spec_retry},\"queued_at_start\":${queued},\"afk_stalled\":$(_usage_json_bool "$afk_stalled"),\"task_run_crash\":$(_usage_json_bool "$crash")},\"anomalies\":${anomaly_json},\"nudge\":${nudge}}"
  _usage_append_jsonl "$(_usage_telemetry_dir)/events.jsonl" "$event_line"

  _usage_sync_rollup_line "$milestone" "$duration_sec" "$anomaly_json" "$nudge" "$grill_q" "$partial" "$prs" "$needs_info"

  echo "$snap_path"
  if [[ "$nudge" == "true" ]]; then
    echo "NUDGE: Anything to flag? Run /feedback or reply skip."
  fi
}

_usage_snapshot_summary() {
  local milestone="$1" grill_q="$2" partial="$3" prs="$4" needs_info="$5" anomalies="$6"
  case "$milestone" in
    grill)
      if [[ -n "$anomalies" ]]; then
        echo "Grill session completed with anomalies. Review lock doc and question count."
      else
        echo "Grill session completed cleanly."
      fi
      ;;
    tasks-published)
      echo "Tasks published. Ready for AFK or further review."
      ;;
    afk-run)
      echo "AFK run finished: ${prs} PR(s) opened, ${needs_info} needs-info."
      ;;
    *)
      echo "Milestone ${milestone} recorded."
      ;;
  esac
}

_usage_sync_rollup_line() {
  local milestone="$1" duration="$2" anomaly_json="$3" nudge="$4"
  local grill_q="$5" partial="$6" prs="$7" needs_info="$8"
  local rollup_dir ts slug line
  rollup_dir="$(_usage_rollup_dir)"
  mkdir -p "$rollup_dir"
  ts="$(_usage_ts)"
  slug="$(_usage_project_slug)"
  line="{\"ts\":\"$ts\",\"project_slug\":\"$(_usage_json_escape "$slug")\",\"milestone\":\"$(_usage_json_escape "$milestone")\",\"duration_sec\":${duration},\"grill_questions\":${grill_q},\"partial_footer_count\":${partial},\"prs_opened\":${prs},\"needs_info_count\":${needs_info},\"anomalies\":${anomaly_json},\"nudge\":${nudge}}"
  _usage_append_jsonl "$rollup_dir/rollup.jsonl" "$line"
}

_usage_append_feedback() {
  local category="$1"
  local severity="$2"
  local text="$3"
  local skill="${4:-}"
  local milestone="${5:-}"
  local open_issue="${6:-false}"

  _usage_ensure_dirs
  local ts id slug line issue_num=""
  ts="$(_usage_ts)"
  id="$(_usage_next_feedback_id)"
  slug="$(_usage_project_slug)"
  line="{\"id\":\"$id\",\"ts\":\"$ts\",\"category\":\"$(_usage_json_escape "$category")\",\"severity\":\"$(_usage_json_escape "$severity")\",\"skill\":\"$(_usage_json_escape "$skill")\",\"milestone\":\"$(_usage_json_escape "$milestone")\",\"text\":\"$(_usage_json_escape "$text")\",\"github_issue\":null,\"snapshot_ref\":null}"
  _usage_append_jsonl "$(_usage_feedback_dir)/entries.jsonl" "$line"

  _usage_sync_feedback_rollup "$id" "$category" "$severity" "$skill" "$milestone"

  if [[ "$open_issue" == "true" || "$open_issue" == "1" || "$severity" == "high" ]]; then
    if command -v gh >/dev/null 2>&1; then
      issue_num="$(gh issue create \
        --title "[OS feedback] ${category}: ${text:0:60}" \
        --body "**Feedback ID:** ${id}
**Category:** ${category}
**Severity:** ${severity}
**Skill:** ${skill:-n/a}
**Milestone:** ${milestone:-n/a}

${text}

---
_Logged via /feedback — work/feedback/entries.jsonl_" 2>/dev/null | grep -oE '[0-9]+$' || true)"
      if [[ -n "$issue_num" ]]; then
        echo "ISSUE:#${issue_num}"
      fi
    fi
  fi

  echo "ENTRY:${id}"
}

_usage_sync_feedback_rollup() {
  local id="$1" category="$2" severity="$3" skill="$4" milestone="$5"
  local rollup_dir ts slug line
  rollup_dir="$(_usage_rollup_dir)"
  mkdir -p "$rollup_dir"
  ts="$(_usage_ts)"
  slug="$(_usage_project_slug)"
  line="{\"ts\":\"$ts\",\"type\":\"feedback\",\"project_slug\":\"$(_usage_json_escape "$slug")\",\"feedback_id\":\"$id\",\"category\":\"$(_usage_json_escape "$category")\",\"severity\":\"$(_usage_json_escape "$severity")\",\"skill\":\"$(_usage_json_escape "$skill")\",\"milestone\":\"$(_usage_json_escape "$milestone")\"}"
  _usage_append_jsonl "$rollup_dir/rollup.jsonl" "$line"
}

_usage_count_lines() {
  local file="$1"
  [[ -f "$file" ]] || { echo 0; return; }
  wc -l <"$file" | tr -d ' '
}

_usage_count_anomalous_snapshots() {
  local dir="$(_usage_snapshots_dir)"
  local count=0
  local f
  [[ -d "$dir" ]] || { echo 0; return; }
  for f in "$dir"/*.md; do
    [[ -f "$f" ]] || continue
    if grep -q '| nudge | true |' "$f" 2>/dev/null; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

_usage_meta_review_eligible() {
  local feedback_count anomalous first_ts now weeks
  feedback_count="$(_usage_count_lines "$(_usage_feedback_dir)/entries.jsonl")"
  anomalous="$(_usage_count_anomalous_snapshots)"
  local rollup="$(_usage_rollup_dir)/rollup.jsonl"
  first_ts=""
  if [[ -f "$rollup" ]]; then
    first_ts="$(head -1 "$rollup" | sed -n 's/.*"ts":"\([^"]*\)".*/\1/p')"
  fi
  if [[ -z "$first_ts" ]]; then
    echo "false|0|0|0"
    return
  fi
  now="$(date -u +%s)"
  local first_epoch
  first_epoch="$(date -d "$first_ts" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$first_ts" +%s 2>/dev/null || echo 0)"
  weeks=0
  if [[ "$first_epoch" -gt 0 ]]; then
    weeks=$(( (now - first_epoch) / 604800 ))
  fi
  if [[ "$weeks" -ge 4 && ( "$feedback_count" -ge 10 || "$anomalous" -ge 5 ) ]]; then
    echo "true|${weeks}|${feedback_count}|${anomalous}"
  else
    echo "false|${weeks}|${feedback_count}|${anomalous}"
  fi
}

_usage_generate_report() {
  _usage_ensure_dirs
  local slug fb_count ev_count snap_count anom eligible meta
  slug="$(_usage_project_slug)"
  fb_count="$(_usage_count_lines "$(_usage_feedback_dir)/entries.jsonl")"
  ev_count="$(_usage_count_lines "$(_usage_telemetry_dir)/events.jsonl")"
  snap_count="$(_usage_count_lines "$(dirname "$(_usage_snapshots_dir)")/entries.jsonl" 2>/dev/null || echo 0)"
  snap_count="$(find "$(_usage_snapshots_dir)" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
  anom="$(_usage_count_anomalous_snapshots)"
  meta="$(_usage_meta_review_eligible)"
  eligible="${meta%%|*}"

  cat <<EOF
# Usage Report — ${slug}

| Metric | Value |
|--------|-------|
| Feedback entries | ${fb_count} |
| Telemetry events | ${ev_count} |
| Snapshots | ${snap_count} |
| Anomalous snapshots | ${anom} |
| Meta-review eligible | ${eligible} |

## Project paths

- Telemetry: work/telemetry/events.jsonl
- Feedback: work/feedback/entries.jsonl
- Snapshots: work/feedback/snapshots/

## OS rollup

- $(_usage_rollup_dir)/rollup.jsonl

## Recent snapshots

$(find "$(_usage_snapshots_dir)" -name '*.md' 2>/dev/null | sort | tail -5 | while read -r f; do echo "- ${f#"$(_usage_project_root)/"}"; done)

## Recommendations (agent)

Read entries and anomalous snapshots. Propose concrete OS skill/doc changes.
User must approve before editing \$AI_DEV_OS_HOME.
Meta-skill auto-review: ${eligible} (needs ≥4 weeks AND ≥10 feedback OR ≥5 anomalous snapshots).
EOF
}