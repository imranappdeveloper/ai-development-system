#!/usr/bin/env bash
# setup-task-run.sh — server AFK: task-run scripts, agent config, optional cron poll
#
# Idempotent. Called by ai-new; agent confirms agent + poll in /setup-ads Phase 1.6.
#
# Usage:
#   setup-task-run.sh [project_dir] [--agent grok|agy] [--poll] [--no-poll]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"
LIB="$OS_HOME/scripts/lib/task-run-agent.sh"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }
warn() { echo "  WARN: $1"; }

usage() {
  cat <<EOF
AI Development OS — task-run server setup

Usage:
  $(basename "$0") [project_dir] [--agent grok|agy] [--poll] [--no-poll]

Writes:
  work/task-run/           handoff, logs, poll log
  docs/agents/task-run.md  server AFK config for agents
  ai-dev-os.yaml           task_run.agent (+ auto_poll if --poll)

Skills: task-run, work-to-pr-v2, issue-processor (bundled in MANIFEST.yaml)
Scripts: task-run-server.sh, task-run-poll.sh

EOF
}

AGENT_FLAG=""
ENABLE_POLL=""
PROJECT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --agent)
      [[ $# -ge 2 ]] || die "--agent requires grok or agy"
      AGENT_FLAG="$2"
      shift 2
      ;;
    --poll) ENABLE_POLL=true; shift ;;
    --no-poll) ENABLE_POLL=false; shift ;;
    -*)
      die "Unknown flag: $1"
      ;;
    *)
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

if [[ "$PROJECT_DIR" == "." ]]; then
  PROJECT_DIR="$(pwd)"
elif [[ "$PROJECT_DIR" != /* ]]; then
  PROJECT_DIR="$(cd "$(dirname "$PROJECT_DIR")" && pwd)/$(basename "$PROJECT_DIR")"
fi

[[ -d "$PROJECT_DIR" ]] || die "Not a directory: $PROJECT_DIR"
[[ -f "$LIB" ]] || die "Missing: $LIB"
# shellcheck source=scripts/lib/task-run-agent.sh
source "$LIB"

merge_task_run_yaml() {
  local yaml="$1"
  local agent="$2"
  local poll="${3:-}"

  if [[ ! -f "$yaml" ]]; then
    warn "ai-dev-os.yaml missing — skip task_run merge"
    return 0
  fi

  if grep -q '^task_run:' "$yaml" 2>/dev/null; then
    local tmp
    tmp="$(mktemp)"
    awk -v agent="$agent" -v poll="$poll" '
      /^task_run:/ { in_tr=1; print; next }
      in_tr && /^[[:space:]]+agent:/ {
        print "  agent: " agent
        next
      }
      in_tr && /^[[:space:]]+auto_poll:/ {
        if (poll != "") print "  auto_poll: " poll
        else print
        next
      }
      in_tr && /^[a-zA-Z#]/ && $0 !~ /^[[:space:]]/ {
        if (poll != "" && !added_poll) { print "  auto_poll: " poll; added_poll=1 }
        in_tr=0
      }
      { print }
      END {
        if (in_tr && poll != "" && !added_poll) print "  auto_poll: " poll
      }
    ' "$yaml" >"$tmp"
    # Ensure agent line exists inside task_run block
    if ! awk '/^task_run:/{p=1} p&&/^[[:space:]]+agent:/{found=1} END{exit !found}' "$tmp"; then
      awk -v agent="$agent" '
        /^task_run:/ { print; print "  agent: " agent; next }
        { print }
      ' "$tmp" >"${tmp}.2" && mv "${tmp}.2" "$tmp"
    fi
    mv "$tmp" "$yaml"
    info "ai-dev-os.yaml — task_run updated (agent=$agent)"
  else
    {
      echo ""
      echo "# Server AFK task manager — grok or agy"
      echo "task_run:"
      echo "  agent: $agent"
      [[ -n "$poll" ]] && echo "  auto_poll: $poll"
    } >>"$yaml"
    info "ai-dev-os.yaml — task_run added (agent=$agent)"
  fi
}

write_task_run_agent_doc() {
  local doc="$1"
  local agent="$2"
  local poll="${3:-false}"
  local agent_label
  agent_label="$(_task_run_agent_label "$agent")"

  mkdir -p "$(dirname "$doc")"
  cat >"$doc" <<EOF
# Server AFK — task-run

Configured by **\`/setup-ads\` Phase 1.6** (\`setup-task-run.sh\`).

## Agent

| Field | Value |
|-------|-------|
| Runtime | ${agent_label} (\`${agent}\`) |
| Config | \`ai-dev-os.yaml\` → \`task_run.agent\` |
| Auto-poll | \`${poll}\` |

## Commands (Ubuntu server)

\`\`\`bash
cd ${PROJECT_DIR}

# Start now — all ready-for-agent tickets:
task-run-server.sh --agent ${agent}

# One epic:
task-run-server.sh --agent ${agent} --epic <N>

# Resume after interruption (optional):
task-run-server.sh --agent ${agent} --continue

# Status / attach:
task-run-server.sh --status
task-run-server.sh --attach
\`\`\`

## Auto-poll

When \`task_run.auto_poll: true\`, install cron from \`work/task-run/cron.example\`.

\`\`\`bash
task-run-poll.sh --agent ${agent} --dry-run
\`\`\`

## Skills (load from \$AI_DEV_OS_HOME/skills/)

| Skill | Role |
|-------|------|
| \`task-run\` | Task manager loop |
| \`work-to-pr-v2\` | Per-issue PR + state machine |
| \`issue-processor\` | Batch subagent pattern |
| \`tdd\` | Subagent implementation |
| \`issue-spec-review\` | Preflight |
| \`pr-readiness-check\` | Before PR |

## Labels

Issues must use \`ready-for-agent\` and \`## Blocked by\` per \`docs/agents/triage-labels.md\`.

Full guide: \`\$AI_DEV_OS_HOME/docs/AFK-TASK-RUN.md\`
EOF
  info "docs/agents/task-run.md — written"
}

write_cron_example() {
  local file="$1"
  local agent="$2"
  cat >"$file" <<EOF
# AI Dev OS — task-run auto-poll (install with: crontab -e)
# Starts or resumes task-run-server (kills stale sessions; --continue for state sync only).

*/15 * * * * cd ${PROJECT_DIR} && task-run-poll.sh --agent ${agent} >> work/task-run/poll.log 2>&1
EOF
  info "work/task-run/cron.example — written"
}

verify_tooling() {
  local agent="$1"
  local ok=true

  for cmd in task-run-server task-run-poll gh; do
    if command -v "$cmd" >/dev/null 2>&1; then
      info "CLI OK: $cmd"
    else
      warn "CLI missing: $cmd — run install-cli.sh on server"
      ok=false
    fi
  done

  if _task_run_verify_agent "$agent" 2>/dev/null; then
    info "Agent CLI OK: $agent"
  else
    warn "Agent CLI missing: $agent — install on server before AFK"
    ok=false
  fi

  if command -v tmux >/dev/null 2>&1; then
    info "CLI OK: tmux"
  else
    warn "tmux missing — required for task-run-server.sh"
    ok=false
  fi

  $ok
}

main() {
  local agent poll_val poll_bool="false"

  AGENT="$(_task_run_resolve_agent "$PROJECT_DIR" "$AGENT_FLAG")"

  if [[ "$ENABLE_POLL" == true ]]; then
    poll_val="true"
    poll_bool="true"
  elif [[ "$ENABLE_POLL" == false ]]; then
    poll_val="false"
    poll_bool="false"
  else
    # preserve existing or default false
    if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]] \
      && grep -A3 '^task_run:' "$PROJECT_DIR/ai-dev-os.yaml" 2>/dev/null | grep -q 'auto_poll:[[:space:]]*true'; then
      poll_val="true"
      poll_bool="true"
    else
      poll_val="false"
      poll_bool="false"
    fi
  fi

  echo "=== AI Development OS — task-run setup ==="
  info "Project: $PROJECT_DIR"
  info "Agent: $(_task_run_agent_label "$AGENT")"

  mkdir -p "$PROJECT_DIR/work/task-run"
  touch "$PROJECT_DIR/work/task-run/.gitkeep" 2>/dev/null || true

  merge_task_run_yaml "$PROJECT_DIR/ai-dev-os.yaml" "$AGENT" "$poll_val"
  write_task_run_agent_doc "$PROJECT_DIR/docs/agents/task-run.md" "$AGENT" "$poll_bool"

  if [[ "$poll_bool" == "true" ]]; then
    write_cron_example "$PROJECT_DIR/work/task-run/cron.example" "$AGENT"
  fi

  # Copy systemd template reference
  if [[ -d "$OS_HOME/templates/systemd" ]]; then
    mkdir -p "$PROJECT_DIR/docs/agents"
    if [[ ! -f "$PROJECT_DIR/docs/agents/task-run-systemd.md" ]]; then
      cat >"$PROJECT_DIR/docs/agents/task-run-systemd.md" <<EOF
# systemd timer (optional)

Templates: \`\$AI_DEV_OS_HOME/templates/systemd/task-run-poll@.service\`

Set \`WorkingDirectory=${PROJECT_DIR}\` and \`Environment=TASK_RUN_AGENT=${AGENT}\` in the service unit.
EOF
      info "docs/agents/task-run-systemd.md — written"
    fi
  fi

  echo ""
  verify_tooling "$AGENT" || true

  echo ""
  echo "=== task-run setup ready ==="
  echo "  Agent:  task-run-server.sh --agent $AGENT"
  echo "  Poll:   task-run-poll.sh --agent $AGENT"
  echo "  Doc:    docs/agents/task-run.md"
  echo "  Skill:  \$AI_DEV_OS_HOME/skills/task-run/SKILL.md"
}

main