#!/usr/bin/env bash
# test-afk-state-sync.sh — unit checks for afk-state-sync
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# shellcheck source=scripts/lib/afk-state-sync.sh
source "$ROOT/scripts/lib/afk-state-sync.sh"

fail=0
echo "=== test-afk-state-sync ==="

plan="$(_afk_sync_plan_action "done " "OPEN")"
[[ "$plan" == *"noop:done-ok"* ]] && echo "  OK: done+OPEN noop" || { echo "  FAIL: done+OPEN ($plan)" >&2; fail=1; }

plan="$(_afk_sync_plan_action "done " "CLOSED")"
[[ "$plan" == *"reopen:"* ]] && echo "  OK: done+CLOSED reopen" || { echo "  FAIL: done+CLOSED ($plan)" >&2; fail=1; }

plan="$(_afk_sync_plan_action "in-progress " "NONE")"
[[ "$plan" == *"recover:"* ]] && echo "  OK: in-progress stuck recover" || { echo "  FAIL: stuck ($plan)" >&2; fail=1; }

plan="$(_afk_sync_plan_action "pr-open " "OPEN")"
[[ "$plan" == *"repair:add-done,remove-pr-open"* ]] && echo "  OK: pr-open repair" || { echo "  FAIL: pr-open ($plan)" >&2; fail=1; }

export AFK_SYNC_LABEL_FIXTURE="$TMP/labels.fixture"
export AFK_SYNC_PR_FIXTURE="$TMP/pr.fixture"
cat >"$AFK_SYNC_LABEL_FIXTURE" <<'EOF'
issue_10=done
issue_11=in-progress
EOF
cat >"$AFK_SYNC_PR_FIXTURE" <<'EOF'
issue_10=CLOSED
issue_11=NONE
EOF

out="$(_afk_sync_run "10,11" false)"
grep -q 'reopen' <<<"$out" && echo "  OK: fixture reopen" || { echo "  FAIL: fixture reopen" >&2; fail=1; }
grep -q 'recover' <<<"$out" && echo "  OK: fixture recover" || { echo "  FAIL: fixture recover" >&2; fail=1; }

if [[ $fail -eq 0 ]]; then
  echo "=== test-afk-state-sync PASSED ==="
  exit 0
else
  echo "=== test-afk-state-sync FAILED ===" >&2
  exit 1
fi