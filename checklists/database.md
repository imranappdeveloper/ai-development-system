# CL-DATABASE — Database Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DATABASE |
| version | 1.0.0 |
| status | draft |
| consumer | PB-draft-database |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved ARCH linked in Work Record; PRD path or `prd_gap` waiver documented |
| 2 | `change_type` valid | One of: `new_schema`, `migration`, `optimization` — matches ARCH scope and workflow |
| 3 | `workflow_id` in INDEX | Matches ARCH `workflow_id` unless human revise notes override |
| 4 | ARCH traceability | §1.3 Related Documents lists ARCH path; `arch_alignment.arch_path` populated |
| 5 | PRD grounding (soft) | Domain entities in §2.1 trace to PRD FR/NFR or ARCH data flows; `prd_gap` documented if PRD absent |
| 6 | Required DB sections | Overview, Data Requirements, Logical Model, Physical Model, Migration Plan, Access Patterns, Security & Compliance, Performance, SSOT, Open Questions, Human Approval per TP-database |
| 7 | No forbidden content | No executable DDL/SQL migration scripts, application code, duplicated ARCH component lists, or secrets |
| 8 | Migration completeness | When `change_type: migration` — §5 steps, reversibility, and rollback plan present |
| 9 | Work Record status | `database_pending_review` before handoff |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (DDL / code / ARCH duplication) | DOC | 3 |
| Missing ARCH link | DOC | 3 |
| Weak logical or physical model | MODEL | 3 |
| Incomplete migration plan | MIGRATE | 3 |
| Irrecoverable ARCH/PRD gap | Escalate OUT-05 | — |