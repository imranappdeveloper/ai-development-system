# CL-DIAGNO — Diagnosis Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DIAGNO |
| version | 1.0.0 |
| status | active |
| consumer | PB-diagnose-bug |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved INT linked; `work_type: bugfix` |
| 2 | `repro_status` valid | One of: confirmed, partial, blocked |
| 3 | INT traceability | `upstream_int_path` set; Symptoms/Reproduction cite INT repro signals |
| 4 | Required diagnosis sections | Summary, Symptoms, Reproduction, Hypotheses, Root Cause, Evidence, Fix Direction, References |
| 5 | No forbidden content | No patch/diff/fix code, routing-matrix embed, or secrets |
| 6 | Root cause stated | `root_cause_category` enum set with rationale (unknown allowed with next steps) |
| 7 | Evidence table | ≥1 evidence row with source and conclusion |
| 8 | Artifact path | Output at `work/diagnose/{work_id}.md` per ARTIFACT-REGISTRY |
| 9 | Work Record status | `diagnose_pending_review` before handoff; `artifacts[]` lists DIAG path |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (fix code / routing embed) | DOC | 3 |
| Missing INT link | LOAD | 3 |
| Insufficient evidence | ANALYZE | 3 |
| Blocked reproduction | ANALYZE | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |