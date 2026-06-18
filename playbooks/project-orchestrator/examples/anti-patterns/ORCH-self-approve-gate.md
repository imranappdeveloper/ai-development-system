# Anti-pattern — Agent self-approves gate

**Violation:** NEVER #2 — agent sets `record_gate` or `decision: approve` on H-*.

## Bad ORS / output

```yaml
gate_history:
  - gate_id: H-INTAKE
    decision: approve
    actor: agent
```

Or narrative: "H-INTAKE approved — proceeding to discovery."

## Why wrong

- AC-GATE-04 fail
- Human gates are advisory but **human-authoritative**
- `record_gate` is human-channel only

## Correct behavior

```yaml
awaiting_human_gate: H-INTAKE
```

Hold package with `required_human_action: record_gate` and `decision: pending` until human acts.