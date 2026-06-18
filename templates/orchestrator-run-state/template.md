---
template_id: TP-ORS
version: 1.0.0
status: active
document_type: orchestrator_run_state
artifact_type: ORS
path_pattern: "{project_root}/work/orchestrator/{work_id}.ors.md"
producer: ORCH-PROJECT
---

# Orchestrator Run State — {{work_id}}

## State (YAML)

```yaml
run_id: RUN-{{run_id_suffix}}
work_id: {{work_id}}
workflow_id: {{workflow_id}}
current_phase: Intake
run_status: idle
current_playbook_id: null
awaiting_human_gate: null
phase_history: []
gate_history: []
playbook_history: []
retry_state: {}
revision: 0
updated: {{date}}
```

---

## Tick Log Reference

`work/orchestrator/logs/{{run_id}}.md`

---

## References

| Ref | Path |
|-----|------|
| design | workflows/project-orchestrator/DESIGN.md §5 |
| standard | standards/ARTIFACT-CONTRACT.md §2 |
| checklist | checklists/orchestrator.md |