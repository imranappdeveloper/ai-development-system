# Golden — ORS after intake tick (H-INTAKE hold)

**Scenario:** HT-02 — first `tick` on WF-FEATURE invokes PB-intake-classify; child completes with `exit_gate: H-INTAKE`.

## Expected ORS state block

```yaml
run_id: RUN-20260618-001
work_id: WR-FEATURE-001
workflow_id: WF-FEATURE
current_phase: Intake
run_status: awaiting_human
current_playbook_id: null
awaiting_human_gate: H-INTAKE
phase_history:
  - phase: Intake
    entered: 2026-06-18T12:00:00Z
gate_history: []
playbook_history:
  - skill_id: PB-intake-classify
    completed: 2026-06-18T12:05:00Z
    handoff_status: complete
    exit_gate: H-INTAKE
retry_state: {}
context_digest_refs:
  - type: INT
    path: work/intake/WR-FEATURE-001.md
revision: 0
updated: 2026-06-18T12:05:00Z
```

## Expected tick summary (excerpt)

```markdown
## Tick summary

- Invoked PB-intake-classify (Intake phase)
- INT persisted: work/intake/WR-FEATURE-001.md
- Child exit_gate H-INTAKE → awaiting_human_gate set
- CL-ORCH: 8/8 pass
```

## Expected human hold (ORCH-OUT-04)

```yaml
hold_reason: awaiting_human_gate
gate_id: H-INTAKE
required_human_action: record_gate
options:
  - decision: approve
  - decision: revise
  - decision: reject
```

## Pass criteria

- AC-GATE-01, AC-GATE-02, AC-OUT-01
- No second playbook invoked
- Matches fixture `fixtures/projects/wf-feature-alpha/`