# PB-discovery-research — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches INT unless revise override | 100% |
| AC-ACC-02 | `discovery_type` valid enum | 100% |
| AC-ACC-03 | Evidence cited for as-is claims | ≥1 citation per major claim |
| AC-COM-01 | All TP-discovery required sections present | 100% |
| AC-COM-02 | §6.2 intake alignment block present | 100% |
| AC-SEC-01 | No secrets in DISC | 0 leaks |
| AC-CON-01 | `decision: pending` at H-FRAME | 100% |
| AC-PRD-01 | DISC persisted before handoff | File path or `persist: pending` |

---

## CL-DISCOVERY Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-03 |
| 5 | AC-COM-01 |
| 6 | AC-COM-01 |
| 7 | AC-SEC-01 + no forbidden docs |
| 8 | AC-COM-02 |
| 9 | AC-PRD-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-DISCOVERY `result: pass` AND all required ACs pass.