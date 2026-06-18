# PB-bootstrap-project — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-bootstrap-project |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved PRD | Block; recommend PB-draft-prd | N |
| EC-ENT-02 | SCAFFOLD already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | PRD `status: draft` only | Block; await H-PLAN on PRD | N |
| EC-ENT-04 | WR missing PRD ref | Block; list missing IN-10 | N |
| EC-ENT-05 | `WF-BUGFIX` workflow | Block; route PB-draft-issue | N |
| EC-ENT-06 | Existing repo with CONTEXT | Block; recommend PB-onboard-project | N |
| EC-RES-01 | PRD lacks stack detail | `scaffold_confidence: low`; list blockers | Y |
| EC-RES-02 | ARCH conflicts with PRD stack | Flag in Open Questions; do not rewrite ARCH | Y |
| EC-WF-01 | `WF-PROJECT-NEW` greenfield | `scaffold_scope: standard` default | N |
| EC-WF-02 | Human requests minimal scaffold | `scaffold_scope: minimal` | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from PRD; note gap | N |
| EC-CTX-02 | CONTEXT > budget | Digest per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full SCAFFOLD + `persist: pending` | Y |
| EC-SCP-01 | Application code in SCAFFOLD | CL-BOOTST #5 fail | N |
| EC-SCP-02 | Routing matrix embedded | CL-BOOTST #5 fail | N |
| EC-SCP-03 | Agent `decision: approve` | CL-BOOTST #10 fail | N |
| EC-LNK-01 | No PRD link in References | CL-BOOTST #3 fail | N |
| EC-VAL-01 | CL-BOOTST fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-OPT-01 | Skill optional — skipped | Orchestrator may skip; no error | N |
| EC-RT-01 | Recommend PB-implement | Fail; scaffold is plan-only | N |
| EC-STK-01 | Stack invented without PRD | CL-BOOTST #3 fail | N |
| EC-FIL-01 | Empty file manifest | CL-BOOTST #4 fail | N |
| EC-CMD-01 | Bootstrap steps not executable | CL-BOOTST #6 fail | N |
| EC-GAT-01 | H-PLAN not on PRD | Block entry | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |
