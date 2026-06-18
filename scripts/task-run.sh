#!/usr/bin/env bash
# task-run.sh — prepare AFK task manager session (tmux detach on server)
#
# Grok runs the agent; this script prepares handoff + optional tmux session.
#
# Usage:
#   task-run.sh <epic> --local [--continue]
#   task-run.sh <epic> --server [--continue] [--detach]
#   task-run.sh --ready --local
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

  --local     Sequential (1 task at a time) — Mac or watch mode
  --server    Parallel up to 3 — Ubuntu server AFK
  --continue  After you merged PRs on GitHub
  --detach    Start tmux session (server AFK — session stays open)

Then open Grok in the tmux window (or new chat) and paste the handoff prompt.

Skill: ~/.grok/skills/task-run/SKILL.md
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

[[ -n "$MODE" ]] || die "Specify --local or --server"
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
Load: ~/.grok/skills/task-run/SKILL.md
\`\`\`

## Human phase complete

- Issues published with dependencies
- User chose: **${MODE}**${CONTINUE:+ (continue after merges)}
- Merge PRs on GitHub when labeled pr-open
- Then: task-run.sh ${EPIC:-} --${MODE} --continue
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