# CL-BOOTST — Bootstrap Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-BOOTST |
| version | 1.0.0 |
| status | active |
| consumer | PB-bootstrap-project |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved PRD linked in WR; `workflow_id` WF-PROJECT-NEW or documented waiver |
| 2 | `scaffold_scope` valid | One of: minimal, standard, full — matches PRD surface |
| 3 | PRD traceability | `upstream_prd_path` set; toolchain grounded in PRD/ARCH — no invented stack |
| 4 | Required scaffold sections | Summary, Directory Plan, Toolchain, Bootstrap Steps, File Manifest, References |
| 5 | No forbidden content | No application/handler/UI code, routing-matrix embed, or secrets |
| 6 | Actionable bootstrap steps | Each step has command or explicit human action — not vague |
| 7 | ARCH alignment | When ARCH linked, component names referenced — ARCH body not rewritten |
| 8 | Artifact path | Output at `work/scaffold/{work_id}.md` per ARTIFACT-REGISTRY |
| 9 | Work Record status | `scaffold_pending_review` before handoff; `artifacts[]` lists SCAFFOLD path |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed) | DOC | 3 |
| Missing PRD link | LOAD | 3 |
| Non-actionable bootstrap steps | DOC | 3 |
| Stack not grounded in PRD | ANALYZE | 3 |
| Irrecoverable PRD gap | Escalate OUT-05 | — |