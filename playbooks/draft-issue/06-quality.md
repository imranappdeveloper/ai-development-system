# PB-draft-issue — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | Upstream links complete |
| Clarity | 25% | Actionable content, testable AC where applicable |
| Completeness | 20% | Required sections per 04-io-contract |
| Safety | 15% | No code/routing embed/secrets |
| Gate compliance | 15% | CL-ISSUE pass + H-PLAN pending |

---

## Required Acceptance Criteria

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches upstream unless revise override | 100% |
| AC-ACC-02 | Required enums valid per registry | 100% |
| AC-TRC-01 | Upstream path(s) in References | 100% |
| AC-SEC-01 | Required sections present | 100% |
| AC-SEC-02 | Human Approval block with `decision: pending` | 100% |
| AC-SCP-01 | No implementation code blocks | 0 blocks |
| AC-SCP-02 | No routing matrix embedded | 0 blocks |
| AC-PRS-01 | OUT-01 persisted before handoff | Paths or `persist: pending` |
| AC-WR-01 | WR `artifacts[]` lists ISS path | 100% |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |

---

## CL-ISSUE Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | Entry criteria |
| 2 | `issue_lane` valid |
| 3 | INT traceability |
| 4 | Required sections |
| 5 | No forbidden content |
| 6 | Testable AC |
| 7 | DIAG alignment |
| 8 | Work Record status |
| 9 | Artifact path |
| 10 | Human approval |

**Handoff allowed:** CL-ISSUE `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-ISSUE checks passed | 10 / 10 |
| Required ACs passed | 10 / 10 |
| Production readiness (10-review) | ≥ 72 / 100 for `active` |
