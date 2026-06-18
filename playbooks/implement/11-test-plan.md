# PB-implement — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 11-test-plan |
| type | umbrella |

---

## Purpose

This test plan validates **umbrella documentation** — not orchestrator execution or CODE production:

1. **Umbrella identity** — human label vs lane routing IDs
2. **Lane routing resolution** — when humans/agents use each `PB-implement-*` child
3. **Build order** — LIFECYCLE / SKILL-CATALOG sequencing
4. **Non-invokability** — ORCH-PROJECT must never invoke `PB-implement`
5. **Prerequisite** — PB-draft-ui-ux gate PASS documented

**Explicitly out of scope:** HT/ET for lane child CODE production (owned by child 11-test-plan.md files when authored).

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable |
| ENV-02 | `registry.yaml` type: umbrella, status: draft, spec_version: 1.0.0 |
| ENV-03 | `routing-matrix.yaml` — confirm target: no permanent `PB-implement` umbrella invoke |
| ENV-04 | `fixtures/decision-matrix.yaml` present |
| ENV-05 | `examples/golden/implement-routing-decision-001.md` present |
| ENV-06 | ≥3 anti-patterns in `examples/anti-patterns/` |
| ENV-07 | `PB-draft-ui-ux` gate PASS — [../draft-ui-ux/test-runs/latest-gate.md](../draft-ui-ux/test-runs/latest-gate.md) |
| ENV-08 | `test-runs/latest-gate.md` documents prerequisite |

---

## Happy Path Tests (HT) — Documentation

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Read README identity table | PB-implement marked not invokable; lane children listed |
| HT-02 | Consult matrix: ISS + API only | Resolve `PB-implement-backend` |
| HT-03 | Consult matrix: ISS + UIUX web | Resolve `PB-implement-frontend` |
| HT-04 | Consult matrix: ISS + UIUX mobile-primary | Resolve `PB-implement-mobile` |
| HT-05 | Consult matrix: ISS cicd tags | Resolve `PB-implement-devops` |
| HT-06 | Consult matrix: full-stack ISS | Resolve multi_lane: backend + frontend |
| HT-07 | CL-IMPLEMENT-UMBRELLA advisory run | 12 items checkable; no disk checklist required |
| HT-08 | Build order read from registry | after PB-draft-ui-ux; children authoring order documented |
| HT-09 | Prerequisite gate reference | PB-draft-ui-ux PASS cited |

---

## Edge Tests (ET) — Wrong Routing ID (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | Invoke skill_id PB-implement | Redirect; EC-RT-01 behavior |
| ET-02 | Implement without ISS | Block; IMP-skip-issues (EC-RT-11) |
| ET-03 | API ISS → frontend lane | Redirect backend; IMP-wrong-lane (EC-RT-06) |
| ET-04 | UI ISS → backend lane | Redirect frontend; IMP-wrong-lane (EC-RT-07) |
| ET-05 | Mobile lane on web-only PRD | Medium confidence; EC-RT-08 |
| ET-06 | Human "run implement" | routing_resolution; never_invoke set |
| ET-07 | Full-stack single invoke | Reject; EC-RT-09 multi_lane |
| ET-08 | WF-BUGFIX without ISS | Block PB-draft-issue (EC-RT-12) |
| ET-09 | os_refs.skill umbrella | Invalid per EC-RT-03 |

---

## Failure Tests (FT)

| ID | Input | Expected |
|----|-------|----------|
| FT-01 | Orchestrator config adds umbrella as sole invoke | Document EC-RT-02; reject in review |
| FT-02 | Adapter registers executable umbrella | EC-RT-04 fail-fast guidance |
| FT-03 | Low confidence without blockers | AC-CMP-01 fail |
| FT-04 | Umbrella promotion without UIUX gate | EC-RT-18 block |

---

## Regression Tests (RT)

| ID | Fixture | Expected |
|----|---------|----------|
| RT-01 | examples/golden/implement-routing-decision-001.md | Stable lane routing outcomes |
| RT-02 | fixtures/decision-matrix.yaml | Row keys unchanged without MAJOR bump |

---

## Integration Tests (IT)

| ID | Check | Expected |
|----|-------|----------|
| IT-01 | ORCH-PROJECT skill-dependency-graph | No PB-implement in execution keys as terminal skill (target) |
| IT-02 | draft-api / draft-ui-ux next_candidates | Point to lane children not umbrella |
| IT-03 | STD-NAMING-001 exception text | Matches README identity rule |
| IT-04 | LIFECYCLE engineering chain | PB-implement umbrella after PB-draft-ui-ux |

**IT note:** Umbrella **excluded** from orchestrator integration by design — IT validates absence and prerequisite chain.

---

## Build Order Tests (BT)

| ID | Check | Expected |
|----|-------|----------|
| BT-01 | LIFECYCLE build_order contains PB-implement umbrella | Position after PB-draft-ui-ux |
| BT-02 | Umbrella draft does not imply children active | All lane children `planned` |
| BT-03 | registry build_order.children_authoring | backend → frontend → mobile → devops |

---

## Promotion Gate (umbrella)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND RT: 100% AND IT: 100% AND BT: 100%
```

**Relaxed vs default STD-SKILL-001 gate:** No ST suite; no child HT dependency.

**Status:** `draft` at spec authoring — promote to `active` (documentation umbrella) when maintainer executes HT/ET suites and syncs catalog.

---

## Manual Rubric (architect)

| # | Question | Pass |
|---|----------|------|
| 1 | Can a new agent avoid invoking PB-implement? | ☐ |
| 2 | Is lane routing documented with golden example and matrix? | ☐ |
| 3 | Are waivers W-UMB-01–03 recorded? | ☐ |
| 4 | Is 09-system-prompt clearly NOT an invoke target? | ☐ |
| 5 | Is PB-draft-ui-ux prerequisite PASS documented? | ☐ |