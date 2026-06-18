# CL-DRAFT — Draft Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DRAFT |
| version | 1.0.0 |
| status | active |
| consumer | PB-draft-feature / PB-draft-issue |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** for the applicable path before human handoff at **H-PLAN**.

---

## Path Selection

| Path | Skill | Output artifact | Primary entry |
|------|-------|-----------------|---------------|
| FEAT | PB-draft-feature | `work/feature/{work_id}.md` | DISC + H-FRAME |
| ISS | PB-draft-issue | `work/issue/{work_id}.md` | INT + H-INTAKE |

Apply checks marked **FEAT**, **ISS**, or **Both** per invoked skill.

---

## Checks

| # | Check | Path | Pass criterion |
|---|-------|------|----------------|
| 1 | Entry criteria | FEAT | H-FRAME approved on linked DISC; no prior FEAT H-PLAN `approve` unless `mode: revise` |
| 2 | Entry criteria | ISS | H-INTAKE approved INT linked; `work_type: bugfix` or routing-authorized narrow issue path |
| 3 | Enums and workflow | Both | FEAT: `feat_type` and `feat_scope` valid; ISS: `issue_lane` valid; `workflow_id` in INDEX |
| 4 | Upstream traceability | FEAT | `upstream_disc_path` set; §2 `upstream_traceability` block populated |
| 5 | Upstream traceability | ISS | `upstream_int_path` set; `upstream_diag_path` when DIAG linked in WR |
| 6 | Scope and sections | FEAT | Summary, Upstream Context, Scope, User-Visible Behavior, ACs, References, Human Approval — grounded in DISC |
| 7 | Scope and sections | ISS | Summary, Reproduction, ACs, Scope (in/out), References, Human Approval — grounded in INT/DIAG |
| 8 | No forbidden content | Both | No code, routing-matrix embed, or secrets; FEAT: no architecture/API/DB detail or ISS decomposition; ISS: no implementation code |
| 9 | Output path and WR status | Both | FEAT: `work/feature/{work_id}.md`; ISS: `work/issue/{work_id}.md`; WR `plan_pending_review`; `artifacts[]` lists output; every AC testable with verify method |
| 10 | Human approval | Both | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / arch / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Wrong artifact path | PERSIST | 3 |
| Untestable acceptance criteria | AC | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |