# STD-NAMING-001 — Naming

| Field | Value |
|-------|-------|
| standard_id | STD-NAMING-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Establish a single, machine- and human-readable naming scheme for identifiers, paths, and enums across the OS so catalogs, orchestrator routing, and agents stay aligned.

## Scope

- Applies to: `AI_DEV_OS_HOME`, project artifacts, INDEX, registries, workflows
- Excludes: application code style inside target repos (use project conventions there)
- Defers skill folder layout to **STD-SKILL-001** — this standard defines **identifier patterns** only

## Rules

### Identifier prefixes (MUST)

| Prefix | Pattern | Example | Immutable after `active` |
|--------|---------|---------|--------------------------|
| `PB-` | `PB-<kebab-case>` | `PB-intake-classify` | yes |
| `MS-` | `MS-<kebab-case>` | `MS-architecture-review` | yes |
| `ORCH-` | `ORCH-<UPPER>` | `ORCH-PROJECT` | yes |
| `WF-` | `WF-<UPPER-KEBAB>` | `WF-FEATURE` | yes |
| `TP-` | `TP-<kebab>` | `TP-intake` | yes |
| `CL-` | `CL-<SHORT>` | `CL-INTAKE` | yes |
| `STD-` | `STD-<DOMAIN>-<NNN>` | `STD-NAMING-001` | on major only |
| `H-` | `H-<PHASE>` | `H-INTAKE` | yes |
| Artifact type | `UPPER-KEBAB` | `SEC-ASSESS` | yes |

### Paths (MUST)

| Asset | Pattern |
|-------|---------|
| Playbook SSOT | `playbooks/<kebab-name>/` |
| Workflow | `workflows/WF-<NAME>/` |
| Template | `templates/<kebab>/template.md` |
| Checklist | `checklists/<kebab-short>.md` |
| Project INT | `work/intake/{work_id}.md` |
| Project WR | `work/{work_id}.md` |
| Project ORS | `work/orchestrator/{work_id}.ors.md` |

Path segments: **lowercase kebab-case** only. No spaces, no camelCase in OS paths.

### Enums (MUST)

- Lowercase snake_case values: `new_project`, `intake_pending_review`
- Enum SSOT: skill `registry.yaml` → `enums:` — not duplicated in three spec files
- Workflow IDs in INT MUST match INDEX exactly

### Work IDs (SHOULD)

- Pattern: `WR-<SLUG>-<NNN>` or project convention documented in WR
- One `work_id` per classified work item — no merged types

## Examples

| Good | Bad | Why |
|------|-----|-----|
| `PB-draft-prd` | `PB-PRD` | kebab-case required |
| `workflows/WF-BUGFIX/` | `workflows/bugfix/` | missing WF- prefix in folder name |
| `classification_confidence: high` | `High` | enum case |
| `STD-CTX-001` | `STD-CONTEXT` | domain + number required |

## Exceptions

- Legacy aliases in adapter `skills/` MAY differ if `registry.yaml` maps to canonical `PB-*`
- Target project code naming follows project `CONTEXT.md` — not this standard
- `PB-feature-planner` is an **umbrella** label only — routing IDs are `PB-decompose-issues`, `PB-draft-feature`

## Validation

| Check | Method |
|-------|--------|
| ID format | Regex: `^(PB|MS)-[a-z0-9-]+$`, `^WF-[A-Z-]+$` |
| Path kebab | No `[A-Z_]` in OS path segments |
| INDEX ↔ disk | Every INDEX playbook row has matching `playbooks/<folder>/` |
| Enum drift | `registry.yaml` enums ⊆ prompt references |

MS-standards-review applies this standard during OS audits.

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-SKILL-001 | Skill folder and `skill_id` immutability |
| STD-ARTIFACT-001 | Artifact type codes and paths |
| STD-DOC-001 | Document IDs in metadata tables |
| STD-VER-001 | Renaming = breaking change rules |
| STD-WF-001 | `workflow_id` enum binding |