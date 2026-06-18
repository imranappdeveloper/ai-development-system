# PB-survey-codebase

| Field | Value |
|-------|-------|
| skill_id | `PB-survey-codebase` |
| name | Survey Codebase |
| phase | Frame (optional pre-step) |
| exit_gate | `none` — advisory SURVEY artifact |
| checklist_id | `CL-SURVEY` |
| status | `active` |
| spec_version | 1.0.0 |

Optional **bounded codebase survey** before discovery or planning. Produces SURVEY at `{project_root}/work/survey/{work_id}.md`.

## Quick Reference

| Item | Value |
|------|-------|
| Requires | INT, H-INTAKE, PB-intake-classify |
| Produces | SURVEY |
| Next (recommend) | PB-discovery-research |
| Human gate | None |

## Spec Index

| Doc | Purpose |
|-----|---------|
| [01-purpose.md](./01-purpose.md) | When / why survey |
| [04-io-contract.md](./04-io-contract.md) | SURVEY I/O |
| [05-context.md](./05-context.md) | **T3 allowlist + caps** |
| [09-system-prompt.md](./09-system-prompt.md) | Agent prompt |
| [11-test-plan.md](./11-test-plan.md) | HT / ET / FT suites |

## Boundaries

- Bounded T3 read per `05-context.md` (40 files, 2,400 lines max)
- No PRD, architecture spec, or code dumps in SURVEY
- No human gate fabrication (`exit_gate: none`)
- No routing matrix in output

## Graph Reference

See `workflows/project-orchestrator/skill-dependency-graph.yaml` → `skills.PB-survey-codebase`.

## Related

- Routing: `workflows/project-orchestrator/routing-matrix.yaml`
- Artifact: `ARTIFACT-REGISTRY.yaml` → SURVEY
- Checklist: `checklists/survey.md`