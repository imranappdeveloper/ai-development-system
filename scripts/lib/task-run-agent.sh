#!/usr/bin/env bash
# task-run-agent.sh — resolve and launch grok | agy for AFK task manager
# Source from task-run-server.sh / task-run-poll.sh

_task_run_resolve_agent() {
  local project_dir="$1"
  local flag_agent="${2:-}"
  local agent=""

  if [[ -n "$flag_agent" ]]; then
    agent="$flag_agent"
  elif [[ -n "${TASK_RUN_AGENT:-}" ]]; then
    agent="$TASK_RUN_AGENT"
  fi
  _task_run_read_agent_from_yaml() {
    local f="$1"
    [[ -f "$f" ]] || return 0
    awk '
      /^task_run:/ { in_tr=1; next }
      in_tr && /^[a-zA-Z]/ && $0 !~ /^[[:space:]]/ { in_tr=0 }
      in_tr && /^[[:space:]]+agent:/ {
        gsub(/^[[:space:]]+agent:[[:space:]]*/, "")
        gsub(/"/, "")
        gsub(/\047/, "")
        print
        exit
      }
    ' "$f" 2>/dev/null || true
  }
  if [[ -z "$agent" ]]; then
    agent="$(_task_run_read_agent_from_yaml "$project_dir/ai-dev-os.local.yaml")"
  fi
  if [[ -z "$agent" ]]; then
    agent="$(_task_run_read_agent_from_yaml "$project_dir/ai-dev-os.yaml")"
  fi
  if [[ -z "$agent" ]]; then
    if command -v grok >/dev/null 2>&1; then
      agent="grok"
    elif command -v agy >/dev/null 2>&1; then
      agent="agy"
    else
      agent="grok"
    fi
  fi

  case "$agent" in
    grok|agy) echo "$agent" ;;
    *)
      echo "ERROR: unknown agent '$agent' (use grok or agy)" >&2
      return 1
      ;;
  esac
}

_task_run_verify_agent() {
  local agent="$1"
  case "$agent" in
    grok)
      command -v grok >/dev/null 2>&1 || {
        echo "ERROR: grok CLI not found — install Grok Build or use --agent agy" >&2
        return 1
      }
      ;;
    agy)
      command -v agy >/dev/null 2>&1 || {
        echo "ERROR: agy CLI not found — install Antigravity CLI or use --agent grok" >&2
        return 1
      }
      ;;
  esac
}

_task_run_agent_label() {
  case "$1" in
    grok) echo "Grok Build" ;;
    agy) echo "Antigravity (agy)" ;;
    *) echo "$1" ;;
  esac
}

_task_run_prompt_suffix() {
  local agent="$1"
  case "$agent" in
    grok)
      cat <<'EOF'
Agent runtime: Grok. Spawn per-issue subagents with the Task tool.
EOF
      ;;
    agy)
      cat <<'EOF'
Agent runtime: Antigravity (agy). Spawn per-issue subagents with invoke_subagent.
EOF
      ;;
  esac
}

# Writes agent launch command to stdout (for embedding in runner script)
_task_run_agent_exec_line() {
  local agent="$1"
  local prompt_file="$2"
  local print_timeout="${TASK_RUN_PRINT_TIMEOUT:-24h}"
  case "$agent" in
    grok)
      printf 'exec grok --always-approve "$(cat %q)"' "$prompt_file"
      ;;
    agy)
      printf 'exec agy --dangerously-skip-permissions --print --print-timeout %q "$(cat %q)"' \
        "$print_timeout" "$prompt_file"
      ;;
  esac
}