---
scenario_id: HT-01
skill_id: PB-intake-classify
prompt_version: 1.0.0
inputs:
  raw_request: Add OAuth2 login for enterprise customers
  project_root: fixtures/projects/project-alpha
expected_outputs:
  out_01_path: work/intake/WR-FEATURE-001.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-discovery-research
---

---
document_id: INT-WR-FEATURE-001
work_id: WR-FEATURE-001
work_type: feature
workflow_id: WF-FEATURE
entry_mode: normal
classification_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T10:00:00Z
requester: product-owner
suggested_priority: P1
recommended_next_skill: PB-discovery-research
---

# Intake — User profile page

## 1. Problem Statement

Customers cannot self-serve email and notification preference updates.

## 2. Classification Rationale

Request describes new user-facing capability on existing product — matches `feature` not `enhancement` (no existing profile page).

## 3. Scope

### 3.1 In Scope

Profile view, email update, notification toggles, OAuth-authenticated access.

### 3.2 Out of Scope

Password reset, billing changes, admin user management.

## Human Approval

| gate_id | H-INTAKE |
| decision | pending |