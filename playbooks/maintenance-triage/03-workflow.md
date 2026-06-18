# PB-maintenance-triage — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-MAINT, INT path from WR |
| 2 | LOAD | Read INT; soft-load REL (post-release), CONTEXT.md slice |
| 3 | SNAPSHOT | Build health signals §2 from evidence |
| 4 | TRIAGE | Backlog §3 — categorize, prioritize, route to WF-* |
| 5 | DOC | Build MAINT per TP-maintenance |
| 6 | PERSIST | Write MAINT; update Work Record |
| 7 | VAL | CL-MAINT (10 checks); recovery ≤3 attempts |
| 8 | HAND | Handoff package; **stop** — await H-OPERATE |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> SNAPSHOT[3 SNAPSHOT]
    SNAPSHOT --> TRIAGE[4 TRIAGE]
    TRIAGE --> DOC[5 DOC]
    DOC --> PERSIST[6 PERSIST]
    PERSIST --> VAL[7 CL-MAINT]
    VAL --> HAND[8 HAND]
    HAND --> H[H-OPERATE]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked INT exist |
| EC-02 | INT `status` approved at H-INTAKE, or `human_waiver` documented |
| EC-03 | `work_type: maintenance` OR post-release operate path with REL (soft) |
| EC-04 | `workflow_id` ∈ `WF-MAINTENANCE`, `WF-RELEASE` |
| EC-05 | No prior MAINT with H-OPERATE `approve` unless `mode: revise` |
| EC-06 | Prerequisite PB-intake-classify sequential gate PASS |

---

## Human Gate — H-OPERATE

| Field | Rule |
|-------|------|
| gate_id | `H-OPERATE` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: maintenance_complete`; human may spawn child work_ids |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: maintenance_rejected` |

**Binding on approve:** approved backlog §3.2, deferred §3.3, and child routing table §7.

---

## Revise Loop

Human `revise` at H-OPERATE → re-enter **LOAD** → increment `revision` → full CL-MAINT → handoff again.

---

## Recovery

CL-MAINT fail → fix per `checklists/maintenance.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## WF-RELEASE Operate Path

When invoked after PB-prepare-release / H-SHIP:

| Step | Rule |
|------|------|
| REL | Soft-required — cite `upstream_rel_path` or document waiver |
| H-SHIP | Soft gate — note in MAINT §1 if operate before ship (anomaly) |
| cycle_type | Default `reactive` unless human specifies `hygiene` |