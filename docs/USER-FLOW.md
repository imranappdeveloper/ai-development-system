# User Flow — Questions & Options (No Document Reading)

**For users:** You never read spec files in `work/` or playbooks. The agent plans in the background and only talks to you through **short questions with options**.

**For agents:** SSOT for user interaction. Internal gates (`H-INTAKE`, `H-FRAME`, `H-PLAN`, `H-DECOMPOSE`) are satisfied **silently** when the user picks an option or says **Start coding** — never expose gate names unless asked.

---

## Rules

| Rule | Detail |
|------|--------|
| **No doc handoffs** | Never ask user to read `work/`, PRD, ISS, playbooks, or long summaries |
| **Forks only** | Ask when multiple valid paths exist (scope, design, task split, trade-off) |
| **Always options** | End questions with **A / B / C** (and your recommendation) |
| **One question** | One question per message; wait for answer |
| **Spec & planning** | Agent invests in specification — writes `work/` + `CONTEXT.md` silently |
| **Coding gate** | Batch: **Start AFK** + `/task-run`. Bug/single: **Start coding** |
| **Simple names** | Use *understand → spec → tasks → code* — not intake/frame/decompose |

---

## Phases (feature / new task)

### Interactive (human in chat)

```
understand → spec → tasks → Start AFK → done (merge PRs)
     ↑           ↑        ↑
  questions   questions  questions (only at forks)
```

### AFK (new chat — `/task-run`)

After tasks published to GitHub and you pick **Start AFK local / server**:

```
task manager → subagent + /tdd per task → PR → next unblocked → until queue empty
```

| Mode | Where | Concurrency |
|------|-------|-------------|
| **Start AFK local** | New Grok chat or `task-run.sh <epic> --local` | 1 task at a time |
| **Start AFK server** | Server + `task-run.sh <epic> --server --detach` (tmux) | up to 3 parallel |

**During AFK:** no questions. Issues use `ready-for-agent` + `## Blocked by`. Ambiguity → `needs-info` + epic comment; queue continues.

**You merge PRs on GitHub.** Then: `/task-run <epic> --continue`.

See [AFK-TASK-RUN.md](./AFK-TASK-RUN.md).

### 1. Understand

- `/setup-ads` → `ai-new` → **`/setup-matt-pocock-skills`** → grill (`/grill-me` or `/grill-with-docs`)
- Alignment summary (≤8 lines) → user: **`yes`** or one correction
- Agent runs classify + discovery + planning playbooks **silently**

**Do not** stop for Approve intake / frame / plan.

### 2. Spec (silent + forks)

Agent builds spec in `work/`. **Only interrupt user when:**

- Scope fork (MVP vs full)
- Design fork (two+ valid approaches)
- Assumption unclear
- Integration / platform choice

**Question format:**

```text
For buy-now on auction lots:

A) Fixed buy-now price on the lot (simplest)
B) Buy-now derived from current bid + markup
C) Something else — tell me

I recommend A because …
```

Record internal gates when user answers; no gate jargon.

### 3. Tasks (GitHub issues)

Publish via `/plan-to-issue-v2 --auto --lean` or `/to-issues`. Each task is a **vertical slice** with `## Blocked by` and label `ready-for-agent`.

Show a **short list only** (number, title, blocked-by), not issue bodies:

```text
Tasks for buy-now (epic #42):
1. #43 buy_now_price field — blocked by: none
2. #44 buy-now button — blocked by: #43
3. #45 completion email — blocked by: #44

A) Start AFK local
B) Start AFK server
C) Not yet — change split

I recommend B on server if issues are AFK-stamped.
```

| User says | Agent does |
|-----------|------------|
| **Start AFK local** | `task-run.sh <epic> --local` + new chat `/task-run` |
| **Start AFK server** | `task-run.sh <epic> --server --detach` + new chat |
| **C** | Adjust split; republish; ask again |

User never reads issue bodies. All doubts cleared **before** Start AFK.

### 4. Code (AFK — no human)

Task manager (`/task-run`) spawns subagent per runnable issue (`ready-for-agent` + deps clear). Subagent uses `/tdd`. You only **merge PRs** on GitHub.

### 5. Done

After merge: `/task-run <epic> --continue`. Epic release when all children `done`.

---

## Bug fix (same principles)

1. `/triage` + `/diagnose` — automatic
2. Silent artifacts in `work/`
3. **Fix plan** as options (not a doc):

```text
Cause: quiet-hours check uses UTC not user timezone

A) Start coding — fix timezone in notification service
B) Different approach — <short alt>
C) Need one more detail — <question>

I recommend A.
```

4. **Start coding** → implement + verify
5. Short done summary

Max **2** user decision points per bug: plan options + Start coding.

---

## What the user says (only these)

| Phrase | When |
|--------|------|
| `yes` | After kickoff alignment summary |
| `A` / `B` / `C` | Any fork question |
| **Start AFK local / server** | After task list — begins autonomous run |
| **Start coding** | Single-task / bug path only (no GitHub queue) |
| `Done.` | Optional — close out work |
| `Bug Fix: …` | Start bug path |

**Removed from user vocabulary:** Approve intake, Approve frame, Approve plan, Approve decompose, Approve implement, Approve fix.

---

## Agent never

- Dump artifacts for user to read
- Implement without **Start AFK** (batch) or **Start coding** (single/bug)
- Ask approval for intake / frame / plan / decompose
- Use gate IDs in user-facing text
- Skip options on real forks

## References (agent only)

| Doc | Topic |
|-----|-------|
| [SETUP-ADS.md](./SETUP-ADS.md) | Kickoff |
| [BUG-FIX.md](./BUG-FIX.md) | Bug path |
| [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) | Kickoff detail |
| [AFK-TASK-RUN.md](./AFK-TASK-RUN.md) | Task manager + server tmux |