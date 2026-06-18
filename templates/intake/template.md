---
template_id: TP-intake
version: 1.0.0
status: active
document_type: intake
artifact_type: INT
path_pattern: "{project_root}/work/intake/{work_id}.md"
producer: PB-intake-classify
gate: H-INTAKE
---

# Intake — {{title}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | INT-{{work_id}} |
| work_id | {{work_id}} |
| work_type | {{work_type}} |
| workflow_id | {{workflow_id}} |
| entry_mode | {{entry_mode}} |
| classification_confidence | {{classification_confidence}} |
| status | draft \| pending_review \| approved \| rejected |
| revision | {{revision}} |
| created | {{date}} |
| requester | {{requester}} |
| suggested_priority | {{priority}} |
| recommended_next_skill | {{recommended_next_skill}} |

---

## 1. Problem Statement

{{problem_statement}}

---

## 2. Classification Rationale

{{classification_rationale}}

---

## 3. Scope

### 3.1 In Scope

{{in_scope}}

### 3.2 Out of Scope

{{out_of_scope}}

---

## 4. Recommended Next Artifacts

| template_id | rationale |
|-------------|-----------|
| {{next_artifact_1}} | {{why_1}} |

---

## 5. Open Questions

{{open_questions}}

---

## 6. Blockers

{{blockers}}

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-INTAKE |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |

---

## References

| Ref | Path |
|-----|------|
| work_record | {{project_root}}/work/{{work_id}}.md |
| contract | playbooks/intake-classify/04-io-contract.md OUT-01 |
| standard | standards/ARTIFACT-CONTRACT.md §3 |