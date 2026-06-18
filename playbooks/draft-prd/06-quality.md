# PB-draft-prd — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches INT unless revise override | 100% |
| AC-ACC-02 | `prd_type` valid enum (`full` \| `lite`) | 100% |
| AC-UP-01 | `upstream_int_path` populated in frontmatter | 100% |
| AC-UP-02 | DISC path or `discovery_gap` documented | 100% |
| AC-COM-01 | All TP-prd required sections present | 100% |
| AC-COM-02 | ≥1 FR and ≥1 AC with IDs | 100% |
| AC-COM-03 | Every AC marked testable with verification method | 100% |
| AC-SEC-01 | No secrets in PRD | 0 leaks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PRD-01 | PRD persisted before handoff | File path or `persist: pending` |

---

## CL-PRD Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-UP-01 + AC-UP-02 |
| 5 | AC-COM-01 (goals grounded) |
| 6 | AC-COM-01 |
| 7 | AC-SEC-01 + no forbidden docs |
| 8 | AC-COM-03 |
| 9 | AC-PRD-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-PRD `result: pass` AND all required ACs pass.