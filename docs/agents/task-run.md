# Server AFK — task-run

Configured by **`/setup-ads` Phase 1.6** (`setup-task-run.sh`).

## Agent

| Field | Value |
|-------|-------|
| Runtime | Grok Build (`grok`) |
| Config | `ai-dev-os.yaml` → `task_run.agent` |
| Auto-poll | `false` |

## Commands (Ubuntu server)

```bash
cd /Users/imran/Documents/projects/ai-development-system

# Start now — all ready-for-agent tickets:
task-run-server.sh --agent grok

# One epic:
task-run-server.sh --agent grok --epic <N>

# Resume after interruption (optional):
task-run-server.sh --agent grok --continue

# Status / attach:
task-run-server.sh --status
task-run-server.sh --attach
```

## Auto-poll

When `task_run.auto_poll: true`, install cron from `work/task-run/cron.example`.

```bash
task-run-poll.sh --agent grok --dry-run
```

## Skills (load from $AI_DEV_OS_HOME/skills/)

| Skill | Role |
|-------|------|
| `task-run` | Task manager loop |
| `work-to-pr-v2` | Per-issue PR + state machine |
| `tdd` | Subagent implementation |
| `issue-spec-review` | Preflight |
| `pr-readiness-check` | Before PR |

## Labels

Issues must use `ready-for-agent` and `## Blocked by` per `docs/agents/triage-labels.md`.

Full guide: `$AI_DEV_OS_HOME/docs/AFK-TASK-RUN.md`
