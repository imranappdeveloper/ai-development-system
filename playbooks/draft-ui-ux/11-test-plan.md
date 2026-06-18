# PB-draft-ui-ux — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/uiux.md` — 10 items, `status: draft` |
| ENV-03 | `templates/ui-ux/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `fixtures/projects/wf-feature-alpha/` with approved PRD + ARCH + DISC + WR |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-07 | PB-draft-api `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved PRD `WF-FEATURE` + ARCH + DISC | UIUX persisted; `change_type: new`; CL-UIUX pass |
| HT-02 | Approved PRD `WF-ENHANCEMENT` | `change_type: additive`; delta screens only |
| HT-03 | Approved PRD `WF-ENHANCEMENT` redesign | `change_type: redesign`; §7 migration notes |
| HT-04 | Mobile-first PRD scope | Recommend PB-implement-mobile; §7 responsive |
| HT-05 | H-PLAN revise | `revision: 1`; notes reflected in UIUX |
| HT-06 | Golden fixture wf-feature-alpha | Output matches UIUX-feature-001 structure |
| HT-07 | ARCH absent with `arch_gap: waiver` | UIUX produced; `arch_alignment: not_applicable` |
| HT-08 | DISC absent with `disc_gap: waiver` | UIUX produced; personas from PRD only |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved PRD | Block; no UIUX handoff as complete |
| ET-02 | UIUX already approved | Block unless `mode: revise` |
| ET-03 | JSX/CSS in UIUX body | CL-UIUX #8 fail |
| ET-04 | Missing PRD link in alignment block | CL-UIUX #4 fail |
| ET-05 | Agent `decision: approve` | CL-UIUX #10 fail |
| ET-06 | Chat-only mode | Full UIUX + `persist: pending` |
| ET-07 | Empty §6 accessibility table | CL-UIUX #9 fail |
| ET-08 | PRD underspecified | `uiux_confidence: low`; open questions listed |
| ET-09 | ARCH missing without waiver | `arch_gap: missing`; screens from PRD only |
| ET-10 | DISC missing without waiver | `disc_gap: missing`; personas from PRD only |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/prd/` | PRD approved; path resolvable |
| FT-02 | `wf-feature-alpha/work/architecture/` | ARCH approved stub present |
| FT-03 | `wf-feature-alpha/work/discovery/` | DISC approved stub present |
| FT-04 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | PRD + ARCH + DISC artifact refs present |
| FT-05 | Anti-pattern `UIUX-contains-code.md` | Manual rubric flags CL-UIUX #8 |
| FT-06 | Anti-pattern `UIUX-no-prd-link.md` | Manual rubric flags CL-UIUX #4 |
| FT-07 | Anti-pattern `UIUX-self-approved.md` | Manual rubric flags CL-UIUX #10 |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-UIUX manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-UIUX rubric | pass |
| 10-review score ≥ 72 | pass (74) |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.