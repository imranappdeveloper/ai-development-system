---
scenario_id: HT-01
skill_id: PB-maintenance-triage
prompt_version: 1.0.0
inputs:
  intake_artifact: work/intake/WR-MAINT-001.md
  work_id: WR-MAINT-001
expected_outputs:
  out_01_path: work/maintenance/WR-MAINT-001.md
  checklist_result: pass
  gate_decision: pending
---

---
document_id: MAINT-WR-MAINT-001
work_id: WR-MAINT-001
workflow_id: WF-MAINTENANCE
cycle_type: scheduled
triage_confidence: high
status: active
revision: 0
created: 2026-06-18T16:00:00Z
upstream_int_path: work/intake/WR-MAINT-001.md
upstream_rel_path: null
template_ref: templates/maintenance/template.md
batch_depth: 1
---

# Maintenance Cycle — Q2 hygiene

## 1. Cycle Overview

### 1.1 Purpose

Quarterly dependency and documentation hygiene for API service.

### 1.2 Trigger

| Trigger | Source | Date |
|---------|--------|------|
| schedule | calendar | 2026-06-18 |

## 2. Health Snapshot

### 2.1 System Health

| Signal | Status | Notes |
|--------|--------|-------|
| errors / incidents | green | No P0 in last 7d |
| performance | green | p95 stable |
| dependencies | yellow | 2 minor CVEs |
| security posture | yellow | See §4 |
| documentation drift | yellow | CONTEXT.md missing workers section |

## 3. Maintenance Backlog

### 3.1 Identified Items

| ID | Category | Description | Priority | Routed workflow |
|----|----------|-------------|----------|-----------------|
| M-001 | dependency | Upgrade lodash transitive CVE | P1 | WF-SECURITY |
| M-002 | docs | Refresh CONTEXT workers section | P2 | WF-DOCS |

### 3.2 Approved for This Cycle

| ID | Summary | Owner | Target date |
|----|---------|-------|-------------|
| M-001 | Patch lodash CVE | platform | 2026-06-25 |

### 3.3 Deferred

| ID | Reason | Revisit date |
|----|--------|--------------|
| M-002 | Capacity — docs cycle next month | 2026-07-18 |

## 4. Dependency & Security Hygiene

| Item | Current | Action | workflow ref | Status |
|------|---------|--------|--------------|--------|
| CVE-2024-XXXX | lodash 4.17.20 | patch | WF-SECURITY | open |

## 5. Technical Debt Review

| Debt item | Impact | Effort | Decision |
|-----------|--------|--------|----------|
| Missing worker docs in CONTEXT | medium | S | defer (M-002) |

## 7. Child Work Records

| work_id | Workflow | Status | Link |
|---------|----------|--------|------|
| (proposed) WR-SEC-001 | WF-SECURITY | proposed | M-001 — spawn after H-OPERATE |

## 10. Follow-Ups

| Item | Owner | Due | work_id |
|------|-------|-----|---------|
| M-002 docs refresh | tech-writer | 2026-07-18 | TBD |

## Human Approval

### Cycle Close

| Field | Value |
|-------|-------|
| gate_id | H-OPERATE |
| decision | pending |