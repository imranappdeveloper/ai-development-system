# PB-draft-architecture — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/architecture.md` — 10 items, `status: active` |
| ENV-03 | `templates/architecture/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `fixtures/projects/wf-feature-alpha/` with approved PRD + WR |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: active`, `spec_version: 1.0.0` |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved PRD `WF-FEATURE` | ARCH persisted; `architecture_type: delta`; CL-ARCH pass |
| HT-02 | Approved PRD `WF-PROJECT-NEW` | `architecture_type: greenfield`; §8 migration N/A or minimal |
| HT-03 | Approved PRD `WF-REFACTOR` | `architecture_type: delta`; §8 Migration present |
| HT-04 | H-PLAN revise | `revision: 1`; notes reflected in ARCH |
| HT-05 | PRD partial mismatch with CONTEXT | `prd_alignment: partial_mismatch`; risks documented |
| HT-06 | Golden fixture wf-feature-alpha | Output matches ARCH-feature-001 structure |

---

## Edge Tests (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved PRD | Block; no ARCH handoff as complete |
| ET-02 | ARCH already approved | Block unless `mode: revise` |
| ET-03 | Code snippet in ARCH | CL-ARCH #7 fail |
| ET-04 | Missing PRD link §1.3 | CL-ARCH #4 fail |
| ET-05 | Agent `decision: approve` | CL-ARCH #10 fail |
| ET-06 | Chat-only mode | Full ARCH + `persist: pending` |
| ET-07 | `work_type: bugfix` | Block; redirect PB-draft-issue |
| ET-08 | PRD underspecified | `architecture_confidence: low`; open questions listed |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/prd/` | PRD approved; path resolvable |
| FT-02 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | PRD artifact ref present |
| FT-03 | Anti-pattern `ARCH-contains-code.md` | Manual rubric flags CL-ARCH #7 |
| FT-04 | Anti-pattern `ARCH-no-prd-link.md` | Manual rubric flags CL-ARCH #4 |
| FT-05 | Anti-pattern `ARCH-self-approved.md` | Manual rubric flags CL-ARCH #10 |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-ARCH manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (6/6) |
| ET(P0) manual walkthrough | pass (8/8) |
| FT manual walkthrough | pass (5/5) |
| CL-ARCH rubric | pass |
| 10-review score ≥ 72 | pass (74) |

**Status:** Promotion criteria met — `registry.yaml` set to `active` v1.0.0. Automated RT suite execution tracked as P1 follow-up.