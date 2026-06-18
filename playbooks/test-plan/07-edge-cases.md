# PB-test-plan — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No CODE and no `code_gap: waiver` | Block; recommend PB-implement-* | N |
| EC-ENT-02 | TEST-PLAN already H-VERIFY approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-IMPLEMENT not approved when CODE present | Block soft; document in handoff | Y |
| EC-ENT-04 | WR missing artifact refs | Block; list missing IN-40–IN-43 | N |
| EC-ENT-05 | PRD and ISS both absent | Proceed with `ac_gap: waiver` or block per human | Y |
| EC-ENT-06 | PB-implement-devops gate not PASS | Block; cite prerequisite IN-33 | N |
| EC-RES-01 | CODE §6 notes conflict with planned layers | Document in §1; align strategy to CODE | N |
| EC-RES-02 | PRD AC conflicts with ISS AC | Flag in §1; `test_confidence: low` | Y |
| EC-RES-03 | CODE partial_mismatch with ISS | `code_alignment: partial_mismatch`; open questions | Y |
| EC-RES-04 | AC ambiguous — cannot map TC-* | List blockers; request human clarify | Y |
| EC-WF-01 | `WF-BUGFIX` single ISS | Narrow scope; reproduction TC in §3 | N |
| EC-WF-02 | `WF-FEATURE` multiple ISS-* | Map each ISS AC; partial via `target_issue_id` | N |
| EC-WF-03 | `WF-SECURITY` | §5 security checks planned — no scan execution | N |
| EC-WF-04 | `WF-PERF` | §6 perf scenarios planned — no benchmark run | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from CODE/ISS; note gap in §8 | N |
| EC-CTX-02 | CONTEXT > budget | Digest test commands per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full TEST-PLAN in output + `persist: pending` | Y |
| EC-SCP-01 | Agent runs `pytest` / `npm test` | CL-TEST-PLAN #5 fail; STOP | N |
| EC-SCP-02 | Agent populates §9 with pass/fail | CL-TEST-PLAN #5 fail | N |
| EC-SCP-03 | Agent sets H-VERIFY `decision: approve` | CL-TEST-PLAN #10 fail | N |
| EC-SCP-04 | Agent writes test source files | CL-TEST-PLAN #9 fail; redirect PB-test-generate | N |
| EC-MAP-01 | AC without TC-* mapping | CL-TEST-PLAN #2 fail | N |
| EC-MAP-02 | Orphan TC-* without AC ref | CL-TEST-PLAN #2 fail | N |
| EC-SEC-01 | Secrets in TEST-PLAN environment table | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-TEST-PLAN fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise_plan notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple CODE lanes (BE+FE) | Merge AC from all linked CODE paths | Y |
| EC-PAR-01 | Partial ISS scope | Plan records completed ISS; deferred in §1.2 out-of-scope | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing AC mapping | MAP | 3 |
| Execution attempted | SCOPE | 3 — escalate if repeated |
| Test code generated | SCOPE | 3 |
| Missing TEST-PLAN persist | PERSIST | 3 |
| Irrecoverable CODE/AC gap | Escalate OUT-05 | — |