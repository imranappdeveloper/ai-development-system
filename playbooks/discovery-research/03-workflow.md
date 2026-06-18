# PB-discovery-research — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-DISCOVERY, INT path from WR |
| 2 | LOAD | Read INT + CONTEXT slice; set `discovery_type` |
| 3 | RESEARCH | Gather evidence (docs, CONTEXT, bounded code markers) |
| 4 | ANALYZE | As-is, gaps, problem, alternatives, risks |
| 5 | DOC | Build DISC per TP-discovery; §6.2 intake alignment only |
| 6 | PERSIST | Write DISC; update Work Record |
| 7 | VAL | CL-DISCOVERY (10 checks); recovery ≤3 attempts |
| 8 | HAND | Handoff package; **stop** — await H-FRAME |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> RESEARCH[3 RESEARCH]
    RESEARCH --> ANALYZE[4 ANALYZE]
    ANALYZE --> DOC[5 DOC]
    DOC --> PERSIST[6 PERSIST]
    PERSIST --> VAL[7 CL-DISCOVERY]
    VAL --> HAND[8 HAND]
    HAND --> H[H-FRAME]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked INT exist |
| EC-02 | INT `status` approved at H-INTAKE, or `human_waiver` documented in WR |
| EC-03 | No prior DISC with H-FRAME `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable when INT requires it |

---

## Human Gate — H-FRAME

| Field | Rule |
|-------|------|
| gate_id | `H-FRAME` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: discovery_approved`; may recommend PB-draft-prd |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: discovery_rejected` |

**Binding on approve:** recommended direction, out-of-scope, and resolved open questions marked sufficient for Plan.

---

## Revise Loop

Human `revise` at H-FRAME → re-enter **LOAD** → increment `revision` → full CL-DISCOVERY → handoff again.

---

## Recovery

CL-DISCOVERY fail → fix per `checklists/discovery.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| discovery_type | Primary | Alternate |
|----------------|---------|-----------|
| `new_project` | PB-discovery-research → PB-draft-prd | PB-bootstrap-project (post-PRD) |
| `existing_onboarding` | PB-onboard-project | — |
| `feature` | PB-draft-prd | PB-draft-feature |
| `enhancement` | PB-draft-prd | — |
| `alignment: requires_re_intake` | PB-intake-classify | — |