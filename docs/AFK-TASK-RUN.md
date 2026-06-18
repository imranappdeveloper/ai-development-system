# AFK Task Run — Server Only

Autonomous implementation after human grill (`/grill-me` or `/grill-with-docs`) + GitHub issues published. **No questions during run.**

**Batch code runs on the Ubuntu server only** — not on Mac/local IDE.

| Phase | Where | Who |
|-------|-------|-----|
| Grill + publish | Any machine (Grok or Antigravity chat) | You + agent |
| Execute queue | **Server** — `task-run-server.sh` | tmux + **grok** or **agy** |
| Merge PRs | GitHub | You (optional timing — agent does not wait) |

---

## Agent choice: grok or agy

| Agent | CLI | Launch flags |
|-------|-----|--------------|
| **grok** | Grok Build | `grok --always-approve` |
| **agy** | Antigravity | `agy --print --dangerously-skip-permissions` |

Set default in project `ai-dev-os.yaml`:

```yaml
task_run:
  agent: agy   # or grok
```

Or per run: `--agent grok` / `--agent agy`  
Or env: `TASK_RUN_AGENT=agy`

Resolution order: `--agent` flag → `TASK_RUN_AGENT` → `ai-dev-os.local.yaml` → `ai-dev-os.yaml` → first CLI found on PATH.

---

## Prerequisites

1. **Per project:** `/setup-project-agents` — runs in `/setup-ads` Phase 1.5
2. **Per server:** `install-cli.sh` — `task-run-server`, `task-run-poll`, `gh`, `tmux`, **grok and/or agy**
3. `gh` authenticated on server; `dev` branch on project repo
4. Child issues published with `ready-for-agent` + `## Blocked by`

---

## Start manually

```bash
cd /path/to/project

# Grok — all ready tickets:
task-run-server.sh --agent grok

# Antigravity (agy) — all ready tickets:
task-run-server.sh --agent agy

# One epic:
task-run-server.sh --agent agy --epic 42

# Resume after interruption (optional — loop does not wait for merges):
task-run-server.sh --agent agy --continue
```

Creates tmux session `task-run-ready` or `task-run-epic-42`, auto-starts the agent.

### Monitor

```bash
task-run-server.sh --status    # health: none | healthy | stale
task-run-server.sh --attach
task-run-server.sh --stop      # kill tmux session
# logs: work/task-run/<slug>-<agent>.log
```

Stale = tmux exists but grok/agy exited and log idle > `TASK_RUN_STALE_MINUTES` (default 45).

---

## Auto-start (cron / systemd)

When work is queued, `task-run-poll.sh` starts or **resumes** the server:

| Condition | Poll action |
|-----------|-------------|
| Healthy tmux + agent running | Skip |
| Stale session (agent exited) | Kill + restart |
| `ready-for-agent` > 0 | Start (`--continue` if prior run — state sync only) |
| Stale session + work queued | Restart (no merge wait) |
| Nothing queued | Skip |

### Cron (every 15 min)

```bash
# Grok
*/15 * * * * cd /path/to/project && task-run-poll.sh --agent grok >> work/task-run/poll.log 2>&1

# Antigravity
*/15 * * * * cd /path/to/project && task-run-poll.sh --agent agy >> work/task-run/poll.log 2>&1
```

Dry run: `task-run-poll.sh --agent agy --dry-run`

### systemd timer

Templates in `$AI_DEV_OS_HOME/templates/systemd/`:

```bash
# Edit service: set WorkingDirectory + TASK_RUN_AGENT
sudo cp templates/systemd/task-run-poll@.service /etc/systemd/system/task-run-poll@.service
sudo cp templates/systemd/task-run-poll@.timer /etc/systemd/system/task-run-poll@.timer
# Set WorkingDirectory=/path/to/project and Environment=TASK_RUN_AGENT=agy in the .service file
sudo systemctl daemon-reload
sudo systemctl enable --now task-run-poll@.timer
```

---

## What task manager does

1. Fetch issues (`--ready` or epic children); state sync (legacy label repair)
2. Build graph from `## Blocked by` (`done` = PR opened satisfies blocker)
3. Queue: unblocked + `ready-for-agent` only
4. Server: ≤3 parallel (worktrees, no file overlap)
5. Subagent per issue + `/tdd` (Grok: Task tool; agy: invoke_subagent)
6. PR created → label `done` → **start next unblocked task** (no merge wait)
7. Loop until queue empty

Skill: `$AI_DEV_OS_HOME/skills/task-run/SKILL.md`

---

## Issue labels

```
ready-for-agent → in-progress → done
                      ↓
                  needs-info
```

`done` = PR opened. Human merges when ready — agent does not wait.

---

## Install (server)

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh
source ~/.bashrc
which task-run-server task-run-poll grok agy gh tmux
```

---

## References

| Skill | Role |
|-------|------|
| `/grill-me` | New project requirements |
| `/grill-with-docs` | Existing project |
| `/task-run` | Task manager (invoked by grok or agy on server) |
| `/work-to-pr-v2` | Per-issue PR flow |