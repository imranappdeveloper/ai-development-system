# PB-implement-devops — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
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
| EC-ENT-05 | ARCH missing and no waiver | Proceed with `arch_gap: missing`; pipelines from ISS only | Y |
| EC-ENT-06 | REL missing for WF-RELEASE ISS | Proceed with `rel_gap: missing`; flag in §5 | Y |
| EC-RES-01 | ARCH underspecified for deploy target | `implement_confidence: low`; open questions | Y |
| EC-RES-02 | ARCH conflicts with existing pipeline | Document in §3; `arch_alignment: partial_mismatch` | Y |
| EC-RES-03 | REL step missing for release automation | Flag `rel_alignment: partial_mismatch`; do not invent ship steps | Y |
| EC-RES-04 | ISS acceptance criteria ambiguous | List blockers; request human clarify at H-IMPLEMENT | Y |
| EC-WF-01 | `WF-BUGFIX` single ISS | H-PLAN soft gate; one ISS scope | N |
| EC-WF-02 | `WF-FEATURE` multiple ISS-* | Map each ISS in §3; partial run via `target_issue_id` | N |
| EC-WF-03 | `WF-SECURITY` pipeline hardening ISS | §7 security notes mandatory | N |
| EC-WF-04 | `WF-REFACTOR` breaking IaC change | §5 rollback notes required | N |
| EC-WF-05 | `WF-RELEASE` automation scope | Recommend PB-prepare-release; no prod ship | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from ISS/ARCH; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest stack per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full CODE in output + `persist: pending` | Y |
| EC-SCP-01 | Backend/frontend files in scope | CL-IMPLEMENT-DEVOPS #9 fail; redirect lane child | N |
| EC-SCP-02 | Agent attempts production deploy | CL-IMPLEMENT-DEVOPS #6 fail; STOP step | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-IMPLEMENT-DEVOPS #10 fail | N |
| EC-VAL-01 | Empty §6 Validation Notes | CL-IMPLEMENT-DEVOPS #5 fail | N |
| EC-VAL-02 | Plan run but not documented | CL-IMPLEMENT-DEVOPS #5 fail — document either way | N |
| EC-LNK-01 | No ISS ID in §3 for file change | CL-IMPLEMENT-DEVOPS #2 fail | N |
| EC-SEC-01 | Secrets in CODE or pipeline env | Redact `[REDACTED]`; CL-IMPLEMENT-DEVOPS #7 review | N |
| EC-VAL-03 | CL-IMPLEMENT-DEVOPS fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-IMPLEMENT | Request specificity; re-HAND | Y |
| EC-MUL-01 | ISS spans devops + backend | Implement devops subset only; flag multi_lane in handoff | Y |
| EC-PAR-01 | Partial ISS completion | CODE records completed ISS; list deferred in §8 | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing ISS link / traceability | LOAD | 3 |
| Missing validation documentation | VAL-DOC | 3 |
| Production deploy or prod apply attempted | SCOPE | 3 — escalate if repeated |
| Wrong lane scope (app code) | SCOPE | 3 |
| Missing CODE persist | PERSIST | 3 |
| Irrecoverable ARCH/REL gap | Escalate OUT-05 | — |