# PB-implement-frontend — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Issue traceability | 25% | ISS mapping in §3; no orphan code |
| Implementation correctness | 25% | Components/screens match UIUX when linked |
| Test documentation | 20% | §6 complete; STD-TEST-001 compliance |
| Safety | 15% | No deploy; no secrets; frontend lane only |
| Gate compliance | 15% | CL-IMPLEMENT-FRONTEND pass + H-IMPLEMENT pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `implement_lane: frontend` in CODE frontmatter | 100% |
| AC-ACC-03 | `implement_scope` valid enum | 100% |
| AC-ISS-01 | Every §4 file maps to ≥1 ISS ID in §3 | 100% |
| AC-ISS-02 | ISS paths in `upstream_issue_paths` | 100% |
| AC-UIX-01 | Screens align with UIUX inventory when UIUX linked | Per screen |
| AC-API-01 | Client calls align with API operations when API linked | Per operation |
| AC-COM-01 | Required CODE sections present | 100% |
| AC-COM-02 | `uiux_alignment` / `api_alignment` blocks when artifacts linked | 100% |
| AC-A11Y-01 | §5 Accessibility populated when UI changes | 100% |
| AC-TST-01 | §6 Testing Notes non-empty | 100% |
| AC-TST-02 | Test types listed (unit/component/e2e) | ≥1 type |
| AC-DEP-01 | No deploy/release/CDN publish in output | 0 occurrences |
| AC-SCP-01 | No backend/mobile/devops file changes claimed | 0 wrong-lane |
| AC-CON-01 | `decision: pending` at H-IMPLEMENT | 100% |
| AC-PRS-01 | CODE persisted at lane path before handoff | File path or `persist: pending` |

---

## CL-IMPLEMENT-FRONTEND Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-ISS-01 + AC-ISS-02 |
| 3 | AC-UIX-01 + uiux_gap + AC-API-01 when API linked |
| 4 | AC-PRS-01 + lane path |
| 5 | AC-TST-01 + AC-TST-02 |
| 6 | AC-DEP-01 |
| 7 | AC-COM-01 §4 Files Changed |
| 8 | WR status + artifact link |
| 9 | AC-SCP-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-IMPLEMENT-FRONTEND `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-IMPLEMENT-FRONTEND checks passed | 10 / 10 |
| Required ACs passed | 16 / 16 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |