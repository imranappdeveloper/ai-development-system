# PB-discovery-research — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/discovery.md` — 10 items |
| ENV-03 | `templates/discovery/template.md` aligned with OUT-01 |
| ENV-04 | Fixture project with approved INT |
| ENV-05 | System prompt 09 v1.0.0 |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT `feature` | DISC persisted; `discovery_type: feature`; CL-DISCOVERY pass |
| HT-02 | Approved INT `new_project` | `discovery_type: new_project`; PB-draft-prd recommended |
| HT-03 | Approved INT `existing_project` | `discovery_type: existing_onboarding` |
| HT-04 | H-FRAME revise | `revision: 1`; notes reflected |
| HT-05 | Research contradicts INT | `alignment: requires_re_intake`; PB-intake-classify recommended |

---

## Edge Tests (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved INT | Block; no DISC handoff as complete |
| ET-02 | `work_type: bugfix` INT | Block; redirect |
| ET-03 | PRD content in DISC | CL-DISCOVERY #7 fail |
| ET-04 | Agent sets new work_type | CL-DISCOVERY #8 fail |
| ET-05 | Chat-only mode | Full DISC + `persist: pending` |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND CL-DISCOVERY manual rubric pass
```

**Status:** Sequential gate PASS — `test-runs/latest-gate.md`; `status: active` (registry 1.0.0).

| Evidence | Result |
|----------|--------|
| Anti-patterns (3) | pass |
| `verify-skill-spec.sh` | pass |
| Prerequisite PB-intake-classify gate | pass |