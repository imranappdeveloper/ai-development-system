# PB-perf-baseline — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | INT links complete |
| Measurability | 25% | Targets have metric + threshold |
| Completeness | 20% | Required sections per 04-io-contract |
| Safety | 15% | No benchmark scripts/routing embed/secrets |
| Gate compliance | 15% | CL-PERF pass + H-PLAN pending |

---

## Required Acceptance Criteria

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` WF-PERF or `work_type: performance` | 100% |
| AC-ACC-02 | Required enums valid per registry | 100% |
| AC-TRC-01 | `upstream_int_path` in References | 100% |
| AC-SEC-01 | Required sections present | 100% |
| AC-SEC-02 | Human Approval block with `decision: pending` | 100% |
| AC-TGT-01 | ≥1 target row with metric and threshold | 100% |
| AC-MEA-01 | Measurement plan documents method without execution | 100% |
| AC-NG-01 | Non-Goals states no load-test execution | 100% |
| AC-PRS-01 | OUT-01 persisted before handoff | Paths or `persist: pending` |
| AC-WR-01 | WR `artifacts[]` lists PERF-BASE path | 100% |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |

---

## CL-PERF Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | Entry criteria |
| 2 | Workflow / work_type valid |
| 3 | INT traceability |
| 4 | Required sections |
| 5 | No forbidden content |
| 6 | Targets & SLOs table |
| 7 | Measurement plan (plan-only) |
| 8 | Artifact path |
| 9 | Work Record status |
| 10 | Human approval |

**Handoff allowed:** CL-PERF `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-PERF checks passed | 10 / 10 |
| Required ACs passed | 11 / 11 |
| Production readiness (10-review) | ≥ 72 / 100 for `active` |