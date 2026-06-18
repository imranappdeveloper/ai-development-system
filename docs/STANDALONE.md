# Standalone — Single Source of Truth

**This repository is the only source of truth** for AI Dev OS operations. No external skill packs, agent-skill repos, or third-party paths are required.

---

## What lives here (SSOT)

| Asset | Path | Purpose |
|-------|------|---------|
| User flows | `docs/` | How users and agents interact |
| Bundled skills | `skills/` + `skills/MANIFEST.yaml` | All slash-command skills |
| Playbooks | `playbooks/` | Internal agent specs (users never read) |
| Workflows | `workflows/` | Phase DAGs, routing, gates |
| Templates | `templates/` | Project binding, artifacts |
| CLI | `scripts/` | `install-cli`, `ai-new`, `check-cli`, `task-run` |
| Standards | `standards/` | Engineering rules |

**Agents load skills from:** `$AI_DEV_OS_HOME/skills/<name>/SKILL.md`

**Never load from:** `~/.agent-skills/`, external git repos, or copied skill packs.

---

## Runtime dependencies (outside this repo)

| Dependency | Required for | Notes |
|------------|--------------|-------|
| `bash`, `git` | CLI, version control | Always |
| `gh` | GitHub issues + AFK PR flow | Per-project; optional for non-GitHub |
| Grok / Antigravity | Agent chat | IDE — not bundled |
| `tmux` | Server AFK detach | Optional |

Nothing else from the internet at runtime except your git remote and GitHub API.

---

## One-time machine setup

```bash
git clone git@github.com:imranappdeveloper/ai-development-system.git ~/ai-development-system
cd ~/ai-development-system
./scripts/install-cli.sh
source ~/.zshrc   # or ~/.bashrc
check-cli
./scripts/verify-standalone.sh
```

`install-cli.sh` syncs `skills/` → `~/.grok/skills/` **only** so Grok discovers slash commands. The OS repo remains SSOT — re-run `install-cli.sh` after every `git pull`.

---

## Per-project setup (all from this OS)

```bash
cd /path/to/your-project
ai-new                    # bind AGENTS.md, ai-dev-os.yaml
/setup-ads                # in Grok chat
```

Inside `/setup-ads`:

1. `check-cli`
2. `ai-new`
3. `/setup-project-agents` → `docs/agents/` (issue tracker, labels, standards)
4. Grill → tasks → Start AFK

All skills invoked are in `skills/MANIFEST.yaml`.

---

## Verify standalone

```bash
./scripts/verify-standalone.sh   # no external skill refs; manifest complete
check-cli                        # CLI + 18 bundled skills
```

---

## After `git pull`

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh && source ~/.zshrc
check-cli
```

On bound projects: `ai-new` merges new `AGENTS.md` blocks.

---

## Hierarchy

```
ai-development-system/     ← SSOT (this repo)
├── skills/              ← all agent skills
├── docs/                ← user + agent SSOT docs
├── playbooks/           ← internal execution specs
└── scripts/             ← CLI entrypoints

your-project/            ← bound via ai-new
├── AGENTS.md            ← points to $AI_DEV_OS_HOME
├── docs/agents/         ← per-project tracker + labels
└── work/                ← runtime artifacts
```