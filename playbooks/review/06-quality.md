# PB-review — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| AC traceability | 25% | Every in-scope AC assessed in §4 |
| Standards coverage | 25% | §3 applicable rows evaluated with pass/fail/n/a |
| Finding quality | 20% | Locations, severity, actionable required actions |
| Upstream grounding | 15% | CODE/ISS/PRD paths linked |
| Review-only discipline | 10% | No code changes; no test execution |
| Gate compliance | 5% | CL-REVIEW pass + H-VERIFY soft pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `review_type` valid enum in REVIEW metadata | 100% |
| AC-ACC-03 | `review_confidence` valid enum | 100% |
| AC-MAP-01 | Every in-scope AC has row in §4 with Met column | 100% |
| AC-MAP-02 | §4 Evidence cites CODE §2/§4 or test reference | Per AC |
| AC-CODE-01 | CODE path in `upstream_code_paths` | 100% |
| AC-CODE-02 | `code_alignment` block when CODE present | 100% |
| AC-PRD-01 | PRD path referenced when PRD linked | 100% |
| AC-ISS-01 | ISS paths in `upstream_issue_paths` when linked | 100% |
| AC-STD-01 | §3 Standards Checklist — no blank Applicable rows | 100% |
| AC-STD-02 | STD-REVIEW-001 dimensions reflected in §3 | 100% |
| AC-FND-01 | P0 findings in §5.1 have Required action | 100% when P0 present |
| AC-FND-02 | Finding IDs use B-/S-/N- prefix convention | 100% |
| AC-SCP-01 | §6 all six questions answered | 100% |
| AC-SCP-02 | Agent did not modify source files | 0 writes |
| AC-SCP-03 | Agent did not execute test commands | 0 runs |
| AC-CON-01 | `decision: pending` at H-VERIFY sub_gate review | 100% |
| AC-PRS-01 | REVIEW persisted at review path before handoff | File path or `persist: pending` |
| AC-CHAIN-01 | PB-test-plan PASS or plan waiver noted in §1.3 | 100% |

---

## CL-REVIEW Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-MAP-01 + AC-MAP-02 |
| 3 | AC-CODE-01 + AC-CODE-02 |
| 4 | AC-PRS-01 + review path |
| 5 | AC-STD-01 + AC-STD-02 |
| 6 | AC-FND-01 + AC-FND-02 |
| 7 | AC-SCP-01 scope assessment |
| 8 | WR status + REVIEW artifact link |
| 9 | AC-SCP-02 + AC-SCP-03 — review only |
| 10 | AC-CON-01 + chain note + next skill recommendation |

**Handoff allowed:** CL-REVIEW `result: pass` AND all required ACs pass.