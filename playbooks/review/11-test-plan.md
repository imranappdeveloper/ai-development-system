# PB-review — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/review.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with CODE stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-test-plan `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-review row present |
| ENV-08 | `templates/review/template.md` available |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | CODE + ISS `WF-FEATURE` | REVIEW at review path; CL-REVIEW pass |
| HT-02 | CODE + single ISS `WF-BUGFIX` | Narrow scope; §4 AC rows for single issue |
| HT-03 | CODE + PRD + TEST-PLAN linked | §1.3 references plan; chain note present |
| HT-04 | `WF-SECURITY` + SEC-ASSESS soft | §3 STD-SEC-001 row evaluated |
| HT-05 | revise at H-VERIFY soft | `revision: 1`; notes in REVIEW |
| HT-06 | Golden fixture wf-feature-alpha | Output matches REVIEW-feature-001 structure |
| HT-07 | Multiple CODE lanes BE+FE | All paths in `upstream_code_paths` |
| HT-08 | P0 blocker documented | `recommendation: reject`; B- finding in §5.1 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No CODE linked | Block; no complete handoff |
| ET-02 | REVIEW already H-VERIFY approved | Block unless `mode: revise` |
| ET-03 | Agent modifies source file | CL-REVIEW #9 fail |
| ET-04 | Agent runs pytest | CL-REVIEW #9 fail |
| ET-05 | Agent `decision: approve` on H-VERIFY | CL-REVIEW #10 fail |
| ET-06 | Chat-only mode | Full REVIEW + `persist: pending` |
| ET-07 | AC without §4 row | CL-REVIEW #2 fail |
| ET-08 | Test-plan gate not PASS | Block soft; cite prerequisite |
| ET-09 | PRD/ISS both missing | `review_confidence: low` or block |
| ET-10 | §3 standards row blank | CL-REVIEW #5 fail |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/implement/backend/WR-FEATURE-ALPHA.md` | CODE stub resolvable |
| FT-02 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | CODE + ISS refs present |
| FT-03 | `wf-feature-alpha/work/review/` | Output directory exists |
| FT-04 | Anti-pattern `REVIEW-self-approved.md` | Manual rubric flags CL #10 |
| FT-05 | Anti-pattern `REVIEW-modifies-code.md` | Manual rubric flags CL #9 |
| FT-06 | Anti-pattern `REVIEW-no-ac-assessment.md` | Manual rubric flags CL #2 |
| FT-07 | Golden `REVIEW-feature-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-REVIEW manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-REVIEW rubric | pass |
| 10-review score ≥ 72 | pass (75) |
| PB-test-plan prerequisite PASS | pass |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and PB-test-generate chain authoring.