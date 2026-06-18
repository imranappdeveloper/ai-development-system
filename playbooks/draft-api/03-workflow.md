# PB-draft-api — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 03-workflow |

---

## Overview

Nine-step linear workflow: verify ARCH entry → load context → model operations → document API → validate → hand off at H-PLAN.

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-API, ARCH path from WR |
| 2 | LOAD | Read ARCH + PRD (soft) + DB (soft) + CONTEXT slice; set `change_type` |
| 3 | MODEL | Operation catalog, request/response shapes |
| 4 | AUTH | Authentication, authorization, error model in §2–§3 |
| 5 | BREAK | Breaking changes & migration in §8 when applicable |
| 6 | DOC | Build API per TP-api; alignment blocks required |
| 7 | PERSIST | Write API; update Work Record |
| 8 | VAL | CL-API (10 checks); recovery ≤3 attempts |
| 9 | HAND | Handoff package; **stop** — await H-PLAN |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> MODEL[3 MODEL]
    MODEL --> AUTH[4 AUTH]
    AUTH --> BREAK[5 BREAK]
    BREAK --> DOC[6 DOC]
    DOC --> PERSIST[7 PERSIST]
    PERSIST --> VAL[8 CL-API]
    VAL --> HAND[9 HAND]
    HAND --> H[H-PLAN]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked ARCH exist |
| EC-02 | ARCH `status` approved at H-PLAN (or `human_waiver` documented in WR) |
| EC-03 | No prior API with H-PLAN `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable when ARCH requires it |
| EC-06 | WR records ARCH path in `artifacts[]` |
| EC-07 | PRD linked or `prd_gap: missing \| waiver` documented |
| EC-08 | DB linked or `db_gap: missing \| waiver` documented |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 API persisted (or `persist: pending` with human ack) |
| XC-02 | CL-API `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-PLAN`, `decision: pending` |
| XC-04 | WR `status: api_pending_review` |

---

## Human Gate — H-PLAN

| Field | Rule |
|-------|------|
| gate_id | `H-PLAN` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: plan_approved`; may recommend PB-implement-backend or PB-decompose-issues |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: api_rejected` |

**Binding on approve:** endpoint catalog, auth model, and resolved open questions marked sufficient for Implement.

---

## Revise Loop

Human `revise` at H-PLAN → re-enter **LOAD** → increment `revision` → full CL-API → handoff again.

---

## Recovery

CL-API fail → fix per `checklists/api.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| change_type / workflow | Primary | Alternate |
|------------------------|---------|-----------|
| `new` (WF-FEATURE) | PB-implement-backend | PB-decompose-issues |
| `additive` (WF-ENHANCEMENT) | PB-implement-backend | PB-decompose-issues |
| `breaking` (WF-REFACTOR) | PB-decompose-issues | PB-implement-backend (small scope) |
| `breaking` (WF-SECURITY) | PB-decompose-issues | PB-implement-backend |
| `arch_alignment: requires_arch_revise` | PB-draft-architecture | — |
| Large surface area | PB-decompose-issues | PB-implement-backend |