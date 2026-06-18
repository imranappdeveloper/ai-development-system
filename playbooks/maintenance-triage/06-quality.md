# PB-maintenance-triage — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches INT (`WF-MAINTENANCE` or `WF-RELEASE`) | 100% |
| AC-ACC-02 | `cycle_type` valid enum | 100% |
| AC-HEA-01 | Health snapshot §2.1 — 5 signals evaluated | 100% |
| AC-BAK-01 | Backlog §3.1 ≥1 item with routed workflow | 100% |
| AC-BAK-02 | §3.2 approved items ≤ batch depth 2 | 100% |
| AC-COM-01 | Required MAINT sections per OUT-01 | 100% |
| AC-SEC-01 | No secrets; no deploy commands in MAINT | 0 violations |
| AC-CON-01 | `decision: pending` at H-OPERATE | 100% |
| AC-PRD-01 | MAINT persisted before handoff | File path or `persist: pending` |

---

## CL-MAINT Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria |
| 2 | AC-ACC-01 |
| 3 | AC-ACC-02 |
| 4 | AC-HEA-01 |
| 5 | AC-BAK-01 |
| 6 | AC-COM-01 |
| 7 | AC-SEC-01 |
| 8 | AC-BAK-02 |
| 9 | AC-PRD-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-MAINT `result: pass` AND all required ACs pass.