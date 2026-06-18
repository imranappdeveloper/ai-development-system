# PB-implement-frontend — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/implement-frontend.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with ISS + UIUX stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-implement-backend `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-implement-frontend row present |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | ISS-FE-001 + UIUX + API `WF-FEATURE` | CODE at lane path; CL-IMPLEMENT-FRONTEND pass |
| HT-02 | Single ISS `WF-BUGFIX` H-PLAN | Component fix; §6 tests documented |
| HT-03 | Screen ISS + UIUX linked | §5 Accessibility populated; CL pass |
| HT-04 | Component-only ISS (no new page) | `implement_scope: components`; CL pass |
| HT-05 | H-IMPLEMENT revise | `revision: 1`; notes in CODE |
| HT-06 | Golden fixture wf-feature-alpha | Output matches CODE-frontend-001 structure |
| HT-07 | UIUX absent with `uiux_gap: waiver` | CODE produced; screens from ISS |
| HT-08 | Partial ISS via `target_issue_id` | Subset in §3; deferred ISS in §8 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No ISS linked | Block; no complete handoff |
| ET-02 | CODE already H-IMPLEMENT approved | Block unless `mode: revise` |
| ET-03 | Empty §6 Testing Notes | CL-IMPLEMENT-FRONTEND #5 fail |
| ET-04 | Deploy command in output | CL-IMPLEMENT-FRONTEND #6 fail |
| ET-05 | Agent `decision: approve` | CL-IMPLEMENT-FRONTEND #10 fail |
| ET-06 | Chat-only mode | Full CODE + `persist: pending` |
| ET-07 | Backend file in §4 | CL-IMPLEMENT-FRONTEND #9 fail |
| ET-08 | Missing ISS ID for file change | CL-IMPLEMENT-FRONTEND #2 fail |
| ET-09 | UIUX missing without waiver | `uiux_gap: missing`; flag in handoff |
| ET-10 | API missing for client ISS | `api_gap: missing`; §7 notes gap |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/issues/ISS-FE-001.md` | ISS stub resolvable |
| FT-02 | `wf-feature-alpha/work/uiux/WR-FEATURE-ALPHA.md` | UIUX stub resolvable |
| FT-03 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | ISS + UIUX artifact refs present |
| FT-04 | `wf-feature-alpha/work/implement/frontend/` | Output directory exists |
| FT-05 | Anti-pattern `CODE-deploy-without-gate.md` | Manual rubric flags CL #6 |
| FT-06 | Anti-pattern `CODE-skip-tests.md` | Manual rubric flags CL #5 |
| FT-07 | Anti-pattern `CODE-self-approved.md` | Manual rubric flags CL #10 |
| FT-08 | Golden `CODE-frontend-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-IMPLEMENT-FRONTEND manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (8/8) |
| CL-IMPLEMENT-FRONTEND rubric | pass |
| 10-review score ≥ 72 | pass (75) |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.