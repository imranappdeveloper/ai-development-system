# STD-META-001 — Meta Skill Contract

| Field | Value |
|-------|-------|
| standard_id | STD-META-001 |
| extends | STD-SKILL-001@1.0.0 |
| version | 1.0.0 |
| status | active |

Meta skills (`MS-*`) **review and improve** the OS itself — they do not produce domain INT/PRD/CODE artifacts for project delivery.

## Identity

| Field | Rule |
|-------|------|
| skill_id | `MS-<kebab-name>` |
| path (SSOT) | `playbooks/meta-<kebab-name>/` |
| index path | `skills/meta-skill/<kebab-name>/` → pointer only |
| exit_gate | `H-META` or `none` |
| produces | Review reports under `{project_root}/work/meta/` or OS repo `reviews/` |

## Inherits from STD-SKILL-001

All 01–11 files, registry.yaml, lifecycle phases (Design → Publish), checklists `CL-META-*`.

## Additional non-responsibilities

- MUST NOT classify intake, write PRD, or implement features
- MUST NOT auto-modify playbooks without human approve at H-META
- MUST NOT replace Principal Architect sign-off on freeze

## Meta skill catalog

| skill_id | Purpose |
|----------|---------|
| MS-architecture-review | SRP, boundaries, OS layering |
| MS-dependency-analysis | Skill graph, routing, cycles |
| MS-standards-review | STD-SKILL-001 / contract compliance |
| MS-workflow-review | phases.yaml, gates, orchestrator |
| MS-repository-review | Repo audit, missing artifacts |
| MS-quality-review | ACs, promotion gates, test coverage |