# PB-feature-planner — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 11-test-plan |
| type | umbrella |

---

## Purpose

This test plan validates **umbrella documentation** — not orchestrator execution:

1. **Umbrella identity** — human label vs routing IDs
2. **Routing resolution** — when humans/agents use `PB-draft-feature` vs `PB-decompose-issues`
3. **Build order** — SKILL-CATALOG sequencing
4. **Non-invokability** — ORCH-PROJECT must never invoke `PB-feature-planner`

**Explicitly out of scope:** HT/ET for child FEAT or ISS-* production (owned by child 11-test-plan.md files).

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable |
| ENV-02 | `registry.yaml` type: umbrella, status: active, spec_version: 1.0.0 |
| ENV-03 | `routing-matrix.yaml` — confirm no `PB-feature-planner` invoke key |
| ENV-04 | `fixtures/decision-matrix.yaml` present |
| ENV-05 | `examples/golden/umbrella-routing-decision-001.md` present |
| ENV-06 | ≥3 anti-patterns in `examples/anti-patterns/` |

---

## Happy Path Tests (HT) — Documentation

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Read README identity table | PB-feature-planner marked not invokable; children listed |
| HT-02 | Consult matrix: narrow enhancement + DISC | Resolve `PB-draft-feature` |
| HT-03 | Consult matrix: PRD approved + multi-epic | Resolve `PB-decompose-issues` |
| HT-04 | Consult matrix: WF-FEATURE greenfield | Resolve `PB-draft-prd` then decompose note |
| HT-05 | CL-FEAT-PLAN advisory run | 10 items checkable; no disk checklist required |
| HT-06 | Build order read from registry | after PB-draft-prd; children authoring order documented |

---

## Edge Tests (ET) — Wrong Routing ID (P0)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | Invoke skill_id PB-feature-planner | Redirect; EC-RT-01 behavior |
| ET-02 | Decompose without PRD | Block; route Plan first (EC-RT-06) |
| ET-03 | WF-BUGFIX → decompose | Redirect PB-draft-issue (EC-RT-12) |
| ET-04 | Merge issues into PRD | Reject pattern FP-merge-decompose-into-prd |
| ET-05 | Skip PRD before decompose | Anti-pattern FP-skip-prd match |
| ET-06 | Human "run feature planner" | routing_resolution; never_invoke set |
| ET-07 | routing-matrix grep PB-feature-planner | No invoke row (AC-ID-02) |
| ET-08 | os_refs.skill umbrella | Invalid per EC-RT-03 |

---

## Failure Tests (FT)

| ID | Input | Expected |
|----|-------|----------|
| FT-01 | Orchestrator config adds umbrella row | Document EC-RT-02; reject in review |
| FT-02 | Adapter registers executable umbrella | EC-RT-04 fail-fast guidance |
| FT-03 | Low confidence without blockers | AC-CMP-01 fail |

---

## Regression Tests (RT)

| ID | Fixture | Expected |
|----|---------|----------|
| RT-01 | examples/golden/umbrella-routing-decision-001.md | Stable routing outcomes |
| RT-02 | fixtures/decision-matrix.yaml | Row keys unchanged without MAJOR bump |

---

## Integration Tests (IT)

| ID | Check | Expected |
|----|-------|----------|
| IT-01 | ORCH-PROJECT skill-dependency-graph | No PB-feature-planner in skills execution keys |
| IT-02 | WF-FEATURE execution_graph | Uses PB-draft-prd + PB-decompose-issues; not umbrella |
| IT-03 | STD-NAMING-001 exception text | Matches README identity rule |

**IT note:** Umbrella **excluded** from orchestrator integration by design — IT validates absence, not invocation.

---

## Build Order Tests (BT)

| ID | Check | Expected |
|----|-------|----------|
| BT-01 | SKILL-CATALOG build_order contains PB-feature-planner | Position after PB-draft-prd |
| BT-02 | Umbrella active does not imply children active | draft-feature, decompose-issues may stay planned |
| BT-03 | registry build_order.children_authoring | PB-draft-feature before PB-decompose-issues |

---

## Promotion Gate (umbrella)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND RT: 100% AND IT: 100% AND BT: 100%
```

**Relaxed vs default STD-SKILL-001 gate:** No ST suite; no child HT dependency.

**Status:** Executed at spec authoring — `status: active` for documentation umbrella.

---

## Manual Rubric (architect)

| # | Question | Pass |
|---|----------|------|
| 1 | Can a new agent avoid invoking PB-feature-planner? | ☐ |
| 2 | Is draft-feature vs decompose decision documented with examples? | ☐ |
| 3 | Are waivers W-UMB-01–03 recorded? | ☐ |
| 4 | Is 09-system-prompt clearly NOT an invoke target? | ☐ |