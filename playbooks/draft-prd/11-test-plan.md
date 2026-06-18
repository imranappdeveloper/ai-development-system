# PB-draft-prd — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/prd.md` — 10 items |
| ENV-03 | `templates/prd/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `wf-feature-alpha` with approved INT + DISC |
| ENV-05 | System prompt 09 v1.0.0 |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT + DISC `feature` | PRD persisted; `prd_type: full`; CL-PRD pass |
| HT-02 | Approved INT `new_project` + DISC | PRD complete; recommend PB-bootstrap-project |
| HT-03 | Approved INT `enhancement` + DISC | `prd_type: lite` or `full` per scope; CL-PRD pass |
| HT-04 | H-PLAN revise | `revision: 1`; notes reflected |
| HT-05 | WF-PRD path, INT only | `discovery_gap: waiver`; PRD traces INT |

---

## Edge Tests (ET)

| ID | Tier | Input | Expected |
|----|------|-------|----------|
| ET-01 | P0 | No approved INT | Block; no PRD handoff as complete |
| ET-02 | P0 | `work_type: bugfix` INT | Block; redirect PB-draft-issue |
| ET-03 | P0 | Code in PRD body | CL-PRD #7 fail |
| ET-04 | P0 | Agent sets `decision: approve` | CL-PRD #10 fail |
| ET-05 | P0 | Chat-only mode | Full PRD + `persist: pending` |
| ET-06 | P1 | DISC missing, waiver in WR | `discovery_gap: waiver`; proceed |
| ET-07 | P1 | Routing matrix pasted in handoff | CL-PRD #4 / NEVER violation |

---

## Fixture Tests (FT)

| ID | Input | Expected |
|----|-------|----------|
| FT-01 | `fixtures/projects/wf-feature-alpha/` | PRD from INT+DISC; WR `plan_pending_review` |
| FT-02 | Golden `PRD-feature-001.md` rubric | All TP-prd sections present |
| FT-03 | Anti-patterns directory | Each fails ≥1 CL-PRD check |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-PRD manual rubric pass
```

**Status:** Manual rubric pass logged 2026-06-18 — promoted to `active` v1.0.0.