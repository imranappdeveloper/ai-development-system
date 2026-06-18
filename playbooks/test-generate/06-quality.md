# PB-test-generate — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Plan traceability | 30% | Every in-scope TC-* addressed in §3 or §5 |
| File catalog completeness | 25% | All created/updated paths listed with `file_action` |
| Convention alignment | 20% | Paths match CONTEXT + CODE §6 |
| Generate-only discipline | 15% | No execution evidence; no test runs |
| Gate compliance | 10% | CL-TEST-GEN pass + no H-VERIFY approve |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `test_phase: generate` in TEST-GEN metadata | 100% |
| AC-ACC-03 | `test_scope` valid enum (from plan) | 100% |
| AC-PLN-01 | `upstream_test_plan_path` in frontmatter | 100% |
| AC-PLN-02 | `plan_alignment` block when TEST-PLAN linked | 100% |
| AC-MAP-01 | Every in-scope TC-* has entry in §3 or §5 deferred | 100% |
| AC-MAP-02 | §3 rows include path, `file_action`, layer, TC-* refs | Per file |
| AC-CODE-01 | CODE path in `upstream_code_paths` when linked | 100% |
| AC-FIL-01 | Every `created`/`updated` file exists on disk | 100% |
| AC-FIL-02 | No orphan catalog rows without path | 0 orphans |
| AC-EXE-01 | §6 has no command results or pass/fail from live runs | 0 execution rows |
| AC-EXE-02 | Agent did not run test commands during session | 0 runs |
| AC-GATE-01 | No H-VERIFY `decision: approve` in TEST-GEN or handoff | 100% |
| AC-GATE-02 | `exit_gate: none` in handoff | 100% |
| AC-PRS-01 | TEST-GEN persisted at generate path before handoff | File path or `persist: pending` |
| AC-HOF-01 | `recommended_next_skill: PB-verify` in OUT-05 | 100% |

---

## CL-TEST-GEN Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-PLN-01 + AC-PLN-02 + plan_alignment |
| 3 | AC-MAP-01 — TC-* coverage |
| 4 | AC-PRS-01 + generate path |
| 5 | AC-FIL-01 + AC-FIL-02 — file catalog |
| 6 | AC-EXE-01 + AC-EXE-02 — generate only |
| 7 | AC-CODE-01 + convention alignment |
| 8 | WR status + TEST-GEN artifact link |
| 9 | AC-GATE-01 + AC-GATE-02 — no H-VERIFY approve |
| 10 | AC-HOF-01 + PB-review alternate |

**Handoff allowed:** CL-TEST-GEN `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-TEST-GEN checks passed | 10 / 10 |
| Required ACs passed | 16 / 16 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |