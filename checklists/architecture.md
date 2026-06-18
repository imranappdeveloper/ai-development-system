# CL-ARCH — Architecture Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-ARCH |
| version | 1.0.0 |
| status | active |
| consumer | PB-draft-architecture |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved PRD linked in Work Record, or documented human waiver; PRD path in `artifacts[]` |
| 2 | `architecture_type` valid | One of: `greenfield`, `as_is`, `delta` — matches workflow and PRD scope |
| 3 | `workflow_id` in INDEX | Matches PRD `workflow_id` unless human revise notes override |
| 4 | PRD traceability | §1.3 Related Documents lists PRD path; `prd_alignment.prd_path` populated |
| 5 | Layer and dependency rules | §3 layer/module map present; dependency direction inward per STD-ARCH-001 |
| 6 | Required ARCH sections | Overview, Context & Constraints, Architectural Approach, Component Design, Data Flow, Cross-Cutting, Technology Choices, Risks, Open Questions, Human Approval |
| 7 | No forbidden content | No application code, implementation snippets, duplicated PRD FR lists, or secrets |
| 8 | System context | §2.1 bounded system context — diagram reference or ASCII description |
| 9 | Work Record status | `architecture_pending_review` before handoff |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / PRD duplication) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Weak structural model | MODEL | 3 |
| Irrecoverable PRD gap | Escalate OUT-05 | — |