---
name: task-run
description: >
  AFK task manager — polls GitHub issues, runs unblocked ready-for-agent tasks via
  subagents + /tdd, opens PRs, marks done at PR create, starts next task immediately
  (no wait for merge). Server only — task-run-server.sh. Never ask questions.
---

# Task Run — AFK Task Manager (server only)

Started on the **Ubuntu server** by `task-run-server.sh` — tmux + **grok** or **agy** (Antigravity) with this skill. You are the **task manager** — not the implementer.

**Core rule:** Task **complete when PR is created** → label `done` → **immediately** start next unblocked issue. **Do not wait for human merge.**

---

## Prerequisites

- `/grill-me` or `/grill-with-docs` + issues published
- Issues: `ready-for-agent`, `## Blocked by` set
- User said **Start AFK on server**

**Read:** `work-to-pr-v2`, `issue-processor`, `tdd`, `issue-spec-review`, `pr-readiness-check`

---

## Server entry

```bash
task-run-server.sh --agent grok|agy [--epic N]
task-run-poll.sh --agent agy    # cron
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
| `--server` | ≤3 parallel subagents (worktrees, no file overlap) |
| `--continue` | State sync + resume (optional; loop does not wait for merges) |
| `--ready` | All runnable `ready-for-agent` issues |

---

## Role: task manager

```
loop:
  1. Fetch issues
  2. State sync (work-to-pr-v2)
  3. Dependency graph from ## Blocked by (done = PR opened satisfies blocker)
  4. Queue = unblocked + ready-for-agent
  5. Batch ≤3 (no path overlap)
  6. Subagent → /tdd → PR → label done → NEXT issue (no merge wait)
  7. needs-info → skip, continue queue
  8. Until queue empty
```

---

## Issue state machine

```
ready-for-agent → in-progress → done
                      ↓
                  needs-info
```

| Label | Meaning |
|-------|---------|
| `ready-for-agent` | Runnable now |
| `in-progress` | Subagent working |
| `done` | PR opened — **task complete**, unblocks dependents |
| `needs-info` | Spec gap — skip until fixed |

**On PR create:**

```bash
gh issue edit <N> --add-label done --remove-label in-progress
gh issue comment <N> --body "PR: <url>"
```

Then **immediately** pick next unblocked `ready-for-agent` issue.

---

## Parallelism

≤3 worktrees; after each PR opens → `done` → next issue. **No wait for merge** between batches.

---

## Autonomous mode

- No user prompts
- No merging PRs (human merges when ready)
- No direct commits to `main`/`dev`

---

## Stop conditions

- No unblocked `ready-for-agent` issues remain
- Only `done`, `needs-info`, or blocked issues left

---

## Report

```text
Task run complete

Done (PR opened):        #<list>
PRs for human merge:     #<list>  (informational)
needs-info:              #<list>
Blocked:                 #<list>
```

SSOT: `$AI_DEV_OS_HOME/skills/task-run/SKILL.md`