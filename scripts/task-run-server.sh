#!/usr/bin/env bash
# task-run-server.sh — server-only AFK: tmux + grok|agy + all ready tickets
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

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }
warn() { echo "  WARN: $1"; }

usage() {
  cat <<EOF
Task Run Server — AFK on Ubuntu/server only

Usage:
  $(basename "$0") [--agent grok|agy]              All ready-for-agent issues
  $(basename "$0") --agent agy --epic <N>            Epic #N children only
  $(basename "$0") --epic <N> --continue             Resume after interruption (optional)
  $(basename "$0") --attach                          Attach to running session
  $(basename "$0") --status                          Session health + queue
  $(basename "$0") --stop                            Kill tmux session

Auto-poll: task-run-poll.sh (cron/systemd)
Skill: \$AI_DEV_OS_HOME/skills/task-run/SKILL.md
EOF
}

EPIC=""
CONTINUE=""
ATTACH=false
STATUS=false
STOP=false
FORCE=false
AGENT_FLAG=""

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
    --continue) CONTINUE=" --continue"; shift ;;
    --attach) ATTACH=true; shift ;;
    --status) STATUS=true; shift ;;
    --stop) STOP=true; shift ;;
    --force) FORCE=true; shift ;;
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
command -v tmux >/dev/null 2>&1 || die "tmux required for server AFK"
command -v gh >/dev/null 2>&1 || die "gh CLI required"

AGENT="$(_task_run_resolve_agent "$PROJECT_ROOT" "$AGENT_FLAG")"
_task_run_verify_agent "$AGENT"

SLUG="$(_task_run_slug "$EPIC")"
SESSION="$(_task_run_session_name "$EPIC")"
HANDOFF_DIR="$(_task_run_handoff_dir "$PROJECT_ROOT")"
mkdir -p "$HANDOFF_DIR"
PROMPT_FILE="$HANDOFF_DIR/${SLUG}-prompt.txt"
LOG_FILE="$(_task_run_log_file "$PROJECT_ROOT" "$SLUG" "$AGENT")"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
AGENT_LABEL="$(_task_run_agent_label "$AGENT")"

if [[ -n "$EPIC" ]]; then
  INVOCATION="/task-run ${EPIC} --server${CONTINUE}"
else
  INVOCATION="/task-run --ready --server${CONTINUE}"
fi

HEALTH="$(_task_run_session_health "$SESSION" "$LOG_FILE")"
READY_COUNT="$(_task_run_count_ready)"
LEGACY_PR_OPEN="$(_task_run_count_pr_open)"

if [[ "$STOP" == true ]]; then
  echo "=== Task Run Server — stop ==="
  if [[ "$HEALTH" == "none" ]]; then
    info "No session: $SESSION"
    exit 0
  fi
  _task_run_kill_session "$SESSION"
  info "Killed session: $SESSION"
  exit 0
fi

if [[ "$STATUS" == true ]]; then
  echo "=== Task Run Server — status ==="
  info "Project: $PROJECT_ROOT"
  info "Agent: $AGENT_LABEL ($AGENT)"
  info "Session: $SESSION"
  info "Health: $HEALTH (stale after ${TASK_RUN_STALE_MINUTES}m idle log)"
  info "ready-for-agent: $READY_COUNT"
  [[ "${LEGACY_PR_OPEN:-0}" -gt 0 ]] && info "legacy pr-open (repair on state sync): $LEGACY_PR_OPEN"
  [[ -f "$LOG_FILE" ]] && info "log: $LOG_FILE"
  [[ -f "$(_task_run_started_marker "$PROJECT_ROOT" "$SLUG")" ]] && info "prior run: yes (--continue on poll restart)"
  case "$HEALTH" in
    healthy) info "action: none — agent running" ;;
    stale) info "action: run task-run-poll.sh or --stop then restart" ;;
    none)
      action="$(_task_run_poll_action "$PROJECT_ROOT" "$SLUG" "$HEALTH" "$READY_COUNT")"
      info "action: $action"
      ;;
  esac
  exit 0
fi

if [[ "$ATTACH" == true ]]; then
  tmux has-session -t "$SESSION" 2>/dev/null || die "No session: $SESSION (run without --attach first)"
  exec tmux attach -t "$SESSION"
fi

if [[ "$HEALTH" == "healthy" && "$FORCE" != true ]]; then
  info "Session healthy: $SESSION — use --attach or --force to restart"
  exit 0
fi

if [[ "$HEALTH" == "stale" ]]; then
  warn "Stale session $SESSION — killing before restart"
  _task_run_kill_session "$SESSION"
fi

{
  cat <<EOF
${INVOCATION}
project_root: ${PROJECT_ROOT}
AI_DEV_OS_HOME: ${AI_DEV_OS_HOME:-$OS_HOME}

Run as task manager until queue empty. Autonomous — no questions.
Load: \$AI_DEV_OS_HOME/skills/task-run/SKILL.md
Process all unblocked ready-for-agent issues. Server mode: up to 3 parallel via worktrees.
EOF
  _task_run_prompt_suffix "$AGENT"
} >"$PROMPT_FILE"

HANDOFF_FILE="$HANDOFF_DIR/${SLUG}-handoff.md"
cat >"$HANDOFF_FILE" <<EOF
# Task run server — ${SLUG}
Generated: ${TS}
Project: ${PROJECT_ROOT}
Agent: **${AGENT_LABEL}** (\`${AGENT}\`)
Mode: **server only** (tmux + auto-start)

## Session

- tmux: \`${SESSION}\`
- log: \`${LOG_FILE}\`
- prompt: \`${PROMPT_FILE}\`

## Commands

\`\`\`bash
task-run-server.sh --agent ${AGENT} --attach
task-run-server.sh --agent ${AGENT} --status
task-run-server.sh --agent ${AGENT} --stop
task-run-poll.sh --agent ${AGENT}
\`\`\`

## Resume after interruption (optional)

\`\`\`bash
task-run-server.sh --agent ${AGENT}${EPIC:+ --epic ${EPIC}} --continue
\`\`\`

Ready: ${READY_COUNT}
EOF

EXEC_LINE="$(_task_run_agent_exec_line "$AGENT" "$PROMPT_FILE")"
RUNNER="$HANDOFF_DIR/${SLUG}-${AGENT}-runner.sh"
cat >"$RUNNER" <<RUNNER
#!/usr/bin/env bash
set -euo pipefail
cd "$PROJECT_ROOT"
export AI_DEV_OS_HOME="${AI_DEV_OS_HOME:-$OS_HOME}"
export PATH="\$HOME/.local/bin:\$PATH"
echo "=== Task Run Server — ${AGENT} starting ==="
echo "Agent: ${AGENT_LABEL}"
echo "Invocation: ${INVOCATION}"
echo "Log: ${LOG_FILE}"
echo ""
${EXEC_LINE} 2>&1 | tee -a "$LOG_FILE"
RUNNER
chmod +x "$RUNNER"

echo "=== Task Run Server ==="
info "Project: $PROJECT_ROOT"
info "Agent: $AGENT_LABEL"
info "Mode: server (parallel ≤3)"
info "Queue: ${EPIC:+epic #${EPIC}}${EPIC:-all ready-for-agent}"
info "Ready: $READY_COUNT"

_task_run_touch_started "$PROJECT_ROOT" "$SLUG"
tmux new-session -d -s "$SESSION" -c "$PROJECT_ROOT" "$RUNNER"
info "tmux started: $SESSION"
info "Log: $LOG_FILE"
info "Attach: task-run-server.sh --attach"
echo ""
cat "$HANDOFF_FILE"