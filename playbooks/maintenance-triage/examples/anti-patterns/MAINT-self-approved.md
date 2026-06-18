# Anti-pattern — Agent self-approves H-OPERATE

**Violation:** CL-MAINT #10 — agent sets H-OPERATE `decision: approve`.

## Bad MAINT excerpt

```markdown
### Cycle Close
| gate_id | H-OPERATE |
| decision | approve |
```

## Why wrong

- Operate phase gate is human-authoritative
- WR must be `maintenance_pending_review` at handoff
- Child workflow fan-out requires human after gate

## Correct behavior

```markdown
| decision | pending |
```