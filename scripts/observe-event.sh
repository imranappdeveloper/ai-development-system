#!/usr/bin/env bash
# observe-event.sh — CLI wrapper for structured run-trace events
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"
LIB="$OS_HOME/scripts/lib/observe-event.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

[[ -f "$LIB" ]] || die "Missing: $LIB"
# shellcheck source=scripts/lib/observe-event.sh
source "$LIB"

usage() {
  cat <<EOF
observe-event — append run-trace events (low-token)

Usage:
  $(basename "$0") run-start [--skill NAME] [--agent grok|agy] [--run-id ID]
  $(basename "$0") run-end [--status ok|fail|skip] [--run-id ID]
  $(basename "$0") emit --type TYPE [options]

Emit options:
  --run-id ID --parent-run-id ID --skill NAME --step NAME --step-index N/M
  --issue N --agent grok|agy --status ok|fail|skip --duration-sec N
  --tokens-in N --tokens-out N --tokens-source exact|estimated

Event types: run_start, run_end, step_start, step_end, heartbeat, tool_call, subagent_spawn
EOF
}

CMD="${1:-}"
shift || true

case "$CMD" in
  -h|--help|"") usage; exit 0 ;;
  run-start)
    run_id="" skill="" agent=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --skill) skill="$2"; shift 2 ;;
        --agent) agent="$2"; shift 2 ;;
        *) die "unknown arg: $1" ;;
      esac
    done
    [[ -n "$run_id" ]] || run_id="$(_observe_new_run_id)"
    _observe_set_current_run_id "$run_id"
    _observe_emit run_start --run-id "$run_id" --skill "$skill" --agent "$agent" --status ok
    echo "$run_id"
    ;;
  run-end)
    run_id="" status="ok"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --status) status="$2"; shift 2 ;;
        *) die "unknown arg: $1" ;;
      esac
    done
    [[ -n "$run_id" ]] || run_id="$(_observe_read_current_run_id)"
    [[ -n "$run_id" ]] || die "no active run"
    _observe_emit run_end --run-id "$run_id" --status "$status"
    _observe_clear_current_run_id
    ;;
  emit)
    event_type=""
    args=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --type) event_type="$2"; shift 2 ;;
        *) args+=("$1"); shift ;;
      esac
    done
    [[ -n "$event_type" ]] || die "emit requires --type"
    _observe_emit "$event_type" "${args[@]}"
    ;;
  *)
    die "unknown command: $CMD"
    ;;
esac