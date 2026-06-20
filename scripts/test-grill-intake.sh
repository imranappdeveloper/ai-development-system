#!/usr/bin/env bash
# test-grill-intake.sh — unit checks for grill-intake.py
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
PROJECT="$TMP/project"
mkdir -p "$PROJECT/work"

echo "=== test-grill-intake ==="

"$ROOT/scripts/grill-intake.py" --project "$PROJECT" init --feature test-feature >/dev/null
[[ -f "$PROJECT/work/grill-intake.json" ]] && echo "  OK: init creates intake" || { echo "  FAIL: init" >&2; fail=1; }

set +e
"$ROOT/scripts/grill-intake.py" --project "$PROJECT" lint >/dev/null
lint_rc=$?
set -e
[[ "$lint_rc" -eq 1 ]] && echo "  OK: empty intake fails lint" || { echo "  FAIL: lint should fail ($lint_rc)" >&2; fail=1; }

cat >"$PROJECT/work/grill-intake.json" <<'EOF'
{
  "feature": "test-feature",
  "document_id": "REQ-LOCK-099",
  "status": "draft",
  "grill_session": "2026-06-20",
  "problem_statement": "Reduce tokens safely.",
  "out_of_scope": ["provider changes"],
  "testing_approach": {"seams": "scripts/", "prior_art": "check-integration.sh"},
  "open_questions": [],
  "journeys": [{
    "name": "AFK gates",
    "current_behavior": "AI only",
    "your_request": "Script gates",
    "agreed_change": "Bash scripts first",
    "files_components": "scripts/",
    "confirmed_forks": "none"
  }],
  "context_updates": "none"
}
EOF

"$ROOT/scripts/grill-intake.py" --project "$PROJECT" lint >/dev/null && echo "  OK: complete intake lint" || { echo "  FAIL: lint pass" >&2; fail=1; }

"$ROOT/scripts/grill-intake.py" --project "$PROJECT" seed-lock --os-home "$ROOT" >/dev/null
[[ -f "$PROJECT/work/requirement-lock.md" ]] && echo "  OK: seed-lock" || { echo "  FAIL: seed-lock" >&2; fail=1; }
grep -q 'status | draft' "$PROJECT/work/requirement-lock.md" && echo "  OK: draft status" || { echo "  FAIL: draft" >&2; fail=1; }
grep -q 'AFK gates' "$PROJECT/work/requirement-lock.md" && echo "  OK: journey in lock" || { echo "  FAIL: journey" >&2; fail=1; }

if [[ $fail -eq 0 ]]; then
  echo "=== test-grill-intake PASSED ==="
  exit 0
else
  echo "=== test-grill-intake FAILED ===" >&2
  exit 1
fi