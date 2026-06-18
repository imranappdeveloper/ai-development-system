# PB-draft-feature — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/draft.md` — 10 items (FEAT + ISS paths) |
| ENV-03 | `templates/feature/template.md` available (narrow subset reference) |
| ENV-04 | Fixture `wf-feat-narrow` with approved DISC + H-FRAME |
| ENV-05 | System prompt 09 v1.0.0 |
| ENV-06 | Prerequisite gate: `playbooks/discovery-research/test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved DISC `WF-FEATURE` narrow slice | FEAT persisted; `feat_scope: narrow_slice`; CL-DRAFT pass |
| HT-02 | Approved DISC `WF-ENHANCEMENT` | `feat_type: enhancement`; CL-DRAFT pass |
| HT-03 | H-PLAN revise | `revision: 1`; notes reflected |
| HT-04 | DISC recommends single vertical slice | FEAT complete; recommend PB-decompose-issues |
| HT-05 | feature-planner DM-01 routing signal | FEAT traces DISC; `prd_waived: true` in traceability |

---

## Edge Tests (ET)

| ID | Tier | Input | Expected |
|----|------|-------|----------|
| ET-01 | P0 | No approved DISC | Block; no FEAT handoff as complete |
| ET-02 | P0 | `work_type: bugfix` | Block; redirect PB-draft-issue |
| ET-03 | P0 | Code in FEAT body | CL-DRAFT #7 fail |
| ET-04 | P0 | Architecture section in FEAT | CL-DRAFT #7 fail |
| ET-05 | P0 | ISS decomposition table in FEAT | CL-DRAFT #7 fail |
| ET-06 | P0 | Agent sets `decision: approve` | CL-DRAFT #10 fail |
| ET-07 | P0 | Chat-only mode | Full FEAT + `persist: pending` |
| ET-08 | P1 | DISC partial alignment | `discovery_alignment: partial`; proceed with flag |
| ET-09 | P1 | Routing matrix pasted in handoff | CL-DRAFT #7 / NEVER violation |
| ET-10 | P1 | Multi-epic DISC scope | Block; recommend PB-draft-prd |

---

## Fixture Tests (FT)

| ID | Input | Expected |
|----|-------|----------|
| FT-01 | `fixtures/projects/wf-feat-narrow/` | FEAT from DISC; WR `plan_pending_review` |
| FT-02 | Golden `FEAT-notification-prefs-001.md` rubric | All required FEAT sections present |
| FT-03 | Anti-patterns directory | Each fails ≥1 CL-DRAFT check |

---

## Promotion Gate (planned → active)

```
Prerequisite: PB-discovery-research gate PASS
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-DRAFT manual rubric pass
```

## Promotion Evidence Log

| Date | Suite | Result | Notes |
|------|-------|--------|-------|
| 2026-06-18 | HT 5/5 | pass | Narrow slice WF-FEATURE + enhancement paths |
| 2026-06-18 | ET(P0) 7/7 | pass | Boundaries: no code, arch, issues, self-approve |
| 2026-06-18 | FT 3/3 | pass | wf-feat-narrow fixture + golden + anti-patterns |
| 2026-06-18 | CL-DRAFT FEAT rubric | pass | 10/10 checks |
| 2026-06-18 | verify-skill-spec.sh | pass | FAIL=0 |
| 2026-06-18 | Prerequisite PB-discovery-research | pass | latest-gate VERDICT PASS |

**Status:** Manual rubric pass logged 2026-06-18 — promoted to `active` v1.0.0.