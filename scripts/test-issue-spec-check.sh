#!/usr/bin/env bash
# test-issue-spec-check.sh — unit checks for issue-spec-check
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# shellcheck source=scripts/lib/issue-spec-check.sh
source "$ROOT/scripts/lib/issue-spec-check.sh"

fail=0
good_body="$TMP/good.md"
bad_body="$TMP/bad.md"

cat >"$good_body" <<'EOF'
## What to build
Add notification toggle on Settings screen.

## Acceptance criteria
- [ ] Toggle visible on Settings
- [ ] Default OFF; saves on change

## Blocked by
None
EOF

cat >"$bad_body" <<'EOF'
## What to build

## Acceptance criteria
- [ ] One only

## Blocked by
#99999
EOF

echo "=== test-issue-spec-check ==="

if _issue_spec_check_structural "$(cat "$good_body")" true; then
  echo "  OK: good body structural READY"
else
  echo "  FAIL: good body should be READY" >&2
  fail=1
fi

if [[ "$ISSUE_SPEC_RESULT" == "READY" && "$ISSUE_SPEC_CHECKBOX_COUNT" == "2" ]]; then
  echo "  OK: checkbox count"
else
  echo "  FAIL: result=$ISSUE_SPEC_RESULT count=$ISSUE_SPEC_CHECKBOX_COUNT" >&2
  fail=1
fi

if _issue_spec_check_structural "$(cat "$bad_body")" true; then
  echo "  FAIL: bad body should NEEDS_SPEC" >&2
  fail=1
else
  echo "  OK: bad body NEEDS_SPEC"
fi

stamp_body="$(cat "$good_body")"
stamp_body+=$'\n\n## AFK preflight\nplan-review: READY\nstamped-at: 2026-06-20\nspec-sha256: '
stamp_body+="$(_issue_spec_compute_sha256_16 "$(cat "$good_body")")"

if _issue_spec_afk_skip_eligible "$stamp_body"; then
  echo "  OK: afk preflight skip eligible"
else
  echo "  FAIL: afk skip should match" >&2
  fail=1
fi

set +e
"$ROOT/scripts/issue-spec-check.sh" --offline --body-file "$good_body" --issue 42 >/dev/null
g=$?
"$ROOT/scripts/issue-spec-check.sh" --offline --body-file "$bad_body" --issue 43 >/dev/null
b=$?
set -e

[[ "$g" -eq 0 ]] && echo "  OK: CLI good exit 0" || { echo "  FAIL: CLI good exit $g" >&2; fail=1; }
[[ "$b" -eq 1 ]] && echo "  OK: CLI bad exit 1" || { echo "  FAIL: CLI bad exit $b" >&2; fail=1; }

if [[ $fail -eq 0 ]]; then
  echo "=== test-issue-spec-check PASSED ==="
  exit 0
else
  echo "=== test-issue-spec-check FAILED ===" >&2
  exit 1
fi