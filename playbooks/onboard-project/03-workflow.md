# PB-onboard-project — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-ONBOAR, INT path from WR |
| 2 | LOAD | Read INT + CONTEXT.md; verify `onboarding_type: existing_project` |
| 3 | ASSESS | Evaluate CONTEXT accuracy, drift, gaps; bounded repo markers |
| 4 | MAP | Build module map and OS adoption checklist |
| 5 | DOC | Build ONBOARD; §6.2 intake alignment only |
| 6 | PERSIST | Write ONBOARD; update Work Record |
| 7 | VAL | CL-ONBOAR (10 checks); recovery ≤3 attempts |
| 8 | HAND | Handoff package; **stop** — await H-FRAME |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> ASSESS[3 ASSESS]
    ASSESS --> MAP[4 MAP]
    MAP --> DOC[5 DOC]
    DOC --> PERSIST[6 PERSIST]
    PERSIST --> VAL[7 CL-ONBOAR]
    VAL --> HAND[8 HAND]
    HAND --> H[H-FRAME]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked INT exist |
| EC-02 | INT `status` approved at H-INTAKE, or `human_waiver` documented in WR |
| EC-03 | `{project_root}/CONTEXT.md` exists and readable |
| EC-04 | `work_type: existing_project` on INT |
| EC-05 | No prior ONBOARD with H-FRAME `approve` unless `mode: revise` |
| EC-06 | Prerequisite PB-intake-classify sequential gate PASS |

---

## Human Gate — H-FRAME

| Field | Rule |
|-------|------|
| gate_id | `H-FRAME` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: onboard_approved`; may recommend PB-draft-prd or PB-survey-codebase |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: onboard_rejected` |

**Binding on approve:** module map, OS adoption checklist, and proposed CONTEXT updates marked sufficient for Plan.

---

## Revise Loop

Human `revise` at H-FRAME → re-enter **LOAD** → increment `revision` → full CL-ONBOAR → handoff again.

---

## Recovery

CL-ONBOAR fail → fix per `checklists/onboard.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| Gaps need deep survey | PB-survey-codebase | — |
| Ready for product framing | PB-draft-prd | — |
| CONTEXT.md updates needed | PB-draft-doc-update | Human direct edit |
| `alignment: requires_re_intake` | PB-intake-classify | — |