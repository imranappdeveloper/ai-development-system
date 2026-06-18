# AFK Task Run — Task Manager

Autonomous implementation after human grill + GitHub issues published. **No questions during run.**

| Phase | Where | Who |
|-------|-------|-----|
| Grill + publish | Main Grok chat | You + agent |
| Execute queue | **New** Grok chat `/task-run` | Task manager + subagents |
| Merge PRs | GitHub | You |

---

## Prerequisites

1. **Per project:** `/setup-matt-pocock-skills` — runs automatically in `/setup-ads` Phase 1.5 → `docs/agents/` + GitHub labels
2. **Per machine:** `install-cli.sh` installs all skills from `$AI_DEV_OS_HOME/skills/MANIFEST.yaml` (no external deps)
3. `gh` authenticated; `dev` branch on project repo
4. Child issues published (`/plan-to-issue-v2 --auto --lean` or `/to-issues`)
5. Each AFK task: label `ready-for-agent`, `## Blocked by` set, fat acceptance criteria
6. You confirmed short task list + dependencies

---

## Human handoff

After task list:

```text
A) Start AFK local
B) Start AFK server
C) Not yet
```

### Local (watch, 1 at a time)

```bash
cd /path/to/project
task-run.sh 42 --local
```

Open **new Grok chat** → paste handoff from `work/task-run/epic-42-handoff.md`:

```text
/task-run 42 --local
project_root: /path/to/project
```

### Server (AFK, up to 3 parallel)

```bash
cd /path/to/project
task-run.sh 42 --server --detach
tmux attach -t task-run-epic-42
# run grok, paste handoff block
```

---

## What task manager does

1. Fetch epic children; **state sync** (merged PRs → `done`)
2. Build graph from `## Blocked by`
3. Queue: **unblocked** + `ready-for-agent` only
4. **Local:** 1 subagent at a time | **Server:** ≤3 parallel (worktrees, no file overlap)
5. Subagent: issue body + `CONTEXT.md` + `/tdd`
6. PR → label `pr-open` — **you merge**, not the agent
7. `needs-info` on issue + comment on epic → **continue** other tasks
8. Loop until queue empty

Skill: `$AI_DEV_OS_HOME/skills/task-run/SKILL.md`
Implementation patterns: `work-to-pr-v2`, `issue-processor`

---

## After you merge PRs

```bash
task-run.sh 42 --local --continue
# or server:
task-run.sh 42 --server --detach --continue
```

New chat:

```text
/task-run 42 --continue --local
project_root: /path/to/project
```

---

## Issue labels

```
ready-for-agent → in-progress → pr-open → done
                      ↓
                  needs-info
```

| Label | Meaning |
|-------|---------|
| `ready-for-agent` | Runnable now |
| `in-progress` | Subagent claimed |
| `pr-open` | Awaiting your merge |
| `done` | Merged to `dev` |
| `needs-info` | Spec gap — fix on GitHub, then re-label |

---

## Install

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh
source ~/.zshrc   # or ~/.bashrc
```

Verifies: `check-cli` (all skills in `skills/MANIFEST.yaml`) and `which task-run`

---

## References

| Skill | Role |
|-------|------|
| `/plan-to-issue-v2` | Grill + publish epic + children |
| `/to-issues` | Vertical slices + dependencies |
| `/task-run` | Task manager loop |
| `/work-to-pr-v2` | Per-issue PR + state machine |
| `/issue-processor` | Batch subagent pattern |