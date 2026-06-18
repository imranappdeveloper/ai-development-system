---
anti_pattern_id: DECOMPOSE-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 10
---

# Anti-Pattern — Self-Approve H-DECOMPOSE

## What goes wrong

Agent sets human gate decision to approved:

```yaml
approvals:
  - gate_id: H-DECOMPOSE
    decision: approve
    approver: PB-decompose-issues
    date: 2026-06-18
```

Or in manifest Human Approval section:

```markdown
| gate_id | H-DECOMPOSE |
| decision | approve |
| approver | agent |
```

## Symptoms

- CL-DECOMP #10 fail
- PB-implement-backend invoked without human authorization
- Audit trail invalid
- Gate bypass

## Correct pattern

Agent sets `decision: pending` only; human approves after review:

```yaml
approvals:
  - gate_id: H-DECOMPOSE
    decision: pending
```

## Prevention

- CL-DECOMP check #10
- N13 in 02-responsibilities.md
- 04-io-contract Human-Only Outputs table