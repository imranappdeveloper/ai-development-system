# Multi-Machine Setup (Mac + Ubuntu)

Projects move between machines. **Never commit machine-specific paths** in `ai-dev-os.yaml` or `AGENTS.md`.

---

## Model

```
┌─────────────────────────────────────────────────────────┐
│  Each machine (once)                                    │
│  export AI_DEV_OS_HOME=~/ai-development-system          │
│  (install-cli.sh writes ~/.zshrc or ~/.bashrc)          │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│  Project repo (git — same on Mac & Ubuntu)                │
│  ai-dev-os.yaml      → paths: env:AI_DEV_OS_HOME, auto    │
│  AGENTS.md           → resolve $AI_DEV_OS_HOME at runtime │
│  ai-dev-os.local.yaml → optional, gitignored per machine │
└─────────────────────────────────────────────────────────┘
```

| File | Commit? | Purpose |
|------|---------|---------|
| `ai-dev-os.yaml` | ✅ yes | Portable binding (`env:AI_DEV_OS_HOME`, `project_root: auto`) |
| `ai-dev-os.local.yaml` | ❌ no | Optional cache of paths on this host |
| `ai-dev-os.local.yaml.example` | ✅ yes | Template for local override |

---

## One-time per machine

### Ubuntu

```bash
git clone git@github.com:imranappdeveloper/ai-development-system.git ~/ai-development-system
~/ai-development-system/scripts/install-cli.sh
source ~/.bashrc
ai-paths check
```

### Mac

```bash
git clone git@github.com:imranappdeveloper/ai-development-system.git ~/ai-development-system
~/ai-development-system/scripts/install-cli.sh
source ~/.zshrc
ai-paths check
```

Same repo path on both machines is **recommended** (`~/ai-development-system`) but not required — only `AI_DEV_OS_HOME` must point to the clone on that machine.

---

## Per project (once, portable)

```bash
cd /path/to/your-app
ai-new
git add ai-dev-os.yaml AGENTS.md ai-dev-os.local.yaml.example .gitignore
git commit -m "Bind AI Dev OS (portable paths)"
```

---

## Switching machines

```bash
# 1. Pull project repo
cd ~/projects/auction && git pull

# 2. Ensure OS + env on THIS machine
cd ~/ai-development-system && git pull
source ~/.zshrc   # or ~/.bashrc on Ubuntu
ai-paths check

# 3. Optional: cache paths for this host
cd ~/projects/auction
ai-paths sync

# 4. Work
grok
```

No manual path editing in yaml.

---

## Commands

| Command | Purpose |
|---------|---------|
| `ai-paths` | Show resolved OS home + project root |
| `ai-paths check` | Fail if `AI_DEV_OS_HOME` missing |
| `ai-paths sync` | Write `ai-dev-os.local.yaml` (gitignored) |
| `ai-paths machine-setup` | Print exports for shell profile |

---

## Agent path resolution order

1. `$AI_DEV_OS_HOME` from environment
2. `ai-dev-os.local.yaml` (if env unset)
3. `project_root` = directory containing `AGENTS.md`

---

## Migrate old projects (hardcoded paths)

If `ai-dev-os.yaml` has `/Users/...` or `/data/...`:

```bash
cd ~/ai-development-system && git pull
cd your-project
ai-new                    # keeps files; won't overwrite
ai-paths sync
```

Replace committed `ai-dev-os.yaml` with portable template from OS repo, or edit to use `paths: env:AI_DEV_OS_HOME` (see `templates/project-starter/ai-dev-os.yaml`).

---

## References

| Doc | Topic |
|-----|-------|
| [GETTING-STARTED.md](./GETTING-STARTED.md) | Install |
| [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) | Kickoff |