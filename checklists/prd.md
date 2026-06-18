# CL-PRD — PRD Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-PRD |
| version | 1.0.0 |
| status | active |
| consumer | PB-draft-prd |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT; DISC linked or `discovery_gap` waiver documented in WR/PRD |
| 2 | `prd_type` valid | One of: `full`, `lite` |
| 3 | `workflow_id` in INDEX | Matches INT `workflow_id` unless human revise notes override |
| 4 | Upstream traceability | `upstream_int_path` set; DISC path or `discovery_gap` field populated |
| 5 | Goals grounded | §1 Goals trace to INT/DISC — no unsupported scope invention |
| 6 | Required PRD sections | Overview, Background, Users, Requirements, ACs, UX overview, Dependencies, Risks, Human Approval per TP-prd |
| 7 | No forbidden content | No code, architecture spec, API/DB detail, issue breakdown, or routing-matrix embed |
| 8 | Testable acceptance criteria | Every AC has `testable: yes` and verification method |
| 9 | Work Record status | `plan_pending_review` before handoff |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (forbidden docs) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Irrecoverable | Escalate OUT-05 | — |