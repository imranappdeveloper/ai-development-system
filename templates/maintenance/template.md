---
template_id: TP-maintenance
version: 1.0.0
status: active
document_type: maintenance
sdlc_workflows: [WF-MAINTENANCE]
gates: [H-INTAKE, H-FRAME, H-OPERATE]
---

# Maintenance Cycle — {{cycle_name}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | {{document_id}} |
| work_id | {{work_id}} |
| project | {{project_name}} |
| author | {{author}} |
| created | {{date}} |
| last_updated | {{date}} |
| status | draft \| active \| closed |
| cycle_type | scheduled \| reactive \| hygiene |
| period | {{start_date}} — {{end_date}} |

---

## 1. Cycle Overview

### 1.1 Purpose

[TODO: Why this maintenance cycle is running.]

### 1.2 Trigger

| Trigger | Source | Date |
|---------|--------|------|
| schedule \| alert \| audit \| drift | | |

---

## 2. Health Snapshot

### 2.1 System Health

| Signal | Status | Notes |
|--------|--------|-------|
| errors / incidents | green \| yellow \| red | |
| performance | green \| yellow \| red | |
| dependencies | green \| yellow \| red | |
| security posture | green \| yellow \| red | |
| documentation drift | green \| yellow \| red | |

### 2.2 Metrics Summary

| Metric | Value | Threshold | Trend |
|--------|-------|-----------|-------|
| | | | up \| down \| stable |

---

## 3. Maintenance Backlog

### 3.1 Identified Items

| ID | Category | Description | Priority | Routed workflow |
|----|----------|-------------|----------|-----------------|
| M- | dependency \| security \| perf \| docs \| debt \| ops | | P0–P3 | WF-* |

### 3.2 Approved for This Cycle

| ID | Summary | Owner | Target date |
|----|---------|-------|-------------|
| | | | |

### 3.3 Deferred

| ID | Reason | Revisit date |
|----|--------|--------------|
| | | |

---

## 4. Dependency & Security Hygiene

| Item | Current | Action | workflow ref | Status |
|------|---------|--------|--------------|--------|
| CVE- | | patch \| accept risk | WF-SECURITY | |
| outdated dep | | upgrade \| pin | | |
| secret rotation | | rotate \| n/a | | |

---

## 5. Technical Debt Review

| Debt item | Impact | Effort | Decision |
|-----------|--------|--------|----------|
| | | S \| M \| L | fix \| defer |

---

## 6. Documentation & Context Drift

| Doc | Issue | Action | Owner |
|-----|-------|--------|-------|
| CONTEXT.md | | update \| ok | |
| runbooks | | update \| ok | |
| ADRs | | add \| ok | |

---

## 7. Child Work Records

| work_id | Workflow | Status | Link |
|---------|----------|--------|------|
| | WF-BUGFIX \| WF-SECURITY \| … | | |

[TODO: Each approved item spawns its own workflow — this doc tracks the batch.]

---

## 8. Execution Log

| Date | Action | work_id | Outcome |
|------|--------|---------|---------|
| | | | |

---

## 9. Cycle Retrospective

### 9.1 Completed

| ID | Outcome |
|----|---------|
| | |

### 9.2 Incomplete

| ID | Blocker | Next step |
|----|---------|-----------|
| | | |

### 9.3 Learnings

[TODO: What to change in process, standards, or CONTEXT.md.]

---

## 10. Follow-Ups

| Item | Owner | Due | work_id |
|------|-------|-----|---------|
| | | | |

---

## Human Approval

### Cycle Start

| Field | Value |
|-------|-------|
| gate_id | H-FRAME |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

### Cycle Close

| Field | Value |
|-------|-------|
| gate_id | H-OPERATE |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| workflow | WF-MAINTENANCE |
| child_work | |
| standards | STD-SEC-002, STD-DOC-001, STD-CI-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |