# PB-implement-devops — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Issue traceability | 25% | ISS mapping in §3; no orphan pipeline/IaC changes |
| Implementation correctness | 25% | Pipelines/IaC match ARCH when linked |
| Validation documentation | 20% | §6 complete; STD-TEST-001 compliance |
| Safety | 15% | No prod deploy; no secrets; DevOps lane only |
| Gate compliance | 15% | CL-IMPLEMENT-DEVOPS pass + H-IMPLEMENT pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `implement_lane: devops` in CODE frontmatter | 100% |
| AC-ACC-03 | `implement_scope` valid enum | 100% |
| AC-ISS-01 | Every §4 file maps to ≥1 ISS ID in §3 | 100% |
| AC-ISS-02 | ISS paths in `upstream_issue_paths` | 100% |
| AC-ARCH-01 | Pipelines/IaC align with ARCH deploy boundaries when ARCH linked | Per component |
| AC-REL-01 | Release automation aligns with REL when REL linked | Per release step |
| AC-COM-01 | Required CODE sections present | 100% |
| AC-COM-02 | `arch_alignment` / `rel_alignment` blocks when artifacts linked | 100% |
| AC-VAL-01 | §6 Validation Notes non-empty | 100% |
| AC-VAL-02 | Validation types listed (lint/plan/dry-run/workflow-syntax) | ≥1 type |
| AC-DEP-01 | No prod deploy/release/infra-apply in output | 0 occurrences |
| AC-SCP-01 | No backend/frontend/mobile file changes claimed | 0 wrong-lane |
| AC-CON-01 | `decision: pending` at H-IMPLEMENT | 100% |
| AC-PRS-01 | CODE persisted at lane path before handoff | File path or `persist: pending` |

---

## CL-IMPLEMENT-DEVOPS Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-ISS-01 + AC-ISS-02 |
| 3 | AC-ARCH-01 + AC-REL-01 + arch_gap/rel_gap |
| 4 | AC-PRS-01 + lane path |
| 5 | AC-VAL-01 + AC-VAL-02 |
| 6 | AC-DEP-01 |
| 7 | AC-COM-01 §4 Files Changed |
| 8 | WR status + artifact link |
| 9 | AC-SCP-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-IMPLEMENT-DEVOPS `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-IMPLEMENT-DEVOPS checks passed | 10 / 10 |
| Required ACs passed | 15 / 15 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |