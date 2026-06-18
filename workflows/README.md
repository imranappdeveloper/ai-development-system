# Workflows

Workflow engine for the AI Dev OS — specifications + execution DAGs. **Does not implement skills.**

| Path | Purpose |
|------|---------|
| [ENGINE.md](./ENGINE.md) | Workflow engine architecture |
| [WORKFLOW-REGISTRY.yaml](./WORKFLOW-REGISTRY.yaml) | Machine catalog |
| [WORKFLOW-SPEC-SCHEMA.md](./WORKFLOW-SPEC-SCHEMA.md) | Reusable spec schema |
| [_spec-template.yaml](./_spec-template.yaml) | Authoring template |
| [specs/](./specs/) | Normative workflow specifications |
| [WF-*/](./) | Per-workflow `phases.yaml` execution DAG |
| [project-orchestrator/](./project-orchestrator/) | Routing, gates, orchestrator design |

## User-facing catalog

| Business name | workflow_id | Class | Spec | Terminal |
|---------------|-------------|-------|------|----------|
| New Project | WF-PROJECT-NEW | end-to-end | [spec](./specs/WF-PROJECT-NEW.yaml) | H-PLAN |
| Existing Project | WF-PROJECT-EXISTING | end-to-end | [spec](./specs/WF-PROJECT-EXISTING.yaml) | H-FRAME |
| Discovery / Research | WF-DISCOVERY | slice | [spec](./specs/WF-DISCOVERY.yaml) | H-FRAME |
| PRD | WF-PRD | slice | [spec](./specs/WF-PRD.yaml) | H-PLAN |
| Feature | WF-FEATURE | end-to-end | [spec](./specs/WF-FEATURE.yaml) | H-SHIP |
| Enhancement | WF-ENHANCEMENT | end-to-end | [spec](./specs/WF-ENHANCEMENT.yaml) | H-PLAN |
| Bug Fix | WF-BUGFIX | end-to-end | [spec](./specs/WF-BUGFIX.yaml) | H-VERIFY |
| Refactor | WF-REFACTOR | end-to-end | [spec](./specs/WF-REFACTOR.yaml) | H-PLAN |
| Testing | WF-TESTING | slice | [spec](./specs/WF-TESTING.yaml) | H-VERIFY |
| Release | WF-RELEASE | operate | [spec](./specs/WF-RELEASE.yaml) | H-OPERATE |
| Maintenance | WF-MAINTENANCE | operate | [spec](./specs/WF-MAINTENANCE.yaml) | H-OPERATE |

**Research** = **Discovery** (`WF-DISCOVERY`, skill `PB-discovery-research`).

## Extended (phases only — spec pending)

| workflow_id | Path |
|-------------|------|
| WF-SECURITY | `WF-SECURITY/phases.yaml` |
| WF-PERF | `WF-PERF/phases.yaml` |
| WF-DOCS | `WF-DOCS/phases.yaml` |

## SSOT chain

```text
specs/WF-*.yaml  →  normative (inputs, gates, standards)
WF-*/phases.yaml →  execution DAG for ORCH-PROJECT
skill-dependency-graph.yaml → derived execution_graphs (must align)
```