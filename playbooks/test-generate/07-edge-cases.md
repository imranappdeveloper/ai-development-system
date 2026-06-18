# PB-test-generate — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No TEST-PLAN linked | Block; recommend PB-test-plan | N |
| EC-ENT-02 | TEST-PLAN `test_phase` not `plan` | Block; cite wrong phase | N |
| EC-ENT-03 | PB-test-plan gate not PASS | Block; cite prerequisite IN-33 | N |
| EC-ENT-04 | WR missing TEST-PLAN ref | Block; list missing IN-11 | N |
| EC-ENT-05 | CODE absent and no `code_gap: waiver` | Block soft; document in handoff | Y |
| EC-ENT-06 | TEST-GEN exists with higher `revision` | Block unless `mode: revise` | Y |
| EC-RES-01 | TEST-PLAN §3.2 detail insufficient to scaffold | `plan_alignment: partial_mismatch`; defer TC-* in §5 | Y |
| EC-RES-02 | CODE §6 conflicts with planned file paths | Align to CODE; note in §1 | N |
| EC-RES-03 | TC-* maps to multiple files | Document all paths in §3 | N |
| EC-RES-04 | Existing test covers TC-* | `file_action: existing` or `skipped` | N |
| EC-WF-01 | `WF-BUGFIX` single ISS | Narrow generation scope | N |
| EC-WF-02 | `WF-FEATURE` deferred integration layer | §5 deferred with `requires test DB` | N |
| EC-WF-03 | `WF-SECURITY` security TC-* | Generate security test stubs — no scan run | N |
| EC-CTX-01 | CONTEXT.md missing | Infer from CODE §6; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest conventions per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full TEST-GEN in output + `persist: pending` | Y |
| EC-SCP-01 | Agent runs `pytest` / `npm test` | CL-TEST-GEN #6 fail; STOP | N |
| EC-SCP-02 | Agent populates §6 with pass/fail | CL-TEST-GEN #6 fail | N |
| EC-SCP-03 | Agent sets H-VERIFY `decision: approve` | CL-TEST-GEN #9 fail | N |
| EC-SCP-04 | Agent claims verification complete | CL-TEST-GEN #9 fail | N |
| EC-MAP-01 | TC-* without §3 or §5 entry | CL-TEST-GEN #3 fail | N |
| EC-MAP-02 | Catalog row without file path | CL-TEST-GEN #5 fail | N |
| EC-FIL-01 | `created` file missing on disk | CL-TEST-GEN #5 fail | N |
| EC-SEC-01 | Secrets in generated test fixtures | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-TEST-GEN fail | Recovery ≤3 → OUT-06 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple CODE lanes (BE+FE) | Generate per lane; catalog all paths | Y |
| EC-PAR-01 | Partial ISS via `target_issue_id` | Subset TC-* only; rest in §5 deferred | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing TC-* coverage | RESOLVE | 3 |
| Execution attempted | SCOPE | 3 — escalate if repeated |
| H-VERIFY approve claimed | SCOPE | 3 |
| Missing file path in catalog | MAP | 3 |
| Missing TEST-GEN persist | PERSIST | 3 |
| Irrecoverable plan/CODE gap | Escalate OUT-06 | — |