# Sequential Promotion Gate — PB-onboard-project

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify `test-runs/latest-gate.md` VERDICT PASS |
| spec_version | 1.0.0 |

## Structural preflight

```bash
./scripts/verify-skill-spec.sh playbooks/onboard-project
# Result: FAIL=0
```

## Manual rubric (11-test-plan.md)

| Suite | Tests | Result | Notes |
|-------|-------|--------|-------|
| ENV | ENV-01–05 | PASS | CL-ONBOAR, CONTEXT.md fixture, intake gate prerequisite |
| HT | HT-01–HT-05 | PASS | Golden ONBOARD-existing-001; §6.2 alignment block |
| ET | ET-01–ET-05 | PASS | No INT, missing CONTEXT, feature redirect, CONTEXT write |
| CL-ONBOAR | 10 checks | PASS | Mapped in 06-quality.md |

## Promotion formula

```
HT: 100% AND ET(P0): 100% AND CL-ONBOAR manual rubric pass AND 10-review ≥ 70
AND prerequisite PB-intake-classify gate PASS
```

## VERDICT: PASS

**Next skill authorized:** PB-survey-codebase, PB-draft-prd (recommend only after H-FRAME).