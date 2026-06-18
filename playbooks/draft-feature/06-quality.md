# PB-draft-feature — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches DISC unless revise override | 100% |
| AC-ACC-02 | `feat_type` and `feat_scope` valid enums | 100% |
| AC-UP-01 | `upstream_disc_path` populated in frontmatter | 100% |
| AC-UP-02 | `upstream_traceability` block present in §2 | 100% |
| AC-COM-01 | All required FEAT sections present per 04-io-contract | 100% |
| AC-COM-02 | ≥1 user flow and ≥1 AC with IDs | 100% |
| AC-COM-03 | Every AC marked testable with verification method | 100% |
| AC-SEC-01 | No secrets in FEAT | 0 leaks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-FEAT-01 | FEAT persisted at `work/feature/{work_id}.md` before handoff | File path or `persist: pending` |
| AC-BND-01 | No architecture, API/DB detail, code, or ISS decomposition | 0 violations |

---

## CL-DRAFT Map (FEAT path)

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry — H-FRAME + DISC |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-UP-01 + AC-UP-02 |
| 5 | AC-COM-01 (scope grounded in DISC) |
| 6 | AC-COM-01 |
| 7 | AC-BND-01 + AC-SEC-01 |
| 8 | AC-COM-03 |
| 9 | AC-FEAT-01 + WR status |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-DRAFT `result: pass` (FEAT path) AND all required ACs pass.