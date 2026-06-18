# PB-verify — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/verify.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with TEST-PLAN + TEST-GEN + CODE stubs |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `spec_version: 1.0.0` |
| ENV-06 | PB-test-generate `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-verify row `status: active` |
| ENV-08 | `templates/testing/template.md` available |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | TEST-PLAN + TEST-GEN + CODE `WF-FEATURE` | TEST-RPT at evidence path; CL-VERIFY pass |
| HT-02 | TEST-PLAN + TEST-GEN single ISS `WF-BUGFIX` | Narrow execution; reproduction TC results in §3.2 |
| HT-03 | Contract layer TC-* + generated contract tests | §9.1 includes contract command; TC-* pass/fail mapped |
| HT-04 | `WF-SECURITY` security TC-* | Security test run results in §5 — no prod scan |
| HT-05 | `mode: revise` after H-VERIFY revise | `revision: 1`; notes in TEST-RPT |
| HT-06 | Golden fixture wf-feature-alpha | Output matches TEST-RPT-feature-001 structure |
| HT-07 | CODE absent with `code_gap: waiver` | TEST-RPT from TEST-PLAN + TEST-GEN only |
| HT-08 | Partial ISS via `target_issue_id` | Subset TC-* executed; rest deferred in §1.2 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No TEST-PLAN linked | Block; no complete handoff |
| ET-02 | No TEST-GEN linked | Block; recommend PB-test-generate |
| ET-03 | Test-generate gate not PASS | Block; cite prerequisite |
| ET-04 | Agent skips execution, claims pass | CL-VERIFY #6 fail |
| ET-05 | Agent `decision: approve` on H-VERIFY | CL-VERIFY #9 fail |
| ET-06 | Chat-only mode | Full TEST-RPT + `persist: pending` |
| ET-07 | §9 populated but no commands run | CL-VERIFY #6 fail |
| ET-08 | Missing TEST-PLAN path in frontmatter | CL-VERIFY #2 fail |
| ET-09 | Agent generates new test files | CL-VERIFY #7 fail |
| ET-10 | Agent claims gate passed | CL-VERIFY #9 fail |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/testing/plan/WR-FEATURE-ALPHA.md` | TEST-PLAN stub resolvable |
| FT-02 | `wf-feature-alpha/work/testing/generate/WR-FEATURE-ALPHA.md` | TEST-GEN stub resolvable |
| FT-03 | `wf-feature-alpha/work/implement/backend/WR-FEATURE-ALPHA.md` | CODE stub resolvable |
| FT-04 | Anti-pattern `TEST-RPT-skip-execution.md` | Manual rubric flags CL #6 |
| FT-05 | Anti-pattern `TEST-RPT-no-plan-link.md` | Manual rubric flags CL #2 |
| FT-06 | Anti-pattern `TEST-RPT-self-approved.md` | Manual rubric flags CL #9 |
| FT-07 | Golden `TEST-RPT-feature-001.md` | §9 evidence + H-VERIFY pending block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-VERIFY manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-VERIFY rubric | pass |
| 10-review score ≥ 72 | pass (76) |
| Test-generate prerequisite PASS | pass |
| verify-skill-spec.sh | pass (FAIL=0) |

## Promotion evidence log

| HT ID | Result | Notes |
|-------|--------|-------|
| HT-01 | pass | TEST-RPT evidence path + CL-VERIFY |
| HT-06 | pass | Golden structure match |
| HT-08 | pass | Partial ISS scope documented |

**Status:** Promoted to `status: active` — `test-runs/latest-gate.md` VERDICT PASS recorded.