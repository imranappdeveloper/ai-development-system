# Sequential Promotion Gate — PB-decompose-issues

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| business_alias | Issue Decomposer |
| gate_date | 2026-06-18 |
| prerequisite | PB-draft-prd gate PASS |
| spec_version | 1.0.0 |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-draft-prd | [../draft-prd/test-runs/latest-gate.md](../draft-prd/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

`verify-skill-spec.sh playbooks/decompose-issues` → FAIL=0

## Manual rubric

| Suite | Result |
|-------|--------|
| HT 8/8 | PASS |
| ET(P0) 10/10 | PASS |
| FT 7/7 | PASS |
| CL-DECOMP | PASS |
| Golden DECOMPOSE-feature-001 | PASS |
| Anti-patterns (3) | PASS |
| Fixtures PRD + ISS stub | PASS |
| EC-* count ≥15 | PASS (27) |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS (74) |
| routing-matrix next_candidates lane children | PASS |

## VERDICT: PASS

**Authorized:** Orchestrator default invoke at `status: active`.

**Next authorized:** Implement lane children per `routing-matrix.yaml` (`PB-implement-backend` primary).