# CL-DISCOVERY — Discovery Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DISCOVERY |
| version | 1.0.0 |
| status | active |
| consumer | PB-discovery-research |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-FRAME**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT, or documented human waiver; INT path in Work Record |
| 2 | `discovery_type` valid | One of: `new_project`, `existing_onboarding`, `feature`, `enhancement` |
| 3 | `workflow_id` in INDEX | Matches INT `workflow_id` unless human revise notes override |
| 4 | Evidence citations | Every as-is / gap claim cites INT quote, CONTEXT.md section, or `evidence[]` source |
| 5 | Problem statement | Present; no implementation solution presupposed |
| 6 | Required DISC sections | Summary, Context, Current State, Problem, Exploration, Recommendations, Out of Scope, Open Questions, Human Approval |
| 7 | No forbidden content | No PRD, architecture spec, issue breakdown, or code in DISC |
| 8 | Intake alignment | §6.2 uses `intake_classification_alignment` — no new `work_type` assignment |
| 9 | Work Record status | `discovery_pending_review` before handoff |
| 10 | Human approval | `gate_id: H-FRAME`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (forbidden docs) | DOC | 3 |
| Missing evidence | RESEARCH | 3 |
| Irrecoverable | Escalate OUT-05 | — |