# PB-project-orchestrator — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 11-test-plan |
| prompt_version_under_test | 0.2.0 |
| spec_range | 01–10 |

---

## 1. Purpose & Scope

Validate ORCH-PROJECT **before** `status: active` and on every `prompt_version` / `registry.yaml` / substrate change.

| In scope | Out of scope |
|----------|--------------|
| Commands, tick flow, ORS/WR persistence | Child playbook domain correctness (separate plans) |
| CL-ORCH + AC-* from 06-quality.md | Full multi-day WF-FEATURE delivery E2E |
| G-ORCH structural gates + G-WF-05 spine alignment | Production automation daemon |
| Golden ORS / hold packages | CI service deployment |

---

## 2. Test Environment

### Prerequisites

| ID | Requirement | Verify |
|----|-------------|--------|
| ENV-01 | `AI_DEV_OS_HOME` readable | `INDEX.md` exists |
| ENV-02 | `checklists/orchestrator.md` — CL-ORCH 8 items | On disk |
| ENV-03 | `templates/orchestrator-run-state/template.md` | Matches ORCH-OUT-01 |
| ENV-04 | `workflows/project-orchestrator/routing-matrix.yaml` | Derived from graph |
| ENV-05 | `workflows/project-orchestrator/gates.yaml` incl. H-META | On disk |
| ENV-06 | `workflows/WF-*/phases.yaml` for all INDEX workflows | 14 workflows |
| ENV-07 | Fixture `fixtures/projects/wf-feature-alpha/` | WR + ORS + CONTEXT |
| ENV-08 | System prompt 09 v0.2.0 | PROMPT markers present |
| ENV-09 | Active child skills for HT path | PB-intake-classify, PB-discovery-research `active` |

### Fixtures

```
fixtures/
└── projects/
    └── wf-feature-alpha/
        ├── CONTEXT.md
        ├── work/
        │   ├── WR-FEATURE-001.md
        │   ├── intake/WR-FEATURE-001.md
        │   └── orchestrator/
        │       ├── WR-FEATURE-001.ors.md
        │       └── logs/.gitkeep
        └── README.md
```

### Execution modes

| Mode | Agent | Suites |
|------|-------|--------|
| Manual | Human + agent in IDE | HT, ET, FT |
| Structural | Script / rubric | G-ORCH, G-WF-05 |
| Golden diff | Compare to `examples/golden/` | HT-02, HT-03 |

---

## 3. Global Pass/Fail Criteria

### Per-test pass (G1–G6)

| # | Criterion |
|---|-----------|
| G1 | Input injected as specified |
| G2 | Output order: ORS → summary → hold/next (AC-OUT-01) |
| G3 | CL-ORCH result recorded (pass or expected fail) |
| G4 | Test-specific expected outputs met |
| G5 | No NEVER-list violation (08-limitations.md) |
| G6 | ORS persisted before narrative (AC-OUT-02) |

### Suite pass

| Suite | Pass rule |
|-------|-----------|
| G-ORCH | 100% T-01–T-08 |
| G-WF-05 | 100% T-E2E-01–06 |
| Happy path (HT) | 100% |
| Edge (ET) | 100% P0 ET |
| Failure (FT) | 100% |

### Promotion gate (draft → active)

```
G-ORCH: 100%
AND G-WF-05: 100%
AND HT: 100%
AND ET(P0): 100%
AND FT: 100%
AND 10-review score ≥ 70
AND no open P0 blockers
```

---

## 4. G-ORCH — Structural promotion

| ID | Scenario | Pass | Evidence |
|----|----------|------|----------|
| T-01 | LOAD resolves all D-OS artifacts | routing-matrix, gates, phases, integrations exist | ✅ 2026-06-18 |
| T-02 | WF-FEATURE sequence in phases.yaml | intake → discovery → prd path | ✅ |
| T-03 | WF-RELEASE no spurious H-VERIFY | prepare-release → H-SHIP | ✅ |
| T-04 | `requires_re_intake` rewind | ORS phase → Intake | HT-05 |
| T-05 | CL-ORCH blocks invoke during gate | `awaiting_human_gate` set | HT-03, ET-02 |
| T-06 | H-META registered | gates.yaml contains H-META for MS-* | ✅ |
| T-07 | Golden + 3 anti-patterns | `examples/` populated | ✅ 2026-06-18 |
| T-08 | Fixtures WR + ORS | `fixtures/projects/wf-feature-alpha/` | ✅ 2026-06-18 |

---

## 5. G-WF-05 — Workflow spine alignment

Validates `execution_sequence` in `workflows/WF-*/phases.yaml` matches `workflows/specs/WF-*.yaml` and terminal gate present.

| ID | Workflow | Terminal gate | Sequence spine (abbrev) | Pass |
|----|----------|---------------|-------------------------|------|
| T-E2E-01 | WF-FEATURE | H-SHIP | intake → discovery → prd → arch → decompose → implement → verify → release | ✅ |
| T-E2E-02 | WF-PROJECT-NEW | H-PLAN | intake → discovery → prd → arch → bootstrap | ✅ |
| T-E2E-03 | WF-PROJECT-EXISTING | H-FRAME | intake → onboard | ✅ |
| T-E2E-04 | WF-ENHANCEMENT | H-PLAN | intake → discovery → prd | ✅ |
| T-E2E-05 | WF-BUGFIX | H-VERIFY | intake → diagnose → issue → implement → verify | ✅ |
| T-E2E-06 | WF-REFACTOR | H-PLAN | intake → draft-architecture | ✅ |

**Method:** Compare spec `execution_sequence` ↔ `phases.yaml` step order; confirm `terminal_gate` in sequence. Planned downstream skills block invoke (ORCH-S7) — structural pass does not require skill `active`.

---

## 6. Happy Path Tests (HT)

### HT-01: `start` — new WF-FEATURE work

| Field | Value |
|-------|-------|
| Input | `command: start`, `raw_request`: feature request, `project_root`: fixtures/projects/wf-feature-alpha |
| Expected | WR created; ORS `current_phase: Intake`, `run_status: idle`; no playbook invoked yet |
| Pass | G1–G6; AC-INV-01; files at WR + ORS paths |

### HT-02: `tick` — invoke PB-intake-classify

| Field | Value |
|-------|-------|
| Setup | HT-01 ORS; first tick |
| Expected | Envelope to PB-intake-classify; INT path in WR `artifacts[]`; `awaiting_human_gate: H-INTAKE` after child completes |
| Pass | Matches golden `examples/golden/ORS-tick-intake-hold-001.md` structure; AC-GATE-01 |

### HT-03: `tick` blocked at gate

| Field | Value |
|-------|-------|
| Setup | ORS with `awaiting_human_gate: H-INTAKE` |
| Expected | ORCH-OUT-04 hold; **no** second playbook invoke |
| Pass | AC-GATE-02; ET-02 |

### HT-04: `record_gate` approve — unblock

| Field | Value |
|-------|-------|
| Input | `human_gate_decision: { gate_id: H-INTAKE, decision: approve }` |
| Expected | `gate_history` append; `awaiting_human_gate: null`; ready for next `tick` |
| Pass | AC-GATE-03; INV-03 |

### HT-05: DISC `requires_re_intake` rewind

| Field | Value |
|-------|-------|
| Setup | ORS at Frame; DISC fixture with `alignment: requires_re_intake` |
| Expected | `current_phase: Intake`; `awaiting_human_gate: null`; PB-intake-classify queued |
| Pass | G-ORCH T-04; EC-ORCH-05 |

### HT-06: `resume` after idle

| Field | Value |
|-------|-------|
| Input | `resume_token` matching ORS |
| Expected | State summary; no domain mutation |
| Pass | ORS unchanged except `updated`; AC-OUT-01 |

### HT-07: Terminal `done` detection

| Field | Value |
|-------|-------|
| Setup | ORS at final gate approved; DOD-01–07 satisfied |
| Expected | `run_status: done`; ORCH-OUT-06 |
| Pass | AC-INV-06; DOD table |

---

## 7. Edge Tests — P0 (ET)

| ID | Trigger | Expected | EC ref |
|----|---------|----------|--------|
| ET-01 | Second `start` same work_id | Resume prompt | EC-ORCH-01 |
| ET-02 | `tick` with `awaiting_human_gate` set | Hold only | EC-ORCH-02 |
| ET-03 | Next skill `status: planned` | Hold `planned_skill` | EC-ORCH-03 |
| ET-04 | Handoff missing OUT-* | Retry once → escalate | EC-ORCH-04 |
| ET-05 | `waive` without reason | Reject record_gate | EC-ORCH-06 |
| ET-06 | `workflow_id` ≠ approved INT | Block advance | EC-ORCH-12 |
| ET-07 | Standalone WR artifacts | Reconcile ORS | EC-ORCH-11 |
| ET-08 | Two invoke requests one tick | Second rejected | EC-ORCH-13 |

---

## 8. Failure Tests (FT)

| ID | Scenario | Expected |
|----|----------|----------|
| FT-01 | CL-ORCH check 6 fail (gate block violated) | `recovering`; no phase advance |
| FT-02 | E-PLAYBOOK 3 retries exhausted | ORCH-OUT-05 escalation |
| FT-03 | Invalid `record_gate` (agent-initiated) | Reject; NEVER violation |
| FT-04 | `abort` mid-run | `run_status: aborted`; hold cleared |
| FT-05 | PREFLIGHT missing INT | ORCH-OUT-04; no invoke |

---

## 9. Evidence log

| Date | Suite | Result | Notes |
|------|-------|--------|-------|
| 2026-06-18 | G-ORCH T-01–T-03, T-06 | ✅ Pass | D-OS paths on disk; WF-RELEASE fix |
| 2026-06-18 | G-WF-05 T-E2E-01–06 | ✅ Pass | Structural spine alignment |
| 2026-06-18 | G-ORCH T-07–T-08 | ✅ Pass | Examples + fixtures added |
| 2026-06-18 | HT-01–HT-07 | ✅ Pass | Manual rubric vs golden fixture |
| 2026-06-18 | ET-01–ET-08 | ✅ Pass | P0 edge cases per 07-edge-cases.md |
| 2026-06-18 | FT-01–FT-05 | ✅ Pass | Failure paths per 03-workflow recovery |
| 2026-06-18 | E2E-WF-FEATURE | ✅ Pass | Canonical `WF-FEATURE/phases.yaml` aligned with routing-matrix; all spine skills `active` (intake→ship); fixture tree `wf-feature-alpha` |

### E2E-WF-FEATURE canonical path (structural)

Verified skill chain in `workflows/WF-FEATURE/phases.yaml` matches active registries:

`PB-intake-classify` → `PB-discovery-research` → `PB-draft-prd` → `PB-draft-architecture` → `PB-draft-database` → `PB-draft-api` → `PB-draft-ui-ux` → `PB-decompose-issues` → `PB-implement-backend` → `PB-test-plan` → `PB-test-generate` → `PB-verify` → `PB-review` → `PB-security-review` → `PB-perf-review` → `PB-prepare-release`

**Promotion status:** All gates satisfied — `status: active` at spec_version 0.2.0.

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Full HT/ET/FT; promotion formula; evidence log |
| 0.1.0 | 2026-06-18 | G-ORCH + G-WF-05 structural tests only |