# STD-PROJ-001 — OS → Project Propagation

| Field | Value |
|-------|-------|
| standard_id | STD-PROJ-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-21 |

---

## Purpose

Every OS change in `AI_DEV_OS_HOME` MUST reach **bound working projects** and **new projects** through the defined propagation paths — not manual per-project edits.

## Scope

- CLI scripts in `scripts/`
- Project templates in `templates/project-starter/`
- Bundled skills in `skills/` + `skills/MANIFEST.yaml`
- OS docs copied to projects (`docs/USAGE-FEEDBACK.md`, etc.)
- `ai-new` / `sync-project.sh` merge logic

Excludes: user-authored project code, `CONTEXT.md`, approved `work/requirement-lock.md`.

## Rules

### SSOT (MUST)

| Asset | Lives in | Never duplicate into |
|-------|----------|----------------------|
| CLI (`observe.sh`, `usage-feedback.sh`, …) | `$AI_DEV_OS_HOME/scripts/` | `your-project/scripts/` |
| Skills | `$AI_DEV_OS_HOME/skills/` | per-project skill copies |
| Templates | `$AI_DEV_OS_HOME/templates/project-starter/` | committed overrides |

### New OS feature checklist (MUST)

When adding or changing OS capability, update **all** applicable:

1. `templates/project-starter/` — new keys, examples, scaffolds
2. `scripts/new-project.sh` — merge blocks for **existing** projects (additive only)
3. `scripts/install-cli.sh` — chmod + `~/.local/bin` symlinks
4. `scripts/check-integration.sh` — verify scaffolds on bound projects
5. `skills/MANIFEST.yaml` — if user-facing skill added
6. `docs/` — user doc synced by `ai-new` where applicable
7. `scripts/verify-standalone.sh` + tests — regression coverage

### Working project propagation (MUST)

| User action | Effect |
|-------------|--------|
| `/sync-project` or `sync-project.sh` | OS pull + `install-cli.sh` + `ai-new .` + `check-integration` |
| `ai-new .` alone | Merge templates into current project (idempotent) |

Agents MUST recommend `/sync-project` after OS `git pull`, not ask users to copy files by hand.

### New project propagation (MUST)

`ai-new` on empty or existing folder MUST apply current `templates/project-starter/` plus merge rules — same result as sync for scaffold items.

### Merge-only (MUST NOT)

- Overwrite user `ai-dev-os.yaml` values (merge missing blocks only)
- Overwrite `CONTEXT.md` or `work/requirement-lock.md`
- Commit `ai-dev-os.local.yaml` (gitignored per machine)

### Project-scoped data (MUST)

OS CLIs run from **any bound project root**; they read that project's `ai-dev-os.yaml` and write under that project's `work/`:

```bash
cd ~/projects/auction && observe.sh status   # auction telemetry
cd ~/projects/other   && observe.sh status   # other telemetry
```

## Examples

```bash
# After changing OS repo
cd ~/ai-development-system && git pull
cd ~/projects/my-app && sync-project

# New project
cd ~/projects && ai-new my-app "idea"
```

## Validation

| Check | Pass |
|-------|------|
| P-PROJ-01 | New feature updates templates + new-project merge |
| P-PROJ-02 | install-cli links new scripts |
| P-PROJ-03 | check-integration detects new scaffolds |
| P-PROJ-04 | sync-project runs ai-new on project |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-LOG-001 | Project `work/telemetry/` layout |
| STD-MEM-001 | Durable vs ephemeral project artifacts |