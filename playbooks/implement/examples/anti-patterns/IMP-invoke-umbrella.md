---
anti_pattern_id: IMP-invoke-umbrella
severity: P0
related_ec: EC-RT-01, EC-RT-05
---

# Anti-Pattern — Invoke PB-implement

## What goes wrong

Agent or orchestrator sets:

```yaml
playbook_invocation:
  skill_id: PB-implement
```

## Symptoms

- No CODE produced in any lane
- Work Record shows skill run without CODE artifact paths
- Pipeline stalls waiting for H-IMPLEMENT on non-existent output
- Verify phase blocked — no CODE to test

## Correct pattern

1. Consult umbrella docs (optional)
2. Emit `routing_resolution` with lane child
3. Invoke child:

```yaml
playbook_invocation:
  skill_id: PB-implement-backend  # or frontend | mobile | devops
```

## Prevention

- 09-system-prompt NEVER list
- routing-matrix excludes umbrella (target state)
- Adapter maps "Implementation" → resolver, not invoke