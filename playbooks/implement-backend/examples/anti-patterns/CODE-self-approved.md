---
anti_pattern_id: CODE-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 10
---

# Anti-Pattern — Self-Approve H-IMPLEMENT

## What goes wrong

Agent sets human gate decision to approved:

```yaml
approvals:
  - gate_id: H-IMPLEMENT
    decision: approve
    approver: PB-implement-backend
    date: 2026-06-18
```

Or in CODE Human Approval section:

```markdown
| gate_id | H-IMPLEMENT |
| decision | approve |
| approver | agent |
```

## Symptoms

- CL-IMPLEMENT-BACKEND #10 fail
- PB-verify invoked without human authorization
- Audit trail invalid
- Gate bypass

## Correct pattern

Agent sets `decision: pending` only; human approves after review:

```yaml
approvals:
  - gate_id: H-IMPLEMENT
    decision: pending
```

## Prevention

- CL-IMPLEMENT-BACKEND check #10
- N13 in 02-responsibilities.md
- 04-io-contract Human-Only Outputs table