# PB-draft-database — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/database.md` — 10 items, `status: draft` |
| ENV-03 | `templates/database/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `fixtures/projects/wf-feature-alpha/` with approved ARCH + PRD + WR |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved ARCH `WF-FEATURE` + PRD | DB persisted; `change_type: new_schema`; CL-DATABASE pass |
| HT-02 | Approved ARCH `WF-REFACTOR` | `change_type: migration`; §5 steps + rollback present |
| HT-03 | Approved ARCH `WF-PERF` | `change_type: optimization`; §8 hot paths documented |
| HT-04 | Approved ARCH `WF-SECURITY` | `change_type: migration`; §7 PII mapping present |
| HT-05 | H-PLAN revise | `revision: 1`; notes reflected in DB |
| HT-06 | Golden fixture wf-feature-alpha | Output matches DB-feature-001 structure |
| HT-07 | PRD absent with `prd_gap: waiver` | DB produced; `prd_alignment: not_applicable` |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved ARCH | Block; no DB handoff as complete |
| ET-02 | DB already approved | Block unless `mode: revise` |
| ET-03 | DDL/SQL in DB body | CL-DATABASE #7 fail |
| ET-04 | Missing ARCH link §1.3 | CL-DATABASE #4 fail |
| ET-05 | Agent `decision: approve` | CL-DATABASE #10 fail |
| ET-06 | Chat-only mode | Full DB + `persist: pending` |
| ET-07 | `change_type: migration` without §5 | CL-DATABASE #8 fail |
| ET-08 | ARCH underspecified | `database_confidence: low`; open questions listed |
| ET-09 | PRD missing without waiver | `prd_gap: missing`; entities from ARCH only |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/architecture/` | ARCH approved; path resolvable |
| FT-02 | `wf-feature-alpha/work/prd/` | PRD approved stub present |
| FT-03 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | ARCH + PRD artifact refs present |
| FT-04 | Anti-pattern `DB-contains-sql.md` | Manual rubric flags CL-DATABASE #7 |
| FT-05 | Anti-pattern `DB-no-arch-link.md` | Manual rubric flags CL-DATABASE #4 |
| FT-06 | Anti-pattern `DB-self-approved.md` | Manual rubric flags CL-DATABASE #10 |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-DATABASE manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (7/7) |
| ET(P0) manual walkthrough | pass (9/9) |
| FT manual walkthrough | pass (6/6) |
| CL-DATABASE rubric | pass |
| 10-review score ≥ 72 | pass (73) |

**Status:** Sequential gate PASS — `test-runs/latest-gate.md`; `registry.yaml` `active`.