# CL-REVIEW — Code Review Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-REVIEW |
| version | 1.0.0 |
| status | draft |
| consumer | PB-review |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-VERIFY** (soft review sub-artifact).

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | CODE linked; H-IMPLEMENT soft satisfied; Verify phase; `work_id` resolvable; PB-test-plan chain PASS or waiver |
| 2 | AC traceability | Every in-scope AC has §4 row with Met + Evidence columns |
| 3 | CODE grounding | CODE path in `upstream_code_paths`; `code_alignment` block or mismatch documented |
| 4 | REVIEW persisted | `{project_root}/work/review/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Standards checklist | §3 all applicable STD-* rows evaluated — no blank Applicable column |
| 6 | Findings quality | B-/S-/N- IDs used; P0 blockers have Required action; locations cited |
| 7 | Scope assessment | §6 all six questions answered |
| 8 | WR updated | REVIEW artifact linked; `status: review_pending` |
| 9 | Review only — no mutation | No source code modified; no test commands executed |
| 10 | Human gate & handoff | `gate_id: H-VERIFY`, `sub_gate: review`, `decision: pending`; chain note (PB-test-plan; PB-test-generate future) |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing AC assessment | EXTRACT | 3 |
| Code modification attempted | SCOPE | 3 — escalate if repeated |
| Standards §3 incomplete | STANDARDS | 3 |
| Missing REVIEW persist | PERSIST | 3 |
| Irrecoverable CODE/AC gap | Escalate OUT-05 | — |