# PB-draft-api — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/api.md` — 10 items, `status: draft` |
| ENV-03 | `templates/api/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `fixtures/projects/wf-feature-alpha/` with approved ARCH + PRD + DB + WR |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-07 | PB-draft-database `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved ARCH `WF-FEATURE` + PRD + DB | API persisted; `change_type: new`; CL-API pass |
| HT-02 | Approved ARCH `WF-ENHANCEMENT` | `change_type: additive`; §3.3 versioning present |
| HT-03 | Approved ARCH `WF-REFACTOR` | `change_type: breaking`; §8 migration path present |
| HT-04 | Approved ARCH `WF-SECURITY` | Auth scopes explicit in §2; CL-API pass |
| HT-05 | H-PLAN revise | `revision: 1`; notes reflected in API |
| HT-06 | Golden fixture wf-feature-alpha | Output matches API-feature-001 structure |
| HT-07 | PRD absent with `prd_gap: waiver` | API produced; `prd_alignment: not_applicable` |
| HT-08 | DB absent with `db_gap: waiver` | API produced; models from ARCH; `db_alignment: not_applicable` |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved ARCH | Block; no API handoff as complete |
| ET-02 | API already approved | Block unless `mode: revise` |
| ET-03 | Handler code in API body | CL-API #8 fail |
| ET-04 | Missing ARCH link in alignment block | CL-API #4 fail |
| ET-05 | Agent `decision: approve` | CL-API #10 fail |
| ET-06 | Chat-only mode | Full API + `persist: pending` |
| ET-07 | `change_type: breaking` without §8 | CL-API #9 fail |
| ET-08 | ARCH underspecified | `api_confidence: low`; open questions listed |
| ET-09 | PRD missing without waiver | `prd_gap: missing`; operations from ARCH only |
| ET-10 | DB missing without waiver | `db_gap: missing`; models from ARCH only |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/architecture/` | ARCH approved; path resolvable |
| FT-02 | `wf-feature-alpha/work/prd/` | PRD approved stub present |
| FT-03 | `wf-feature-alpha/work/database/` | DB approved stub present |
| FT-04 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | ARCH + PRD + DB artifact refs present |
| FT-05 | Anti-pattern `API-contains-code.md` | Manual rubric flags CL-API #8 |
| FT-06 | Anti-pattern `API-no-arch-link.md` | Manual rubric flags CL-API #4 |
| FT-07 | Anti-pattern `API-self-approved.md` | Manual rubric flags CL-API #10 |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-API manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-API rubric | pass |
| 10-review score ≥ 72 | pass (74) |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.