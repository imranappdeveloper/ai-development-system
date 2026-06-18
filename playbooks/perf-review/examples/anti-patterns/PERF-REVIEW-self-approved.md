---
anti_pattern_id: PERF-REVIEW-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 10
---

# Anti-Pattern — Agent Self-Approves H-VERIFY

## What goes wrong

Agent sets Human Approval to approve:

```yaml
gate_id: H-VERIFY
sub_gate: perf_review
decision: approve
approver: PB-perf-review
```

## Symptoms

- CL-PERF-REVIEW #10 fail
- STD-REV-001 human authority violated
- Downstream PB-prepare-release may proceed without human sign-off

## Correct pattern

Agent always sets `decision: pending`. Human records approve/revise/reject after review.