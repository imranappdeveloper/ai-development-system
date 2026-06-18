# CL-INTAKE — Intake Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-INTAKE |
| version | 1.0.0 |
| status | active |
| consumer | PB-intake-classify |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-INTAKE**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | `work_type` set | Set, or `low` confidence path with blockers + alternatives |
| 2 | `workflow_id` in INDEX | Exists in `{AI_DEV_OS_HOME}/INDEX.md` |
| 3 | `entry_mode` set | `new_project`, `existing_project`, or `normal` with evidence |
| 4 | `classification_rationale` | ≥2 sentences; medium confidence lists one rejected alternative |
| 5 | `problem_statement` | Present in INT body |
| 6 | Scope sections | `in_scope` and `out_of_scope` present |
| 7 | `recommended_next_artifacts` | Table with ≥1 row; template IDs only |
| 8 | No forbidden content | No PRD, discovery, issue, or code drafts in INT |
| 9 | Work Record status | `intake_pending_review` before handoff |
| 10 | Human approval | `gate_id: H-INTAKE`, `decision: pending` only |