# Sequential Promotion Gate — PB-perf-baseline

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| business_alias | Performance Baseline |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify gate PASS |
| spec_version | 1.0.0 |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-intake-classify | [../intake-classify/test-runs/latest-gate.md](../intake-classify/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

`verify-skill-spec.sh playbooks/perf-baseline` → FAIL=0

## Manual rubric

| Suite | Result |
|-------|--------|
| HT 8/8 | PASS |
| ET(P0) 11/11 | PASS |
| FT 7/7 | PASS |
| CL-PERF | PASS |
| Golden PERF-BASE-perf-001.md | PASS |
| Anti-patterns (3) | PASS |
| Fixtures wf-perf-alpha | PASS |
| EC-* count ≥15 | PASS |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS |
| routing-matrix status active | PASS |

## VERDICT: PASS

**Authorized:** Orchestrator default invoke at `status: active`.

**Next authorized:** PB-implement, PB-perf-review per `routing-matrix.yaml`.