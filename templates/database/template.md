---
template_id: TP-database
version: 1.0.0
status: active
document_type: database
sdlc_workflows: [WF-FEATURE, WF-REFACTOR, WF-SECURITY, WF-PERF]
gates: [H-PLAN]
---

# Database Design — {{domain_or_feature_name}}

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
| change_type | new_schema \| migration \| optimization |

---

## 1. Overview

### 1.1 Purpose

[TODO: What data capability this design supports.]

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| | |

### 1.3 Related Documents

| Document | Path |
|----------|------|
| architecture | |
| PRD | |
| API | |

---

## 2. Data Requirements

### 2.1 Domain Entities

| Entity | Description | Source (PRD / domain) |
|--------|-------------|----------------------|
| | | |

### 2.2 Data Volume & Growth

| Metric | Current | Projected | Notes |
|--------|---------|-----------|-------|
| rows | | | |
| storage | | | |

### 2.3 Retention & Lifecycle

| Data type | Retention | Archival / deletion |
|-----------|-----------|---------------------|
| | | |

---

## 3. Logical Model

### 3.1 Entity Relationship Overview

[TODO: ER diagram reference or description.]

```
[TODO: Diagram link — assets/diagrams/]
```

### 3.2 Entities & Attributes

| Entity | Attribute | Type | Nullable | Notes |
|--------|-----------|------|----------|-------|
| | | | yes \| no | |

### 3.3 Relationships

| From | To | Cardinality | FK | Notes |
|------|-----|-------------|-----|-------|
| | | 1:1 \| 1:N \| N:M | | |

---

## 4. Physical Model

### 4.1 Tables / Collections

| Name | Purpose | Partitioning / sharding |
|------|---------|------------------------|
| | | |

### 4.2 Indexes

| Table | Index | Columns | Purpose |
|-------|-------|---------|---------|
| | | | |

### 4.3 Constraints

| Table | Constraint | Rule |
|-------|------------|------|
| | PK \| UK \| CK \| FK | |

---

## 5. Migration Plan

### 5.1 Current Schema State

[TODO: Reference existing schema version or baseline.]

### 5.2 Target Schema State

[TODO: ]

### 5.3 Migration Steps

| Step | Action | Reversible | Downtime |
|------|--------|------------|----------|
| | | yes \| no | |

### 5.4 Rollback Plan

[TODO: How to revert if migration fails.]

---

## 6. Access Patterns

| Operation | Frequency | Latency target | Query / access path |
|-----------|-----------|----------------|---------------------|
| read | | | |
| write | | | |

---

## 7. Security & Compliance

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| encryption at rest | | STD-SEC-001 |
| encryption in transit | | STD-SEC-001 |
| PII fields | | STD-SEC-001 |
| access control | | STD-SEC-001 |
| audit logging | | STD-OPS-001 |

---

## 8. Performance Considerations

| Hot path | Risk | Mitigation |
|----------|------|------------|
| | | |

---

## 9. SSOT & Consistency

| Definition | SSOT location | Consumers |
|------------|---------------|-----------|
| schema | | STD-ARCH-005 |

---

## 10. Open Questions

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
| upstream | TP-architecture, TP-prd |
| downstream | TP-api, TP-feature, TP-testing |
| standards | STD-ARCH-005, STD-SEC-001, STD-PERF-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |