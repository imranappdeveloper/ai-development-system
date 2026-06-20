#!/usr/bin/env bash
# test-ai-pr-review-notify.sh — unit tests for ai-pr-review-notify helpers
set -euo pipefail

_self="${BASH_SOURCE[0]}"
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/lib/ai-pr-review-notify.sh
source "$OS_REPO/scripts/lib/ai-pr-review-notify.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

assert_eq() {
  local got="$1" want="$2" label="$3"
  if [[ "$got" != "$want" ]]; then
    echo "FAIL: $label — got '$got', want '$want'" >&2
    exit 1
  fi
  echo "OK: $label"
}

review_clean="$tmpdir/clean.md"
cat > "$review_clean" <<'EOF'
## Summary
Looks good.

### Recommendation
✅ Safe to merge

## Issues
EOF

review_bugs="$tmpdir/bugs.md"
cat > "$review_bugs" <<'EOF'
## Summary
Found problems.

### Recommendation
⚠️ Fix before merge

## Issues

### Issue 1 -- Severity: bug
- File: src/a.ts:10
- Description: null deref
- Suggestion: guard
- Status: open
EOF

assert_eq "$(_ai_pr_review_count_bugs "$review_clean")" "0" "no bugs"
assert_eq "$(_ai_pr_review_count_bugs "$review_bugs")" "1" "one bug"
assert_eq "$(_ai_pr_review_recommendation "$review_clean" 0)" "✅ Safe to merge" "safe recommendation"
assert_eq "$(_ai_pr_review_recommendation "$review_bugs" 1)" "⚠️ Fix before merge" "fix recommendation"
assert_eq "$(_ai_pr_review_recommendation "$review_clean" 2)" "⚠️ Fix before merge" "bugs override safe rec"

body="$(_ai_pr_review_issue_body "https://github.com/o/r/pull/1" "✅ Safe to merge")"
[[ "$body" == *"https://github.com/o/r/pull/1"* ]] || { echo "FAIL: body missing PR URL"; exit 1; }
[[ "$body" == *"AI review: ✅ Safe to merge"* ]] || { echo "FAIL: body missing AI line"; exit 1; }
echo "OK: issue body format"

echo "All ai-pr-review-notify tests passed."