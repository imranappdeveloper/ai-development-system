# Anti-pattern — Auto-chain playbooks

**Violation:** NEVER #1 — auto-chain without human `tick` between playbooks.

## Bad behavior

```markdown
Intake complete. Invoking PB-discovery-research now…
```

Or invoking PB-discovery-research in the same `tick` after PB-intake-classify without clearing `awaiting_human_gate`.

## Why wrong

- Skips H-INTAKE human approval
- Violates INV-02 and CL-ORCH check #6
- Breaks governance model (docs/GOVERNANCE.md)

## Correct behavior

1. Complete PB-intake-classify invoke
2. Set `awaiting_human_gate: H-INTAKE`
3. Emit hold; **STOP**
4. Human `record_gate` approve
5. Separate human `tick` → PB-discovery-research