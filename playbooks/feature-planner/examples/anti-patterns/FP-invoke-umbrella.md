---
anti_pattern_id: FP-invoke-umbrella
severity: P0
related_ec: EC-RT-01, EC-RT-05
---

# Anti-Pattern — Invoke PB-feature-planner

## What goes wrong

Agent or orchestrator sets:

```yaml
playbook_invocation:
  skill_id: PB-feature-planner
```

## Symptoms

- No FEAT, PRD, or ISS-* produced
- Work Record shows skill run without artifacts
- Pipeline stalls waiting for exit_gate that does not exist

## Correct pattern

1. Consult umbrella docs (optional)
2. Emit `routing_resolution`
3. Invoke child:

```yaml
playbook_invocation:
  skill_id: PB-draft-feature  # or PB-decompose-issues
```

## Prevention

- 09-system-prompt NEVER list
- routing-matrix excludes umbrella
- Adapter maps "Feature Planner" → resolver, not invoke