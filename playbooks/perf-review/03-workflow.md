# PB-perf-review — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 03-workflow |

---

## Overview

Ten-step linear workflow: verify entry → load CODE + PERF-BASE → extract scope → compare targets → analyze hotspots → document findings → persist review → validate → hand off. **Never run benchmarks.**

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-PERF-REVIEW, artifact paths from WR |
| 2 | LOAD | Read CODE + PERF-BASE (soft) + WR + CONTEXT slice; set `perf_review_scope` |
| 3 | SCOPE | Extract hot paths from CODE §4; NFR/baseline targets from PERF-BASE |
| 4 | COMPARE | Build §3 targets table; `baseline_alignment` when PERF-BASE present |
| 5 | ANALYZE | Static review of changed modules — queries, loops, I/O, caching |
| 6 | FIND | Populate §4 findings + §5 hotspot inventory with severity |
| 7 | DOC | Build PERF-REVIEW per OUT-01; §6 `review_only` placeholder |
| 8 | PERSIST | Write `work/perf-review/{work_id}.md`; update WR |
| 9 | VAL | CL-PERF-REVIEW (10 checks); recovery ≤3 attempts |
| 10 | HAND | Handoff package; **stop** — H-VERIFY pending |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> SCOPE[3 SCOPE]
    SCOPE --> COMPARE[4 COMPARE]
    COMPARE --> ANALYZE[5 ANALYZE]
    ANALYZE --> FIND[6 FIND]
    FIND --> DOC[7 DOC]
    DOC --> PERSIST[8 PERSIST]
    PERSIST --> VAL[9 CL-PERF-REVIEW]
    VAL --> HAND[10 HAND]
    HAND --> STOP[STOP — no benchmarks]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-ENT-01 | `work_id` and resolvable `project_root` from WR |
| EC-ENT-02 | `workflow_id` in INDEX.md |
| EC-ENT-03 | CODE linked in WR `artifacts[]` |
| EC-ENT-04 | H-IMPLEMENT approved when CODE present (soft) |
| EC-ENT-05 | PERF-BASE linked for WF-PERF (soft — waiver allowed) |
| EC-ENT-06 | No prior PERF-REVIEW with H-VERIFY `approve` unless `mode: revise` |
| EC-ENT-07 | WR records CODE path in `artifacts[]` |
| EC-ENT-08 | PB-test-plan gate PASS documented (prerequisite) |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 PERF-REVIEW persisted at `work/perf-review/{work_id}.md` |
| XC-02 | CL-PERF-REVIEW `result: pass` |
| XC-03 | OUT-04 handoff includes H-VERIFY `decision: pending` |
| XC-04 | WR `status: perf_review_pending` |
| XC-05 | §6 Benchmark Evidence empty or `review_only — deferred to human/PB-verify` |
| XC-06 | Every §4 finding traces to CODE §4 path |
| XC-07 | No load-test commands run by agent |

---

## Human Gate — H-VERIFY

| Field | Rule |
|-------|------|
| gate_id | `H-VERIFY` |
| Agent sets | `decision: pending` |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR notes perf review approved; may invoke PB-prepare-release |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: perf_review_rejected` |

**Binding on handoff:** CODE-grounded findings; no benchmark evidence; blockers documented with required actions.

---

## Revise Loop

Human `revise` → re-enter **LOAD** → increment `revision` → full CL-PERF-REVIEW → handoff again.

---

## Recovery

CL-PERF-REVIEW fail → fix per `checklists/perf-review.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| PERF-REVIEW complete, no blockers | PB-prepare-release | PB-draft-doc-update |
| `code_alignment: requires_code_revise` | PB-implement-* (lane) | — |
| `baseline_alignment: requires_baseline_revise` | PB-perf-baseline | — |
| Blockers present | Human revise → PB-implement-* | — |