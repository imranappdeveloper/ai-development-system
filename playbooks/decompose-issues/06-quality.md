# PB-decompose-issues — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | PRD link + FR/NFR coverage map |
| Issue clarity | 25% | Testable AC, scope in/out, lane tags |
| Completeness | 20% | All in-scope PRD items mapped |
| Safety | 15% | No implementation code or PRD duplication |
| Gate compliance | 15% | CL-DECOMP pass + H-DECOMPOSE pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches PRD unless revise override | 100% |
| AC-ACC-02 | `decompose_scope` valid enum | 100% |
| AC-ACC-03 | PRD path in manifest `prd_alignment.prd_path` | 100% |
| AC-ISS-01 | Each ISS-* has Summary, AC, Scope, Tags, References | 100% |
| AC-ISS-02 | `issue_id` matches `ISS-{LANE}-{SEQ}` pattern | 100% |
| AC-ISS-03 | Every AC row has `verify` method | 100% |
| AC-COV-01 | Manifest coverage map lists all in-scope FR/NFR | 100% or `decompose_gap` documented |
| AC-LANE-01 | `lane` enum valid per issue | 100% |
| AC-SCP-01 | No handler/UI/IaC code blocks in ISS-* | 0 blocks |
| AC-SCP-02 | No routing matrix embedded in output | 0 blocks |
| AC-CON-01 | `decision: pending` at H-DECOMPOSE | 100% |
| AC-PRS-01 | ISS-* persisted before handoff | Paths or `persist: pending` |
| AC-WR-01 | WR `artifacts[]` lists every ISS-* path | 100% |

---

## CL-DECOMP Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-07) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-03 + PRD refs in each ISS-* |
| 5 | AC-ISS-02 + AC-LANE-01 |
| 6 | AC-ISS-01 + AC-ISS-03 |
| 7 | AC-SCP-01 + AC-SCP-02 |
| 8 | AC-COV-01 |
| 9 | AC-WR-01 + WR status |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-DECOMP `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-DECOMP checks passed | 10 / 10 |
| Required ACs passed | 13 / 13 |
| Open coverage gaps with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |