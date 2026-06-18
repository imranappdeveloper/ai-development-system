# PB-onboard-project — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/onboard.md` — 10 items |
| ENV-03 | Fixture project with approved INT + CONTEXT.md |
| ENV-04 | System prompt 09 v1.0.0 |
| ENV-05 | Prerequisite `PB-intake-classify` `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT `existing_project` + CONTEXT.md | ONBOARD persisted; `onboarding_type: existing_project`; CL-ONBOAR pass |
| HT-02 | CONTEXT minor drift | `context_drift: minor`; proposed updates in §3 |
| HT-03 | H-FRAME revise | `revision: 1`; notes reflected |
| HT-04 | Module map from monorepo | ≥3 modules in §4 |
| HT-05 | Onboard contradicts INT | `alignment: requires_re_intake`; PB-intake-classify recommended |

---

## Edge Tests (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved INT | Block; no ONBOARD handoff as complete |
| ET-02 | CONTEXT.md missing | Block; EC-ENT-04 |
| ET-03 | `work_type: feature` INT | Block; redirect |
| ET-04 | Agent writes CONTEXT.md | CL-ONBOAR #7 fail |
| ET-05 | Chat-only mode | Full ONBOARD + `persist: pending` |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND CL-ONBOAR manual rubric pass
AND prerequisite PB-intake-classify gate PASS
```

**Status:** Sequential gate PASS — `test-runs/latest-gate.md`; `status: active` (registry 1.0.0).

| Evidence | Result |
|----------|--------|
| Anti-patterns (3) | pass |
| `verify-skill-spec.sh` | pass |
| Prerequisite PB-intake-classify gate | pass |