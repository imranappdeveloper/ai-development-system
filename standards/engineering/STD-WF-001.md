# STD-WF-001 — Workflow

| Field | Value |
|-------|-------|
| standard_id | STD-WF-001 |
| version | 1.0.0 |
| status | active |
| owner | Workflow Owner |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Rules for authoring and maintaining **workflow definitions** (`WF-*`) — not orchestrator tick implementation (see `DESIGN.md`).

## Scope

- `workflows/specs/WF-*.yaml`, `workflows/WF-*/phases.yaml`, `WORKFLOW-REGISTRY.yaml`, `skill-dependency-graph.yaml` `execution_graphs`
- Excludes: orchestrator tick steps, CL-ORCH, gate semantics (**docs/GOVERNANCE.md** + `gates.yaml`)

## Rules

### Workflow identity (MUST)

- Every cataloged `WF-*` MUST have `workflows/specs/WF-*.yaml` + `workflows/WF-*/phases.yaml` + `README.md`
- `workflow_id` in INT MUST match an INDEX row
- Execution sequence derived from `skill-dependency-graph.yaml` — phases.yaml MUST NOT contradict graph without architect waiver

### Phase spine (MUST)

Canonical phases: `Intake → Frame → Plan → Decompose → Implement → Verify → Ship → Operate → DONE`

Skip phases via routing optional skills + `waivable_gates` — not by deleting phases from the model.

### phases.yaml contents (MUST)

```yaml
workflow_id: WF-*
execution_sequence: []  # playbooks + H-* gates in order
phases: []             # grouped steps by phase
terminal_gate: H-*     # workflow-specific
```

### Human gates in sequence (MUST)

- Gate steps use `H-*` ids from `gates.yaml` only
- A gate MUST follow its producing playbook(s) per integration table
- No gate without a bound artifact type (**ARTIFACT-REGISTRY.yaml**)

### Playbook eligibility (MUST)

- Only `draft` or `active` playbooks in default happy path
- `planned` playbooks MAY appear in sequence only as documented stubs — orchestrator blocks invoke (**DESIGN.md** ORCH-S7)

### Rewind (MUST)

Rewind targets documented in `DESIGN.md` §3 — workflows MUST NOT define alternate rewind semantics locally.

## Examples

**WF-BUGFIX terminal:** `H-VERIFY` after `PB-verify` — no DISC required (H-FRAME waived per `gates.yaml`).

**WF-RELEASE:** `PB-intake-classify → H-INTAKE → PB-prepare-release → H-SHIP → H-OPERATE` — no spurious `H-VERIFY` without `PB-verify`.

## Exceptions

- `WF-PROJECT-NEW` MAY terminate at H-PLAN without Implement phase
- Enhancement MAY stop at H-PLAN per routing
- Experimental workflows MUST be marked `status: draft` in phases.yaml until INDEX promotion

## Validation

| Check | Pass |
|-------|------|
| W-WF-01 | 11 INDEX workflows have phases.yaml |
| W-WF-02 | execution_sequence ⊆ registered playbooks + gates |
| W-WF-03 | terminal_gate reachable |
| W-WF-04 | routing-matrix consistent for each step |

MS-workflow-review validates W-WF-*.

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-NAMING-001 | `WF-*` identifiers |
| STD-MEM-001 | ORS `current_phase` |
| STD-TEST-001 | Workflow integration test scenarios |
| STD-DOC-001 | Workflow README requirement |
| STD-VER-001 | phases.yaml version bumps |