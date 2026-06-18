# Implementation Fixtures

| Path | Purpose |
|------|---------|
| [decision-matrix.yaml](./decision-matrix.yaml) | Machine-readable lane routing rules for `PB-implement-*` children |

## Decision Matrix Usage

1. Load when `routing_confidence` would be below `high`
2. Match `when` clauses against work context (phase, workflow_id, artifacts, lane_signals, gates)
3. Emit `routing_resolution` per matched rule `id`
4. **Never** treat matrix match as permission to invoke `PB-implement`

## Fixture Conventions

- `resolve` values are invokable lane routing IDs or `multi_lane` / `none_redirect`
- `none_redirect` means block and list `blockers` — human or upstream skill required
- Rules DM-01 through DM-12 align with golden example `implement-routing-decision-001.md`

## Project Fixtures

No `fixtures/projects/` tree required for umbrella — routing is artifact-type and ISS-tag based, not repo-specific. Lane child playbooks add project fixtures at their promotion.