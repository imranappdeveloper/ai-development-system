# CL-API — API Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-API |
| version | 1.0.0 |
| status | draft |
| consumer | PB-draft-api |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved ARCH linked in Work Record; PRD path or `prd_gap` waiver documented; DB path or `db_gap` waiver documented |
| 2 | `change_type` valid | One of: `new`, `additive`, `breaking` — matches ARCH scope and workflow |
| 3 | `workflow_id` in INDEX | Matches ARCH `workflow_id` unless human revise notes override |
| 4 | ARCH traceability | §1.3 Related Documents or References lists ARCH path; `arch_alignment.arch_path` populated |
| 5 | PRD grounding (soft) | Operations in §4 trace to PRD FR/NFR or ARCH data flows; `prd_gap` documented if PRD absent |
| 6 | DB grounding (soft) | Data models in §5 align with DB entities when DB linked; `db_gap` documented if DB absent |
| 7 | Required API sections | Overview, Auth & Authorization, Common Conventions, Endpoints, Data Models, Security, Testing Notes, Open Questions, Human Approval per TP-api |
| 8 | No forbidden content | No handler/middleware implementation code, duplicated ARCH component lists, embedded secrets, or machine-readable spec pasted as body SSOT |
| 9 | Breaking change completeness | When `change_type: breaking` — §8 Breaking Changes & Migration with affected clients and migration path present |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / ARCH duplication / secrets) | DOC | 3 |
| Missing ARCH link | DOC | 3 |
| Weak endpoint or model definitions | MODEL | 3 |
| Incomplete breaking-change plan | BREAK | 3 |
| Irrecoverable ARCH/PRD/DB gap | Escalate OUT-05 | — |