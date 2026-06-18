#!/usr/bin/env bash
# task-run-session.sh — tmux session health, GitHub queue signals, stale recovery
# Source from task-run-server.sh / task-run-poll.sh

TASK_RUN_STALE_MINUTES="${TASK_RUN_STALE_MINUTES:-45}"

_task_run_slug() {
  local epic="${1:-}"
  if [[ -n "$epic" ]]; then
    echo "epic-${epic}"
  else
    echo "ready"
  fi
}

_task_run_session_name() {
  echo "task-run-$(_task_run_slug "$1")"
}

_task_run_handoff_dir() {
  echo "${1:-.}/work/task-run"
}

_task_run_log_file() {
  local project="$1"
  local slug="$2"
  local agent="$3"
  echo "$(_task_run_handoff_dir "$project")/${slug}-${agent}.log"
}

_task_run_started_marker() {
  local project="$1"
  local slug="$2"
  echo "$(_task_run_handoff_dir "$project")/${slug}.started"
}

_task_run_count_issues() {
  local label="$1"
  gh issue list --label "$label" --state open --limit 100 \
    --json number --jq 'length' 2>/dev/null || echo "0"
}

_task_run_count_ready() {
  _task_run_count_issues "ready-for-agent"
}

_task_run_count_pr_open() {
  # Legacy label — repair to done on state sync; not a merge-wait signal
  _task_run_count_issues "pr-open"
}

_task_run_pane_has_agent() {
  local session="$1"
  local pane_pid
  pane_pid="$(tmux list-panes -t "$session" -F '#{pane_pid}' 2>/dev/null | head -1 || true)"
  [[ -n "$pane_pid" ]] || return 1
  local pids
  pids="$(pstree -p "$pane_pid" 2>/dev/null | grep -oE '[0-9]+' | sort -u || true)"
  local pid
  for pid in $pids; do
    local comm
    comm="$(ps -p "$pid" -o comm= 2>/dev/null | tr -d ' ' || true)"
    case "$comm" in
      grok|agy|node|python3) return 0 ;;
    esac
    # agy may run as node child
    if ps -p "$pid" -o args= 2>/dev/null | grep -qE '(grok|agy|--always-approve|--dangerously-skip-permissions)'; then
      return 0
    fi
  done
  return 1
}

_task_run_log_recent() {
  local log_file="$1"
  local max_min="${2:-$TASK_RUN_STALE_MINUTES}"
  [[ -f "$log_file" ]] || return 1
  local now mtime age
  now="$(date +%s)"
  mtime="$(stat -c %Y "$log_file" 2>/dev/null || stat -f %m "$log_file" 2>/dev/null || echo 0)"
  age=$(( (now - mtime) / 60 ))
  [[ "$age" -le "$max_min" ]]
}

# Prints: none | healthy | stale
_task_run_session_health() {
  local session="$1"
  local log_file="${2:-}"

  if ! tmux has-session -t "$session" 2>/dev/null; then
    echo "none"
    return 0
  fi

  if _task_run_pane_has_agent "$session"; then
    echo "healthy"
    return 0
  fi

  if [[ -n "$log_file" ]] && _task_run_log_recent "$log_file"; then
    echo "healthy"
    return 0
  fi

  echo "stale"
}

_task_run_kill_session() {
  local session="$1"
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux kill-session -t "$session" 2>/dev/null || true
    return 0
  fi
  return 1
}

# Decide poll/server restart mode: fresh | continue | skip
_task_run_poll_action() {
  local project="$1"
  local slug="$2"
  local health="$3"
  local ready="${4:-0}"
  local marker
  marker="$(_task_run_started_marker "$project" "$slug")"

  if [[ "$health" == "healthy" ]]; then
    echo "skip"
    return 0
  fi

  if [[ "${ready:-0}" -gt 0 ]]; then
    if [[ -f "$marker" ]]; then
      echo "continue"
    else
      echo "fresh"
    fi
    return 0
  fi

  echo "skip"
}

_task_run_touch_started() {
  local project="$1"
  local slug="$2"
  mkdir -p "$(_task_run_handoff_dir "$project")"
  date -u +%Y-%m-%dT%H:%M:%SZ >"$(_task_run_started_marker "$project" "$slug")"
}