# PB-perf-review — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| CODE traceability | 30% | Every finding maps to CODE §4 path |
| Baseline / NFR grounding | 25% | PERF-BASE or PRD NFR referenced or waiver |
| Finding quality | 25% | Severity, location, required action on blockers |
| Review-only discipline | 10% | No benchmark evidence; no code fixes |
| Gate compliance | 10% | CL-PERF-REVIEW pass + H-VERIFY pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `perf_review_scope` valid enum | 100% |
| AC-ACC-03 | `review_type: performance` in metadata | 100% |
| AC-CODE-01 | CODE path in `upstream_code_paths` | 100% |
| AC-CODE-02 | `code_alignment` block present | 100% |
| AC-BASE-01 | PERF-BASE path when linked | 100% |
| AC-BASE-02 | `baseline_alignment` or `baseline_gap: waiver` | 100% |
| AC-FND-01 | §4 has ≥1 finding or explicit clean review statement | 100% |
| AC-FND-02 | Blockers include required action | Per blocker |
| AC-HOT-01 | §5 hotspot inventory references CODE paths | 100% |
| AC-NFR-01 | §3 populated when PERF-BASE or PRD NFR present | 100% |
| AC-BMK-01 | §6 has no live benchmark metrics | 0 metric rows |
| AC-BMK-02 | Agent did not run load-test commands | 0 runs |
| AC-FIX-01 | No application source files modified | 0 edits |
| AC-CON-01 | `decision: pending` at H-VERIFY | 100% |
| AC-PRS-01 | PERF-REVIEW persisted before handoff | File path or `persist: pending` |

---

## CL-PERF-REVIEW Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-CODE-01 + AC-FND-01 traceability |
| 3 | AC-BASE-01 + AC-BASE-02 |
| 4 | AC-PRS-01 + perf-review path |
| 5 | AC-BMK-01 + AC-BMK-02 — review only |
| 6 | AC-FND-02 findings complete |
| 7 | AC-NFR-01 baseline/NFR comparison |
| 8 | WR status + PERF-REVIEW artifact link |
| 9 | AC-FIX-01 — no code fixes |
| 10 | AC-CON-01 + next skill recommendation |

---

## Scoring Rubric (10-review)

| Score band | Meaning |
|------------|---------|
| 72–100 | Draft complete — promotion candidate |
| 50–71 | Spec gaps — revise before gate |
| 0–49 | Scaffold — not invokable |