#!/usr/bin/env bash
# verify-catalog.sh — INDEX.md active_skills count matches active playbook registries
# Usage: ./scripts/verify-catalog.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

INDEX="INDEX.md"
FAIL=0

fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }
pass() { echo "  PASS: $1"; }

echo "=== verify-catalog: INDEX.md active_skills vs registry count ==="

if [[ ! -f "$INDEX" ]]; then
  echo "FAIL: INDEX.md not found"
  exit 1
fi

# Count active playbook registries (exclude scaffold and meta skills)
REGISTRY_COUNT=0
while IFS= read -r registry; do
  base="$(basename "$(dirname "$registry")")"
  [[ "$base" == "_contract-scaffold" ]] && continue
  [[ "$base" == meta-* ]] && continue
  REGISTRY_COUNT=$((REGISTRY_COUNT + 1))
done < <(grep -l '^status: active' playbooks/*/registry.yaml 2>/dev/null || true)

INDEX_COUNT="$(grep -m1 '| active_skills |' "$INDEX" | sed -E 's/.*\| ([0-9]+) \|/\1/' || echo "")"

if [[ -z "$INDEX_COUNT" ]]; then
  fail "INDEX.md missing active_skills field"
else
  if [[ "$INDEX_COUNT" -eq "$REGISTRY_COUNT" ]]; then
    pass "active_skills=$INDEX_COUNT matches registry count=$REGISTRY_COUNT"
  else
    fail "active_skills=$INDEX_COUNT but registry count=$REGISTRY_COUNT"
    echo "  Active registries:"
    grep -l '^status: active' playbooks/*/registry.yaml 2>/dev/null \
      | grep -v '_contract-scaffold' \
      | grep -v 'meta-' \
      | sed 's/^/    /' || true
  fi
fi

echo "=== Summary: verify-catalog — FAIL=$FAIL ==="
[[ "$FAIL" -eq 0 ]] && exit 0 || exit 1