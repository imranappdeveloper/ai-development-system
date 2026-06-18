# Feature Planner Fixtures

| Path | Purpose |
|------|---------|
| [decision-matrix.yaml](./decision-matrix.yaml) | Machine-readable routing rules for `PB-draft-feature` vs `PB-decompose-issues` |

## Decision Matrix Usage

1. Load when `routing_confidence` would be below `high`
2. Match `when` clauses against work context (phase, workflow_id, artifacts, gates)
3. Emit `routing_resolution` per matched rule `id`
4. **Never** treat matrix match as permission to invoke `PB-feature-planner`

## Fixture Conventions

- `resolve` values are invokable routing IDs or documented siblings (`PB-draft-prd`, `PB-implement`)
- `none_redirect` means block and list `blockers` — human or Plan-phase skill required
- Rules DM-01 through DM-08 align with golden example `umbrella-routing-decision-001.md`

## Project Fixtures

No `fixtures/projects/` tree required for umbrella — routing is artifact-type based, not repo-specific. Child playbooks add project fixtures at their promotion.