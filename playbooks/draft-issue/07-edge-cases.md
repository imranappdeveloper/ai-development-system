# PB-draft-issue — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | ISS already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` not bugfix | Block; route PB-decompose-issues or PRD path | N |
| EC-ENT-04 | WR missing INT ref | Block; list missing IN-10 | N |
| EC-ENT-05 | H-INTAKE not approved | Block | N |
| EC-ENT-06 | `WF-FEATURE` workflow | Block; route PB-decompose-issues | N |
| EC-RES-01 | Repro gaps in INT | Document in ISS Reproduction; `issue_confidence: low` | Y |
| EC-RES-02 | DIAG optional missing | Proceed from INT; note `diag_gap` | N |
| EC-WF-01 | `WF-BUGFIX` | Single ISS at `work/issue/{work_id}.md` | N |
| EC-WF-02 | DIAG present | Link `upstream_diag_path`; align AC | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT/DIAG | N |
| EC-CTX-02 | Chat-only agent | Full ISS + `persist: pending` | Y |
| EC-SCP-01 | Fix code in ISS | CL-ISSUE #5 fail | N |
| EC-SCP-02 | Routing matrix embedded | CL-ISSUE #5 fail | N |
| EC-SCP-03 | Agent `decision: approve` | CL-ISSUE #10 fail | N |
| EC-LNK-01 | No INT link | CL-ISSUE #3 fail | N |
| EC-LNK-02 | DIAG ran but no link | CL-ISSUE #7 fail | N |
| EC-VAL-01 | CL-ISSUE fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity | Y |
| EC-AC-01 | Untestable AC | CL-ISSUE #6 fail | N |
| EC-PATH-01 | Uses `work/issues/` plural | CL-ISSUE #9 fail — singular path | N |
| EC-LANE-01 | Wrong lane for UI bug | Set `issue_lane: frontend` | N |
| EC-RT-01 | Recommend PB-decompose-issues | Fail — single issue path | N |
| EC-HOT-01 | Production outage INT | `fix_scope: hotfix`; flag P0 | Y |
| EC-MUL-01 | Multiple issues requested | Block; route PB-decompose-issues | N |
| EC-IMP-01 | Recommend lane child vs umbrella | PB-implement acceptable; lane child preferred | N |
| EC-REG-01 | Regression AC missing | Add regression verify AC | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |
