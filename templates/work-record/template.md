---
template_id: TP-WR
version: 1.0.0
status: active
document_type: work_record
artifact_type: WR
path_pattern: "{project_root}/work/{work_id}.md"
---

# Work Record — {{work_id}}

## Frontmatter (YAML)

```yaml
work_id: {{work_id}}
status: intake_in_progress
work_type: {{work_type}}
workflow_id: {{workflow_id}}
entry_mode: {{entry_mode}}
artifacts: []
approvals: []
revision: 0
os_refs:
  skill: PB-intake-classify
  spec_version: "1.0.0"
  prompt_version: "1.0.0"
orchestrator:
  run_id: null
  current_phase: Intake
  run_status: idle
  ors_path: work/orchestrator/{{work_id}}.ors.md
```

---

## 1. Summary

{{summary}}

---

## 2. Artifact Index

| type | path | status |
|------|------|--------|
| INT | work/intake/{{work_id}}.md | pending |

---

## 3. Approval History

| gate_id | decision | approver | date | notes |
|---------|----------|----------|------|-------|
| | | | | |

---

## References

| Ref | Path |
|-----|------|
| standard | standards/ARTIFACT-CONTRACT.md §1 |
| registry | ARTIFACT-REGISTRY.yaml#WR |