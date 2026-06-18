# Skills (Platform Adapters)

This directory is **not** the specification source of truth.

| Use | Path |
|-----|------|
| Playbook specs (SSOT) | `../playbooks/<name>/` |
| Workflow/template index | `../INDEX.md` |
| Platform skill bundles | Copy or symlink from `playbooks/` here |

**Discovery:** `PB-discovery-research` → `../playbooks/discovery-research/`

**Meta skills:** `skills/meta-skill/` → `../playbooks/meta-*/` (see [meta-skill/README.md](./meta-skill/README.md))

**Build catalog:** [meta-skill/SKILL-CATALOG.yaml](./meta-skill/SKILL-CATALOG.yaml)

Do not author numbered spec files (`01-purpose.md`, etc.) in this directory.