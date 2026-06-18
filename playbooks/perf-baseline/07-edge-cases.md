# PB-perf-baseline — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | PERF-BASE already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` not performance and not WF-PERF | Block; wrong workflow | N |
| EC-ENT-04 | WR missing INT ref | Block; list missing IN-10 | N |
| EC-ENT-05 | H-INTAKE not approved | Block; complete Intake gate | N |
| EC-RES-01 | INT lacks concrete perf signals | `baseline_confidence: low`; open questions | Y |
| EC-RES-02 | Measurement environment unknown | `measurement_readiness: partial` | Y |
| EC-RES-03 | Conflicting PRD NFR vs INT | Flag in Open Questions | Y |
| EC-WF-01 | `WF-PERF` path | Proceed; recommend PB-implement after approve | N |
| EC-WF-02 | Performance on feature workflow | Proceed if `work_type: performance` linked | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT only | N |
| EC-CTX-02 | Module map absent | Scope from INT; list path gaps | N |
| EC-CTX-03 | Chat-only agent | Full PERF-BASE + `persist: pending` | Y |
| EC-SCP-01 | k6/script in artifact | CL-PERF #5 fail | N |
| EC-SCP-02 | Routing matrix embedded | CL-PERF #5 fail | N |
| EC-SCP-03 | Agent `decision: approve` | CL-PERF #10 fail | N |
| EC-LNK-01 | No INT link in References | CL-PERF #3 fail | N |
| EC-VAL-01 | CL-PERF fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-TGT-01 | No measurable targets | CL-PERF #6 fail | N |
| EC-TGT-02 | Targets without thresholds | CL-PERF #6 fail | N |
| EC-MEA-01 | Measurement plan includes execution results | CL-PERF #7 fail — plan only | N |
| EC-MEA-02 | `measurement_readiness: blocked` | Document blockers; handoff with open questions | Y |
| EC-NXT-01 | Recommend PB-perf-review before CODE | Allowed as alternate — note Verify phase | N |
| EC-NXT-02 | Recommend PB-implement direct | Primary for WF-PERF after H-PLAN | N |
| EC-PRD-01 | PRD NFR soft upstream | Merge into targets table with citation | N |
| EC-REV-01 | Revise increments revision | `revision: n+1`; preserve approvals append-only | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (scripts / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Insufficient targets | TARGET | 3 |
| Measurement plan includes execution | MEASURE | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |