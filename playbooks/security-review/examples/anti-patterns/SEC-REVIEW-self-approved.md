---
anti_pattern_id: SEC-REVIEW-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 10
---

# Anti-Pattern — Self-Approve H-VERIFY

## What goes wrong

Agent sets human gate decision to approved:

```yaml
approvals:
  - gate_id: H-VERIFY
    decision: approve
    approver: PB-security-review
    date: 2026-06-18
```

Or in SEC-REVIEW Human Approval section:

```markdown
| gate_id | H-VERIFY |
| decision | approve |
| approver | agent |
```

## Symptoms

- CL-SECURITY-REVIEW #10 fail
- PB-prepare-release invoked without human authorization
- Audit trail invalid
- Optional gate treated as auto-approved

## Correct pattern

Agent sets `decision: pending` only; human approves after review:

```yaml
approvals:
  - gate_id: H-VERIFY
    decision: pending
```