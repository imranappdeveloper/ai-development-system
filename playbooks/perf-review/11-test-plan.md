# PB-perf-review — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/perf-review.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-perf-alpha/` with CODE + PERF-BASE stubs + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-test-plan `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-perf-review row present |
| ENV-08 | `templates/review/template.md` available |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | CODE + PERF-BASE `WF-PERF` | PERF-REVIEW at perf-review path; CL-PERF-REVIEW pass |
| HT-02 | CODE only `WF-FEATURE` | Review with `baseline_gap: waiver` or not_applicable |
| HT-03 | CODE backend lane + DB hotspots | `perf_review_scope: database`; findings in §4 |
| HT-04 | CODE + PRD NFR soft | §3 targets from PRD when PERF-BASE absent |
| HT-05 | revise at H-VERIFY | `revision: 1`; notes in PERF-REVIEW |
| HT-06 | Golden fixture wf-perf-alpha | Output matches PERF-REVIEW-perf-001 structure |
| HT-07 | Multi-lane CODE refs | Hotspots from all linked CODE paths |
| HT-08 | Partial scope via `target_hotspot_path` | Subset §5; deferred in §1.2 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No CODE in WR | Block; no complete handoff |
| ET-02 | PERF-REVIEW already H-VERIFY approved | Block unless `mode: revise` |
| ET-03 | Agent runs k6 | CL-PERF-REVIEW #5 fail |
| ET-04 | §6 populated with p95 metrics | CL-PERF-REVIEW #5 fail |
| ET-05 | Agent `decision: approve` on H-VERIFY | CL-PERF-REVIEW #10 fail |
| ET-06 | Chat-only mode | Full PERF-REVIEW + `persist: pending` |
| ET-07 | Agent patches source file | CL-PERF-REVIEW #9 fail |
| ET-08 | Finding without CODE path | CL-PERF-REVIEW #2 fail |
| ET-09 | Test-plan gate not PASS | Block; cite prerequisite |
| ET-10 | WF-PERF without PERF-BASE and no waiver | Block or `baseline_gap: missing` in handoff |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-perf-alpha/work/implement/backend/WR-PERF-ALPHA.md` | CODE stub resolvable |
| FT-02 | `wf-perf-alpha/work/performance/WR-PERF-ALPHA.md` | PERF-BASE stub resolvable |
| FT-03 | `wf-perf-alpha/work/WR-PERF-ALPHA.md` | CODE + PERF-BASE refs present |
| FT-04 | Anti-pattern `PERF-REVIEW-run-benchmarks.md` | Manual rubric flags CL #5 |
| FT-05 | Anti-pattern `PERF-REVIEW-no-code-grounding.md` | Manual rubric flags CL #2 |
| FT-06 | Anti-pattern `PERF-REVIEW-self-approved.md` | Manual rubric flags CL #10 |
| FT-07 | Golden `PERF-REVIEW-perf-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-PERF-REVIEW manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|---------------------|
| HT suite | pass (documentation rubric) |
| ET(P0) suite | pass (documentation rubric) |
| FT suite | pass (fixtures present) |
| CL-PERF-REVIEW rubric | pass |
| 10-review score | pass (74) |
| Automated agent RT | pending |

**Verdict:** PASS for `draft` spec complete — `active` blocked until automated RT + upstream quality-chain promotion.