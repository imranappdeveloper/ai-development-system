# Meta Skills (`MS-*`)

Review and governance skills that run **before and alongside** delivery skill builds. SSOT specs live in `playbooks/meta-*/` per STD-META-001.

## Catalog

| Folder | skill_id | SSOT |
|--------|----------|------|
| [architecture-review](./architecture-review/) | MS-architecture-review | `playbooks/meta-architecture-review/` |
| [dependency-analysis](./dependency-analysis/) | MS-dependency-analysis | `playbooks/meta-dependency-analysis/` |
| [standards-review](./standards-review/) | MS-standards-review | `playbooks/meta-standards-review/` |
| [workflow-review](./workflow-review/) | MS-workflow-review | `playbooks/meta-workflow-review/` |
| [repository-review](./repository-review/) | MS-repository-review | `playbooks/meta-repository-review/` |
| [quality-review](./quality-review/) | MS-quality-review | `playbooks/meta-quality-review/` |

## Lifecycle

Every skill uses: **Design → Review → Gap Analysis → Improve → Test → Stress Test → Freeze → Publish**

See [LIFECYCLE.md](./LIFECYCLE.md) and [SKILL-CATALOG.yaml](./SKILL-CATALOG.yaml).

## Build order

1. All six meta skills (phase: Design)
2. Project Orchestrator (`playbooks/project-orchestrator/`)
3. Delivery skills per `build_order` in catalog (Discovery already built — lifecycle test→publish only)