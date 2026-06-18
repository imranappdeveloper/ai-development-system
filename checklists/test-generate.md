# CL-TEST-GEN — Test Generation Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-TEST-GEN |
| version | 1.0.0 |
| status | draft |
| consumer | PB-test-generate |
| gate | Blocks handoff (OUT-05) when `result: fail` |

Agent must pass **all 10 items** before human handoff. **Never approve H-VERIFY.**

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | TEST-PLAN linked at `work/testing/plan/{work_id}.md`; PB-test-plan gate PASS; Verify phase; `work_id` resolvable |
| 2 | TEST-PLAN grounding | `upstream_test_plan_path` in frontmatter; `plan_alignment` block or `plan_gap: waiver` documented |
| 3 | TC-* traceability | Every in-scope TC-* from TEST-PLAN §3.1 addressed in §3 catalog or §5 deferred with reason |
| 4 | TEST-GEN persisted | `{project_root}/work/testing/generate/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Generated files catalog | §3 lists every `created`/`updated` path with `file_action`; files exist on disk |
| 6 | Generate only — no execution | §6 Execution Evidence empty or `generate_only` placeholder; no test commands run; no pass/fail results |
| 7 | CODE / convention alignment | CODE path linked when present; paths match CONTEXT test conventions |
| 8 | WR updated | TEST-GEN artifact linked; `status: test_gen_pending_review` |
| 9 | No H-VERIFY approve | No `decision: approve` for H-VERIFY; `exit_gate: none`; never claim verification complete |
| 10 | Human handoff | `recommended_next_skill: PB-verify`; `alternate_next_skill: PB-review`; no auto-invoke |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing TC-* coverage | RESOLVE | 3 |
| Execution attempted | SCOPE | 3 — escalate if repeated |
| H-VERIFY approve claimed | SCOPE | 3 |
| Missing file path in catalog | MAP | 3 |
| Missing TEST-GEN persist | PERSIST | 3 |
| Irrecoverable plan/CODE gap | Escalate OUT-06 | — |