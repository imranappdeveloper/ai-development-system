# Anti-pattern — Agent self-approves discovery

**Violation:** CL-DISCOVERY #10 — agent sets H-FRAME `decision: approve`.

## Bad DISC excerpt

```markdown
## Human Approval
| gate_id | H-FRAME |
| decision | approve |
```

## Why wrong

- Frame phase gate is human-authoritative
- WR must be `discovery_pending_review` at handoff

## Correct behavior

```markdown
| decision | pending |
```

Recommend next playbook only after human H-FRAME approval via orchestrator `record_gate`.