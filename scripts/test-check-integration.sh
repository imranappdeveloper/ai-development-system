#!/usr/bin/env bash
# test-check-integration.sh — unit checks for check-integration.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export AI_DEV_OS_HOME="$ROOT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
assert_exit() {
  local desc="$1" expect="$2"
  shift 2
  set +e
  "$@" >/dev/null 2>&1
  local got=$?
  set -e
  if [[ "$got" == "$expect" ]]; then
    echo "  OK: $desc (exit $got)"
  else
    echo "  FAIL: $desc (got exit $got want $expect)" >&2
    fail=1
  fi
}

echo "=== test-check-integration ==="

# Unbound project → FAIL
mkdir -p "$TMP/empty"
assert_exit "unbound project fails" 1 "$ROOT/scripts/check-integration.sh" "$TMP/empty" --quiet

# Minimal bound project → may be PARTIAL (warnings) but not hard FAIL on CLI
mkdir -p "$TMP/bound/work" "$TMP/bound/docs"
cp "$ROOT/templates/project-starter/AGENTS.md" "$TMP/bound/AGENTS.md"
cp "$ROOT/templates/project-starter/ai-dev-os.yaml" "$TMP/bound/ai-dev-os.yaml"
sed -i '' "s|{{PROJECT_NAME}}|test-project|g" "$TMP/bound/ai-dev-os.yaml" 2>/dev/null \
  || sed -i "s|{{PROJECT_NAME}}|test-project|g" "$TMP/bound/ai-dev-os.yaml"
assert_exit "bound scaffold passes CLI" 0 "$ROOT/scripts/check-integration.sh" "$TMP/bound" --quiet

out="$("$ROOT/scripts/check-integration.sh" "$TMP/bound" --quiet)"
if [[ "$out" == INTEGRATION:* ]]; then
  echo "  OK: quiet summary line"
else
  echo "  FAIL: quiet summary (got '$out')" >&2
  fail=1
fi

# Fully integrated fixture
mkdir -p "$TMP/full/docs/agents" "$TMP/full/work/task-run"
cp "$TMP/bound/AGENTS.md" "$TMP/full/AGENTS.md"
cp "$TMP/bound/ai-dev-os.yaml" "$TMP/full/ai-dev-os.yaml"
for doc in issue-tracker.md triage-labels.md domain.md engineering-standards.md task-run.md; do
  echo "# test" > "$TMP/full/docs/agents/$doc"
done
echo "# context" > "$TMP/full/CONTEXT.md"
sed -i '' 's|_Setup pending — run `/setup-project-agents`._|GitHub issues — see docs/agents/issue-tracker.md.|' "$TMP/full/AGENTS.md" 2>/dev/null \
  || sed -i 's|_Setup pending — run `/setup-project-agents`._|GitHub issues — see docs/agents/issue-tracker.md.|' "$TMP/full/AGENTS.md"

full_out="$("$ROOT/scripts/check-integration.sh" "$TMP/full" 2>/dev/null)"
if grep -q 'FULLY INTEGRATED' <<<"$full_out" || grep -q 'PARTIAL' <<<"$full_out"; then
  echo "  OK: full fixture produces summary"
else
  echo "  FAIL: full fixture summary missing" >&2
  fail=1
fi

[[ -x "$ROOT/scripts/check-integration.sh" ]] && echo "  OK: executable" || { echo "  FAIL: not executable" >&2; fail=1; }

for ts in issue-spec-check.sh issue-context-pack.sh afk-state-sync.sh grill-intake.py; do
  [[ -x "$ROOT/scripts/$ts" ]] && echo "  OK: token script $ts" || { echo "  FAIL: missing $ts" >&2; fail=1; }
done

token_out="$("$ROOT/scripts/check-integration.sh" "$TMP/full" 2>/dev/null)"
grep -q 'Token optimization' <<<"$token_out" && echo "  OK: token section in integration report" || { echo "  FAIL: token section" >&2; fail=1; }

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1