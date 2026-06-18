# Sequential Promotion Gate — PB-diagnose-bug

| Field | Value |
|-------|-------|
| skill_id | PB-diagnose-bug |
| business_alias | Bug Diagnosis |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify gate PASS |
| spec_version | 1.0.0 |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-intake-classify | [../intake-classify/test-runs/latest-gate.md](../intake-classify/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

`verify-skill-spec.sh playbooks/diagnose-bug` → FAIL=0

## Manual rubric

| Suite | Result |
|-------|--------|
| HT 8/8 | PASS |
| ET(P0) 10/10 | PASS |
| FT 7/7 | PASS |
| CL-DIAGNO | PASS |
| Golden DIAG-bugfix-001.md | PASS |
| Anti-patterns (3) | PASS |
| Fixtures wf-bugfix-alpha | PASS |
| EC-* count ≥15 | PASS |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS |
| routing-matrix status active | PASS |

## VERDICT: PASS

**Authorized:** Orchestrator default invoke at `status: active`.

**Next authorized:** PB-draft-issue per `routing-matrix.yaml`.
