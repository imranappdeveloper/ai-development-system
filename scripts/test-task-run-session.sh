#!/usr/bin/env bash
# test-task-run-session.sh — unit checks for task-run session helpers
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/lib/task-run-session.sh
source "$ROOT/scripts/lib/task-run-session.sh"

fail=0
assert() {
  local desc="$1"
  local got="$2"
  local want="$3"
  if [[ "$got" == "$want" ]]; then
    echo "  OK: $desc"
  else
    echo "  FAIL: $desc (got='$got' want='$want')" >&2
    fail=1
  fi
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/work/task-run"

echo "=== test-task-run-session ==="

assert "slug ready" "$(_task_run_slug "")" "ready"
assert "slug epic" "$(_task_run_slug "42")" "epic-42"
assert "session name" "$(_task_run_session_name "42")" "task-run-epic-42"

touch "$TMP/work/task-run/epic-42.started"
assert "poll skip healthy" \
  "$(_task_run_poll_action "$TMP" "epic-42" "healthy" "3")" "skip"

assert "poll fresh first run" \
  "$(_task_run_poll_action "$TMP" "ready" "none" "2")" "fresh"

touch "$TMP/work/task-run/ready.started"
assert "poll continue with ready" \
  "$(_task_run_poll_action "$TMP" "ready" "none" "2")" "continue"

assert "poll skip no ready" \
  "$(_task_run_poll_action "$TMP" "ready" "none" "0")" "skip"

assert "poll skip idle" \
  "$(_task_run_poll_action "$TMP" "ready" "none" "0")" "skip"

LOG="$TMP/run.log"
echo "line" >"$LOG"
assert "log recent" "$(_task_run_log_recent "$LOG" 60 && echo yes || echo no)" "yes"

touch -d '2 hours ago' "$LOG" 2>/dev/null || touch -t 202001010000 "$LOG"
assert "log stale" "$(_task_run_log_recent "$LOG" 45 && echo yes || echo no)" "no"

assert "health none" "$(_task_run_session_health "task-run-nonexistent-$$" "")" "none"

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1