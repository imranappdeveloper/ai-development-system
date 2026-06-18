# CL-ORCH — Orchestrator Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-ORCH |
| version | 1.0.0 |
| applies_to | ORCH-PROJECT |
| normative_ref | `workflows/project-orchestrator/DESIGN.md` §13 |

Run before persisting ORS after each orchestrator tick.

---

## Checks

| # | Check | Pass criteria |
|---|-------|---------------|
| 1 | Invariants INV-01–06 | At most one running playbook; no invoke during `awaiting_human_gate`; gate history consistent |
| 2 | Playbook history | `playbook_history[-1]` matches completed handoff `skill_id` |
| 3 | Phase transition | Valid per `workflows/{workflow_id}/phases.yaml` |
| 4 | Gate state | `awaiting_human_gate` consistent with last playbook `exit_gate` |
| 5 | Artifact paths | WR `artifacts[]` paths exist or `persist: pending` flagged |
| 6 | Gate block | No playbook invoked while `awaiting_human_gate` set |
| 7 | Workflow binding | `workflow_id` matches approved INT unless human rewind |
| 8 | Routing preflight | Next playbook ∈ `routing-matrix.yaml` with entry criteria met |

---

## On Fail

- Halt tick; set `run_status: recovering` or `awaiting_human`
- Emit escalation package (ORCH-OUT-05)
- Do not advance phase