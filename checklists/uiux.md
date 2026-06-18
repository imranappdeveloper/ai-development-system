# CL-UIUX — UI/UX Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-UIUX |
| version | 1.0.0 |
| status | draft |
| consumer | PB-draft-ui-ux |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved PRD linked in Work Record; ARCH path or `arch_gap` waiver documented; DISC path or `disc_gap` waiver documented |
| 2 | `change_type` valid | One of: `new`, `additive`, `redesign` — matches PRD scope and workflow |
| 3 | `workflow_id` in INDEX | Matches PRD `workflow_id` unless human revise notes override |
| 4 | PRD traceability | §1.3 Related Documents or References lists PRD path; `prd_alignment.prd_path` populated |
| 5 | ARCH grounding (soft) | Screens in §4 trace to ARCH components or data flows; `arch_gap` documented if ARCH absent |
| 6 | DISC grounding (soft) | Personas/journeys cite DISC research when linked; `disc_gap` documented if DISC absent |
| 7 | Required UIUX sections | Overview, Users & Journeys, Information Architecture, Screen Inventory, Interaction & States, Accessibility, Responsive/Platform Notes, Open Questions, Human Approval per TP-uiux |
| 8 | No forbidden content | No component implementation code (JSX/CSS/React), embedded routing matrix, duplicated ARCH component lists as SSOT, or machine-readable design tokens pasted as body SSOT |
| 9 | Accessibility completeness | §6 Accessibility table populated with WCAG-oriented targets per STD-A11Y-001 |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / ARCH duplication / routing embed) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Weak screen or journey definitions | MODEL | 3 |
| Incomplete accessibility table | A11Y | 3 |
| Irrecoverable PRD/ARCH gap | Escalate OUT-05 | — |