---
template_id: TP-feature
version: 1.0.0
status: active
document_type: feature-specification
sdlc_workflows: [WF-FEATURE, WF-ENHANCEMENT]
gates: [H-DECOMPOSE, H-PLAN]
---

# Feature Specification — {{feature_name}}

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
| feature_type | new \| enhancement |
| slice | {{vertical_slice_name}} |

---

## 1. Summary

[TODO: One paragraph — this slice/feature and its user-visible outcome.]

---

## 2. Parent Context

| Reference | Path | Relevant section |
|-----------|------|------------------|
| PRD | | |
| architecture | | |
| API | | |
| database | | |

---

## 3. Scope

### 3.1 In Scope

| Item | Notes |
|------|-------|
| | |

### 3.2 Out of Scope

| Item | Rationale |
|------|-----------|
| | |

### 3.3 Dependencies

| Dependency | Type | Status |
|------------|------|--------|
| | feature \| infra \| external | |

---

## 4. Functional Behavior

### 4.1 User Flows

| Flow ID | Actor | Steps summary |
|---------|-------|---------------|
| F- | | |

### 4.2 Business Rules

| Rule ID | Rule | Source |
|---------|------|--------|
| BR- | | |

### 4.3 Edge Cases

| Case | Expected behavior |
|------|-------------------|
| | |

---

## 5. Technical Specification

### 5.1 Components Affected

| Component / path | Change type |
|------------------|-------------|
| | new \| modify \| remove |

### 5.2 Interfaces

| Interface | Change | Doc ref |
|-----------|--------|---------|
| API | | TP-api |
| DB | | TP-database |
| events | | |

### 5.3 State & Data

[TODO: State transitions, new fields, persistence behavior.]

---

## 6. Acceptance Criteria

| ID | Criterion | Testable | Test type |
|----|-----------|----------|-----------|
| AC- | | yes \| no | unit \| integration \| e2e \| manual |

---

## 7. Implementation Slices

| Slice ID | Description | Issue ref | Order |
|----------|-------------|-----------|-------|
| SL- | | | |

---

## 8. UX / UI Notes

[TODO: Screens, components, a11y requirements if user-facing.]

| Screen / component | Behavior | A11y notes |
|--------------------|----------|------------|
| | | STD-A11Y-001 |

---

## 9. Observability

| Signal | Type | Notes |
|--------|------|-------|
| log | | STD-OPS-001 |
| metric | | |
| alert | | |

---

## 10. Rollout

| Stage | Action | Flag / config |
|-------|--------|---------------|
| | | |

---

## 11. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| | | | open |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-DECOMPOSE |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| upstream | TP-prd, TP-architecture, TP-api, TP-database |
| downstream | TP-testing, issues |
| standards | STD-ARCH-001, STD-TEST-001, STD-A11Y-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |