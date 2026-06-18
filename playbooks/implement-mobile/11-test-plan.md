# PB-implement-mobile — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/implement-mobile.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha-mobile/` with ISS + UIUX stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-implement-frontend `test-runs/latest-gate.md` VERDICT PASS (sequential gate) |
| ENV-07 | `routing-matrix.yaml` PB-implement-mobile row present |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | ISS-MOB-001 + UIUX + API `WF-FEATURE` | CODE at lane path; CL-IMPLEMENT-MOBILE pass |
| HT-02 | Single ISS `WF-BUGFIX` H-PLAN | Screen fix; §6 tests documented |
| HT-03 | Navigation ISS + UIUX linked | §5 Platform & Navigation populated; CL pass |
| HT-04 | UIUX-only ISS (no API data-fetch) | `implement_scope: native_screens`; CL pass |
| HT-05 | H-IMPLEMENT revise | `revision: 1`; notes in CODE |
| HT-06 | Golden fixture wf-feature-alpha-mobile | Output matches CODE-mobile-001 structure |
| HT-07 | UIUX absent with `uiux_gap: waiver` | CODE produced; screens from ISS |
| HT-08 | Partial ISS via `target_issue_id` | Subset in §3; deferred ISS in §8 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No ISS linked | Block; no complete handoff |
| ET-02 | CODE already H-IMPLEMENT approved | Block unless `mode: revise` |
| ET-03 | Empty §6 Testing Notes | CL-IMPLEMENT-MOBILE #5 fail |
| ET-04 | App store submit command in output | CL-IMPLEMENT-MOBILE #6 fail |
| ET-05 | Agent `decision: approve` | CL-IMPLEMENT-MOBILE #10 fail |
| ET-06 | Chat-only mode | Full CODE + `persist: pending` |
| ET-07 | Backend file in §4 | CL-IMPLEMENT-MOBILE #9 fail |
| ET-08 | Missing ISS ID for file change | CL-IMPLEMENT-MOBILE #2 fail |
| ET-09 | UIUX missing without waiver | `uiux_gap: missing`; flag in handoff |
| ET-10 | API missing for data-fetch ISS | `api_gap: missing`; §5 notes gap |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha-mobile/work/issues/ISS-MOB-001.md` | ISS stub resolvable |
| FT-02 | `wf-feature-alpha-mobile/work/uiux/WR-FEATURE-ALPHA-MOBILE.md` | UIUX stub resolvable |
| FT-03 | `wf-feature-alpha-mobile/work/WR-FEATURE-ALPHA-MOBILE.md` | ISS + UIUX artifact refs present |
| FT-04 | `wf-feature-alpha-mobile/work/implement/mobile/` | Output directory exists |
| FT-05 | Anti-pattern `CODE-app-store-submit.md` | Manual rubric flags CL #6 |
| FT-06 | Anti-pattern `CODE-skip-tests.md` | Manual rubric flags CL #5 |
| FT-07 | Anti-pattern `CODE-self-approved.md` | Manual rubric flags CL #10 |
| FT-08 | Golden `CODE-mobile-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-IMPLEMENT-MOBILE manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (8/8) |
| CL-IMPLEMENT-MOBILE rubric | pass |
| 10-review score ≥ 72 | pass (74) |

**Status:** Draft complete — `status: draft` retained pending PB-implement-frontend sequential gate and `test-runs/latest-gate.md` evidence.