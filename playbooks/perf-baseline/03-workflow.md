# PB-perf-baseline — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Overview

Nine-step linear workflow: verify entry → load context → scope → define targets/SLOs → document measurement plan → persist → validate → hand off at H-PLAN. **Never execute load tests.**

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-PERF, upstream path from WR |
| 2 | LOAD | Read INT + soft artifacts + CONTEXT slice |
| 3 | SCOPE | Extract performance scope from INT; set `perf_scope` enum |
| 4 | TARGET | Build targets/SLO table with measurable thresholds |
| 5 | MEASURE | Document measurement plan — tools, environment, cadence — **plan only** |
| 6 | DOC | Build PERF-BASE per 04-io-contract |
| 7 | PERSIST | Write `{project_root}/work/performance/{work_id}.md`; update Work Record |
| 8 | VAL | CL-PERF (10 checks); recovery ≤3 attempts |
| 9 | HAND | Handoff package; **stop** — await H-PLAN |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> SCOPE[3 SCOPE]
    SCOPE --> TARGET[4 TARGET]
    TARGET --> MEASURE[5 MEASURE]
    MEASURE --> DOC[6 DOC]
    DOC --> PERSIST[7 PERSIST]
    PERSIST --> VAL[8 CL-PERF]
    VAL --> HAND[9 HAND]
    HAND --> H[H-PLAN]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-ENT-01 | `work_id` and linked INT artifact exist |
| EC-ENT-02 | H-INTAKE gate satisfied per routing-matrix |
| EC-ENT-03 | No prior PERF-BASE with H-PLAN `approve` unless `mode: revise` |
| EC-ENT-04 | `workflow_id` is WF-PERF or `work_type: performance` |
| EC-ENT-05 | `project_root` resolvable when required |
| EC-ENT-06 | WR records INT path in `artifacts[]` |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 persisted (or `persist: pending` with human ack) |
| XC-02 | CL-PERF `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-PLAN`, `decision: pending` |
| XC-04 | WR `status: perf_baseline_pending_review` |

---

## Human Gate — H-PLAN

| Field | Rule |
|-------|------|
| gate_id | `H-PLAN` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR status advanced; may recommend `PB-implement` or `PB-perf-review` |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR status rejected; orchestrator recovery |

---

## Revise Loop

Human `revise` at H-PLAN → re-enter **LOAD** → update PERF-BASE → full CL-PERF → handoff again.

---

## Recovery

CL-PERF fail → fix per `checklists/perf.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| WF-PERF default — implement path | PB-implement | PB-implement-backend per lane |
| Baseline-only / review-first path | PB-perf-review | After CODE exists (Verify) |
| Upstream gap | PB-intake-classify | Human waiver |
| Wrong workflow | Block — cite EC-ENT-* | — |

---

## Sequential Gates (promotion)

| Prerequisite | Gate record | Required verdict |
|--------------|-------------|------------------|
| PB-intake-classify | `playbooks/intake-classify/test-runs/latest-gate.md` | VERDICT PASS |

Promotion chain documented in `test-runs/latest-gate.md` and `11-test-plan.md` ENV-06.