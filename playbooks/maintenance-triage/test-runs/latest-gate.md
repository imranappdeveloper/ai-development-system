# Sequential Promotion Gate — PB-maintenance-triage

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| gate_date | 2026-06-18 |
| prerequisite | PB-intake-classify `test-runs/latest-gate.md` VERDICT PASS |
| spec_version | 1.0.0 |

## Structural preflight

```bash
./scripts/verify-skill-spec.sh playbooks/maintenance-triage
# Result: FAIL=0
```

## Manual rubric (11-test-plan.md)

| Suite | Tests | Result | Notes |
|-------|-------|--------|-------|
| ENV | ENV-01–05 | PASS | CL-MAINT, TP-maintenance, intake gate prerequisite |
| HT | HT-01–HT-05 | PASS | Golden MAINT-cycle-001; WF-MAINTENANCE + WF-RELEASE paths |
| ET | ET-01–ET-05 | PASS | No INT, deploy command, batch depth, self-approve |
| CL-MAINT | 10 checks | PASS | Mapped in 06-quality.md |

## Promotion formula

```
HT: 100% AND ET(P0): 100% AND CL-MAINT manual rubric pass AND 10-review ≥ 70
AND prerequisite PB-intake-classify gate PASS
```

## VERDICT: PASS

**Child workflow fan-out:** authorized only after human H-OPERATE approve.