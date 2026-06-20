#!/usr/bin/env bash
# test-issue-context-pack.sh — unit checks for issue-context-pack
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export ISSUE_PACK_PROJECT_ROOT="$TMP/project"
mkdir -p "$ISSUE_PACK_PROJECT_ROOT/work"

cat >"$ISSUE_PACK_PROJECT_ROOT/CONTEXT.md" <<'EOF'
# Context

### notification
User-facing alert preference stored per account.
EOF

cat >"$ISSUE_PACK_PROJECT_ROOT/work/requirement-lock.md" <<'EOF'
### Settings toggle

| Field | Content |
|-------|---------|
| **Agreed change** | Toggle on Settings; default OFF |
| **Files / components** | `lib/settings.dart` |
EOF

cat >"$TMP/issue.md" <<'EOF'
## What to build
Add notification toggle using notification term from glossary.

## Requirement lock
work/requirement-lock.md — section: Settings toggle

## Files to spot-check
- `lib/settings.dart`

## Acceptance criteria
- [ ] Toggle works
- [ ] notification pref saved
EOF

echo "=== test-issue-context-pack ==="
fail=0

pack="$("$ROOT/scripts/issue-context-pack.sh" --body-file "$TMP/issue.md" --issue 7 --project "$ISSUE_PACK_PROJECT_ROOT")"

[[ -f "$pack" ]] && echo "  OK: pack written" || { echo "  FAIL: pack missing" >&2; fail=1; }

grep -q 'Settings toggle' "$pack" && echo "  OK: lock section" || { echo "  FAIL: lock section" >&2; fail=1; }
grep -q 'lib/settings.dart' "$pack" && echo "  OK: spot-check file" || { echo "  FAIL: spot-check" >&2; fail=1; }
grep -q 'notification' "$pack" && echo "  OK: CONTEXT excerpt" || { echo "  FAIL: CONTEXT" >&2; fail=1; }
grep -q 'docs/agents' "$pack" && grep -q 'Do \*\*not\*\* reload full' "$pack" && echo "  OK: agents discipline note" || { echo "  FAIL: agents note" >&2; fail=1; }

if [[ $fail -eq 0 ]]; then
  echo "=== test-issue-context-pack PASSED ==="
  exit 0
else
  echo "=== test-issue-context-pack FAILED ===" >&2
  exit 1
fi