---
name: setup-task-run
description: >
  Configure server AFK task-run for a project — agent choice (grok or agy),
  work/task-run/, docs/agents/task-run.md, optional cron poll. Runs in
  /setup-ads Phase 1.6 after setup-project-agents. Required before task-run-server.sh.
disable-model-invocation: true
---

# Setup Task Run — Server AFK

Invoked in **`/setup-ads` Phase 1.6** (after Phase 1.5 `setup-project-agents`, before grill).

Configures **server-only** batch implementation: `task-run-server.sh`, `task-run-poll.sh`, bundled skills.

**User never reads AFK-TASK-RUN.md** — one question at a time with **A/B** at forks.

---

## When to run

| Condition | Action |
|-----------|--------|
| `/setup-ads` Phase 1.6 | Full setup (questions below) |
| `docs/agents/task-run.md` missing | Re-run Phase 1.6 |
| User changes agent or poll preference | Re-run with new flags |

---

## Phase 1.6 questions (one at a time)

### Q1 — Server AFK agent

```text
Which agent runs tasks on the Ubuntu server?

A) grok — Grok Build CLI
B) agy — Antigravity CLI

I recommend <detected default> because it's installed on this machine.
```

Detect: `command -v grok` / `command -v agy`. If both, recommend grok unless user prefers agy.

### Q2 — Auto-poll

```text
When new ready-for-agent tickets land on GitHub, should the server auto-start AFK?

A) Yes — write cron.example (task-run-poll.sh every 15 min)
B) No — manual task-run-server.sh only

I recommend B until your first epic is published, then enable A on the server.
```

---

## Run script (after Q1 + Q2)

From `project_root`:

```bash
$AI_DEV_OS_HOME/scripts/setup-task-run.sh . \
  --agent grok|agy \
  --poll|--no-poll
```

Idempotent — safe to re-run.

---

## Writes

| Path | Purpose |
|------|---------|
| `ai-dev-os.yaml` | `task_run.agent`, `task_run.auto_poll` |
| `docs/agents/task-run.md` | Agent + commands for AFK skills |
| `work/task-run/` | Handoffs, logs, `cron.example` (if poll) |
| `docs/agents/task-run-systemd.md` | Optional systemd pointer |

---

## Verify (server)

```bash
which task-run-server task-run-poll grok agy gh tmux
task-run-server.sh --status --agent <chosen>
```

Warn (do not block setup) if server CLIs missing on **Mac** — implementation runs on **Ubuntu** anyway.

---

## Bundled skills (MANIFEST.yaml)

Ensure present via `check-cli` / `install-cli.sh`:

- `task-run`
- `work-to-pr-v2`

- `issue-spec-review`
- `pr-readiness-check`
- `tdd`

---

## Handoff to Phase 7

After issues published, user picks Start AFK — run on server:

```bash
task-run-server.sh --agent <from task_run.agent> --epic <N>
# or if auto_poll:
task-run-poll.sh --agent <agent>
```

See `$AI_DEV_OS_HOME/docs/AFK-TASK-RUN.md` (agent only).