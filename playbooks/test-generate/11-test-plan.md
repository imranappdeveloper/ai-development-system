# PB-test-generate — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/test-generate.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with TEST-PLAN + CODE stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-test-plan `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-test-generate row present |
| ENV-08 | TEST-PLAN golden at `fixtures/.../testing/plan/WR-FEATURE-ALPHA.md` |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | TEST-PLAN + CODE `WF-FEATURE` | TEST-GEN at generate path; CL-TEST-GEN pass |
| HT-02 | TEST-PLAN + single ISS `WF-BUGFIX` | Narrow scope; reproduction test file in §3 |
| HT-03 | Contract layer TC-* + API linked | Contract test file in `tests/contract/` |
| HT-04 | `WF-SECURITY` security TC-* | Security test stub generated — no scan run |
| HT-05 | `mode: revise` | `revision: 1`; notes in TEST-GEN |
| HT-06 | Golden fixture wf-feature-alpha | Output matches TEST-GEN-feature-001 structure |
| HT-07 | CODE absent with `code_gap: waiver` | TEST-GEN from TEST-PLAN only |
| HT-08 | Partial ISS via `target_issue_id` | Subset TC-* generated; rest in §5 deferred |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No TEST-PLAN linked | Block; no complete handoff |
| ET-02 | TEST-PLAN gate not PASS | Block; cite prerequisite |
| ET-03 | Agent runs pytest | CL-TEST-GEN #6 fail |
| ET-04 | §6 populated with pass/fail | CL-TEST-GEN #6 fail |
| ET-05 | Agent `decision: approve` on H-VERIFY | CL-TEST-GEN #9 fail |
| ET-06 | Chat-only mode | Full TEST-GEN + `persist: pending` |
| ET-07 | TC-* missing from §3 and §5 | CL-TEST-GEN #3 fail |
| ET-08 | Catalog row without path | CL-TEST-GEN #5 fail |
| ET-09 | `created` file missing on disk | CL-TEST-GEN #5 fail |
| ET-10 | Agent claims verification complete | CL-TEST-GEN #9 fail |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/testing/plan/WR-FEATURE-ALPHA.md` | TEST-PLAN stub resolvable |
| FT-02 | `wf-feature-alpha/work/implement/backend/WR-FEATURE-ALPHA.md` | CODE stub resolvable |
| FT-03 | `wf-feature-alpha/work/testing/generate/` | Output directory exists |
| FT-04 | Anti-pattern `TEST-GEN-execute-tests.md` | Manual rubric flags CL #6 |
| FT-05 | Anti-pattern `TEST-GEN-no-file-paths.md` | Manual rubric flags CL #5 |
| FT-06 | Anti-pattern `TEST-GEN-self-approved.md` | Manual rubric flags CL #9 |
| FT-07 | Golden `TEST-GEN-feature-001.md` | §3 catalog + handoff block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-TEST-GEN manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-TEST-GEN rubric | pass |
| 10-review score ≥ 72 | pass (75) |
| Test-plan prerequisite PASS | pass |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.