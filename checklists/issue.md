# CL-ISSUE — Bugfix Issue Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-ISSUE |
| version | 1.0.0 |
| status | active |
| consumer | PB-draft-issue |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved INT linked; `work_type: bugfix`; `workflow_id: WF-BUGFIX` |
| 2 | `issue_lane` valid | One of: backend, frontend, mobile, devops, unspecified — with rationale if unspecified |
| 3 | INT traceability | `upstream_int_path` set; repro steps grounded in INT |
| 4 | DIAG alignment | When DIAG linked in WR, `upstream_diag_path` set and root cause reflected in Summary/AC |
| 5 | Required issue sections | Summary, Reproduction, Acceptance Criteria (testable), Scope (in/out), References |
| 6 | No forbidden content | No implementation code, routing-matrix embed, duplicated INT/DIAG body, or secrets |
| 7 | Singular artifact path | Output at `work/issue/{work_id}.md` — not `work/issues/` plural |
| 8 | Testable acceptance criteria | Every AC row has `verify` method; regression AC when DIAG indicates regression |
| 9 | Work Record status | `plan_pending_review` before handoff; `artifacts[]` lists ISS path |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Wrong artifact path (plural issues/) | PERSIST | 3 |
| Untestable acceptance criteria | AC | 3 |
| Irrecoverable repro gap | Escalate OUT-05 | — |