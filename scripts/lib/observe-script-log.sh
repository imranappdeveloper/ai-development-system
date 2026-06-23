#!/usr/bin/env bash
# observe-script-log.sh — auto-telemetry for OS script invocations (source or CLI)
#
# Sourced:
#   OBSERVE_PROJECT_ROOT=/path/to/project
#   source "$AI_DEV_OS_HOME/scripts/lib/observe-script-log.sh"
#   _observe_script_log_begin "ads-preflight.sh" "$@"
#   trap '_observe_script_log_finish $?' EXIT
#
# CLI:
#   observe-script-log.sh record --project DIR --script NAME --args "..." --exit N [--files "a,b"]
set -euo pipefail

_observe_script_log_setup() {
  [[ -n "${_OBSERVE_SCRIPT_LOG_LOADED:-}" ]] && return 0
  _OBSERVE_SCRIPT_LOG_LOADED=1
  local _lib_dir
  _lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=scripts/lib/observe-event.sh
  source "$_lib_dir/observe-event.sh"
}

_observe_script_log_begin() {
  _observe_script_log_setup
  OBSERVE_SCRIPT_LOG_NAME="$1"
  shift || true
  OBSERVE_SCRIPT_LOG_ARGS="$*"
  OBSERVE_SCRIPT_LOG_START_EPOCH="$(date +%s)"
}

_observe_script_log_set_files() {
  OBSERVE_SCRIPT_LOG_FILES="$1"
}

_observe_script_log_finish() {
  local exit_code="${1:-0}"
  [[ -n "${OBSERVE_SCRIPT_LOG_NAME:-}" ]] || return 0
  local status="ok"
  [[ "$exit_code" -eq 0 ]] || status="fail"
  local duration=0
  if [[ -n "${OBSERVE_SCRIPT_LOG_START_EPOCH:-}" ]]; then
    duration=$(( $(date +%s) - OBSERVE_SCRIPT_LOG_START_EPOCH ))
  fi
  _observe_activity_emit script_invoked \
    --script "$OBSERVE_SCRIPT_LOG_NAME" \
    --args-summary "$OBSERVE_SCRIPT_LOG_ARGS" \
    --status "$status" \
    --duration-sec "$duration"
  if [[ -n "${OBSERVE_SCRIPT_LOG_FILES:-}" ]]; then
    _observe_activity_emit files_used \
      --script "$OBSERVE_SCRIPT_LOG_NAME" \
      --files "$OBSERVE_SCRIPT_LOG_FILES" \
      --status ok
  fi
  unset OBSERVE_SCRIPT_LOG_NAME OBSERVE_SCRIPT_LOG_ARGS OBSERVE_SCRIPT_LOG_START_EPOCH OBSERVE_SCRIPT_LOG_FILES
}

_observe_script_log_record() {
  local project="" script="" args="" exit_code="0" files=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --project) project="$2"; shift 2 ;;
      --script) script="$2"; shift 2 ;;
      --args) args="$2"; shift 2 ;;
      --exit) exit_code="$2"; shift 2 ;;
      --files) files="$2"; shift 2 ;;
      *) return 1 ;;
    esac
  done
  [[ -n "$project" && -n "$script" ]] || return 1
  export OBSERVE_PROJECT_ROOT="$(cd "$project" && pwd)"
  _observe_script_log_setup
  OBSERVE_SCRIPT_LOG_NAME="$script"
  OBSERVE_SCRIPT_LOG_ARGS="$args"
  OBSERVE_SCRIPT_LOG_FILES="$files"
  OBSERVE_SCRIPT_LOG_START_EPOCH="$(date +%s)"
  _observe_script_log_finish "$exit_code"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  cmd="${1:-}"
  shift || true
  case "$cmd" in
    record) _observe_script_log_record "$@" ;;
    -h|--help)
      cat <<EOF
observe-script-log — record OS script invocation telemetry

  record --project DIR --script NAME --args "..." --exit N [--files "a,b"]
EOF
      ;;
    *) echo "ERROR: unknown command: ${cmd:-}" >&2; exit 1 ;;
  esac
fi