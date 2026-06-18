# PB-draft-ui-ux — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved PRD | Block; recommend PB-draft-prd | N |
| EC-ENT-02 | UIUX already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | PRD `status: draft` only | Block; await H-PLAN on PRD or waiver | N |
| EC-ENT-04 | WR missing PRD artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | ARCH missing and no waiver | Proceed with `arch_gap: missing`; screens from PRD only | Y |
| EC-ENT-06 | DISC missing and no waiver | Proceed with `disc_gap: missing`; personas from PRD | Y |
| EC-RES-01 | PRD underspecified for screen design | `uiux_confidence: low`; list blockers in open questions | Y |
| EC-RES-02 | PRD FR not mappable to screens | Flag `prd_alignment: partial_mismatch`; do not invent scope | Y |
| EC-RES-03 | ARCH component missing for planned screen | Flag `arch_alignment: partial_mismatch`; do not invent backend | Y |
| EC-RES-04 | DISC persona conflicts with PRD | Flag `disc_alignment: partial_mismatch`; cite both sources | Y |
| EC-WF-01 | `WF-FEATURE` greenfield screens | `change_type: new`; full screen inventory | N |
| EC-WF-02 | `WF-ENHANCEMENT` additive screen | `change_type: additive`; delta screens only | N |
| EC-WF-03 | `WF-ENHANCEMENT` layout overhaul | `change_type: redesign`; migration notes in §7 | Y |
| EC-WF-04 | Mobile-only scope in PRD | Recommend PB-implement-mobile; responsive §7 explicit | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from PRD only; note gap in §1.2 | N |
| EC-CTX-02 | CONTEXT > budget | Digest design-system conventions per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full UIUX in output + `persist: pending` | Y |
| EC-SCP-01 | JSX/CSS in UIUX body | CL-UIUX #8 fail; use tables and wireframe descriptions | N |
| EC-SCP-02 | ARCH component list copied into UIUX | CL-UIUX #8 fail; reference ARCH path only | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-UIUX #10 fail | N |
| EC-LNK-01 | No PRD link in alignment block | CL-UIUX #4 fail | N |
| EC-A11Y-01 | Empty §6 accessibility table | CL-UIUX #9 fail | N |
| EC-VAL-01 | CL-UIUX fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-PLAN | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple unrelated surfaces in PRD | Flag; recommend split work_id or PRD revise | Y |
| EC-API-01 | API artifact present | Align data-display fields; do not redesign API | N |
| EC-DS-01 | Existing design system in CONTEXT | Reference tokens by name; do not paste token JSON | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / ARCH duplication) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Insufficient journey or screen definitions | MODEL | 3 |
| Incomplete accessibility table | A11Y | 3 |
| Irrecoverable PRD/ARCH gap | Escalate OUT-05 | — |