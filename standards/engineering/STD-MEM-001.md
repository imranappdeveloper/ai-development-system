# STD-MEM-001 — Memory

| Field | Value |
|-------|-------|
| standard_id | STD-MEM-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Define **what is remembered** across sessions — durable stores, never chat.

## Scope

- Project `work/` artifacts, WR, ORS, approvals
- Excludes: field-level WR/ORS schemas (**STD-ARTIFACT-001**), which files to load (**STD-CTX-001**)

## Rules

### SSOT hierarchy (MUST)

| Question | SSOT | Never SSOT |
|----------|------|------------|
| Where am I in workflow? | ORS | Chat |
| What artifacts exist? | WR `artifacts[]` | Agent memory |
| What was classified? | INT (post H-INTAKE) | Session summary |
| What was discovered? | DISC (post H-FRAME) | Notes in prompt |
| What did human approve? | WR `approvals[]` + ORS `gate_history` | Verbal ack |

### Write responsibility (MUST)

- Producing skill writes its primary OUT-* artifact and updates WR
- Orchestrator writes ORS each tick
- Humans write gate decisions via `record_gate` or WR approval block

### `persist: pending` (MUST)

When agent cannot write files: handoff MUST flag `persist: pending` with full artifact body in OUT. Next tick or human persists before gate.

### Revision (MUST)

- WR and domain artifacts increment `revision` on semantic change
- ORS `revision` increments each tick
- Append-only: `approvals[]`, `gate_history`, `playbook_history`

### Cross-session resume (MUST)

Resume loads: ORS → WR → linked artifacts per `context_reload_list`. Chat history is not replayed.

### Isolation (MUST)

Memory is scoped to `project_root` + `work_id`. No cross-project WR links unless human cites in INT.

## Examples

```yaml
# WR memory index
artifacts:
  - type: INT
    path: work/intake/WR-FEATURE-001.md
  - type: DISC
    path: work/discovery/WR-FEATURE-001.md
```

## Exceptions

- Ephemeral tick logs MAY rotate — ORS remains authoritative for position
- Meta review reports MAY live in `work/meta/` or OS `reviews/` per **STD-META-001**
- Batch maintenance: child WRs link via `parent_run_id` (max depth 2 per `gates.yaml`)

## Validation

| Check | Pass |
|-------|------|
| M-MEM-01 | Handoff lists artifact paths |
| M-MEM-02 | No "remember from chat" in prompts |
| M-MEM-03 | `revision` bumps on revise loop |
| M-MEM-04 | Gate decisions in `approvals[]` or `gate_history` |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-ARTIFACT-001 | WR/ORS field shapes |
| STD-CTX-001 | Reload list on resume |
| STD-LOG-001 | Tick log vs durable state |
| STD-PROMPT-001 | Stop after persist + handoff |
| STD-WF-001 | Phase encoded in ORS |