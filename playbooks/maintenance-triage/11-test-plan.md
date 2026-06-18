# PB-maintenance-triage — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/maintenance.md` — 10 items |
| ENV-03 | `templates/maintenance/template.md` aligned with OUT-01 |
| ENV-04 | Fixture with approved INT `maintenance` |
| ENV-05 | Prerequisite `PB-intake-classify` `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved INT `maintenance` / WF-MAINTENANCE | MAINT persisted; CL-MAINT pass |
| HT-02 | Post-release with REL linked | `upstream_rel_path` set; `cycle_type: reactive` |
| HT-03 | Scheduled hygiene cycle | `cycle_type: scheduled`; §4 dependency rows |
| HT-04 | H-OPERATE revise | `revision: 1`; notes reflected |
| HT-05 | P0 CVE in backlog | §3.2 routes WF-SECURITY; ≤2 approved |

---

## Edge Tests (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No approved INT | Block; no MAINT handoff as complete |
| ET-02 | Deploy command in MAINT | CL-MAINT #7 fail |
| ET-03 | >2 approved §3.2 items | CL-MAINT #8 fail |
| ET-04 | Agent self-approves H-OPERATE | CL-MAINT #10 fail |
| ET-05 | Chat-only mode | Full MAINT + `persist: pending` |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND CL-MAINT manual rubric pass
AND prerequisite PB-intake-classify gate PASS
```

**Status:** Sequential gate PASS — `test-runs/latest-gate.md`; `status: active` (registry 1.0.0).

| Evidence | Result |
|----------|--------|
| Anti-patterns (3) | pass |
| `verify-skill-spec.sh` | pass |
| Prerequisite PB-intake-classify gate | pass |