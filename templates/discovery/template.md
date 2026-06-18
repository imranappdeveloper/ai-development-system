---
template_id: TP-discovery
version: 1.0.0
status: active
document_type: discovery
sdlc_workflows: [WF-PROJECT-NEW, WF-PROJECT-EXISTING, WF-FEATURE, WF-ENHANCEMENT]
gates: [H-INTAKE, H-FRAME]
---

# Discovery — {{initiative_name}}

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
| discovery_type | new_project \| existing_onboarding \| feature \| enhancement |

---

## 1. Summary

[TODO: Brief description of what is being discovered and why now.]

---

## 2. Context

### 2.1 Background

[TODO: How this initiative arose — request, incident, strategy, tech debt.]

### 2.2 Stakeholders

| Role | Name / team | Interest |
|------|-------------|----------|
| | | |

### 2.3 Related Work

| work_id / link | Relationship |
|----------------|--------------|
| | |

---

## 3. Current State Analysis

### 3.1 As-Is Description

[TODO: Systems, processes, or experiences as they exist today.]

### 3.2 Evidence

| Source | Finding | Reference |
|--------|---------|-----------|
| user feedback | | |
| metrics | | |
| code / doc survey | | |

### 3.3 Gaps

| Gap | Severity | Notes |
|-----|----------|-------|
| | | |

---

## 4. Problem Definition

### 4.1 Problem Statement

[TODO: Single clear problem statement.]

### 4.2 Affected Users / Systems

[TODO: ]

### 4.3 Impact

[TODO: Quantify or qualify business/user/technical impact.]

---

## 5. Exploration

### 5.1 Questions Investigated

| Question | Method | Finding |
|----------|--------|---------|
| | | |

### 5.2 Alternatives Considered

| Option | Pros | Cons | Status |
|--------|------|------|--------|
| | | | considered \| rejected \| selected |

### 5.3 Risks Identified

| Risk | Likelihood | Impact | Mitigation idea |
|------|------------|--------|-----------------|
| | | | |

---

## 6. Recommendations

### 6.1 Recommended Direction

[TODO: What we should do based on discovery.]

### 6.2 Intake Classification Alignment

Discovery **confirms or challenges** the intake classification — it does **not** assign a new `work_type`. If research contradicts INT, document mismatch and recommend `PB-intake-classify` re-intake.

| Field | Value |
|-------|-------|
| intake_work_type | {{work_type}} |
| intake_workflow_id | {{workflow_id}} |
| alignment | aligned \| partial_mismatch \| requires_re_intake |
| mismatch_summary | |
| rationale | |

### 6.3 Suggested Next Artifacts

| Artifact | Template | Required |
|----------|----------|----------|
| | TP-prd \| TP-feature \| TP-architecture | yes \| no |

---

## 7. Out of Scope

[TODO: What discovery explicitly did not cover.]

---

## 8. Open Questions

| # | Question | Owner | Blocks |
|---|----------|-------|--------|
| | | | |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-INTAKE \| H-FRAME |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| upstream | TP-vision |
| downstream | TP-prd, TP-feature, TP-architecture |
| standards | STD-DOC-001, STD-ARCH-004 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |