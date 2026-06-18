# AI Development OS v1.0

A vendor-agnostic **AI Development Operating System** — workflows, playbooks, human gates, templates, and standards for structured AI-assisted software delivery.

| Field | Value |
|-------|-------|
| version | **1.0.0** |
| status | **frozen** |
| freeze_date | 2026-06-18 |
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

1. Set `AI_DEV_OS_HOME` to this repository
2. Follow [Getting Started](./docs/GETTING-STARTED.md) — intake → gates → `work/` artifacts
3. Read [FOUNDATION.md](./FOUNDATION.md) — freeze manifest
4. Browse [INDEX.md](./INDEX.md) — full catalog

---

## v1.0 Release Bundle

Frozen artifacts: [`release/v1.0/`](./release/v1.0/)

| Document | Description |
|----------|-------------|
| Platform Manifest | Identity, scope, sign-off |
| Version Report | Component versions |
| Architecture Report | Layer model, gates, flows |
| Dependency Graph | Skill/workflow ordering |
| Skill Registry | 32 delivery + 6 meta skills |
| Workflow Registry | 14 workflows |
| Standards Registry | 18 standards |
| Roadmap v2 | v1.1 → v2.0 plan |
| Future Enhancements | Post-freeze backlog |

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
| `skills/` | Platform adapter pointers (not SSOT) |
| `scripts/` | CI validation scripts |

---

## CI Validation

```bash
./scripts/verify-catalog.sh
./scripts/sync-routing-graph.sh
./scripts/simulate-workflow.sh all
```

---

## Roadmap

v1.0 is frozen. See [release/v1.0/ROADMAP-v2.md](./release/v1.0/ROADMAP-v2.md) for v1.1+.