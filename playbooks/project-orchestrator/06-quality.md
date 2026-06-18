# PB-project-orchestrator — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 06-quality |
| normative_ref | `workflows/project-orchestrator/DESIGN.md` §13–14 |

---

## Self-check

Run **CL-ORCH** (`checklists/orchestrator.md`) before every ORS persist. Tick fails if any of 8 checks fail.

| CL-ORCH # | Maps to AC |
|-----------|------------|
| 1 | AC-INV-01–06 |
| 2 | AC-HIST-01 |
| 3 | AC-PHASE-01 |
| 4 | AC-GATE-01 |
| 5 | AC-ART-01 |
| 6 | AC-GATE-02 |
| 7 | AC-WF-01 |
| 8 | AC-ROUTE-01 |

---

## Acceptance criteria

### Invariants (AC-INV)

| ID | Criterion | Verify |
|----|-----------|--------|
| AC-INV-01 | At most one `current_playbook_id` in running substate | ORS after tick |
| AC-INV-02 | `awaiting_human_gate` set ⟹ no playbook invoked same tick | Tick log |
| AC-INV-03 | Phase past gate only with `gate_history` approve | ORS + phases.yaml |
| AC-INV-04 | `workflow_id` matches approved INT unless rewind | WR + INT |
| AC-INV-05 | `playbook_history` append-only | ORS diff |
| AC-INV-06 | `done` only when DOD-01–07 satisfied | Done package |

### History and phase (AC-HIST, AC-PHASE)

| ID | Criterion | Verify |
|----|-----------|--------|
| AC-HIST-01 | `playbook_history[-1].skill_id` matches ingested handoff | Post-ingest |
| AC-PHASE-01 | `current_phase` transition legal in phases.yaml | ROUTE step |

### Gates (AC-GATE)

| ID | Criterion | Verify |
|----|-----------|--------|
| AC-GATE-01 | `awaiting_human_gate` matches child `exit_gate` | Post-invoke |
| AC-GATE-02 | No invoke while `awaiting_human_gate` non-null | HOLD branch |
| AC-GATE-03 | `record_gate` appends WR `approvals[]` + ORS `gate_history` | Human channel only |
| AC-GATE-04 | Agent never sets `decision: approve` on H-* | NEVER list |

### Artifacts and routing (AC-ART, AC-ROUTE, AC-WF)

| ID | Criterion | Verify |
|----|-----------|--------|
| AC-ART-01 | WR artifact paths exist or `persist: pending` flagged | PREFLIGHT |
| AC-ROUTE-01 | Next playbook ∈ routing-matrix with entry criteria met | PREFLIGHT |
| AC-WF-01 | `workflow_id` bound post H-INTAKE approve | ORS after record_gate |

### Output order (AC-OUT)

| ID | Criterion | Verify |
|----|-----------|--------|
| AC-OUT-01 | Output order: ORS → tick summary → hold/next action | 09-system-prompt |
| AC-OUT-02 | ORS persisted before handoff narrative | Every tick |

---

## Promotion gates (G-ORCH)

Structural gates for orchestrator substrate and spec completeness.

| Gate | Criterion | Evidence |
|------|-----------|----------|
| G-ORCH-01 | All WF-* phase DAGs defined | `workflows/WF-*/phases.yaml` exist |
| G-ORCH-02 | Routing matrix covers INDEX playbooks | `routing-matrix.yaml` derived from graph |
| G-ORCH-03 | WF-FEATURE happy path documented | `11-test-plan.md` HT-01–HT-03 |
| G-ORCH-04 | `requires_re_intake` rewind documented | EC-ORCH-05 + HT-05 |
| G-ORCH-05 | `work_id` isolation documented | EC-ORCH-01 + INV-01 |
| G-ORCH-06 | CL-ORCH checklist on disk | `checklists/orchestrator.md` |
| G-ORCH-07 | Golden + anti-pattern examples | `examples/` |
| G-ORCH-08 | Architect review ≥70, no open P0 | `10-review.md` |

### G-WF-05 (workflow structural)

End-to-end spine alignment — see `11-test-plan.md` §G-WF-05 (T-E2E-01–06).

---

## Definition of Done (DOD)

Per DESIGN §14 — terminal when all satisfied:

| ID | Criterion |
|----|-----------|
| DOD-01 | Terminal gate in `gate_history` with `decision: approve` |
| DOD-02 | WR artifact index complete for workflow |
| DOD-03 | `run_status: done` in ORS |
| DOD-04 | No `awaiting_human_gate` set |
| DOD-05 | `current_phase: DONE` |
| DOD-06 | Tick log chain complete |
| DOD-07 | Done package (ORCH-OUT-06) emitted |

Terminal gate per `workflows/{workflow_id}/phases.yaml` (e.g. WF-FEATURE → H-SHIP).

---

## Promotion gate (draft → active)

Maps to **STD-SKILL-001** G-SKILL gates and orchestrator-specific tests:

```
G-ORCH-01..08 pass
AND G-WF-05 T-E2E-01..06 pass
AND HT: 100%
AND ET(P0): 100%
AND FT: 100%
AND 10-review score ≥ 70
AND no open P0 blockers
```

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | AC-* map, G-ORCH-06–08, promotion formula |
| 0.1.0 | 2026-06-18 | Stub G-ORCH + DOD reference |