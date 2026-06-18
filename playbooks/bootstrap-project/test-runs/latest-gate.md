# Sequential Promotion Gate — PB-bootstrap-project

| Field | Value |
|-------|-------|
| skill_id | PB-bootstrap-project |
| business_alias | Project Bootstrap |
| gate_date | 2026-06-18 |
| prerequisite | PB-draft-prd gate PASS |
| spec_version | 1.0.0 |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-draft-prd | [../draft-prd/test-runs/latest-gate.md](../draft-prd/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

`verify-skill-spec.sh playbooks/bootstrap-project` → FAIL=0

## Manual rubric

| Suite | Result |
|-------|--------|
| HT 8/8 | PASS |
| ET(P0) 10/10 | PASS |
| FT 7/7 | PASS |
| CL-BOOTST | PASS |
| Golden BOOTSTRAP-project-001.md | PASS |
| Anti-patterns (3) | PASS |
| Fixtures wf-project-new | PASS |
| EC-* count ≥15 | PASS |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS |
| routing-matrix status active | PASS |

## VERDICT: PASS

**Authorized:** Orchestrator default invoke at `status: active`.

**Next authorized:** PB-onboard-project per `routing-matrix.yaml`.
