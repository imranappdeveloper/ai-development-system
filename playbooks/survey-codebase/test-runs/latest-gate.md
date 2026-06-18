# Sequential Promotion Gate — PB-survey-codebase

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify `test-runs/latest-gate.md` VERDICT PASS; PB-onboard-project `test-runs/latest-gate.md` VERDICT PASS |
| spec_version | 1.0.0 |

## Structural preflight

```bash
./scripts/verify-skill-spec.sh playbooks/survey-codebase
# Result: FAIL=0
```

## Manual rubric (11-test-plan.md)

| Suite | Tests | Result | Notes |
|-------|-------|--------|-------|
| ENV | ENV-01–05 | PASS | CL-SURVEY active; fixtures + allowlist in 05-context |
| HT | HT-01–HT-05 | PASS | Golden SURVEY-feature-001; advisory handoff |
| ET | ET-01–ET-08 | PASS | No INT, unbounded scan, PRD in SURVEY, gate fabrication |
| FT | FT-01–FT-03 | PASS | Fixture INT + minimal CONTEXT |
| CL-SURVEY | 10 checks | PASS | Mapped in 06-quality.md |

## Promotion formula

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-SURVEY manual rubric pass AND 10-review ≥ 75
```

## VERDICT: PASS

**Next skill authorized (recommend only):** PB-discovery-research.