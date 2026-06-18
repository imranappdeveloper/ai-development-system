# PB-survey-codebase — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/survey.md` — 10 items, `status: active` |
| ENV-03 | Fixture project with approved INT + minimal CONTEXT |
| ENV-04 | System prompt 09 v1.0.0 |
| ENV-05 | Prerequisite `PB-intake-classify` or `PB-onboard-project` `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT `feature` + repo | SURVEY persisted; `survey_type: feature_context`; CL-SURVEY pass |
| HT-02 | Approved INT `existing_project` | `survey_type: existing_project`; module map ≥3 |
| HT-03 | `scan_focus` on `src/api/` | Manifest lists only allowlist paths under focus |
| HT-04 | `mode: refresh` | `revision: 1`; prior SURVEY referenced |
| HT-05 | Survey complete handoff | `recommended_next_skill: PB-discovery-research`; no gate block |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved INT | Block; no SURVEY handoff as complete |
| ET-02 | Path outside allowlist scanned | CL-SURVEY #4 fail |
| ET-03 | PRD content in SURVEY | CL-SURVEY #7 fail |
| ET-04 | Agent sets new work_type | CL-SURVEY #8 fail |
| ET-05 | H-FRAME block in SURVEY | CL-SURVEY #10 fail |
| ET-06 | Routing matrix excerpt in SURVEY | CL-SURVEY #10 fail |
| ET-07 | Chat-only mode | Full SURVEY + `persist: pending` |
| ET-08 | >40 files scanned | Stop at cap; §9 documents truncation |

---

## Fixture Tests (FT)

| ID | Input | Expected |
|----|-------|----------|
| FT-01 | `fixtures/inputs/approved-int-survey.md` + `fixtures/projects/minimal/` | Golden-aligned SURVEY structure |
| FT-02 | Golden `SURVEY-feature-001.md` | `scenario_id: HT-01`; §6.2 alignment block |
| FT-03 | Anti-pattern trio | Each violation maps to CL-SURVEY check |

---

## Promotion Gate (planned → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-SURVEY manual rubric pass
AND prerequisite PB-intake-classify or PB-onboard-project gate PASS
```

**Status:** Sequential gate PASS — `test-runs/latest-gate.md`; `status: active` (registry 1.0.0).

---

## Promotion Evidence Log

| Date | Suite | Tests | Result | Notes |
|------|-------|-------|--------|-------|
| 2026-06-18 | ENV | ENV-01–05 | PASS | CL-SURVEY active; fixtures present |
| 2026-06-18 | HT | HT-01–HT-05 | PASS | Golden SURVEY-feature-001; advisory handoff |
| 2026-06-18 | ET | ET-01–ET-08 | PASS | Anti-patterns; bounded scan caps |
| 2026-06-18 | FT | FT-01–FT-03 | PASS | Fixture INT + minimal CONTEXT |
| 2026-06-18 | CL-SURVEY | 10 checks | PASS | Mapped in 06-quality.md |
| 2026-06-18 | verify-skill-spec | structural | PASS | FAIL=0 |
| 2026-06-18 | Prerequisite gate | intake + onboard | PASS | Sequential promotion satisfied |