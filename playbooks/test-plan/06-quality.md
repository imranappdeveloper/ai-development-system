# PB-test-plan — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| AC traceability | 30% | Every in-scope AC maps to ≥1 TC-* |
| Strategy completeness | 25% | Layers selected with STD-TEST-002 rationale |
| Upstream grounding | 20% | CODE/PRD/ISS paths linked or waivers documented |
| Plan-only discipline | 15% | No execution evidence; no test runs |
| Gate compliance | 10% | CL-TEST-PLAN pass + H-VERIFY soft pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `test_phase: plan` in TEST-PLAN metadata | 100% |
| AC-ACC-03 | `test_scope` valid enum | 100% |
| AC-MAP-01 | Every in-scope AC has ≥1 TC-* in §3.1 | 100% |
| AC-MAP-02 | §3.2 case details include precondition, steps, expected (planned) | Per TC |
| AC-CODE-01 | CODE path in `upstream_code_paths` when linked | 100% |
| AC-CODE-02 | `code_alignment` block when CODE present | 100% |
| AC-PRD-01 | PRD path referenced when PRD linked | 100% |
| AC-ISS-01 | ISS paths in `upstream_issue_paths` when linked | 100% |
| AC-STR-01 | §2.1 layer table complete with rationale | 100% |
| AC-STR-02 | Regression §4 populated when CODE §4 present | 100% |
| AC-EXE-01 | §9 has no command results or pass/fail from live runs | 0 execution rows |
| AC-EXE-02 | Agent did not run test commands during session | 0 runs |
| AC-GEN-01 | No generated test source code in output | 0 test files written |
| AC-CON-01 | `decision: pending` at H-VERIFY sub_gate plan | 100% |
| AC-PRS-01 | TEST-PLAN persisted at plan path before handoff | File path or `persist: pending` |

---

## CL-TEST-PLAN Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-MAP-01 + AC-MAP-02 |
| 3 | AC-CODE-01 + AC-CODE-02 + code_gap |
| 4 | AC-PRS-01 + plan path |
| 5 | AC-EXE-01 + AC-EXE-02 — plan only |
| 6 | AC-STR-01 + STD-TEST-002 compliance |
| 7 | AC-STR-02 regression when applicable |
| 8 | WR status + TEST-PLAN artifact link |
| 9 | AC-GEN-01 — no test code generation |
| 10 | AC-CON-01 + PB-test-generate recommendation |

**Handoff allowed:** CL-TEST-PLAN `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-TEST-PLAN checks passed | 10 / 10 |
| Required ACs passed | 16 / 16 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |