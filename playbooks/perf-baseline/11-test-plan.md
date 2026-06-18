# PB-perf-baseline — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/perf.md` — 10 items, `status: active` |
| ENV-03 | Fixture `fixtures/projects/wf-perf-alpha/` |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: active`, `spec_version: 1.0.0` |
| ENV-06 | PB-intake-classify `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-perf-baseline row present |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT + WF-PERF | PERF-BASE complete; CL-PERF pass |
| HT-02 | PRD NFR soft upstream | Targets cite PRD; pass |
| HT-03 | H-PLAN revise | `revision: 1`; notes reflected |
| HT-04 | Golden fixture wf-perf-alpha | Matches PERF-BASE-perf-001.md structure |
| HT-05 | WR updated | `artifacts[]` lists PERF-BASE path |
| HT-06 | Handoff | `recommended_next_skill: PB-implement` |
| HT-07 | Alternate path | May recommend PB-perf-review when noted |
| HT-08 | `verify-skill-spec.sh` | FAIL=0 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No upstream INT | Block; no complete handoff |
| ET-02 | Artifact already approved | Block unless `mode: revise` |
| ET-03 | k6 script in PERF-BASE body | CL-PERF #5 fail |
| ET-04 | Missing INT link | CL-PERF #3 fail |
| ET-05 | Agent `decision: approve` | CL-PERF #10 fail |
| ET-06 | Chat-only mode | Full artifact + `persist: pending` |
| ET-07 | Wrong workflow | EC-ENT block |
| ET-08 | Routing matrix embed | CL-PERF #5 fail |
| ET-09 | Low confidence path | Open Questions populated |
| ET-10 | Sequential gate missing | Promotion blocked |
| ET-11 | Measurement plan with results | CL-PERF #7 fail |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-perf-alpha/work/intake/` | INT stub present |
| FT-02 | `wf-perf-alpha/work/WR-PERF-ALPHA.md` | WR with artifact refs |
| FT-03 | Anti-patterns (3) | Manual rubric flags checklist fails |
| FT-04 | Golden PERF-BASE-perf-001.md | Structure valid |
| FT-05 | `verify-skill-spec.sh` | FAIL=0 |
| FT-06 | `test-runs/latest-gate.md` | VERDICT PASS |
| FT-07 | routing-matrix `status: active` | Row aligned |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-PERF manual rubric pass AND 10-review ≥ 72
```

## Promotion Evidence Log (2026-06-18)

| Test | Result |
|------|--------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (11/11) |
| FT fixture walkthrough | pass (7/7) |
| CL-PERF rubric | pass |
| Golden PERF-BASE-perf-001.md | pass |
| Anti-patterns (3) | pass |
| Sequential gate latest-gate.md | pass |
| verify-skill-spec.sh | FAIL=0 |