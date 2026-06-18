# Team Onboarding — Mac + Ubuntu

One checklist for **new** and **existing** projects. Steps 1–3 are the same on every machine; step 4 splits by project type.

**Time:** ~10 minutes per machine · **Per project:** bind once, kickoff once.

---

## Choose your path

| | **New project** | **Existing project** |
|---|-----------------|----------------------|
| **You have** | Empty folder or a new idea | Code already (e.g. Odoo addon, API, app) |
| **Bind** | `cd ~/projects/my-app && ai-new` | `cd /path/to/repo && ai-new` |
| **Grill** | `/grill-me` — use cases, MVP, flows | `/grill-with-docs` — explore code, glossary, goals |
| **In chat** | `New project: <one-line idea>` | `Existing project: <what it is> — <goal>` |
| **Example** | `New project: Auction alerts — email when outbid` | `Existing project: Odoo auction addon — add buy-now` |

> Bind the **project repo** (e.g. auction module), not a parent install (e.g. full Odoo tree).

---

## Part A — Each machine (once)

Same for new and existing projects.

### 1. Clone the OS repo

| Machine | Command |
|---------|---------|
| **Ubuntu** | `git clone git@github.com:imranappdeveloper/ai-development-system.git ~/ai-development-system` |
| **Mac** | Same path recommended: `~/ai-development-system` |

After updates: `cd ~/ai-development-system && git pull`

### 2. Install CLI + skills

```bash
cd ~/ai-development-system
./scripts/install-cli.sh
source ~/.zshrc    # Mac
source ~/.bashrc   # Ubuntu
```

Installs: `ai-new`, `ai-paths`, `check-cli`, all bundled skills from `skills/MANIFEST.yaml` → synced to `~/.grok/skills/`

### 3. Verify CLI

```bash
check-cli
ai-paths check
```

| Result | Action |
|--------|--------|
| `check-cli` **fails** | Re-run `./scripts/install-cli.sh`, then `source` your shell rc |
| `ai-paths check` warns | `install-cli.sh` sets `AI_DEV_OS_HOME` in `~/.zshrc` / `~/.bashrc` — `source` again |

`/setup-ads` stops at step 1 if `check-cli` fails.

---

## Part B — New project

### 4a. Scaffold + bind

**Option A — current folder (already empty or ready):**

```bash
mkdir -p ~/projects/my-app && cd ~/projects/my-app
ai-new
```

**Option B — create subfolder with idea:**

```bash
cd ~/projects
ai-new my-app "Auction alerts — email when outbid"
cd my-app
```

Creates: `AGENTS.md`, `ai-dev-os.yaml`, `work/`, `docs/`, `.gitignore`, `git init` if needed.

### 5a. Kickoff

```bash
grok
```

```text
/setup-ads
New project: Auction alerts — email when outbid
```

**What happens:** `check-cli` → `ai-new` → **`/setup-matt-pocock-skills`** → **`/grill-me`** → `CONTEXT.md` → **`yes`** → task list → **Start AFK**

### 6a. Commit (when ready)

```bash
git add AGENTS.md ai-dev-os.yaml ai-dev-os.local.yaml.example .gitignore CONTEXT.md
git commit -m "Bind AI Dev OS + kickoff context"
```

---

## Part C — Existing project

### 4b. Bind (additive — no overwrites)

```bash
cd /path/to/your-repo    # e.g. ~/odoo/odoo/auction — the module repo only
ai-new
```

`ai-new` is idempotent — safe on repos that already have code:

| File | Behavior |
|------|----------|
| Your code | **Untouched** |
| `AGENTS.md` | **Merges** missing OS blocks — keeps your custom/Odoo rules |
| `ai-dev-os.yaml` | **Kept as-is** if present — never overwritten |
| `work/`, `docs/`, `.gitignore` | Created if missing |

```bash
git add AGENTS.md ai-dev-os.yaml ai-dev-os.local.yaml.example .gitignore
git commit -m "Bind AI Dev OS (portable paths)"
```

### 5b. Kickoff

```bash
grok
```

```text
/setup-ads
Existing project: Odoo auction addon — add buy-now price on lots
```

**What happens:** `check-cli` → `ai-new` → **`/setup-matt-pocock-skills`** → **`/grill-with-docs`** → `CONTEXT.md` → **`yes`** → task list → **Start AFK**

Re-run `/setup-ads` anytime you start a new goal on the same codebase.

---

## Part D — New machine (team member or laptop switch)

Applies after the project is already bound in git — typical for **existing** projects; same steps for **new** projects once committed.

```bash
# 1. OS on this machine
cd ~/ai-development-system && git pull
./scripts/install-cli.sh && source ~/.zshrc   # or ~/.bashrc
check-cli

# 2. Project repo
cd /path/to/your-project && git pull
ai-new    # merges any new OS blocks into AGENTS.md; skips unchanged files

# 3. Grok
grok
/setup-ads
Existing project: <codebase> — <what you want next>
```

Never commit machine paths (`/Users/...`, `/data/...`) — use `$AI_DEV_OS_HOME`.  
Details: [MULTI-MACHINE.md](./MULTI-MACHINE.md)

---

## Bug fixes (new or existing — any time)

```text
Bug Fix: <what's broken>
Details: <steps to reproduce>
```

Automatic: triage → diagnose → fix options → **Start coding** — max 2 decision points.  
Spec: [BUG-FIX.md](./BUG-FIX.md) · [USER-FLOW.md](./USER-FLOW.md)

---

## Quick reference

| Command / phrase | New | Existing |
|------------------|-----|----------|
| `ai-new` | Scaffold empty folder | Add OS files to repo with code |
| `/setup-ads` | ✅ | ✅ |
| `New project: …` | ✅ kickoff phrase | — |
| `Existing project: …` | — | ✅ kickoff phrase |
| `/grill-me` | ✅ auto | — |
| `/grill-with-docs` | — | ✅ auto |
| `A` / `B` / `C` | ✅ forks | ✅ forks |
| **Start AFK local / server** | ✅ batch features | ✅ batch features |
| `/task-run` | New chat — task manager | New chat — task manager |
| **Start coding** | bugs / single task | bugs / single task |
| `Bug Fix: …` | ✅ | ✅ |

AFK: [AFK-TASK-RUN.md](./AFK-TASK-RUN.md) · Flow: [USER-FLOW.md](./USER-FLOW.md)

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `command not found: ai-new` | `install-cli.sh` + `source ~/.zshrc` |
| `command not found: ai-paths` | `git pull` in OS repo, re-run `install-cli.sh` |
| `/setup-ads` stops immediately | Run `check-cli` — follow install instructions |
| Stale `AGENTS.md` after OS upgrade | `ai-new` in project dir — merges missing blocks |
| Bound wrong directory | `cd` to module/project root, run `ai-new` again |
| Agent missing OS footer | [OS-STATUS-FOOTER.md](./OS-STATUS-FOOTER.md) |

---

**Owner:** Platform · **Consumers:** Team members on Mac or Ubuntu