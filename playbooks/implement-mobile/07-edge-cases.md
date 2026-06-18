# PB-implement-mobile — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No ISS / ISS-* linked | Block; recommend PB-decompose-issues or PB-draft-issue | N |
| EC-ENT-02 | CODE already H-IMPLEMENT approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-DECOMPOSE not approved (WF-FEATURE) | Block; await H-DECOMPOSE or document waiver | Y |
| EC-ENT-04 | WR missing ISS artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | UIUX missing and no waiver | Proceed with `uiux_gap: missing`; screens from ISS/ARCH only | Y |
| EC-ENT-06 | API missing for data-fetch ISS | Proceed with `api_gap: missing`; flag in §5 | Y |
| EC-RES-01 | UIUX underspecified for screen | `implement_confidence: low`; open questions | Y |
| EC-RES-02 | UIUX conflicts with existing navigation | Document in §3; `uiux_alignment: partial_mismatch` | Y |
| EC-RES-03 | API operation missing for data-fetch | Flag `api_alignment: partial_mismatch`; do not invent endpoints | Y |
| EC-RES-04 | ISS acceptance criteria ambiguous | List blockers; request human clarify at H-IMPLEMENT | Y |
| EC-WF-01 | `WF-BUGFIX` single ISS | H-PLAN soft gate; one ISS scope | N |
| EC-WF-02 | `WF-FEATURE` multiple ISS-* | Map each ISS in §3; partial run via `target_issue_id` | N |
| EC-WF-03 | `WF-SECURITY` hardening ISS | §7 accessibility/security notes mandatory | N |
| EC-WF-04 | `WF-REFACTOR` navigation change | §5 platform notes required | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from ISS/UIUX; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest stack per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full CODE in output + `persist: pending` | Y |
| EC-SCP-01 | Backend files in scope | CL-IMPLEMENT-MOBILE #9 fail; redirect PB-implement-backend | N |
| EC-SCP-02 | Agent attempts app store submit | CL-IMPLEMENT-MOBILE #6 fail; STOP step | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-IMPLEMENT-MOBILE #10 fail | N |
| EC-SCP-04 | Web frontend files in scope | CL-IMPLEMENT-MOBILE #9 fail; redirect PB-implement-frontend | N |
| EC-TST-01 | Empty §6 Testing Notes | CL-IMPLEMENT-MOBILE #5 fail | N |
| EC-TST-02 | Tests run but not documented | CL-IMPLEMENT-MOBILE #5 fail — document either way | N |
| EC-LNK-01 | No ISS ID in §3 for file change | CL-IMPLEMENT-MOBILE #2 fail | N |
| EC-SEC-01 | Secrets or tokens in CODE or code comments | Redact `[REDACTED]`; CL-IMPLEMENT-MOBILE #7 review | N |
| EC-VAL-01 | CL-IMPLEMENT-MOBILE fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-IMPLEMENT | Request specificity; re-HAND | Y |
| EC-MUL-01 | ISS spans mobile + backend | Implement mobile subset only; flag multi_lane in handoff | Y |
| EC-PAR-01 | Partial ISS completion | CODE records completed ISS; list deferred in §8 | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing ISS link / traceability | LOAD | 3 |
| Missing UIUX link / uiux_gap undocumented | LOAD | 3 |
| Missing tests documentation | TEST-DOC | 3 |
| App store submit or release action | SCOPE | 3 |
| Wrong lane scope | SCOPE | 3 |
| Missing CODE persist | PERSIST | 3 |
| Irrecoverable UIUX/API gap | Escalate OUT-05 | — |