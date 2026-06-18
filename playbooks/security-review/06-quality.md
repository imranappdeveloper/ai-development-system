# PB-security-review — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| CODE traceability | 25% | Findings map to CODE §4 files |
| Security coverage | 25% | STD-SEC-001 dimensions reviewed |
| Finding quality | 20% | P0/P1/P2 with remediation |
| Safety | 15% | No code mutation; no secrets |
| Gate compliance | 15% | CL-SECURITY-REVIEW pass + H-VERIFY pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `review_type: security_code` in SEC-REVIEW frontmatter | 100% |
| AC-ACC-03 | `security_review_scope` valid enum | 100% |
| AC-CODE-01 | `upstream_code_path` references CODE artifact | 100% |
| AC-CODE-02 | Every §3 scope file from CODE §4 | 100% |
| AC-FND-01 | §4 Findings lists severity + file ref per item | 100% when issues exist |
| AC-FND-02 | P0 findings include remediation | 100% when P0 present |
| AC-ASS-01 | `assess_alignment` block when SEC-ASSESS linked | 100% |
| AC-ASS-02 | `assess_gap` documented when SEC-ASSESS absent | 100% |
| AC-COM-01 | Required SEC-REVIEW sections present | 100% |
| AC-SEC-01 | No secrets in SEC-REVIEW or cited snippets | 0 occurrences |
| AC-MUT-01 | No code patches or deploy commands in output | 0 occurrences |
| AC-SCP-01 | Does not produce SEC-ASSESS at Plan path | 0 wrong-artifact |
| AC-CON-01 | `decision: pending` at H-VERIFY | 100% |
| AC-PRS-01 | SEC-REVIEW persisted at review path before handoff | File path or `persist: pending` |

---

## CL-SECURITY-REVIEW Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-CODE-01 + AC-CODE-02 |
| 3 | AC-ASS-01 + AC-ASS-02 + assess_gap |
| 4 | AC-PRS-01 + review path |
| 5 | AC-FND-01 + AC-FND-02 |
| 6 | AC-MUT-01 |
| 7 | AC-SEC-01 + STD-SEC-001 §2 |
| 8 | WR status + artifact link |
| 9 | AC-SCP-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-SECURITY-REVIEW `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-SECURITY-REVIEW checks passed | 10 / 10 |
| Required ACs passed | 15 / 15 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |