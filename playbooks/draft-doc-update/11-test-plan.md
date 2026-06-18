# PB-draft-doc-update — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/doc-update.md` — CL-DOC-UPDATE 10 items, `status: draft` |
| ENV-03 | `templates/doc-plan/template.md` aligned with OUT-01 |
| ENV-04 | Fixture `fixtures/projects/wf-docs-alpha/` with approved INT |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-07 | `routing-matrix.yaml` PB-draft-doc-update row present |
| ENV-08 | Quality-chain lifecycle position documented (after PB-perf-review); **INT-only fixtures sufficient** |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT `documentation` WF-DOCS | DOC-PLAN persisted; `doc_plan_type` set; CL-DOC-UPDATE pass |
| HT-02 | INT + PERF-REVIEW soft linked | §3 quality_chain_refs; DU-* from perf findings |
| HT-03 | `doc_plan_type: changelog` INT | §5 includes CHANGELOG DU-* row |
| HT-04 | H-PLAN revise | `revision: 1`; notes reflected |
| HT-05 | Golden fixture wf-docs-alpha | Output matches DOC-PLAN-docs-001 structure |
| HT-06 | `doc_scope: project_docs` | §4 inventory from `docs/**` listing |
| HT-07 | INT-only (no quality-chain) | `quality_chain_gap: waiver`; CL-DOC-UPDATE pass |
| HT-08 | `doc_plan_type: runbook` | §7 rollout includes review phase |

---

## Edge Tests (ET)

| ID | Tier | Input | Expected |
|----|------|-------|----------|
| ET-01 | P0 | No approved INT | Block; no complete handoff |
| ET-02 | P0 | DOC-PLAN already H-PLAN approved | Block unless `mode: revise` |
| ET-03 | P0 | Agent edits `docs/README.md` | CL-DOC-UPDATE #7 fail |
| ET-04 | P0 | Agent sets `decision: approve` | CL-DOC-UPDATE #10 fail |
| ET-05 | P0 | Chat-only mode | Full DOC-PLAN + `persist: pending` |
| ET-06 | P0 | `work_type: feature` INT | Block; redirect PB-draft-prd |
| ET-07 | P0 | §5 empty (no DU-* rows) | CL-DOC-UPDATE #6 fail |
| ET-08 | P1 | PERF-REVIEW handoff without INT | Block; INT required |
| ET-09 | P1 | Routing matrix pasted in handoff | CL-DOC-UPDATE #4 / NEVER violation |
| ET-10 | P1 | `doc_scope: os_docs` without INT signal | Block or downgrade per EC-OS-01 |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-docs-alpha/work/intake/WR-DOCS-ALPHA.md` | Approved INT `documentation` resolvable |
| FT-02 | `wf-docs-alpha/work/WR-DOCS-ALPHA.md` | INT ref present |
| FT-03 | `wf-docs-alpha/CONTEXT.md` | Project context stub present |
| FT-04 | Anti-pattern `DOC-PLAN-writes-docs.md` | Manual rubric flags CL #7 |
| FT-05 | Anti-pattern `DOC-PLAN-no-int-link.md` | Manual rubric flags CL #4 |
| FT-06 | Anti-pattern `DOC-PLAN-self-approved.md` | Manual rubric flags CL #10 |
| FT-07 | Golden `DOC-PLAN-docs-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-DOC-UPDATE manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|---------------------|
| HT suite | pass (documentation rubric) |
| ET(P0) suite | pass (documentation rubric) |
| FT suite | pass (fixtures present) |
| CL-DOC-UPDATE rubric | pass |
| 10-review score | pass (88) |
| Automated agent RT | pending |

**Verdict:** PASS for `draft` spec complete — `active` blocked until automated RT execution.