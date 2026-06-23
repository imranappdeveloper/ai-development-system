#!/usr/bin/env bash
# test-resolve-screen.sh — unit checks for resolve-screen
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export AI_DEV_OS_HOME="$ROOT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
PROJECT="$TMP/project"
mkdir -p "$PROJECT/work/telemetry/runs"
touch "$PROJECT/work/telemetry/runs/.gitkeep"

echo "=== test-resolve-screen ==="

# --- alias hit ---
cat >"$PROJECT/work/ui-aliases.yaml" <<'EOF'
login screen:
  query: "LoginScreen auth"
  files:
    - lib/features/auth/login_screen.dart
  node: LoginScreen
EOF

out="$("$ROOT/scripts/resolve-screen.sh" --phrase "login screen validation message" --project "$PROJECT" --json)"
python3 -c "
import json, sys
d = json.loads(sys.argv[1])
assert d['ok'] is True, d
assert d['source'] == 'alias', d
assert d['nickname'] == 'login screen', d
assert 'login_screen.dart' in d['files'][0], d
print('  OK: alias hit')
" "$out" || { echo "  FAIL: alias hit" >&2; fail=1; }

# --- miss without graph ---
out="$("$ROOT/scripts/resolve-screen.sh" --phrase "checkout screen" --project "$PROJECT" --json 2>/dev/null || true)"
python3 -c "
import json, sys
d = json.loads(sys.argv[1])
assert d['ok'] is False, d
assert d['source'] == 'miss', d
print('  OK: miss without graph')
" "$out" || { echo "  FAIL: miss" >&2; fail=1; }

# --- telemetry logged ---
if [[ -f "$PROJECT/work/telemetry/events.jsonl" ]]; then
  grep -q 'resolve_screen' "$PROJECT/work/telemetry/events.jsonl" \
    && echo "  OK: resolve_screen telemetry" \
    || { echo "  FAIL: telemetry" >&2; fail=1; }
else
  echo "  FAIL: events.jsonl missing" >&2
  fail=1
fi

# --- issue-context-pack alias bridge ---
cat >"$TMP/issue.md" <<'EOF'
## What to build
Fix validation on login screen.

## Acceptance criteria
- [ ] Message styled
EOF

pack="$("$ROOT/scripts/issue-context-pack.sh" --body-file "$TMP/issue.md" --issue 9 --project "$PROJECT")"
grep -q 'login_screen.dart' "$pack" \
  && echo "  OK: context-pack alias files" \
  || { echo "  FAIL: context-pack" >&2; fail=1; }

[[ -x "$ROOT/scripts/resolve-screen.sh" ]] && echo "  OK: executable" || { echo "  FAIL: not executable" >&2; fail=1; }

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== test-resolve-screen PASSED ==="
  exit 0
fi
echo "=== test-resolve-screen FAILED ===" >&2
exit 1