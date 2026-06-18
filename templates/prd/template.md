---
template_id: TP-prd
version: 1.0.0
status: active
document_type: prd
sdlc_workflows: [WF-PROJECT-NEW, WF-FEATURE, WF-ENHANCEMENT]
gates: [H-FRAME, H-PLAN]
---

# PRD — {{feature_name}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | {{document_id}} |
| work_id | {{work_id}} |
| project | {{project_name}} |
| author | {{author}} |
| created | {{date}} |
| last_updated | {{date}} |
| status | draft \| in_review \| approved |
| prd_type | full \| lite |

---

## 1. Overview

### 1.1 Summary

[TODO: One paragraph — what we are building.]

### 1.2 Goals

| Goal | Metric | Target |
|------|--------|--------|
| | | |

### 1.3 Non-Goals

| Non-goal | Rationale |
|----------|-----------|
| | |

---

## 2. Background & Context

[TODO: Link to discovery, vision, or business context.]

| Reference | Path |
|-----------|------|
| discovery | |
| vision | |

---

## 3. Users & Use Cases

### 3.1 Personas

| Persona | Need |
|---------|------|
| | |

### 3.2 User Stories

| ID | As a… | I want… | So that… | Priority |
|----|-------|---------|----------|----------|
| US- | | | | |

### 3.3 Use Cases

| ID | Actor | Flow summary |
|----|-------|--------------|
| UC- | | |

---

## 4. Requirements

### 4.1 Functional Requirements

| ID | Requirement | Priority (M/S/C/W) | Notes |
|----|-------------|-------------------|-------|
| FR- | | | |

### 4.2 Non-Functional Requirements

| ID | Category | Requirement | Target |
|----|----------|-------------|--------|
| NFR- | performance \| security \| a11y \| reliability | | |

---

## 5. Acceptance Criteria

| ID | Criterion | Testable | Verification method |
|----|-----------|----------|---------------------|
| AC- | | yes \| no | |

---

## 6. User Experience

### 6.1 UX Overview

[TODO: High-level UX intent — wireframes optional as links.]

### 6.2 Accessibility

[TODO: A11y requirements per STD-A11Y-001 / project CONTEXT.md.]

---

## 7. Technical Considerations

[TODO: High-level only — detail in TP-architecture, TP-api, TP-database.]

| Area | Notes | Detailed doc |
|------|-------|--------------|
| architecture | | TP-architecture |
| api | | TP-api |
| data | | TP-database |

---

## 8. Dependencies

| Dependency | Type | Owner | Status |
|------------|------|-------|--------|
| | internal \| external | | |

---

## 9. Rollout & Success

### 9.1 Rollout Plan

[TODO: Phasing, feature flags, migration.]

### 9.2 Success Metrics

| Metric | Baseline | Target | Window |
|--------|----------|--------|--------|
| | | | |

---

## 10. Risks & Open Questions

### 10.1 Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| | | |

### 10.2 Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| | | | open |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| upstream | TP-vision, TP-discovery |
| downstream | TP-architecture, TP-feature, TP-api, TP-database |
| standards | STD-DOC-001, STD-A11Y-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |