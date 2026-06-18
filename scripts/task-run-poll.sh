#!/usr/bin/env bash
# task-run-poll.sh — cron/systemd: start/resume task-run-server when work is queued
#
# Usage:
#   task-run-poll.sh [--agent grok|agy] [--epic N] [--dry-run]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"
LIB_AGENT="$OS_HOME/scripts/lib/task-run-agent.sh"
LIB_SESSION="$OS_HOME/scripts/lib/task-run-session.sh"
SERVER="$OS_HOME/scripts/task-run-server.sh"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }
warn() { echo "  WARN: $1"; }

usage() {
  cat <<EOF
Task Run Poll — auto-start/resume server AFK

Usage:
  $(basename "$0") [--agent grok|agy] [--epic N] [--dry-run]

Behaviour:
  - healthy tmux session → skip
  - stale session → kill, then restart if work queued
  - ready-for-agent > 0 → start (or --continue if prior run — state sync only)

Cron (every 15 min):
  */15 * * * * cd /path/to/project && task-run-poll.sh --agent agy >> work/task-run/poll.log 2>&1

Env:
  TASK_RUN_AGENT=grok|agy
  TASK_RUN_STALE_MINUTES=45
EOF
}

AGENT_FLAG=""
EPIC=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --agent)
      [[ $# -ge 2 ]] || die "--agent requires grok or agy"
      AGENT_FLAG="$2"
      shift 2
      ;;
    --epic)
      [[ $# -ge 2 ]] || die "--epic requires a number"
      EPIC="$2"
      shift 2
      ;;
    --dry-run) DRY_RUN=true; shift ;;
    -*) die "Unknown option: $1" ;;
    *) die "Unexpected argument: $1" ;;
  esac
done

[[ -f "$LIB_AGENT" ]] || die "Missing: $LIB_AGENT"
[[ -f "$LIB_SESSION" ]] || die "Missing: $LIB_SESSION"
# shellcheck source=scripts/lib/task-run-agent.sh
source "$LIB_AGENT"
# shellcheck source=scripts/lib/task-run-session.sh
source "$LIB_SESSION"

PROJECT_ROOT="$(pwd)"
[[ -d "$PROJECT_ROOT/.git" ]] || die "Not a git repo: $PROJECT_ROOT"
command -v gh >/dev/null 2>&1 || die "gh CLI required"
[[ -x "$SERVER" ]] || die "Missing: $SERVER"

AGENT="$(_task_run_resolve_agent "$PROJECT_ROOT" "$AGENT_FLAG")"
_task_run_verify_agent "$AGENT"

SLUG="$(_task_run_slug "$EPIC")"
SESSION="$(_task_run_session_name "$EPIC")"
LOG_FILE="$(_task_run_log_file "$PROJECT_ROOT" "$SLUG" "$AGENT")"
HANDOFF_DIR="$(_task_run_handoff_dir "$PROJECT_ROOT")"
mkdir -p "$HANDOFF_DIR"
POLL_LOG="$HANDOFF_DIR/poll.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

READY_COUNT="$(_task_run_count_ready)"
HEALTH="$(_task_run_session_health "$SESSION" "$LOG_FILE")"
ACTION="$(_task_run_poll_action "$PROJECT_ROOT" "$SLUG" "$HEALTH" "$READY_COUNT")"

{
  echo "[$TS] poll project=$PROJECT_ROOT agent=$AGENT health=$HEALTH ready=$READY_COUNT action=$ACTION session=$SESSION"
} >>"$POLL_LOG"

if [[ "$ACTION" == "skip" ]]; then
  [[ "$HEALTH" == "healthy" ]] && info "session healthy ($SESSION) — skip"
  exit 0
fi

if [[ "$HEALTH" == "stale" ]]; then
  warn "stale session $SESSION — killing"
  if [[ "$DRY_RUN" != true ]]; then
    _task_run_kill_session "$SESSION"
  fi
fi

echo "=== Task Run Poll ==="
info "Health: $HEALTH → action: $ACTION"
info "Ready: $READY_COUNT"
info "Agent: $(_task_run_agent_label "$AGENT")"

ARGS=(--agent "$AGENT" --force)
[[ -n "$EPIC" ]] && ARGS+=(--epic "$EPIC")
if [[ "$ACTION" == "continue" ]]; then
  ARGS+=(--continue)
  info "Starting: task-run-server.sh ${ARGS[*]}"
else
  info "Starting: task-run-server.sh ${ARGS[*]}"
fi

if [[ "$DRY_RUN" == true ]]; then
  info "dry-run — would run task-run-server.sh"
  exit 0
fi

"$SERVER" "${ARGS[@]}"