#!/usr/bin/env bash
# verify-standalone.sh — confirm OS repo is self-contained SSOT (no external skill deps)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/skills/MANIFEST.yaml"
FAIL=0

die() { echo "FAIL: $1" >&2; FAIL=1; }
ok() { echo "  OK: $1"; }

echo "=== AI Dev OS — Standalone verification ==="
echo "  repo: $ROOT"
echo ""

# 1. Manifest exists
[[ -f "$MANIFEST" ]] || die "skills/MANIFEST.yaml missing"
ok "MANIFEST.yaml present"

# 2. All manifest skills bundled
while IFS= read -r skill; do
  [[ -z "$skill" ]] && continue
  if [[ -f "$ROOT/skills/${skill}/SKILL.md" ]]; then
    ok "skill bundled: ${skill}"
  else
    die "skill missing: skills/${skill}/SKILL.md"
  fi
done < <(awk '/^required:/{p=1;next} /^[a-zA-Z#]/{if(p&&$1!="required:")p=0} p && /^  - /{gsub(/^  - /,""); print}' "$MANIFEST")

# 3. No external agent-skills load paths (allow "never" / "no external" warnings in docs)
_bad_refs="$(grep -rE '~/.agent-skills|agent-skills/shared' "$ROOT/skills" "$ROOT/scripts" 2>/dev/null \
  | grep -v 'verify-standalone.sh' \
  | grep -vE 'never |no external|No external|not external' || true)"
if [[ -n "$_bad_refs" ]]; then
  echo "$_bad_refs" >&2
  die "external agent-skills reference found in skills/ or scripts/"
else
  ok "no external agent-skills load paths"
fi

# 4. Core docs present
for doc in docs/STANDALONE.md docs/USER-FLOW.md docs/REQUIREMENT-CHECK.md docs/SETUP-ADS.md skills/MANIFEST.yaml; do
  [[ -f "$ROOT/$doc" ]] || die "missing $doc"
done
ok "core SSOT docs present"

# 5. CLI scripts executable
for s in install-cli.sh check-cli.sh new-project.sh task-run.sh ai-paths.sh; do
  [[ -x "$ROOT/scripts/$s" ]] || die "not executable: scripts/$s"
done
ok "CLI scripts executable"

# 6. check-cli (quiet)
if AI_DEV_OS_HOME="$ROOT" "$ROOT/scripts/check-cli.sh" --quiet; then
  ok "check-cli passes"
else
  die "check-cli failed — run install-cli.sh"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
  echo "=== STANDALONE OK — repo is self-contained SSOT ==="
  exit 0
else
  echo "=== STANDALONE FAILED — fix items above ==="
  exit 1
fi