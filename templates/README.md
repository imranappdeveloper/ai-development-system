# Templates Catalog

Reusable document skeletons for the AI Dev OS. Templates define **shape and guidance only** — not filled content.

## Conventions

| Rule | Description |
|------|-------------|
| Placeholders | `{{field_name}}` — replace when filling |
| Instructions | `[TODO: …]` — delete when complete |
| IDs | `TP-<kebab-name>` registered in root `INDEX.md` |
| Approval | Every template includes `## Human Approval` |
| References | Every template includes `## References` |

## Catalog

| ID | Path | Document | SDLC use |
|----|------|----------|----------|
| TP-intake | `intake/` | Intake (INT) | Intake phase — PB-intake-classify |
| TP-WR | `work-record/` | Work Record | All workflows — project state |
| TP-ORS | `orchestrator-run-state/` | Orchestrator Run State | ORCH-PROJECT run control |
| TP-vision | `vision/` | Product Vision | New project, major initiative |
| TP-discovery | `discovery/` | Discovery | Intake, Frame, Plan |
| TP-prd | `prd/` | PRD | Features, enhancements |
| TP-req-lock | `requirement-lock/` | Requirement Lock | Grill SSOT before issue publish; AFK execution contract |
| TP-architecture | `architecture/` | Architecture | New project, features, refactors |
| TP-database | `database/` | Database | Schema design, migrations |
| TP-api | `api/` | API | API design, contract changes |
| TP-feature | `feature/` | Feature Specification | Feature slices, enhancements |
| TP-testing | `testing/` | Testing | Implement, Verify |
| TP-review | `review/` | Review | Verify |
| TP-doc-plan | `doc-plan/` | Documentation Plan | WF-DOCS — PB-draft-doc-update |
| TP-release | `release/` | Release | Ship |
| TP-maintenance | `maintenance/` | Maintenance | Operate, maintenance cycles |

## Usage

1. Copy `template.md` to project artifact path (do not edit master template).
2. Fill `{{placeholders}}`; remove `[TODO]` instructions.
3. Link artifact in Work Record.
4. Obtain human approval at workflow gate before downstream skills run.

## Authoring New Templates

Copy `_template/` and register in this catalog and root `INDEX.md`.