# AI Development OS v1.1 — Release Bundle

**Frozen:** 2026-06-19 | **Status:** production release | **spec_sha:** `c969fe5de054aaac`

Immutable v1.1 freeze artifacts. Live SSOT continues at repository root; these files are reference snapshots.

**v1.0 playbook substrate** remains frozen in [`release/v1.0/`](../v1.0/) — unchanged.

## What v1.1 adds

Standalone execution layer: bundled slash skills, server AFK, user-facing flows — runnable without external skill packs.

## Documents

| File | Description |
|------|-------------|
| [PLATFORM-MANIFEST.md](./PLATFORM-MANIFEST.md) | v1.1 identity, scope, sign-off |
| [VERSION-REPORT.md](./VERSION-REPORT.md) | Component versions at freeze |
| [BUNDLED-SKILLS.yaml](./BUNDLED-SKILLS.yaml) | 19 slash skills snapshot |

## Live SSOT (evolves on main)

| Asset | Path |
|-------|------|
| Bundled skills | `skills/` + `skills/MANIFEST.yaml` |
| User flows | `docs/USER-FLOW.md`, `docs/AFK-TASK-RUN.md` |
| Server AFK | `scripts/task-run-server.sh`, `task-run-poll.sh` |
| Standalone guide | `docs/STANDALONE.md` |
| v1.0 substrate | `release/v1.0/` (immutable) |