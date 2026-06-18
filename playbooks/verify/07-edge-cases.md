# PB-verify — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No TEST-PLAN linked | Block; recommend PB-test-plan | N |
| EC-ENT-02 | No TEST-GEN linked | Block; recommend PB-test-generate | N |
| EC-ENT-03 | PB-test-generate gate not PASS | Block; cite prerequisite IN-33 | N |
| EC-ENT-04 | WR missing TEST-PLAN / TEST-GEN refs | Block; list missing IN-41–IN-42 | N |
| EC-ENT-05 | TEST-PLAN `test_phase` not `plan` | Block; cite wrong phase | N |
| EC-ENT-06 | TEST-RPT exists with H-VERIFY approved | Block unless `mode: revise` | Y |
| EC-RES-01 | TEST-GEN §3 file missing on disk | `gen_alignment: partial_mismatch`; block or run available subset | Y |
| EC-RES-02 | TEST-PLAN TC-* not in TEST-GEN catalog | Run existing tests; note gap in §1 | Y |
| EC-RES-03 | CODE §6 conflicts with TEST-GEN paths | Align commands to TEST-GEN §3 | N |
| EC-RES-04 | Flaky test intermittent fail | Document in §9.3; `execution_result: fail`; recommend re-run | Y |
| EC-WF-01 | `WF-BUGFIX` single ISS | Narrow execution to reproduction TC-* | N |
| EC-WF-02 | `WF-FEATURE` deferred integration layer | `execution_result: partial`; integration in §1.2 out-of-scope | N |
| EC-WF-03 | `WF-SECURITY` security TC-* | Run security test stubs — no production scan | N |
| EC-WF-04 | `WF-TESTING` dedicated verify | Full regression per TEST-PLAN §4 | N |
| EC-CTX-01 | CONTEXT.md missing | Infer commands from CODE §6; note gap in §8 | N |
| EC-CTX-02 | CONTEXT > budget | Digest test commands per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full TEST-RPT in output + `persist: pending` | Y |
| EC-ENV-01 | TEST_DATABASE_URL not set | Integration `blocked`; unit/contract run; §9.3 notes env | Y |
| EC-ENV-02 | CI mode unavailable locally | Run local equivalent; note delta in §8 | N |
| EC-SCP-01 | Agent skips execution, claims pass | CL-VERIFY #6 fail; STOP | N |
| EC-SCP-02 | Agent fabricates exit codes | CL-VERIFY #5 + #6 fail | N |
| EC-SCP-03 | Agent sets H-VERIFY `decision: approve` | CL-VERIFY #9 fail | N |
| EC-SCP-04 | Agent generates new test files | CL-VERIFY #7 fail; redirect PB-test-generate | N |
| EC-MAP-01 | TC-* executed without §3.2 result | CL-VERIFY #3 fail | N |
| EC-MAP-02 | §9 populated but §3.2 empty | CL-VERIFY #3 fail | N |
| EC-SEC-01 | Secrets in TEST-RPT environment table | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-VERIFY fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-VERIFY | Request specificity; re-EXECUTE | Y |
| EC-MUL-01 | Multiple CODE lanes (BE+FE) | Run suites per lane; aggregate in §9.2 | Y |
| EC-PAR-01 | Partial ISS via `target_issue_id` | Subset TC-* only; rest deferred in §1.2 | Y |
| EC-FAIL-01 | All tests fail | `execution_result: fail`; recommend PB-implement-* | N |
| EC-FAIL-02 | Mixed pass/fail | `execution_result: fail`; §9.3 per failure | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing execution evidence | EXECUTE | 3 |
| Fabricated / skipped runs | EXECUTE | 3 — escalate if repeated |
| H-VERIFY approve claimed | SCOPE | 3 |
| Missing TEST-PLAN / TEST-GEN link | LOAD | 3 |
| Missing TEST-RPT persist | PERSIST | 3 |
| Irrecoverable env blocker | Escalate OUT-05 | — |