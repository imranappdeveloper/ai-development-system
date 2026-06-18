# PB-test-plan — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/test-plan.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with CODE stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-implement-devops `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-test-plan row present |
| ENV-08 | `templates/testing/template.md` available |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | CODE + PRD + ISS `WF-FEATURE` | TEST-PLAN at plan path; CL-TEST-PLAN pass |
| HT-02 | CODE + single ISS `WF-BUGFIX` | Narrow scope; reproduction TC in §3 |
| HT-03 | CODE with contract layer + API linked | §2.1 contract=yes; TC-* for API ops |
| HT-04 | `WF-SECURITY` + SEC-ASSESS soft | §5 security checks planned — no scan run |
| HT-05 | revise_plan at H-VERIFY soft | `revision: 1`; notes in TEST-PLAN |
| HT-06 | Golden fixture wf-feature-alpha | Output matches TEST-PLAN-feature-001 structure |
| HT-07 | CODE absent with `code_gap: waiver` | TEST-PLAN from PRD/ISS only |
| HT-08 | Partial ISS via `target_issue_id` | Subset AC mapped; deferred in §1.2 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No CODE and no waiver | Block; no complete handoff |
| ET-02 | TEST-PLAN already H-VERIFY approved | Block unless `mode: revise` |
| ET-03 | Agent runs pytest | CL-TEST-PLAN #5 fail |
| ET-04 | §9 populated with pass/fail | CL-TEST-PLAN #5 fail |
| ET-05 | Agent `decision: approve` on H-VERIFY | CL-TEST-PLAN #10 fail |
| ET-06 | Chat-only mode | Full TEST-PLAN + `persist: pending` |
| ET-07 | Agent writes test .py file | CL-TEST-PLAN #9 fail |
| ET-08 | AC without TC-* | CL-TEST-PLAN #2 fail |
| ET-09 | Devops gate not PASS | Block; cite prerequisite |
| ET-10 | PRD/ISS both missing without waiver | Block or `ac_gap: missing` in handoff |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/implement/backend/WR-FEATURE-ALPHA.md` | CODE stub resolvable |
| FT-02 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | CODE + ISS refs present |
| FT-03 | `wf-feature-alpha/work/testing/plan/` | Output directory exists |
| FT-04 | Anti-pattern `TEST-PLAN-execute-tests.md` | Manual rubric flags CL #5 |
| FT-05 | Anti-pattern `TEST-PLAN-no-ac-mapping.md` | Manual rubric flags CL #2 |
| FT-06 | Anti-pattern `TEST-PLAN-self-approved.md` | Manual rubric flags CL #10 |
| FT-07 | Golden `TEST-PLAN-feature-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-TEST-PLAN manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-TEST-PLAN rubric | pass |
| 10-review score ≥ 72 | pass (74) |
| Devops prerequisite PASS | pass |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.