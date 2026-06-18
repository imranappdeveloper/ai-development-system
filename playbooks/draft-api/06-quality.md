# PB-draft-api — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | ARCH link + PRD/DB operation mapping |
| Contract clarity | 25% | Operations, models, errors, auth |
| Completeness | 20% | TP-api required sections |
| Safety | 15% | No implementation code, secrets, or ARCH duplication |
| Gate compliance | 15% | CL-API pass + H-PLAN pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches ARCH unless revise override | 100% |
| AC-ACC-02 | `change_type` valid enum | 100% |
| AC-ACC-03 | ARCH path in References / alignment block | 100% |
| AC-API-01 | §4 operation catalog with auth column | Present |
| AC-API-02 | §5 data models for request/response bodies | Present |
| AC-API-03 | §2 auth table populated per STD-SEC-001 | Present |
| AC-COM-01 | All TP-api required sections present | 100% |
| AC-COM-02 | `arch_alignment` block present | 100% |
| AC-BRK-01 | §8 breaking changes when `change_type: breaking` | 100% when applicable |
| AC-SEC-01 | §9 security table populated | Per STD-SEC-001 |
| AC-SCP-01 | No handler code or application snippets | 0 blocks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PRS-01 | API persisted before handoff | File path or `persist: pending` |
| AC-DB-01 | Models align with DB entities or `db_gap` documented | Per soft DB link |

---

## CL-API Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-03 + arch_alignment.arch_path |
| 5 | AC-API-01 + PRD grounding or prd_gap |
| 6 | AC-API-02 + AC-DB-01 |
| 7 | AC-COM-01 |
| 8 | AC-SCP-01 + AC-SEC-01 |
| 9 | AC-BRK-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-API `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-API checks passed | 10 / 10 |
| Required ACs passed | 14 / 14 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |