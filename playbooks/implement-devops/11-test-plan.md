# PB-implement-devops — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/implement-devops.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-feature-alpha/` with ISS-DO-001 stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | PB-implement-backend `test-runs/latest-gate.md` VERDICT PASS |
| ENV-07 | `routing-matrix.yaml` PB-implement-devops row present |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | ISS-DO-001 + ARCH `WF-FEATURE` | CODE at lane path; CL-IMPLEMENT-DEVOPS pass |
| HT-02 | Single ISS `WF-BUGFIX` H-PLAN | Pipeline fix; §6 validation documented |
| HT-03 | IaC ISS + ARCH linked | §5 Pipeline & Rollback populated; CL pass |
| HT-04 | CI-only ISS (no IaC) | `implement_scope: ci_pipeline`; CL pass |
| HT-05 | H-IMPLEMENT revise | `revision: 1`; notes in CODE |
| HT-06 | Golden fixture wf-feature-alpha | Output matches CODE-devops-001 structure |
| HT-07 | ARCH absent with `arch_gap: waiver` | CODE produced; pipelines from ISS |
| HT-08 | WF-RELEASE with REL linked | Recommend PB-prepare-release in handoff |
| HT-09 | Partial ISS via `target_issue_id` | Subset in §3; deferred ISS in §8 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No ISS linked | Block; no complete handoff |
| ET-02 | CODE already H-IMPLEMENT approved | Block unless `mode: revise` |
| ET-03 | Empty §6 Validation Notes | CL-IMPLEMENT-DEVOPS #5 fail |
| ET-04 | Prod deploy command in output | CL-IMPLEMENT-DEVOPS #6 fail |
| ET-05 | Agent `decision: approve` | CL-IMPLEMENT-DEVOPS #10 fail |
| ET-06 | Chat-only mode | Full CODE + `persist: pending` |
| ET-07 | Backend file in §4 | CL-IMPLEMENT-DEVOPS #9 fail |
| ET-08 | Missing ISS ID for file change | CL-IMPLEMENT-DEVOPS #2 fail |
| ET-09 | ARCH missing without waiver | `arch_gap: missing`; flag in handoff |
| ET-10 | REL missing for WF-RELEASE ISS | `rel_gap: missing`; §5 notes gap |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-feature-alpha/work/issues/ISS-DO-001.md` | ISS stub resolvable |
| FT-02 | `wf-feature-alpha/work/WR-FEATURE-ALPHA.md` | ISS artifact ref present |
| FT-03 | `wf-feature-alpha/work/implement/devops/` | Output directory exists |
| FT-04 | Anti-pattern `CODE-prod-deploy-without-gate.md` | Manual rubric flags CL #6 |
| FT-05 | Anti-pattern `CODE-skip-validation.md` | Manual rubric flags CL #5 |
| FT-06 | Anti-pattern `CODE-self-approved.md` | Manual rubric flags CL #10 |
| FT-07 | Golden `CODE-devops-001.md` | STD §10.2 scenario block present |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-IMPLEMENT-DEVOPS manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT manual walkthrough | pass (9/9) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT manual walkthrough | pass (7/7) |
| CL-IMPLEMENT-DEVOPS rubric | pass |
| 10-review score ≥ 72 | pass (74) |

**Status:** Draft complete — `status: draft` retained pending sequential gate execution and `test-runs/latest-gate.md` evidence.