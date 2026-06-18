# Anti-pattern — Agent fabricates human gate on advisory SURVEY

**Violation:** CL-SURVEY #10 — skill has `exit_gate: none`; agent must not add gate blocks.

## Bad SURVEY excerpt

```markdown
## Human Approval
| gate_id | H-FRAME |
| decision | approve |
```

## Why wrong

- PB-survey-codebase produces advisory SURVEY only
- Frame gates apply to DISC/ONBOARD — not SURVEY
- Self-approval bypasses human authority on downstream artifacts

## Correct behavior

```markdown
## 10. Advisory Handoff
| exit_gate | none |
| recommended_next_skill | PB-discovery-research |
```

No `gate_id`, no `decision` field. Human/orchestrator decides next invoke.