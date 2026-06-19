---
name: task-run
description: >
  AFK task manager — state sync, dependency queue, delegates each issue to full
  work-to-pr-v2 (spec review, TDD, PR readiness, PR, done at create). Server only.
  Never ask questions.
---

# Task Run — AFK Task Manager (server only)

Started on the **Ubuntu server** by `task-run-server.sh` — tmux + **grok** or **agy**. You are the **orchestrator**, not the implementer.

**Core rule:** Task **complete when PR is created** → `done` → **next unblocked issue immediately**. **Do not wait for merge.**

---

## Prerequisites

- Issues published via `/plan-to-issue-v2 --auto --lean` (canonical)
- Labels: `ready-for-agent`; bodies: `## Blocked by`
- User said **Start AFK on server**

**Read:** `work-to-pr-v2` only (it loads `issue-spec-review`, `tdd`, `pr-readiness-check`).

**Do not** use `issue-processor` or run `/tdd` alone — always delegate the full `work-to-pr-v2` per-issue loop.

---

## Server entry

```bash
task-run-server.sh --agent grok|agy [--epic N]
task-run-poll.sh --agent agy
task-run-server.sh --status
```

---

## Invocation

```text
/task-run <epic> --server
/task-run --ready --server
```

| Flag | Behavior |
|------|----------|
| `--server` | ≤3 parallel via worktrees (no file overlap) |
| `--continue` | State sync + resume after interruption |
| `--ready` | All runnable `ready-for-agent` issues |

---

## Role: orchestrator loop

```
loop:
  1. Fetch issues (epic children or --ready)
  2. State sync — work-to-pr-v2 "State sync + recovery" section
  3. Dependency graph from ## Blocked by (done = PR opened)
  4. Queue = unblocked + ready-for-agent
  5. Batch ≤3 — check file overlap per work-to-pr-v2 Parallelism
  6. Per issue: spawn subagent with work-to-pr-v2 per-issue loop (steps 1–6)
  7. needs-info → skip, continue queue
  8. Until queue empty
```

### Per-issue delegation (mandatory)

For each queued issue, spawn a **fresh subagent** (`Task` / `invoke_subagent`) with:

```text
Load and follow $AI_DEV_OS_HOME/skills/work-to-pr-v2/SKILL.md
Execute the "Per-issue loop" for issue #<N> only.
Working directory: <repo root or worktree path>
Pass --lean if epic children have AFK preflight stamps.
Do not process other issues. Do not ask questions.
```

Subagent runs the **full** pipeline: `issue-spec-review` → claim → branch/worktree → `/tdd` → `pr-readiness-check` → `gh pr create` → `done`.

Orchestrator does **not** skip spec review or PR readiness.

---

## Issue state machine

```
ready-for-agent → in-progress → done
                      ↓
                  needs-info
```

| Label | Meaning |
|-------|---------|
| `done` | PR opened — unblocks dependents |
| `needs-info` | Spec gap — skip until fixed |

---

## Parallelism

Follow `work-to-pr-v2` Parallelism: max 3 worktrees, no path overlap. After each PR → `done` → next issue. **No merge wait.**

---

## Autonomous mode

- No user prompts
- No merging PRs
- No direct commits to `main`/`dev`
- No `--execute` in planning chat — this skill is the only batch executor

---

## Stop conditions

- No unblocked `ready-for-agent` issues remain

---

## Report

```text
Task run complete

Done (PR opened):        #<list>
PRs for human merge:     #<list>
needs-info:              #<list>
Blocked:                 #<list>
```

SSOT: `$AI_DEV_OS_HOME/skills/task-run/SKILL.md`