# Anti-pattern — Agent self-approves onboarding

**Violation:** CL-ONBOAR #10 — agent sets H-FRAME `decision: approve`.

## Bad ONBOARD excerpt

```markdown
## 8. Human Approval
| gate_id | H-FRAME |
| decision | approve |
```

## Why wrong

- Frame phase gate is human-authoritative
- WR must be `onboard_pending_review` at handoff

## Correct behavior

```markdown
| decision | pending |
```

Recommend next playbook only after human H-FRAME approval via orchestrator `record_gate`.