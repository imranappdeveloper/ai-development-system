#!/usr/bin/env bash
# task-run.sh — prepare AFK task manager handoff (prefer task-run-server.sh on server)
#
# Server implementation: use task-run-server.sh (tmux + grok auto-start).
# This script writes handoff files only — for manual grok paste if needed.
#
# Usage:
#   task-run-server.sh                      # preferred — all ready tickets
#   task-run-server.sh --epic <N>           # preferred — one epic
#   task-run.sh <epic> --server [--continue] [--detach]
#   task-run.sh --ready --server [--detach]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

usage() {
  cat <<EOF
Task Run — AFK handoff helper

Prepares a new Grok chat prompt for /task-run (task manager).

Usage:
  $(basename "$0") <epic> --local [--continue]
  $(basename "$0") <epic> --server [--continue] [--detach]
  $(basename "$0") --ready --local|--server [--detach]

  --server    Parallel up to 3 — Ubuntu server AFK (required for batch code)
  --continue  Resume after interruption (state sync; loop does not wait for merges)
  --detach    Start tmux session (prints handoff — use task-run-server.sh to auto-run grok)

Batch implementation runs on server only. Use: task-run-server.sh

Skill: \$AI_DEV_OS_HOME/skills/task-run/SKILL.md
EOF
}

EPIC=""
MODE=""
CONTINUE=""
DETACH=false
READY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --local) MODE="local"; shift ;;
    --server) MODE="server"; shift ;;
    --continue) CONTINUE="--continue"; shift ;;
    --detach) DETACH=true; shift ;;
    --ready) READY=true; shift ;;
    -*) die "Unknown option: $1" ;;
    *)
      if [[ -z "$EPIC" && "$READY" == false ]]; then
        EPIC="$1"
      else
        die "Unexpected argument: $1"
      fi
      shift
      ;;
  esac
done

[[ -n "$MODE" ]] || die "Specify --server (batch code runs on server — use task-run-server.sh)"
if [[ "$MODE" == "local" ]]; then
  echo "WARN: --local is deprecated. Batch implementation runs on server only." >&2
  echo "      Use: task-run-server.sh" >&2
fi
PROJECT_ROOT="$(pwd)"
[[ -d "$PROJECT_ROOT/.git" ]] || die "Not a git repo: $PROJECT_ROOT"
command -v gh >/dev/null 2>&1 || die "gh CLI required for task-run"

if [[ "$READY" == true ]]; then
  INVOCATION="/task-run --ready --${MODE}"
  SLUG="ready"
else
  [[ -n "$EPIC" ]] || die "Epic number required (or use --ready)"
  INVOCATION="/task-run ${EPIC} --${MODE}${CONTINUE}"
  SLUG="epic-${EPIC}"
fi

HANDOFF_DIR="$PROJECT_ROOT/work/task-run"
mkdir -p "$HANDOFF_DIR"
HANDOFF_FILE="$HANDOFF_DIR/${SLUG}-handoff.md"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat > "$HANDOFF_FILE" <<EOF
# Task run handoff — ${SLUG}
Generated: ${TS}
Project: ${PROJECT_ROOT}

## Paste into NEW Grok chat

\`\`\`text
${INVOCATION}
project_root: ${PROJECT_ROOT}
AI_DEV_OS_HOME: ${AI_DEV_OS_HOME:-$OS_HOME}

Run as task manager until queue empty. Autonomous — no questions.
Load: \$AI_DEV_OS_HOME/skills/task-run/SKILL.md
\`\`\`

## Human phase complete

- Issues published with dependencies
- User chose: **${MODE}**${CONTINUE:+ (resume after interruption)}
- Agent marks \`done\` when PR opens — starts next task without waiting for merge
- Optional resume: task-run.sh ${EPIC:-} --${MODE} --continue
EOF

info "Handoff written: $HANDOFF_FILE"
echo ""
cat "$HANDOFF_FILE"
echo ""

if [[ "$DETACH" == true ]]; then
  command -v tmux >/dev/null 2>&1 || die "--detach requires tmux"
  SESSION="task-run-${SLUG}"
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    info "tmux session exists: $SESSION — attach with: tmux attach -t $SESSION"
  else
    tmux new-session -d -s "$SESSION" -c "$PROJECT_ROOT" \
      "echo '=== Task Run AFK ==='; echo ''; cat '$HANDOFF_FILE'; echo ''; echo 'Run: grok'; echo 'Then paste the block above.'; echo ''; exec bash"
    info "tmux started: $SESSION"
    info "Attach: tmux attach -t $SESSION"
  fi
fi

echo "Open a new Grok chat, paste the invocation block from the handoff file."