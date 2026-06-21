# Standalone — Single Source of Truth

**This repository is the only source of truth** for AI Dev OS operations. No external skill packs, agent-skill repos, or third-party paths are required.

---

## What lives here (SSOT)

| Asset | Path | Purpose |
|-------|------|---------|
| User flows | `docs/` | How users and agents interact |
| Usage feedback | `docs/USAGE-FEEDBACK.md` | Telemetry, snapshots, `/feedback`, `/usage-report` |
| Bundled skills | `skills/` + `skills/MANIFEST.yaml` | All slash-command skills |
| Playbooks | `playbooks/` | Internal agent specs (users never read) |
| Workflows | `workflows/` | Phase DAGs, routing, gates |
| Templates | `templates/` | Project binding, artifacts |
| CLI | `scripts/` | `install-cli`, `ai-new`, `sync-project`, `observe`, `check-cli`, `task-run` |
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
| `tmux` | Server AFK (`task-run-server.sh`) | Required on server |
| `grok` | Server AFK agent (Grok Build) | One of grok or agy |
| `agy` | Server AFK agent (Antigravity) | One of grok or agy |

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

`install-cli.sh` symlinks `skills/` → `~/.grok/skills/` and `~/.gemini/config/skills/` so **grok** and **agy** discover slash commands. SSOT stays in `$AI_DEV_OS_HOME/skills/` — `git pull` updates skills immediately via symlinks. Re-run `install-cli.sh` only when adding new manifest skills or fixing broken links.

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
check-cli                        # CLI + bundled skills (symlink check)
```

---

## After `git pull`

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh && source ~/.zshrc
check-cli
```

On bound projects: run **`sync-project`** (pulls OS + runs `ai-new .` + `check-integration`). See **STD-PROJ-001** — every OS feature MUST update templates, `new-project.sh` merges, `install-cli.sh`, and integration checks so sync and new projects stay current.

## OS CLI vs project data

| Layer | Location | Example |
|-------|----------|---------|
| CLI / skills | `$AI_DEV_OS_HOME` | `observe.sh`, `usage-feedback.sh`, `skills/observe/` |
| Per-project config | `your-project/ai-dev-os.yaml` | `telemetry.level`, `feedback:` |
| Per-project runtime | `your-project/work/` | `work/telemetry/runs/` |

Same `observe` command on PATH; data is **per project** based on `cwd`.

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