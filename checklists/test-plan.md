# CL-TEST-PLAN — Test Plan Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-TEST-PLAN |
| version | 1.0.0 |
| status | draft |
| consumer | PB-test-plan |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-VERIFY** (soft plan sub-artifact).

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | CODE linked or `code_gap` waiver; PB-implement-devops gate PASS; Verify phase; `work_id` resolvable |
| 2 | AC traceability | Every in-scope AC maps to ≥1 TC-* in §3.1; §3.2 planned details present |
| 3 | CODE grounding | CODE path linked when present; `code_alignment` block or `code_gap: waiver` documented |
| 4 | TEST-PLAN persisted | `{project_root}/work/testing/plan/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Plan only — no execution | §9 Execution Evidence empty or `plan_only` placeholder; no test commands run; no pass/fail results |
| 6 | Strategy complete | §2.1 layer table with rationale per STD-TEST-002 |
| 7 | Regression scope | §4 populated when CODE §4 Files Changed present |
| 8 | WR updated | TEST-PLAN artifact linked; `status: test_plan_pending_review` |
| 9 | No test code generation | No test source files written — generation is PB-test-generate |
| 10 | Human gate & handoff | `gate_id: H-VERIFY`, `sub_gate: plan`, `decision: pending`; recommend PB-test-generate only |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing AC mapping | MAP | 3 |
| Execution attempted | SCOPE | 3 — escalate if repeated |
| Test code generated | SCOPE | 3 |
| Missing TEST-PLAN persist | PERSIST | 3 |
| Irrecoverable CODE/AC gap | Escalate OUT-05 | — |