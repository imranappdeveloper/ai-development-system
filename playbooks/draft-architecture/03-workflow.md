# PB-draft-architecture — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Overview

Eight-step linear workflow: verify PRD entry → load context → model structure → document ARCH → validate → hand off at H-PLAN.

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-ARCH, PRD path from WR |
| 2 | LOAD | Read PRD + CONTEXT slice; set `architecture_type` |
| 3 | MODEL | Context diagram, layers, components, dependency rules |
| 4 | FLOWS | Data flows, integrations, cross-cutting concerns |
| 5 | DOC | Build ARCH per TP-architecture; §1.3 PRD link required |
| 6 | PERSIST | Write ARCH; update Work Record |
| 7 | VAL | CL-ARCH (10 checks); recovery ≤3 attempts |
| 8 | HAND | Handoff package; **stop** — await H-PLAN |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> MODEL[3 MODEL]
    MODEL --> FLOWS[4 FLOWS]
    FLOWS --> DOC[5 DOC]
    DOC --> PERSIST[6 PERSIST]
    PERSIST --> VAL[7 CL-ARCH]
    VAL --> HAND[8 HAND]
    HAND --> H[H-PLAN]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked PRD exist |
| EC-02 | PRD `status` approved at H-PLAN (or `human_waiver` documented in WR) |
| EC-03 | No prior ARCH with H-PLAN `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable when PRD requires it |
| EC-06 | WR records `PB-draft-prd` in `os_refs` or PRD path in `artifacts[]` |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 ARCH persisted (or `persist: pending` with human ack) |
| XC-02 | CL-ARCH `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-PLAN`, `decision: pending` |
| XC-04 | WR `status: architecture_pending_review` |

---

## Human Gate — H-PLAN

| Field | Rule |
|-------|------|
| gate_id | `H-PLAN` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: plan_approved`; may recommend PB-decompose-issues |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: architecture_rejected` |

**Binding on approve:** layer boundaries, non-goals in scope table, and resolved open questions marked sufficient for Decompose.

---

## Revise Loop

Human `revise` at H-PLAN → re-enter **LOAD** → increment `revision` → full CL-ARCH → handoff again.

---

## Recovery

CL-ARCH fail → fix per `checklists/architecture.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| architecture_type / workflow | Primary | Alternate |
|------------------------------|---------|-----------|
| `greenfield` (WF-PROJECT-NEW) | PB-decompose-issues | PB-draft-database |
| `delta` (WF-REFACTOR) | PB-decompose-issues | PB-implement (small scope) |
| `delta` (WF-FEATURE) | PB-decompose-issues | PB-draft-api |
| `prd_alignment: requires_prd_revise` | PB-draft-prd | — |
| Complex data model | PB-draft-database | PB-decompose-issues |