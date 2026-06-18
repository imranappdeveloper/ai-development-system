---
name: task-run
description: >
  AFK task manager — polls GitHub issues for an epic, runs unblocked ready-for-agent
  tasks via subagents + /tdd, opens PRs, loops until queue empty. Use in a NEW Grok chat
  after /plan-to-issue-v2 published tasks. Flags: --local (sequential), --server (parallel≤3),
  --continue (after PR merges). Never ask questions during execution.
---

# Task Run — AFK Task Manager

Run in a **new Grok chat** after human grill + issue publish. You are the **task manager** — not the implementer.

**Prerequisites (human phase complete):**

- `/plan-to-issue-v2 --auto --lean` or `/to-issues` published child issues
- User confirmed task list + dependencies
- User said **Start AFK local** or **Start AFK server**
- Issues labeled `ready-for-agent` with `## Blocked by` filled in
- AFK slices only — HITL / `needs-info` issues are not in queue

**Read before starting:**

| Skill / doc | Purpose |
|-------------|---------|
| `work-to-pr-v2` | `~/.grok/skills/work-to-pr-v2/SKILL.md` — state machine, PR flow, worktrees |
| `issue-processor` | `~/.grok/skills/issue-processor/SKILL.md` — batch loop, one subagent per issue |
| `tdd` | `~/.grok/skills/tdd/SKILL.md` — subagent implementation |
| `issue-spec-review` | Preflight when AFK stamp missing |
| `pr-readiness-check` | Before each PR |

Project: `CONTEXT.md`, `AGENTS.md`, `docs/agents/*` if present.

---

## Invocation

```text
/task-run <epic>
/task-run <epic> --local
/task-run <epic> --server
/task-run <epic> --continue
/task-run --ready --local
```

| Flag | Behavior |
|------|----------|
| `--local` | **Sequential** — 1 subagent at a time; user may watch |
| `--server` | **Parallel** — up to **3** concurrent subagents when no file overlap |
| `--continue` | After human merged PRs — state sync, then next unblocked issues |
| `--ready` | All `ready-for-agent` issues (max 5 per run), no epic filter |

Default if no flag: **`--local`**.

Shell wrapper (tmux detach on server):

```bash
task-run.sh <epic> --server --detach
```

---

## Role: task manager

You **orchestrate**. You **do not** implement application code yourself.

```
loop:
  1. Fetch epic children (or --ready set)
  2. State sync + recovery (work-to-pr-v2 rules)
  3. Build dependency graph from ## Blocked by
  4. Queue = unblocked + ready-for-agent only
  5. Pick batch (size 1 local | ≤3 server, no path overlap)
  6. For each issue → spawn fresh subagent (Task tool)
  7. Subagent → /tdd → PR readiness → gh pr create → pr-open
  8. On needs-info → label issue + comment on epic; continue queue
  9. Repeat until stop conditions
```

---

## Issue state machine

```
ready-for-agent → in-progress → pr-open → done
                      ↓
                  needs-info
```

| Label | Meaning |
|-------|---------|
| `ready-for-agent` | Runnable — deps satisfied, spec complete |
| `in-progress` | Claimed — subagent working |
| `pr-open` | PR open — **human merges** |
| `done` | PR merged into `dev` |
| `needs-info` | Blocked on ambiguity — skip until human fixes spec |

**Runnable rule:** issue must be **unblocked** (all blockers `done`) AND labeled **`ready-for-agent`**.

---

## Subagent prompt (per issue)

Spawn **one fresh subagent per issue** (`Task` tool). Include:

```markdown
Implement GitHub issue #<N> using /tdd.

Working directory: <repo root or .worktrees/issue-<N>/>
Issue body: <full body — AC are the spec>
Read: CONTEXT.md, AGENTS.md, docs/agents/engineering-standards.md (if present)

Rules:
- Follow ~/.grok/skills/tdd/SKILL.md
- Match neighbouring code — no drive-by refactors
- Skip UI tests unless AC requires
- Run tests + build before returning
- Return: files changed, test results, branch name
```

Task manager verifies AC, runs `pr-readiness-check`, opens PR.

---

## Parallelism

| Mode | Concurrency | Isolation |
|------|-------------|-----------|
| `--local` | 1 | Single checkout on `dev` |
| `--server` | ≤3 | `git worktree add .worktrees/issue-<N>` per parallel issue |

Before parallel batch: compare paths/modules in issue bodies. **Overlap → run sequentially.**

Never two subagents in the same working tree.

---

## Ambiguity during AFK (Q6)

If subagent or spec review hits missing spec:

```bash
gh issue edit <N> --add-label needs-info --remove-label in-progress
gh issue comment <N> --body "> Blocked: <specific gap>"
gh issue comment <epic> --body "Task #<N> needs-info: <one line>"
```

**Continue** other unblocked issues. Do **not** pause whole run.

---

## Autonomous mode (mandatory)

- **No** `AskQuestion` / user prompts during execution
- **No** merging PRs
- **No** commits to `main` or `dev` directly
- **No** implementing code in task-manager context — subagents only

Human gates: **PR merge on GitHub** only.

---

## Stop conditions

- Queue empty — no unblocked `ready-for-agent` issues
- All remaining: `pr-open` (awaiting merge), `done`, `needs-info`, or blocked
- Unrecoverable build failure on project root

---

## Report (end of run)

```text
Task run complete — epic #<epic> (<local|server>)

PRs opened (pr-open):     #<list>
Merged → done (sync):      #<list>
Awaiting your merge:       #<list>
needs-info (skipped):      #<list>
Blocked (deps):            #<list>

Next: merge PRs on GitHub, then:
  /task-run <epic> --continue --local
  or: task-run.sh <epic> --server --detach --continue
```

---

## Handoff from human chat

Human chat ends with:

```text
A) Start AFK local
B) Start AFK server
C) Not yet
```

On A or B:

1. Open **new Grok chat** (or `task-run.sh --detach` tmux on server)
2. Paste:

```text
/task-run <epic> --local
project_root: <absolute path>
```

3. Task manager runs until stop conditions

---

## Skill map

| Step | Skill |
|------|-------|
| Publish tasks | `plan-to-issue-v2`, `to-issues` |
| Execute queue | **task-run** (this) |
| Per-issue impl | `work-to-pr-v2` patterns + `tdd` |
| Preflight | `issue-spec-review` |
| Pre-PR | `pr-readiness-check` |

Canonical copy: `$AI_DEV_OS_HOME/skills/task-run/SKILL.md`