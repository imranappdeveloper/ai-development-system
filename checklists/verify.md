# CL-VERIFY — Test Execution Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-VERIFY |
| version | 1.0.0 |
| status | draft |
| consumer | PB-verify |
| gate | Blocks handoff (OUT-04) when `result: fail`; H-VERIFY remains pending until human approves |

Agent must pass **all 10 items** before human handoff at **H-VERIFY** (evidence sub-artifact). **Never approve H-VERIFY.**

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | TEST-PLAN + TEST-GEN linked (soft); PB-test-generate gate PASS; Verify phase; `work_id` resolvable |
| 2 | Upstream grounding | `upstream_test_plan_path` and `upstream_test_gen_path` in frontmatter; alignment blocks or waivers documented |
| 3 | TC-* traceability | Every executed TC-* has actual result in §3.2; deferred TC-* listed in §1.2 or §9 with reason |
| 4 | TEST-RPT persisted | `{project_root}/work/testing/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Execution evidence | §9.1 commands with exit codes and timestamps; §9.2 summary; §9.3 failure log when failures present |
| 6 | Suites actually run | At least one test command executed for in-scope layers — no fabricated pass without runs |
| 7 | CODE / plan alignment | TEST-PLAN path linked; TEST-GEN §3 paths referenced in commands or §9 |
| 8 | WR updated | TEST-RPT artifact linked; `status: verify_pending_review` |
| 9 | No H-VERIFY approve | No `decision: approve` for H-VERIFY; agent documents evidence only |
| 10 | Human gate & handoff | `gate_id: H-VERIFY`, `decision: pending`; recommend PB-review or PB-prepare-release only |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing execution evidence | EXECUTE | 3 |
| Fabricated / skipped runs | EXECUTE | 3 — escalate if repeated |
| H-VERIFY approve claimed | SCOPE | 3 |
| Missing TEST-PLAN / TEST-GEN link | LOAD | 3 |
| Missing TEST-RPT persist | PERSIST | 3 |
| Irrecoverable env blocker | Escalate OUT-05 | — |