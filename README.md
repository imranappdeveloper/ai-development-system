# AI Development OS v1.0

A vendor-agnostic **AI Development Operating System** — workflows, playbooks, human gates, templates, and standards for structured AI-assisted software delivery.

| Field | Value |
|-------|-------|
| version | **1.0.0** |
| status | **frozen** |
| version | **1.1.0** |
| freeze_date | 2026-06-19 |
| active_skills | 32 |
| workflows | 14 |

---

## Quick Start

**New or existing project?** `/setup-ads` (after one-time `install-cli.sh`):

```bash
# From any folder — creates ./my-app here:
ai-new my-app "Your idea in one line"
cd my-app && grok

# Or scaffold the current folder:
cd my-app && ai-new && grok
# chat: /setup-ads
```

→ **[docs/SETUP-ADS.md](./docs/SETUP-ADS.md)** — bind + grill (new / existing).  
**Bug fix?** → **[docs/BUG-FIX.md](./docs/BUG-FIX.md)** — `Bug Fix: …` and approve 3 cards.

**Install OS?** → **[docs/GETTING-STARTED.md](./docs/GETTING-STARTED.md)** — one-time setup.  
**Standalone SSOT?** → **[docs/STANDALONE.md](./docs/STANDALONE.md)** — everything runs from this repo only.

1. Set `AI_DEV_OS_HOME` to this repository
2. Follow [Getting Started](./docs/GETTING-STARTED.md) — intake → gates → `work/` artifacts
3. Read [FOUNDATION.md](./FOUNDATION.md) — freeze manifest
4. Browse [INDEX.md](./INDEX.md) — full catalog

---

## v1.1 Release Bundle (current)

Frozen artifacts: [`release/v1.1/`](./release/v1.1/)

| Document | Description |
|----------|-------------|
| Platform Manifest | Standalone execution scope, sign-off |
| Version Report | Component versions at freeze |
| Bundled Skills | 19 slash skills snapshot |

**v1.0 playbook substrate** (immutable): [`release/v1.0/`](./release/v1.0/)

---

## Structure

| Directory | Purpose |
|-----------|---------|
| `release/v1.0/` | Frozen v1.0 release bundle |
| `docs/` | Platform documentation |
| `workflows/` | Workflow engine + specs + phase DAGs |
| `playbooks/` | Agent skill specifications (SSOT) |
| `templates/` | Artifact templates |
| `checklists/` | Quality self-checks |
| `standards/` | Engineering standards + contracts |
| `skills/` | **Bundled slash skills (SSOT)** — 19 skills, `skills/MANIFEST.yaml` |
| `scripts/` | CLI + server AFK (`task-run-server`, `task-run-poll`) + CI validation |

---

## CI Validation

```bash
./scripts/verify-standalone.sh    # bundled skills + symlinks (v1.1 gate)
./scripts/verify-catalog.sh
./scripts/sync-routing-graph.sh
./scripts/simulate-workflow.sh all
```

---

## Roadmap

v1.1 is frozen (standalone execution). v1.0 playbook substrate unchanged. See [release/v1.0/ROADMAP-v2.md](./release/v1.0/ROADMAP-v2.md) for v1.2+.