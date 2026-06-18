# PB-decompose-issues — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Overview

Nine-step linear workflow: verify PRD entry → load context → analyze coverage → assign lanes → document ISS-* → validate → hand off at H-DECOMPOSE.

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-DECOMP, PRD path from WR |
| 2 | LOAD | Read PRD + ARCH/API/DB/UIUX (soft) + CONTEXT slice; set `decompose_scope` |
| 3 | ANALYZE | Map FR/NFR and user stories to implementable units |
| 4 | LANE | Assign `lane` and `issue_id` per unit (`ISS-BE-001`, `ISS-FE-001`, …) |
| 5 | DOC | Build each ISS-* per 04-io-contract; write decomposition manifest |
| 6 | PERSIST | Write `{project_root}/work/issues/{issue_id}.md`; update Work Record |
| 7 | VAL | CL-DECOMP (10 checks); recovery ≤3 attempts |
| 8 | HAND | Handoff package; **stop** — await H-DECOMPOSE |
| 9 | STOP | No downstream invoke until human approves |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> ANALYZE[3 ANALYZE]
    ANALYZE --> LANE[4 LANE]
    LANE --> DOC[5 DOC]
    DOC --> PERSIST[6 PERSIST]
    PERSIST --> VAL[7 CL-DECOMP]
    VAL --> HAND[8 HAND]
    HAND --> H[H-DECOMPOSE]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked PRD exist |
| EC-02 | PRD `status` approved at H-PLAN (or `human_waiver` documented in WR) |
| EC-03 | No prior ISS-* set with H-DECOMPOSE `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable when PRD requires it |
| EC-06 | WR records PRD path in `artifacts[]` |
| EC-07 | H-PLAN `approve` on PRD recorded in WR `approvals[]` |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 ISS-* files persisted (or `persist: pending` with human ack) |
| XC-02 | CL-DECOMP `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-DECOMPOSE`, `decision: pending` |
| XC-04 | WR `status: decompose_pending_review` |

---

## Human Gate — H-DECOMPOSE

| Field | Rule |
|-------|------|
| gate_id | `H-DECOMPOSE` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: decompose_approved`; may recommend PB-implement-backend or other lane child |
| On revise | Re-enter LOAD with `human_revise_notes`; increment issue `revision` |
| On reject | WR `status: decompose_rejected` |

**Binding on approve:** issue set, AC testability, and lane assignments marked sufficient for Implement.

---

## Revise Loop

Human `revise` at H-DECOMPOSE → re-enter **LOAD** → update affected ISS-* → full CL-DECOMP → handoff again.

---

## Recovery

CL-DECOMP fail → fix per `checklists/decompose.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| decompose_scope / signal | Primary | Alternate |
|--------------------------|---------|-----------|
| Backend-critical path first | PB-implement-backend | PB-implement-frontend |
| Frontend-only surface | PB-implement-frontend | — |
| Mobile client in scope | PB-implement-mobile | PB-implement-backend |
| Infra / pipeline work | PB-implement-devops | PB-implement-backend |
| `prd_alignment: requires_prd_revise` | PB-draft-prd | — |
| Single backend issue only | PB-implement-backend | — |

**Never recommend:** `PB-implement` umbrella — route to lane child per STD-NAMING-001.