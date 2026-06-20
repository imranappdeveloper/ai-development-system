# User Flow — Questions & Options (No Document Reading)

**For users:** You never read spec files in `work/` or playbooks. The agent plans in the background and only talks to you through **short questions with options** and a **pre-AFK overview**.

**For agents:** SSOT for user interaction. Internal gates (`H-INTAKE`, `H-FRAME`, `H-PLAN`, `H-DECOMPOSE`) are satisfied **silently** when the user picks an option or says **Start AFK** — never expose gate names unless asked.

---

## Rules

| Rule | Detail |
|------|--------|
| **Requirement check** | Restate → context → impact → use cases → edge cases → confirm if unclear ([REQUIREMENT-CHECK.md](./REQUIREMENT-CHECK.md)) |
| **Skills from project** | Load `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` only — see `skills/MANIFEST.yaml` |
| **No doc handoffs** | Never ask user to read `work/`, PRD, ISS, playbooks, or long summaries |
| **Grill = SSOT** | Approved `work/requirement-lock.md` is the execution contract; issues are slices of it |
| **Forks only** | Ask on misalignment, gaps, or related changes — not every UI micro-detail |
| **Always options** | End questions with **A / B / C** (and your recommendation) |
| **One question** | One question per message; wait for answer |
| **Spec & planning** | Agent explores codebase once in grill; writes lock doc + `CONTEXT.md` silently |
| **Coding gate** | Batch: **Start AFK** + `/task-run`. Bug/single: **Start coding** |
| **Simple names** | Use *understand → lock → overview → code* — not intake/frame/decompose |

---

## Phases (feature / new task)

### Interactive (human in chat)

```
understand → grill + lock doc → overview → Start AFK → done (PRs opened; merge when ready)
     ↑              ↑              ↑
  questions    questions only   per-screen one-liners + task table
               on misalignment
```

### AFK (server — `task-run-server.sh`)

After tasks published and you approve the overview:

```
task manager → subagent + /tdd per task → PR → next unblocked → until queue empty
```

| Mode | Where | Concurrency |
|------|-------|-------------|
| **Start AFK on server** | `task-run-server.sh --agent grok\|agy` (tmux + auto-start) | up to 3 parallel |

**Batch code runs on the server only.** Grill and planning can happen on any machine; implementation does not.

**During AFK:** no questions. Agents read lock doc + issue slice; spot-check named files only. Ambiguity → `needs-info` + epic comment; queue continues.

**You merge PRs on GitHub when ready** — agent marks `done` at PR create and continues to next task without waiting.

See [AFK-TASK-RUN.md](./AFK-TASK-RUN.md).

### 1. Understand + grill

- `/setup-ads` → `ai-new` → **`/setup-project-agents`** → grill (`/grill-me` or `/grill-with-docs`)
- Agent **explores codebase first**, then asks only on **misalignment**, missing info, or related changes
- Writes **`work/requirement-lock.md`** (silent) — your words preserved in **Your request** fields
- Updates **`CONTEXT.md`** when domain terms or decisions change
- Alignment summary (≤8 lines) → user: **`yes`** or one correction

**Do not** stop for Approve intake / frame / plan.

**Question format (misalignment only):**

```text
On Settings screen you asked for a notification toggle. Current code has no prefs model.

A) Add toggle on Settings only (simplest)
B) Add toggle + email template change
C) Something else — tell me

I recommend A because …
```

### 2. Lock doc (silent)

Agent completes requirement lock with per-screen entries:

- Current behavior | Your request | Agreed change | Files to touch | Confirmed forks

User does not read the lock doc unless they ask.

### 3. Overview + tasks (before publish)

Run **`/plan-to-issue-v2`** (default). Show **overview only**:

```text
Buy-now — agreed changes:

Lot detail → add buy-now button when price set (fixed price from seller)
Checkout → skip bidding flow when buy-now used
…

Tasks for buy-now (epic draft):
1. buy_now_price field — blocked by: none
2. buy-now button on lot detail — blocked by: #1
3. checkout short-circuit — blocked by: #2

A) Publish and Start AFK on server (grok)
B) Publish and Start AFK on server (agy)
C) Not yet — change something

I recommend A or B on Ubuntu.
```

| User says | Agent does |
|-----------|------------|
| **A — grok** | Publish issues + `task-run-server.sh --agent grok [--epic N]` |
| **B — agy** | Publish issues + `task-run-server.sh --agent agy [--epic N]` |
| **C — small fix** | Edit lock doc, adjust tasks, show overview again |
| **C — scope change** | Re-grill affected screens, update lock doc, show overview again |

User never reads full issue bodies. All doubts cleared **before** Start AFK.

**Legacy:** `--auto --lean` skips lock doc and overview — opt-in only, not default.

### 4. Code (AFK — no human)

Task manager spawns subagent per runnable issue. Subagent reads lock doc section + issue; **spot-checks** named files only (no requirement re-discovery). On PR create → `done` → next unblocked task.

### 5. Done

Epic complete when all children are `done` (PR opened). You **merge PRs on GitHub when ready** — agent does not wait.

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
| `yes` | After kickoff or lock-doc alignment summary |
| `A` / `B` / `C` | Any fork or overview gate question |
| **Start AFK on server** | After overview approved |
| **Start coding** | Single-task / bug path only (no GitHub queue) |
| `Done.` | Optional — close out work |
| `/feedback` | Report OS friction anytime |
| `/usage-report` | Full usage rollup + recommendations |
| `Bug Fix: …` | Start bug path |

---

## Agent never

- Dump artifacts for user to read
- Implement without **Start AFK** (batch) or **Start coding** (single/bug)
- Re-explore codebase for requirements at AFK time (spot-check lock doc files only)
- Guess product behaviour not recorded in lock doc or issue
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
| [REQUIREMENT-CHECK.md](./REQUIREMENT-CHECK.md) | Validate user input before acting |
| `templates/requirement-lock/template.md` | Lock doc structure |
| [USAGE-FEEDBACK.md](./USAGE-FEEDBACK.md) | Snapshots, `/feedback`, `/usage-report` |