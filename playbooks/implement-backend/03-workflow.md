# PB-implement-backend — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-implement-backend |
| version | 1.0.0 |
| status | draft |
| document | 03-workflow |

---

## Overview

Ten-step linear workflow: verify ISS entry → load context → implement per issues → document tests → validate → hand off at H-IMPLEMENT. **Never deploy.**

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-IMPLEMENT-BACKEND, ISS paths from WR |
| 2 | LOAD | Read ISS/ISS-* + API (soft) + DB (soft) + CONTEXT slice; set `implement_scope` |
| 3 | PLAN | Map each ISS to files/modules; confirm backend lane scope |
| 4 | TDD | Load **`/tdd`** skill; per ISS vertical slice: RED (one failing test) → GREEN (minimal code) → refactor — never all-tests-then-all-code |
| 5 | TEST-DOC | Record TDD cycles in §6 Testing Notes (commands, results; mandatory) |
| 6 | DOC | Build CODE record per OUT-01; alignment blocks required |
| 7 | PERSIST | Write `work/implement/backend/{work_id}.md`; update WR |
| 8 | VAL | CL-IMPLEMENT-BACKEND (10 checks); recovery ≤3 attempts |
| 9 | HAND | Handoff package; **stop** — await H-IMPLEMENT |
| 10 | STOP | No deploy, no PB-verify auto-invoke |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> PLAN[3 PLAN]
    PLAN --> TDD[4 TDD /tdd]
    TDD --> TESTDOC[5 TEST-DOC]
    TESTDOC --> DOC[6 DOC]
    DOC --> PERSIST[7 PERSIST]
    PERSIST --> VAL[8 CL-IMPLEMENT-BACKEND]
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
| EC-07 | API linked or `api_gap: missing \| waiver` documented |
| EC-08 | DB linked or `db_gap: missing \| waiver` documented when migrations expected |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 CODE persisted at `work/implement/backend/{work_id}.md` |
| XC-02 | CL-IMPLEMENT-BACKEND `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-IMPLEMENT`, `decision: pending` |
| XC-04 | WR `status: implement_backend_pending_review` |
| XC-05 | §6 Testing Notes non-empty |
| XC-06 | No deployment actions in output |

---

## Human Gate — H-IMPLEMENT

| Field | Rule |
|-------|------|
| gate_id | `H-IMPLEMENT` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR `status: implement_approved`; may recommend PB-verify |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR `status: implement_rejected` |

**Binding on approve:** ISS mapping complete, tests documented, files changed list accurate.

---

## Revise Loop

Human `revise` at H-IMPLEMENT → re-enter **LOAD** → increment `revision` → full CL-IMPLEMENT-BACKEND → handoff again.

---

## Recovery

CL-IMPLEMENT-BACKEND fail → fix per `checklists/implement-backend.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| CODE complete, tests documented | PB-verify | PB-review (parallel after verify) |
| `api_alignment: requires_api_revise` | PB-draft-api | — |
| `db_alignment: requires_db_revise` | PB-draft-database | — |
| Missing ISS | PB-decompose-issues | PB-draft-issue |
| Frontend scope detected | PB-implement-frontend | — |