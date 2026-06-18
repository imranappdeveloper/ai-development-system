# PB-security-review — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No CODE artifact linked | Block; recommend PB-implement | N |
| EC-ENT-02 | SEC-REVIEW already H-VERIFY approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-IMPLEMENT not approved | Block; await H-IMPLEMENT or document advisory waive | Y |
| EC-ENT-04 | WR missing CODE artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | SEC-ASSESS missing and no waiver | Proceed with `assess_gap: missing`; review from CODE/STD-SEC-001 | Y |
| EC-ENT-06 | Invoked during Plan phase | Block; redirect PB-security-assess | N |
| EC-RES-01 | CODE §4 paths missing on disk | Flag `security_review_confidence: low`; open questions | Y |
| EC-RES-02 | SEC-ASSESS controls not reflected in CODE | `assess_alignment: partial_mismatch` | Y |
| EC-RES-03 | CODE §7 security notes contradict findings | Document conflict in §4 | Y |
| EC-RES-04 | P0 finding requires implement fix | `review_decision: fail`; recommend PB-implement revise | Y |
| EC-WF-01 | `WF-BUGFIX` CVE fix CODE | Focused scope; cite ISS/CVE ref | N |
| EC-WF-02 | `WF-FEATURE` multi-lane CODE | Review linked lane CODE; flag other lanes in §7 | N |
| EC-WF-03 | `WF-SECURITY` hardening path | SEC-ASSESS SHOULD be linked; assess_alignment mandatory | N |
| EC-WF-04 | `WF-REFACTOR` auth middleware change | crypto + auth scope; rollback note in §6 | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from CODE; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest security patterns per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full SEC-REVIEW in output + `persist: pending` | Y |
| EC-SCP-01 | Agent patches repository code | CL-SECURITY-REVIEW #6 fail; STOP step | N |
| EC-SCP-02 | Agent produces SEC-ASSESS | CL-SECURITY-REVIEW #9 fail; wrong playbook | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-SECURITY-REVIEW #10 fail | N |
| EC-FND-01 | Known issues but empty §4 | CL-SECURITY-REVIEW #5 fail | N |
| EC-FND-02 | Finding without file ref | CL-SECURITY-REVIEW #2 fail | N |
| EC-SEC-01 | Secrets in SEC-REVIEW or snippets | Redact `[REDACTED]`; CL #7 review | N |
| EC-VAL-01 | CL-SECURITY-REVIEW fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-VERIFY | Request specificity; re-HAND | Y |
| EC-OPT-01 | H-VERIFY waived for optional skill | Document `human_waiver`; skip downstream block | Y |
| EC-PAR-01 | Parallel with PB-review | Independent artifacts; no cross-overwrite | N |
| EC-TST-01 | TEST-RPT shows security test fail | Cite in §4; do not re-run tests | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing CODE link / traceability | LOAD | 3 |
| Missing findings documentation | FIND | 3 |
| Code mutation attempted | SCOPE | 3 |
| Confused with PB-security-assess | SCOPE | 3 |
| Missing SEC-REVIEW persist | PERSIST | 3 |
| Irrecoverable CODE gap | Escalate OUT-05 | — |