# PB-verify — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Execution completeness | 30% | In-scope layers run; §9 populated |
| TC-* traceability | 25% | Results mapped to TEST-PLAN TC-* |
| Upstream grounding | 20% | TEST-PLAN + TEST-GEN paths linked or waivers |
| Evidence discipline | 15% | Real commands, exit codes, timestamps |
| Gate compliance | 10% | CL-VERIFY pass + H-VERIFY pending only |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `test_phase: evidence` in TEST-RPT metadata | 100% |
| AC-ACC-03 | `test_scope` valid enum | 100% |
| AC-ACC-04 | `execution_result` valid enum | 100% |
| AC-PLN-01 | `upstream_test_plan_path` in frontmatter when TEST-PLAN linked | 100% |
| AC-PLN-02 | `plan_alignment` block when TEST-PLAN linked | 100% |
| AC-GEN-01 | `upstream_test_gen_path` in frontmatter when TEST-GEN linked | 100% |
| AC-GEN-02 | `gen_alignment` block when TEST-GEN linked | 100% |
| AC-MAP-01 | Every executed TC-* has status in §3.2 | 100% |
| AC-MAP-02 | Deferred TC-* documented with reason | Per TC |
| AC-EXE-01 | §9.1 lists commands with exit codes and timestamps | ≥1 command when in scope |
| AC-EXE-02 | §9.2 results summary populated | 100% |
| AC-EXE-03 | §9.3 failure log when `execution_result: fail` | 100% |
| AC-GATE-01 | No H-VERIFY `decision: approve` in TEST-RPT or handoff | 100% |
| AC-GATE-02 | `decision: pending` at H-VERIFY sub_gate evidence | 100% |
| AC-PRS-01 | TEST-RPT persisted at evidence path before handoff | File path or `persist: pending` |
| AC-HOF-01 | `recommended_next_skill` is PB-review or PB-prepare-release | 100% |

---

## CL-VERIFY Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-PLN-01 + AC-PLN-02 + AC-GEN-01 + AC-GEN-02 |
| 3 | AC-MAP-01 + AC-MAP-02 — TC-* results |
| 4 | AC-PRS-01 + evidence path |
| 5 | AC-EXE-01 + AC-EXE-02 + AC-EXE-03 |
| 6 | Suites actually run — no fabrication |
| 7 | TEST-GEN §3 paths referenced in execution |
| 8 | WR status + TEST-RPT artifact link |
| 9 | AC-GATE-01 — no H-VERIFY approve |
| 10 | AC-GATE-02 + AC-HOF-01 |

**Handoff allowed:** CL-VERIFY `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-VERIFY checks passed | 10 / 10 |
| Required ACs passed | 17 / 17 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |