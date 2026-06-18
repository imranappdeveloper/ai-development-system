# Anti-pattern — Auto-recommend as invoke

**Violation:** NEVER / N12 — treating `recommended_next_skill` as permission to start the next playbook.

## Bad handoff

```markdown
Intake complete. Starting PB-discovery-research…
```

## Why wrong

- Skips H-INTAKE human approval
- Orchestrator must receive `record_gate` before next `tick`
- `recommended_next_skill` is advisory only

## Correct behavior

```yaml
gate_id: H-INTAKE
decision: pending
recommended_next_skill: PB-discovery-research
```

Stop at handoff marker — await human approval.