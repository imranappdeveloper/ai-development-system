# STD-ARCH-001 — Architecture

| Field | Value |
|-------|-------|
| standard_id | STD-ARCH-001 |
| version | 1.0.0 |
| status | active |
| owner | Principal Architect |
| review_cycle | semi-annual |
| effective | 2026-06-18 |

---

## Purpose

Enforce **layering, boundaries, and dependency direction** for the OS and for architecture artifacts in projects.

## Scope

- OS repo structure (`docs/ARCHITECTURE.md` layers)
- Project architecture artifacts (`TP-architecture`)
- Excludes: workflow sequencing (**STD-WF-001**), skill SRP tables (playbook `02-responsibilities.md`)

## Rules

### OS layers (MUST)

Dependency flows **inward**:

```text
Infrastructure (skills/, adapters)
  → Interface (playbooks/, templates/, checklists/)
    → Application (orchestrator, routing, phases)
      → Domain (standards/, ARTIFACT-REGISTRY, gates)
```

- Domain MUST NOT import from playbooks
- Playbooks reference standards by ID — no forked copies
- Orchestrator reads domain SSOT — does not embed domain rules in prompts

### Single responsibility (MUST)

- One playbook = one primary artifact type in default path
- Orchestrator coordinates; does not classify, discover, or implement
- Standards layer holds normative rules; playbooks hold operational steps

### Project architecture artifacts (MUST)

`TP-architecture` documents MUST include:

- Context diagram (bounded system)
- Module/layer map with allowed dependencies
- External integrations and trust boundaries
- ADR index or decision log pointer — not full ADR duplication

### Forbidden couplings (MUST NOT)

- Playbook → playbook direct auto-chain
- `skills/` as SSOT for specs
- Project `playbooks/` copying OS specs
- Circular skill dependencies in `skill-dependency-graph.yaml`

### Extension (SHOULD)

New capabilities extend via new `PB-*` + routing row — not by expanding orchestrator domain duties.

## Examples

| Good | Bad |
|------|-----|
| INT produced only by PB-intake-classify | INT fields edited by PB-discovery-research |
| STD-SEC-001 referenced in implement prompt | Security rules copied into 09-system-prompt |
| `PB-draft-architecture` produces ARCH | PRD sections in ARCH file |

## Exceptions

- Meta skills MAY read entire OS for audit at T3 (**STD-CTX-001**)
- Thin adapters in `skills/` MAY wrap multiple playbooks for vendor limits — routing unchanged
- Emergency hotfix MAY touch two layers with architect waiver in WR

## Validation

| Check | Pass |
|-------|------|
| A-ARCH-01 | MS-architecture-review score ≥ 70 for freeze |
| A-ARCH-02 | No circular deps in skill graph |
| A-ARCH-03 | ARCH artifact lists allowed module edges |
| A-ARCH-04 | New skill has N-* non-responsibilities |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-DOC-001 | Architecture doc placement |
| STD-NAMING-001 | Module and skill IDs |
| STD-WF-001 | Phase boundaries |
| STD-REVIEW-001 | Architecture review findings |
| STD-SKILL-001 | Playbook boundary contract |