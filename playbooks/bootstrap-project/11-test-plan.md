# PB-bootstrap-project — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-bootstrap-project |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/bootstrap.md` — 10 items, `status: active` |
| ENV-03 | Fixture `fixtures/projects/wf-project-new/` |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: active`, `spec_version: 1.0.0` |
| ENV-06 | PB-draft-prd `test-runs/latest-gate.md` VERDICT PASS |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | Approved upstream + WF-PROJECT-NEW | SCAFFOLD complete; CL-BOOTST pass |
| HT-02 | Soft upstream linked | References populated; pass |
| HT-03 | H-PLAN revise | `revision: 1`; notes reflected |
| HT-04 | Golden fixture wf-project-new | Matches BOOTSTRAP-project-001.md structure |
| HT-05 | WR updated | `artifacts[]` lists SCAFFOLD path |
| HT-06 | Handoff | `recommended_next_skill: PB-onboard-project` |
| HT-07 | Optional skill skip (if applicable) | Orchestrator may bypass without error |
| HT-08 | `verify-skill-spec.sh` | FAIL=0 |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No upstream artifact | Block; no complete handoff |
| ET-02 | Artifact already approved | Block unless `mode: revise` |
| ET-03 | Code in SCAFFOLD body | CL-BOOTST #5 fail |
| ET-04 | Missing upstream link | CL-BOOTST #3 fail |
| ET-05 | Agent `decision: approve` | CL-BOOTST #10 fail |
| ET-06 | Chat-only mode | Full artifact + `persist: pending` |
| ET-07 | Wrong workflow | EC-ENT block |
| ET-08 | Routing matrix embed | CL-BOOTST #5 fail |
| ET-09 | Low confidence path | Open Questions populated |
| ET-10 | Sequential gate missing | Promotion blocked |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-project-new/work/` | Upstream stub present |
| FT-02 | `wf-project-new/work/WR-PROJECT-NEW.md` | WR with artifact refs |
| FT-03 | Anti-patterns (3) | Manual rubric flags checklist fails |
| FT-04 | Golden BOOTSTRAP-project-001.md | Structure valid |
| FT-05 | `verify-skill-spec.sh` | FAIL=0 |
| FT-06 | `test-runs/latest-gate.md` | VERDICT PASS |
| FT-07 | routing-matrix `status: active` | Row aligned |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-BOOTST manual rubric pass AND 10-review ≥ 72
```

## Promotion Evidence Log (2026-06-18)

| Test | Result |
|------|--------|
| HT manual walkthrough | pass (8/8) |
| ET(P0) manual walkthrough | pass (10/10) |
| FT fixture walkthrough | pass (7/7) |
| CL-BOOTST rubric | pass |
| Golden BOOTSTRAP-project-001.md | pass |
| Anti-patterns (3) | pass |
| Sequential gate latest-gate.md | pass |
| verify-skill-spec.sh | FAIL=0 |
