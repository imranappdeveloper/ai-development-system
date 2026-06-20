#!/usr/bin/env bash
# test-usage-snapshot.sh — unit checks for usage-snapshot helpers
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export AI_DEV_OS_HOME="$ROOT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export USAGE_PROJECT_ROOT="$TMP/project"
mkdir -p "$USAGE_PROJECT_ROOT"

# shellcheck source=scripts/lib/usage-snapshot.sh
source "$ROOT/scripts/lib/usage-snapshot.sh"

fail=0
assert() {
  local desc="$1" got="$2" want="$3"
  if [[ "$got" == "$want" ]]; then
    echo "  OK: $desc"
  else
    echo "  FAIL: $desc (got='$got' want='$want')" >&2
    fail=1
  fi
}

echo "=== test-usage-snapshot ==="

assert "no anomalies clean grill" "$(_usage_detect_anomalies 5 0 true 2 0 0 0 false false)" ""
assert "partial footer" "$(_usage_detect_anomalies 2 1 true 1 0 0 0 false false)" "partial_footer"
assert "grill high" "$(_usage_detect_anomalies 9 0 true 0 0 0 0 false false)" "grill_questions_high"
assert "afk zero prs" "$(_usage_detect_anomalies 0 0 true 0 0 0 3 false false)" "afk_zero_prs"
assert "grill abandoned" "$(_usage_detect_anomalies 3 0 false 0 0 0 0 false false)" "grill_abandoned"

out="$(_usage_write_snapshot grill 5 0 true 0 0 0 0 false false 60 "grill-me" 0)"
snap_path="$TMP/project/work/feedback/snapshots/$(date -u +%Y-%m-%d)-grill-project.md"
[[ -f "$snap_path" ]] && echo "  OK: snapshot file written" || { echo "  FAIL: snapshot missing" >&2; fail=1; }

grep -q '| nudge | false |' "$snap_path" && echo "  OK: clean run no nudge" || { echo "  FAIL: nudge flag" >&2; fail=1; }

out2="$(_usage_write_snapshot afk-run 0 1 true 0 2 0 4 true false 3600 "task-run" 0)"
snap_afk="$TMP/project/work/feedback/snapshots/$(date -u +%Y-%m-%d)-afk-run-project.md"
grep -q '| nudge | true |' "$snap_afk" && echo "  OK: anomalous nudge" || { echo "  FAIL: expected nudge" >&2; fail=1; }

entry="$(_usage_append_feedback workflow-friction medium "test note" grill-me grill)"
grep -q 'FB-' <<<"$entry" && echo "  OK: feedback id" || { echo "  FAIL: feedback id" >&2; fail=1; }
[[ -f "$TMP/project/work/feedback/entries.jsonl" ]] && echo "  OK: feedback jsonl" || { echo "  FAIL: entries.jsonl" >&2; fail=1; }

[[ -f "$ROOT/.usage/rollup.jsonl" ]] && echo "  OK: os rollup" || { echo "  FAIL: rollup" >&2; fail=1; }

meta="$(_usage_meta_review_eligible)"
assert "meta gate off early" "${meta%%|*}" "false"

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1