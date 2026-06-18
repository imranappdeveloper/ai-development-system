# Anti-pattern — Agent self-approves intake

**Violation:** CL-INTAKE #10 — agent sets `decision: approve` on H-INTAKE.

## Bad INT excerpt

```markdown
## Human Approval
| gate_id | H-INTAKE |
| decision | approve |
| approver | agent |
```

## Why wrong

- Governance bypass; human is final authority on classification
- WR must stay `intake_pending_review` until human acts

## Correct behavior

```markdown
| decision | pending |
```

Only human may change to `approve`, `revise`, or `reject` at H-INTAKE.