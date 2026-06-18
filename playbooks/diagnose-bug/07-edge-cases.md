# PB-diagnose-bug — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-diagnose-bug |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | DIAG already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` not bugfix | Block; wrong workflow | N |
| EC-ENT-04 | WR missing INT ref | Block; list missing IN-10 | N |
| EC-ENT-05 | H-INTAKE not approved | Block; complete Intake gate | N |
| EC-RES-01 | Repro insufficient | `repro_status: partial`; list gaps | Y |
| EC-RES-02 | Cannot reproduce | `repro_status: blocked`; evidence plan | Y |
| EC-WF-01 | `WF-BUGFIX` path | Proceed; recommend PB-draft-issue after approve | N |
| EC-WF-02 | Human skips diagnose | Optional skill — PB-draft-issue direct OK | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT only | N |
| EC-CTX-02 | Logs referenced in INT | Include in Evidence — redact secrets | N |
| EC-CTX-03 | Chat-only agent | Full DIAG + `persist: pending` | Y |
| EC-SCP-01 | Fix code in DIAG | CL-DIAGNO #5 fail | N |
| EC-SCP-02 | Routing matrix embedded | CL-DIAGNO #5 fail | N |
| EC-SCP-03 | Agent `decision: approve` | CL-DIAGNO #10 fail | N |
| EC-LNK-01 | No INT link in References | CL-DIAGNO #3 fail | N |
| EC-VAL-01 | CL-DIAGNO fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-OPT-01 | Optional skill skipped | No error; ISS may proceed without DIAG | N |
| EC-RC-01 | Root cause unknown | `root_cause_category: unknown` + next steps | Y |
| EC-RC-02 | Multiple hypotheses tied | Rank by likelihood table | N |
| EC-EV-01 | No evidence rows | CL-DIAGNO #7 fail | N |
| EC-FIX-01 | Full implementation plan in DIAG | Fix direction only — CL-DIAGNO #5 | N |
| EC-RT-01 | Recommend PB-implement direct | Recommend PB-draft-issue first | N |
| EC-REG-01 | Regression suspected | `root_cause_category: regression` | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |
