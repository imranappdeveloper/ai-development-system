# PB-decompose-issues — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/decompose.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with approved PRD + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: active`, `spec_version: 1.0.0` |
| ENV-06 | PB-draft-prd `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved PRD `WF-FEATURE` | ISS-BE-001 + ISS-FE-001; `decompose_scope: multi_lane`; CL-DECOMP pass |
| HT-02 | Approved PRD `WF-ENHANCEMENT` backend-only | `decompose_scope: single_lane`; one ISS-BE-* |
| HT-03 | PRD + ARCH + API + DB + UIUX soft linked | Lane hints in AC; CL-DECOMP pass |
| HT-04 | H-DECOMPOSE revise | `revision: 1`; notes reflected in ISS-* |
| HT-05 | Golden fixture wf-feature-alpha | Output matches DECOMPOSE-feature-001 structure |
| HT-06 | Manifest coverage map | All FR/NFR mapped or `decompose_gap` documented |
| HT-07 | WR updated | `artifacts[]` lists all ISS-*; `decompose_pending_review` |
| HT-08 | Handoff recommends lane child | `recommended_next_skill: PB-implement-backend` (not umbrella) |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved PRD | Block; no complete handoff |
| ET-02 | ISS-* already approved | Block unless `mode: revise` |
| ET-03 | Handler code in ISS-* body | CL-DECOMP #7 fail |
| ET-04 | Missing PRD link in References | CL-DECOMP #4 fail |
| ET-05 | Agent `decision: approve` | CL-DECOMP #10 fail |
| ET-06 | Chat-only mode | Full ISS-* + `persist: pending` |
| ET-07 | FR/NFR without mapping | CL-DECOMP #8 fail |
| ET-08 | PRD underspecified | `decompose_confidence: low`; gaps listed |
| ET-09 | `WF-BUGFIX` workflow | Block; route PB-draft-issue |
| ET-10 | Recommend PB-implement umbrella | EC-RT-01 fail; lane child only |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/prd/` | PRD approved stub present |
| FT-02 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | PRD artifact ref + H-PLAN approve |
| FT-03 | `wf-feature-alpha/work/issues/ISS-BE-001.md` | ISS stub resolvable |
| FT-04 | Anti-pattern `DECOMPOSE-contains-code.md` | Manual rubric flags CL-DECOMP #7 |
| FT-05 | Anti-pattern `DECOMPOSE-no-prd-link.md` | Manual rubric flags CL-DECOMP #4 |
| FT-06 | Anti-pattern `DECOMPOSE-self-approved.md` | Manual rubric flags CL-DECOMP #10 |
| FT-07 | `verify-skill-spec.sh` | FAIL=0 |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-DECOMP manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-DECOMP rubric | pass |
| 10-review score ≥ 72 | pass (74) |
| verify-skill-spec.sh | pass (FAIL=0) |

**Promotion evidence log:** HT 8/8 pass, ET 10/10 pass, FT 7/7 pass — recorded in `test-runs/latest-gate.md`.

**Status:** Active — `test-runs/latest-gate.md` VERDICT PASS.