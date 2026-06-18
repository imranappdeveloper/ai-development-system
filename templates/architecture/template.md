---
template_id: TP-architecture
version: 1.0.0
status: active
document_type: architecture
sdlc_workflows: [WF-PROJECT-NEW, WF-FEATURE, WF-REFACTOR, WF-SECURITY, WF-PERF]
gates: [H-PLAN]
---

# Architecture — {{system_or_feature_name}}

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
| architecture_type | greenfield \| as_is \| delta |

---

## 1. Overview

### 1.1 Purpose

[TODO: What this architecture document covers and what decisions it enables.]

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| | |

### 1.3 Related Documents

| Document | Path | Relationship |
|----------|------|--------------|
| PRD | | informs |
| ADR | | decisions |

---

## 2. Context & Constraints

### 2.1 System Context

[TODO: C4 Context-level — actors, external systems, boundaries.]

```
[TODO: Diagram link or ASCII diagram reference — assets/diagrams/]
```

### 2.2 Assumptions

| Assumption | Impact if invalid |
|------------|-------------------|
| | |

### 2.3 Constraints

| Constraint | Source |
|------------|--------|
| | |

### 2.4 Quality Attributes

| Attribute | Requirement | Standard ref |
|-----------|-------------|--------------|
| security | | STD-SEC-001 |
| performance | | STD-PERF-001 |
| reliability | | |
| maintainability | | STD-ARCH-001 |

---

## 3. Architectural Approach

### 3.1 Style & Patterns

[TODO: e.g. layered, hexagonal, event-driven — justify per STD-ARCH-004.]

### 3.2 Layer / Module Structure

| Layer / Module | Responsibility | Dependencies (inward) |
|----------------|----------------|----------------------|
| | | |

### 3.3 Dependency Rules

[TODO: What may depend on what — per STD-ARCH-001.]

---

## 4. Component Design

### 4.1 Components

| Component | Responsibility | Interfaces | Owner |
|-----------|----------------|------------|-------|
| | | | |

### 4.2 Container View

[TODO: C4 Container-level diagram reference.]

### 4.3 Key Interactions

| From | To | Protocol | Purpose |
|------|-----|----------|---------|
| | | | |

---

## 5. Data Flow

[TODO: Primary data flows for critical use cases.]

| Flow | Trigger | Steps | Persistence |
|------|---------|-------|-------------|
| | | | |

---

## 6. Cross-Cutting Concerns

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| authentication | | STD-SEC-001 |
| authorization | | STD-SEC-001 |
| logging | | STD-OPS-001 |
| error handling | | STD-OPS-002 |
| configuration | | STD-ARCH-005 |

---

## 7. Technology Choices

| Area | Choice | Rationale | ADR ref |
|------|--------|-----------|---------|
| | | | |

---

## 8. Migration & Transition

[TODO: Required for delta/refactor architectures only.]

### 8.1 Current State

[TODO: ]

### 8.2 Target State

[TODO: ]

### 8.3 Migration Strategy

| Phase | Action | Rollback |
|-------|--------|----------|
| | | |

---

## 9. Risks & Tradeoffs

| Decision / risk | Tradeoff | Alternative rejected |
|-----------------|----------|---------------------|
| | | |

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
| upstream | TP-prd, TP-discovery |
| downstream | TP-database, TP-api, TP-feature |
| standards | STD-ARCH-001, STD-ARCH-002, STD-ARCH-004, STD-ARCH-005 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |