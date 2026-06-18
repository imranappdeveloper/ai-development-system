# CL-DECOMP — Decompose Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DECOMP |
| version | 1.0.0 |
| status | draft |
| consumer | PB-decompose-issues |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-DECOMPOSE**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-PLAN approved PRD linked in Work Record; `workflow_id` ∈ supported set; no prior H-DECOMPOSE `approve` unless `mode: revise` |
| 2 | `decompose_scope` valid | One of: `single_lane`, `multi_lane`, `full_stack` — matches PRD surface and breakdown rationale |
| 3 | `workflow_id` in INDEX | Matches PRD `workflow_id` unless human revise notes override |
| 4 | PRD traceability | Every ISS-* §References lists PRD path; `prd_alignment.prd_path` populated on decomposition manifest |
| 5 | Lane assignment | Each ISS-* has `lane` ∈ {backend, frontend, mobile, devops} and `issue_id` matches `ISS-{LANE}-{SEQ}` pattern |
| 6 | Required issue sections | Summary, Acceptance Criteria (testable), Scope (in/out), Tags, References per issue contract |
| 7 | No forbidden content | No handler/UI implementation code, sprint ordering SSOT, duplicated PRD body, routing matrix embed, or secrets |
| 8 | Coverage completeness | Every PRD FR/NFR in scope maps to ≥1 ISS-* AC or documented `decompose_gap` in manifest |
| 9 | Work Record status | `decompose_pending_review` before handoff; `artifacts[]` lists all ISS-* paths |
| 10 | Human approval | `gate_id: H-DECOMPOSE`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / PRD duplication / routing embed) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Weak or untestable acceptance criteria | AC | 3 |
| Incomplete FR/NFR coverage | ANALYZE | 3 |
| Irrecoverable PRD gap | Escalate OUT-05 | — |