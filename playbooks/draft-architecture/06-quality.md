# PB-draft-architecture — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | PRD link + FR/NFR mapping |
| Structural clarity | 25% | Layers, components, dependency rules |
| Completeness | 20% | TP-architecture required sections |
| Safety | 15% | No code, secrets, or PRD duplication |
| Gate compliance | 15% | CL-ARCH pass + H-PLAN pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches PRD unless revise override | 100% |
| AC-ACC-02 | `architecture_type` valid enum | 100% |
| AC-ACC-03 | PRD path in §1.3 Related Documents | 100% |
| AC-STR-01 | Layer/module map with dependency direction | Per STD-ARCH-001 |
| AC-STR-02 | System context (diagram or bounded description) | Present |
| AC-COM-01 | All TP-architecture required sections present | 100% |
| AC-COM-02 | `prd_alignment` block present | 100% |
| AC-SEC-01 | No secrets in ARCH | 0 leaks |
| AC-SCP-01 | No application code or implementation snippets | 0 blocks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PRS-01 | ARCH persisted before handoff | File path or `persist: pending` |

---

## CL-ARCH Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-06) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-03 + prd_alignment.prd_path |
| 5 | AC-STR-01 |
| 6 | AC-COM-01 |
| 7 | AC-SCP-01 + AC-SEC-01 |
| 8 | AC-STR-02 |
| 9 | AC-PRS-01 + WR status |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-ARCH `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-ARCH checks passed | 10 / 10 |
| Required ACs passed | 11 / 11 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |