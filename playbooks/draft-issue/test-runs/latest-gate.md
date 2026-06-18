# Sequential Promotion Gate — PB-draft-issue

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| business_alias | Bugfix Issue Draft |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify gate PASS |
| spec_version | 1.0.0 |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-intake-classify | [../intake-classify/test-runs/latest-gate.md](../intake-classify/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

`verify-skill-spec.sh playbooks/draft-issue` → FAIL=0

## Manual rubric

| Suite | Result |
|-------|--------|
| HT 8/8 | PASS |
| ET(P0) 10/10 | PASS |
| FT 7/7 | PASS |
| CL-ISSUE | PASS |
| Golden ISSUE-bugfix-001 | PASS |
| Anti-patterns (3) | PASS |
| Fixtures wf-bugfix-alpha | PASS |
| EC-* count ≥15 | PASS |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS |
| routing-matrix status active | PASS |

## VERDICT: PASS

**Authorized:** Orchestrator default invoke at `status: active`.

**Next authorized:** PB-implement per `routing-matrix.yaml`.