# PB-implement-mobile — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Issue traceability | 25% | ISS mapping in §3; no orphan code |
| Implementation correctness | 25% | Screens/states match UIUX when linked |
| Test documentation | 20% | §6 complete; STD-TEST-001 compliance |
| Safety | 15% | No app store submit; no secrets; mobile lane only |
| Gate compliance | 15% | CL-IMPLEMENT-MOBILE pass + H-IMPLEMENT pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `implement_lane: mobile` in CODE frontmatter | 100% |
| AC-ACC-03 | `implement_scope` valid enum | 100% |
| AC-ISS-01 | Every §4 file maps to ≥1 ISS ID in §3 | 100% |
| AC-ISS-02 | ISS paths in `upstream_issue_paths` | 100% |
| AC-UIUX-01 | Screens align with UIUX flows when UIUX linked | Per screen |
| AC-UIUX-02 | Loading/empty/error states per UIUX §4 when defined | Per state |
| AC-API-01 | Data-fetch calls align with API operations when API linked | Per operation |
| AC-COM-01 | Required CODE sections present | 100% |
| AC-COM-02 | `uiux_alignment` block when UIUX linked; `api_alignment` when API linked | 100% |
| AC-TST-01 | §6 Testing Notes non-empty | 100% |
| AC-TST-02 | Test types listed (unit/widget/integration/e2e) | ≥1 type |
| AC-DEP-01 | No app store submit/release/infra-apply in output | 0 occurrences |
| AC-SCP-01 | No backend/web-frontend/devops file changes claimed | 0 wrong-lane |
| AC-CON-01 | `decision: pending` at H-IMPLEMENT | 100% |
| AC-PRS-01 | CODE persisted at lane path before handoff | File path or `persist: pending` |

---

## CL-IMPLEMENT-MOBILE Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-ISS-01 + AC-ISS-02 |
| 3 | AC-UIUX-01 + AC-API-01 + uiux_gap/api_gap |
| 4 | AC-PRS-01 + lane path |
| 5 | AC-TST-01 + AC-TST-02 |
| 6 | AC-DEP-01 |
| 7 | AC-COM-01 §4 Files Changed |
| 8 | WR status + artifact link |
| 9 | AC-SCP-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-IMPLEMENT-MOBILE `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-IMPLEMENT-MOBILE checks passed | 10 / 10 |
| Required ACs passed | 16 / 16 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |