#!/usr/bin/env bash
# verify-skill-spec.sh — STD-SKILL-001 structural + promotion preflight
# Usage: ./scripts/verify-skill-spec.sh playbooks/intake-classify
set -euo pipefail

SKILL_DIR="${1:?Usage: verify-skill-spec.sh <playbook-dir>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -d "$SKILL_DIR" ]]; then
  echo "FAIL: directory not found: $SKILL_DIR"
  exit 1
fi

SKILL_ID=$(grep -m1 '^skill_id:' "$SKILL_DIR/registry.yaml" 2>/dev/null | awk '{print $2}' || echo unknown)
FAIL=0
WARN=0

pass() { echo "  PASS: $1"; }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  WARN: $1"; WARN=$((WARN + 1)); }

echo "=== verify-skill-spec: $SKILL_ID ($SKILL_DIR) ==="

# Required spec files
for f in 01-purpose.md 02-responsibilities.md 03-workflow.md 04-io-contract.md \
         05-context.md 06-quality.md 07-edge-cases.md 08-limitations.md \
         09-system-prompt.md 10-review.md 11-test-plan.md README.md registry.yaml; do
  if [[ -f "$SKILL_DIR/$f" ]]; then pass "$f exists"; else fail "missing $f"; fi
done

# Registry
if [[ -f "$SKILL_DIR/registry.yaml" ]]; then
  for key in skill_id spec_version prompt_version status; do
    if grep -q "^${key}:" "$SKILL_DIR/registry.yaml"; then pass "registry $key"; else fail "registry missing $key"; fi
  done
  REG_STATUS=$(grep '^status:' "$SKILL_DIR/registry.yaml" | awk '{print $2}')
  pass "registry status=$REG_STATUS"
fi

# Examples
GOLDEN_COUNT=$(find "$SKILL_DIR/examples/golden" -name '*.md' 2>/dev/null | wc -l || echo 0)
ANTI_COUNT=$(find "$SKILL_DIR/examples/anti-patterns" -name '*.md' 2>/dev/null | wc -l || echo 0)
[[ "$GOLDEN_COUNT" -ge 1 ]] && pass "golden examples: $GOLDEN_COUNT" || fail "golden examples < 1 ($GOLDEN_COUNT)"
[[ "$ANTI_COUNT" -ge 3 ]] && pass "anti-patterns: $ANTI_COUNT" || fail "anti-patterns < 3 ($ANTI_COUNT)"

# Fixtures
if [[ -d "$SKILL_DIR/fixtures" ]]; then pass "fixtures/ exists"; else fail "missing fixtures/"; fi

# Edge cases (count EC- lines in table or EC-* ids)
EC_COUNT=$(grep -cE 'EC-[A-Z]+-[0-9]+|^\| EC-' "$SKILL_DIR/07-edge-cases.md" 2>/dev/null || echo 0)
[[ "$EC_COUNT" -ge 15 ]] && pass "edge cases: $EC_COUNT" || fail "edge cases < 15 ($EC_COUNT)"

# System prompt markers
if grep -qE 'PROMPT_START|PROMPT START' "$SKILL_DIR/09-system-prompt.md" 2>/dev/null; then
  pass "09-system-prompt has PROMPT start marker"
else
  fail "09-system-prompt missing PROMPT start marker"
fi

# 10-review score
if grep -qE '[7-9][0-9]\s*/\s*100|readiness.*[7-9][0-9]|Score.*[7-9][0-9]' "$SKILL_DIR/10-review.md" 2>/dev/null; then
  pass "10-review has readiness score ≥70"
else
  warn "10-review score not found or <70"
fi

# Checklist linkage
CL_ID=$(grep -m1 '^checklist_id:' "$SKILL_DIR/registry.yaml" 2>/dev/null | awk '{print $2}' || echo null)
if [[ "$CL_ID" != "null" && -n "$CL_ID" ]]; then
  CL_FILE="checklists/$(echo "$CL_ID" | sed 's/CL-//' | tr '[:upper:]' '[:lower:]' | sed 's/_/-/g').md"
  # Map common IDs
  case "$CL_ID" in
    CL-INTAKE) CL_FILE="checklists/intake.md" ;;
    CL-DISCOVERY) CL_FILE="checklists/discovery.md" ;;
    CL-PRD) CL_FILE="checklists/prd.md" ;;
    CL-ARCH) CL_FILE="checklists/architecture.md" ;;
    CL-ORCH) CL_FILE="checklists/orchestrator.md" ;;
    CL-IMPLEMENT-BACKEND) CL_FILE="checklists/implement-backend.md" ;;
    CL-IMPLEMENT-FRONTEND) CL_FILE="checklists/implement-frontend.md" ;;
    CL-IMPLEMENT-MOBILE) CL_FILE="checklists/implement-mobile.md" ;;
    CL-IMPLEMENT-DEVOPS) CL_FILE="checklists/implement-devops.md" ;;
    CL-DATABASE) CL_FILE="checklists/database.md" ;;
    CL-API) CL_FILE="checklists/api.md" ;;
    CL-UIUX) CL_FILE="checklists/uiux.md" ;;
    CL-TEST-PLAN) CL_FILE="checklists/test-plan.md" ;;
    CL-TEST-GEN) CL_FILE="checklists/test-generate.md" ;;
    CL-SECURITY-REVIEW) CL_FILE="checklists/security-review.md" ;;
    CL-PERF-REVIEW) CL_FILE="checklists/perf-review.md" ;;
    CL-DOC-UPDATE) CL_FILE="checklists/doc-update.md" ;;
    CL-RELEASE) CL_FILE="checklists/release.md" ;;
    CL-DECOMP) CL_FILE="checklists/decompose.md" ;;
    CL-BOOTST) CL_FILE="checklists/bootstrap.md" ;;
    CL-DIAGNO) CL_FILE="checklists/diagnose.md" ;;
    CL-ISSUE) CL_FILE="checklists/issue.md" ;;
    CL-VERIFY) CL_FILE="checklists/verify.md" ;;
    CL-REVIEW) CL_FILE="checklists/review.md" ;;
    CL-ONBOAR) CL_FILE="checklists/onboard.md" ;;
    CL-SURVEY) CL_FILE="checklists/survey.md" ;;
    CL-DRAFT) CL_FILE="checklists/draft.md" ;;
    CL-SECURI) CL_FILE="checklists/security.md" ;;
    CL-PERF) CL_FILE="checklists/perf.md" ;;
    CL-MAINT) CL_FILE="checklists/maintenance.md" ;;
  esac
  if [[ -f "$CL_FILE" ]]; then pass "checklist $CL_ID → $CL_FILE"; else fail "checklist $CL_ID file missing ($CL_FILE)"; fi
else
  warn "checklist_id null (umbrella skill?)"
fi

# Promotion evidence in 11-test-plan
if grep -qiE 'promotion evidence|evidence log|HT.*pass' "$SKILL_DIR/11-test-plan.md" 2>/dev/null; then
  pass "11-test-plan has promotion evidence section"
else
  warn "11-test-plan missing promotion evidence log"
fi

# Sequential gate stamp
if [[ -f "$SKILL_DIR/test-runs/latest-gate.md" ]]; then
  if grep -qiE 'VERDICT:?\s*PASS|verdict.*PASS' "$SKILL_DIR/test-runs/latest-gate.md"; then
    pass "test-runs/latest-gate.md VERDICT PASS"
  else
    fail "test-runs/latest-gate.md not PASS"
  fi
else
  warn "no test-runs/latest-gate.md (sequential gate not recorded)"
fi

echo "=== Summary: $SKILL_ID — FAIL=$FAIL WARN=$WARN ==="
[[ "$FAIL" -eq 0 ]] && exit 0 || exit 1