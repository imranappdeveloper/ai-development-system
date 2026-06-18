# PB-decompose-issues — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved PRD | Block; recommend PB-draft-prd | N |
| EC-ENT-02 | ISS-* already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | PRD `status: draft` only | Block; await H-PLAN on PRD or waiver | N |
| EC-ENT-04 | WR missing PRD artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | H-PLAN not approved on PRD | Block; complete Plan gate first | N |
| EC-ENT-06 | `WF-BUGFIX` workflow | Block; route to PB-draft-issue | N |
| EC-RES-01 | PRD underspecified for breakdown | `decompose_confidence: low`; list blockers in manifest | Y |
| EC-RES-02 | PRD FR with no obvious lane | Flag in manifest; propose split; human confirms at H-DECOMPOSE | Y |
| EC-RES-03 | ARCH conflicts with PRD scope | `prd_alignment: partial_mismatch`; do not expand PRD | Y |
| EC-RES-04 | API/DB/UIUX partial — soft only | Use for AC hints; do not require for entry | N |
| EC-WF-01 | `WF-FEATURE` multi-lane | `decompose_scope: multi_lane` or `full_stack` | N |
| EC-WF-02 | `WF-ENHANCEMENT` single component | `decompose_scope: single_lane` | N |
| EC-WF-03 | Human `single_issue_path` waiver | One ISS-* allowed with `decompose_waiver` | Y |
| EC-WF-04 | PRD non-goals in issue scope | CL-DECOMP #7 fail — move to scope `out` | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from PRD only; note gap in manifest | N |
| EC-CTX-02 | CONTEXT > budget | Digest stack per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full ISS-* in output + `persist: pending` | Y |
| EC-SCP-01 | Handler/UI code in ISS-* body | CL-DECOMP #7 fail; use AC tables only | N |
| EC-SCP-02 | Full PRD body copied into issue | CL-DECOMP #7 fail; reference PRD path only | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-DECOMP #10 fail | N |
| EC-LNK-01 | No PRD link in ISS-* References | CL-DECOMP #4 fail | N |
| EC-COV-01 | FR/NFR without ISS-* mapping | CL-DECOMP #8 fail or `decompose_gap` with owner | Y |
| EC-VAL-01 | CL-DECOMP fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-DECOMPOSE | Request specificity; re-HAND | Y |
| EC-MUL-01 | Duplicate issue IDs proposed | Regenerate unique `ISS-{LANE}-{SEQ}` | N |
| EC-LANE-01 | Wrong lane prefix (e.g. ISS-BE for UI) | CL-DECOMP #5 fail | N |
| EC-RT-01 | Recommend PB-implement umbrella | Fail; recommend lane child only | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / PRD duplication) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Untestable acceptance criteria | AC | 3 |
| Incomplete FR/NFR coverage | ANALYZE | 3 |
| Irrecoverable PRD gap | Escalate OUT-05 | — |