# PB-implement-devops — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| status | draft |
| document | 03-workflow |

---

## Overview

Ten-step linear workflow: verify ISS entry → load context → implement per issues → document validation → validate → hand off at H-IMPLEMENT. **Never production deploy.**

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-IMPLEMENT-DEVOPS, ISS paths from WR |
| 2 | LOAD | Read ISS/ISS-* + ARCH (soft) + REL (soft) + CONTEXT slice; set `implement_scope` |
| 3 | PLAN | Map each ISS to files/modules; confirm DevOps lane scope |
| 4 | TDD | Load **`/tdd`** skill where testable; per ISS vertical slice: failing validation test → minimal CI/IaC/config → pass → refactor |
| 5 | VAL-DOC | Run lint/plan/dry-run; populate §6 Validation Notes from TDD + validation runs (mandatory) |
| 6 | DOC | Build CODE record per OUT-01; alignment blocks required |
| 7 | PERSIST | Write `work/implement/devops/{work_id}.md`; update WR |
| 8 | VAL | CL-IMPLEMENT-DEVOPS (10 checks); recovery ≤3 attempts |
| 9 | HAND | Handoff package; **stop** — await H-IMPLEMENT |
| 10 | STOP | No prod deploy, no PB-verify auto-invoke |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> PLAN[3 PLAN]
    PLAN --> TDD[4 TDD /tdd]
    TDD --> VALDOC[5 VAL-DOC]
    VALDOC --> DOC[6 DOC]
    DOC --> PERSIST[7 PERSIST]
    PERSIST --> VAL[8 CL-IMPLEMENT-DEVOPS]
    VAL --> HAND[9 HAND]
    HAND --> H[H-IMPLEMENT]
    HAND --> STOP[10 STOP]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-01 | `work_id` and linked ISS or ISS-* exist |
| EC-02 | H-DECOMPOSE approved (WF-FEATURE path) or H-PLAN (WF-BUGFIX path) |
| EC-03 | No prior CODE with H-IMPLEMENT `approve` unless `mode: revise` |
| EC-04 | `workflow_id` in INDEX.md |
| EC-05 | `project_root` resolvable from WR |
| EC-06 | WR records ISS artifact path(s) in `artifacts[]` |
| EC-07 | ARCH linked or `arch_gap: missing \| waiver` documented |
| EC-08 | REL linked or `rel_gap: missing \| waiver` documented when WF-RELEASE scope |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 CODE persisted at `work/implement/devops/{work_id}.md` |
| XC-02 | CL-IMPLEMENT-DEVOPS `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-IMPLEMENT`, `decision: pending` |
| XC-04 | WR `status: implement_devops_pending_review` |
| XC-05 | §6 Validation Notes non-empty |
| XC-06 | No production deployment actions in output |

---

## Human Gate — H-IMPLEMENT

| Field | Rule |
|-------|------|
| gate_id | `H-IMPLEMENT` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: implement_approved`; may recommend PB-verify or PB-prepare-release |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: implement_rejected` |

**Binding on approve:** ISS mapping complete, validation documented, files changed list accurate.

---

## Revise Loop

Human `revise` at H-IMPLEMENT → re-enter **LOAD** → increment `revision` → full CL-IMPLEMENT-DEVOPS → handoff again.

---

## Recovery

CL-IMPLEMENT-DEVOPS fail → fix per `checklists/implement-devops.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| CODE complete, validation documented | PB-verify | PB-prepare-release (WF-RELEASE scope) |
| `arch_alignment: requires_arch_revise` | PB-draft-architecture | — |
| `rel_alignment: requires_rel_prepare` | PB-prepare-release | — |
| Missing ISS | PB-decompose-issues | PB-draft-issue |
| Backend scope detected | PB-implement-backend | — |
| Frontend scope detected | PB-implement-frontend | — |