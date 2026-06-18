# PB-security-assess — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | INT links and SA-* control IDs |
| Threat coverage | 25% | Documented model with enumerated threats |
| Completeness | 20% | Required sections per 04-io-contract |
| Safety | 15% | No code/routing embed/secrets |
| Gate compliance | 15% | CL-SECURI pass + H-PLAN pending |

---

## Required Acceptance Criteria

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id: WF-SECURITY` or INT `work_type: security` | 100% |
| AC-ACC-02 | `assess_scope` and `threat_model_method` valid enums | 100% |
| AC-TRC-01 | `upstream_int_path` in frontmatter and References | 100% |
| AC-THR-01 | Threat model section with ≥3 enumerated threats | 100% |
| AC-CTL-01 | ≥3 SA-* controls with testable requirements | 100% |
| AC-RISK-01 | Risk register with severity per STD enums | 100% |
| AC-REM-01 | Remediation plan prioritized — no code blocks | 0 code blocks |
| AC-SEC-01 | Secrets redacted per STD-SEC-001 | 0 live secrets |
| AC-SCP-01 | No routing matrix embedded | 0 blocks |
| AC-PRS-01 | OUT-01 persisted before handoff | Paths or `persist: pending` |
| AC-WR-01 | WR `artifacts[]` lists SEC-ASSESS path | 100% |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |

---

## CL-SECURI Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | Entry criteria (INT + H-INTAKE + WF-SECURITY) |
| 2 | INT traceability |
| 3 | Threat model documented |
| 4 | Scope in/out tables |
| 5 | SA-* security controls |
| 6 | Remediation plan (no code) |
| 7 | Risk register |
| 8 | Artifact path |
| 9 | WR status |
| 10 | Human approval |

**Handoff allowed:** CL-SECURI `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-SECURI checks passed | 10 / 10 |
| Required ACs passed | 12 / 12 |
| Production readiness (10-review) | ≥ 72 / 100 for `active` |