# PB-draft-feature — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Overview

Seven-step linear workflow: verify entry → load DISC → synthesize narrow slice → document → persist → validate → hand off at H-PLAN.

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-DRAFT, DISC path from WR |
| 2 | LOAD | Read DISC + CONTEXT slice; confirm H-FRAME approval |
| 3 | SYNTH | Map scope, behavior, ACs from DISC; set `feat_type` / `feat_scope` |
| 4 | DOC | Build FEAT per 04-io-contract — no architecture or issue slices |
| 5 | PERSIST | Write `{project_root}/work/feature/{work_id}.md`; update Work Record |
| 6 | VAL | CL-DRAFT FEAT-path checks; recovery ≤3 attempts |
| 7 | HAND | Handoff package; **stop** — await H-PLAN |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> SYNTH[3 SYNTH]
    SYNTH --> DOC[4 DOC]
    DOC --> PERSIST[5 PERSIST]
    PERSIST --> VAL[6 CL-DRAFT]
    VAL --> HAND[7 HAND]
    HAND --> H[H-PLAN]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked DISC exist |
| EC-02 | DISC `status` approved at H-FRAME |
| EC-03 | No prior FEAT with H-PLAN `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable when required |
| EC-06 | WR records DISC path in `artifacts[]` |
| EC-07 | Scope qualifies as narrow slice per DISC (not multi-epic) |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 persisted (or `persist: pending` with human ack) |
| XC-02 | CL-DRAFT `result: pass` (FEAT path) |
| XC-03 | OUT-04 handoff includes `gate_id: H-PLAN`, `decision: pending` |
| XC-04 | WR `status: plan_pending_review` |

---

## Human Gate — H-PLAN

| Field | Rule |
|-------|------|
| gate_id | `H-PLAN` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR status advanced; may recommend `PB-decompose-issues` or direct implement for single unit |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR status rejected; orchestrator recovery |

**Binding on approve:** in-scope behavior, non-goals, and ACs marked sufficient for implement or decompose.

---

## Revise Loop

Human `revise` at H-PLAN → re-enter **LOAD** → update FEAT → full CL-DRAFT → handoff again.

---

## Recovery

CL-DRAFT fail → fix per `checklists/draft.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| Default success | PB-decompose-issues | PB-implement when single unit (human decision) |
| Scope too large for FEAT | PB-draft-prd | Human redirect at H-PLAN |
| Upstream gap | PB-discovery-research | Human waiver |
| Wrong workflow | Block — cite EC-ENT-* | — |

Routing authority lives in orchestrator substrate — playbook outputs name candidates only.

---

## Sequential Gates (promotion)

| Prerequisite | Gate record | Required verdict |
|--------------|-------------|------------------|
| PB-discovery-research | `playbooks/discovery-research/test-runs/latest-gate.md` | VERDICT PASS |

Promotion chain documented in `test-runs/latest-gate.md` and `11-test-plan.md` ENV-06.