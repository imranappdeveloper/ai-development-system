# PB-security-assess — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | SEC-ASSESS already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` not security and not WF-SECURITY | Block; wrong workflow | N |
| EC-ENT-04 | WR missing INT ref | Block; list missing IN-10 | N |
| EC-ENT-05 | H-INTAKE not approved | Block; complete Intake gate | N |
| EC-ENT-06 | PB-intake-classify gate not PASS | Block promotion invoke | N |
| EC-RES-01 | INT lacks threat context | `assess_confidence: low`; open questions | Y |
| EC-RES-02 | Architecture unknown | Proceed from INT; flag CONTEXT gap | Y |
| EC-WF-01 | `WF-SECURITY` path | Proceed; recommend PB-implement after approve | N |
| EC-WF-02 | Mixed security scope | `assess_scope: mixed_security` | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT only | N |
| EC-CTX-02 | Secrets in INT input | Redact `[REDACTED]`; note in OUT-03 | N |
| EC-CTX-03 | Chat-only agent | Full SEC-ASSESS + `persist: pending` | Y |
| EC-SCP-01 | Fix code in remediation | CL-SECURI #6 fail | N |
| EC-SCP-02 | Routing matrix embedded | CL-SECURI #6 fail | N |
| EC-SCP-03 | Agent `decision: approve` | CL-SECURI #10 fail | N |
| EC-SCP-04 | Produces SEC-REVIEW artifact | CL-SECURI scope fail — wrong playbook | N |
| EC-SCP-05 | Reads CODE for code review | Block — PB-security-review scope | N |
| EC-LNK-01 | No INT link in References | CL-SECURI #2 fail | N |
| EC-VAL-01 | CL-SECURI fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-THR-01 | Single threat only | Expand model or document rationale | Y |
| EC-CTL-01 | Controls without SA-* IDs | CL-SECURI #5 fail | N |
| EC-RISK-01 | Empty risk register | CL-SECURI #7 fail | N |
| EC-REM-01 | Pentest commands in plan | Remove — assessment only | N |
| EC-RT-01 | Recommend PB-security-review before implement | Default PB-implement for WF-SECURITY | N |
| EC-STD-01 | STD-SEC-001 violation | Redact; CL-SECURI #6 fail if secrets present | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed / wrong artifact) | DOC | 3 |
| Missing INT link | LOAD | 3 |
| Insufficient threat model | MODEL | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |