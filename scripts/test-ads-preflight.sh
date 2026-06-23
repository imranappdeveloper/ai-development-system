#!/usr/bin/env bash
# test-ads-preflight.sh — unit checks for ads-preflight.sh
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

echo "=== test-ads-preflight ==="

# Unbound project → FAIL
mkdir -p "$TMP/empty"
assert_exit "unbound project fails" 1 "$ROOT/scripts/ads-preflight.sh" "$TMP/empty" --json --quiet

# Bound without docs/agents → FAIL
mkdir -p "$TMP/bound/work" "$TMP/bound/docs"
cp "$ROOT/templates/project-starter/AGENTS.md" "$TMP/bound/AGENTS.md"
cp "$ROOT/templates/project-starter/ai-dev-os.yaml" "$TMP/bound/ai-dev-os.yaml"
sed -i '' "s|{{PROJECT_NAME}}|test-project|g" "$TMP/bound/ai-dev-os.yaml" 2>/dev/null \
  || sed -i "s|{{PROJECT_NAME}}|test-project|g" "$TMP/bound/ai-dev-os.yaml"
assert_exit "bound without agents fails" 1 "$ROOT/scripts/ads-preflight.sh" "$TMP/bound" --json --quiet

# Full fixture → OK
mkdir -p "$TMP/full/docs/agents" "$TMP/full/work/telemetry/runs"
cp "$TMP/bound/AGENTS.md" "$TMP/full/AGENTS.md"
cp "$TMP/bound/ai-dev-os.yaml" "$TMP/full/ai-dev-os.yaml"
for doc in issue-tracker.md triage-labels.md domain.md engineering-standards.md task-run.md; do
  echo "# test" >"$TMP/full/docs/agents/$doc"
done
assert_exit "full fixture passes" 0 "$ROOT/scripts/ads-preflight.sh" "$TMP/full" --json --quiet

json_out="$("$ROOT/scripts/ads-preflight.sh" "$TMP/full" --json --quiet)"
python3 -c "
import json, sys
doc = json.loads(sys.argv[1])
assert doc['status'] == 'ok', doc['status']
assert doc['project'] == sys.argv[2]
ids = {c['id'] for c in doc['checks']}
for req in ('check-cli', 'ai-paths', 'agents-md', 'ai-dev-os-yaml', 'docs-agents-issue-tracker.md'):
    assert req in ids, req
assert 'local_survey' in doc
assert 'graphify' in doc
print('  OK: JSON structure')
" "$json_out" "$TMP/full" || { echo "  FAIL: JSON structure" >&2; fail=1; }

[[ -x "$ROOT/scripts/ads-preflight.sh" ]] && echo "  OK: executable" || { echo "  FAIL: not executable" >&2; fail=1; }

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1