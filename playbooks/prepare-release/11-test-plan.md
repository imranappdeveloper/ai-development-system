# PB-prepare-release — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/release.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with CODE + TEST-RPT + WR |
| ENV-04 | Fixture `fixtures/projects/wf-release-alpha/` for WF-RELEASE waiver path |
| ENV-05 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-06 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-07 | `routing-matrix.yaml` PB-prepare-release row present |
| ENV-08 | `templates/release/template.md` available |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | CODE + TEST-RPT `WF-FEATURE` | REL at release path; CL-RELEASE pass |
| HT-02 | CODE + TEST-RPT + REVIEW linked | §11 includes review open items |
| HT-03 | `semver_hint: 1.2.0` + `release_type_hint: minor` | §3 matches hint |
| HT-04 | Multi-lane CODE BE+FE | §2.1 row per lane |
| HT-05 | revise at H-SHIP | `revision: 1`; notes in REL |
| HT-06 | Golden fixture wf-feature-alpha | Output matches REL-feature-001 structure |
| HT-07 | SEC-REVIEW linked with no P0 | §4.4 Security populated |
| HT-08 | `WF-RELEASE` without TEST-RPT | Waiver in §8.1; CL-RELEASE pass |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No CODE linked | Block; no complete handoff |
| ET-02 | REL already H-SHIP approved | Block unless `mode: revise` |
| ET-03 | Agent runs kubectl apply | CL-RELEASE #10 fail |
| ET-04 | Agent `decision: approve` on H-SHIP | CL-RELEASE #10 fail |
| ET-05 | Agent modifies source file | CL-RELEASE #9 fail |
| ET-06 | Chat-only mode | Full REL + `persist: pending` |
| ET-07 | §2.1 row without WR artifact | CL-RELEASE #5 fail |
| ET-08 | TEST-RPT absent on WF-FEATURE | Block soft; recommend PB-verify |
| ET-09 | TEST-RPT fail in §8.1 | §11 blocker documented |
| ET-10 | §8.1 row without evidence | CL-RELEASE #8 fail |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/implement/backend/WR-FEATURE-ALPHA.md` | CODE stub resolvable |
| FT-02 | `wf-feature-alpha/work/testing/WR-FEATURE-ALPHA.md` | TEST-RPT stub resolvable |
| FT-03 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | CODE + TEST-RPT refs present |
| FT-04 | `wf-feature-alpha/work/release/` | Output directory exists |
| FT-05 | Anti-pattern `REL-self-approved.md` | Manual rubric flags CL #10 |
| FT-06 | Anti-pattern `REL-deploy-commands.md` | Manual rubric flags CL #10 |
| FT-07 | Anti-pattern `REL-missing-verify.md` | Manual rubric flags CL #2 |
| FT-08 | Golden `REL-feature-001.md` | STD §10.2 scenario block present |
| FT-09 | `wf-release-alpha/work/WR-RELEASE-001.md` | WF-RELEASE waiver path |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-RELEASE manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (9/9) |
| CL-RELEASE rubric | pass |
| 10-review score ≥ 72 | pass (79) |
| Quality chain upstream noted | pass |

**Status:** Draft complete — `status: draft` retained pending PB-verify active and automated RT execution.