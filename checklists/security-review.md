# CL-SECURITY-REVIEW — Security Code Review Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-SECURITY-REVIEW |
| version | 1.0.0 |
| status | draft |
| consumer | PB-security-review |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-VERIFY** (soft optional gate).

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | CODE artifact linked in WR; H-IMPLEMENT satisfied; `workflow_phase: Verify`; not Plan-phase assess |
| 2 | CODE traceability | Every finding maps to ≥1 file path from CODE §4 Files Changed or cited diff |
| 3 | SEC-ASSESS grounding | SEC-ASSESS path linked when present; `assess_gap: missing \| waiver` documented if absent (soft) |
| 4 | SEC-REVIEW persisted | `{project_root}/work/security-review/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Findings documented | §4 Findings lists P0/P1/P2 items with file refs and remediation — never empty when issues exist |
| 6 | No code mutation | No repository edits, patches, or deploy commands in output or SEC-REVIEW record |
| 7 | STD-SEC-001 compliance | Secrets redacted; auth/input-validation/data-exposure dimensions reviewed per standard |
| 8 | WR updated | SEC-REVIEW artifact linked; `status: security_review_pending` or equivalent |
| 9 | Scope compliance | Verify-phase security **code** review only — does not produce SEC-ASSESS or redesign plans |
| 10 | Human approval | `gate_id: H-VERIFY`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing CODE link / traceability | LOAD | 3 |
| Missing findings for known issues | FIND | 3 |
| Code mutation attempted | SCOPE | 3 — escalate if repeated |
| Confused with PB-security-assess (Plan) | SCOPE | 3 |
| Missing SEC-REVIEW persist | PERSIST | 3 |
| Irrecoverable CODE artifact gap | Escalate OUT-05 | — |