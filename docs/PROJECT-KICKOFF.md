# Project Kickoff — Question-First (No Long Docs)

**For users:** You answer short questions. The agent writes `CONTEXT.md` and project files. You never read playbook specs.

**For agents:** Run **`/setup-ads`** first — [SETUP-ADS.md](./SETUP-ADS.md). OS status footer on the **last line** of every reply — [OS-STATUS-FOOTER.md](./OS-STATUS-FOOTER.md).

| Project type | Start here |
|--------------|------------|
| **Any bind / kickoff** | **[SETUP-ADS.md](./SETUP-ADS.md)** — `/setup-ads` |
| **New project** | [§1 New project](#1-new-project-kickoff) → `/grill-me` |
| **Existing project** | [§2 Existing project](#2-existing-project-kickoff) → `/grill-with-docs` |
| **Bug fix** | **[BUG-FIX.md](./BUG-FIX.md)** — `Bug Fix: …` (automatic triage → diagnose → fix) |
| After kickoff | [§3 Then the OS takes over](#3-then-the-os-takes-over) |

---

## 1. New project kickoff

### Easiest way — one command (from any folder)

One-time install (if `ai-new` is not found):

```bash
export AI_DEV_OS_HOME=/data/project/ai-development-system
$AI_DEV_OS_HOME/scripts/install-cli.sh
source ~/.bashrc
```

Then:

```bash
# Option A — scaffold CURRENT folder (you are already in the project dir)
cd ~/projects/my-app
ai-new

# Option B — create a subfolder in current directory
cd ~/projects
ai-new my-app "Notification preferences — email, push, quiet hours"
cd my-app
```

**Existing repo with code:** `cd your-repo && ai-new` — adds missing OS files only; never overwrites.

(Without `ai-new`, use `$AI_DEV_OS_HOME/scripts/new-project.sh` — same behavior.)

Then open in **Grok** (`cd` to project, run `grok`) or **Antigravity** (open folder) and type:

```text
/setup-ads
New project: <one-line idea>
```

Or: `start` (same flow via AGENTS.md)

The script works from **any directory** — it always uses your **current folder (pwd)** as the base. OS files (`AGENTS.md`, `work/`, `ai-dev-os.yaml`) are added there.

**Interactive:**

```bash
$AI_DEV_OS_HOME/scripts/new-project.sh -i
```

### Manual way (same flow)

```bash
mkdir -p ~/my-app/work && cd ~/my-app
```

Say in chat: `New project: <one sentence>` + ask for PROJECT-KICKOFF grill.

**Users never read long docs or paste intake prompts.**

---

### What the agent does (automatic)

#### Phase A — `/setup-ads` → `/grill-me` (required for new projects)

Load skills from **`$AI_DEV_OS_HOME/skills/`** — `setup-ads`, `setup-project-agents`, `setup-task-run`, then `grill-me` or `grill-with-docs`.

Full script: [SETUP-ADS.md](./SETUP-ADS.md) Phase 3A.

**Rules:**

| Rule | Detail |
|------|--------|
| Run `ai-new` first | Idempotent OS file bind |
| One question at a time | Wait for answer before next |
| Your recommendation | End each question with "I recommend X because …" |
| No spec dumping | Never ask user to read `playbooks/*` |
| Write as you go | Update `CONTEXT.md` (glossary only) |
| **Skip standard practices** | Do NOT grill TDD, CI, folder layout — agent applies later |

**New-project topics:** problem, users, use cases, main flows, MVP scope, platforms, integrations, constraints, success metric, domain language, assumptions, open risks.

Stop when core topics resolved or deferred → `docs/OPEN-QUESTIONS.md`.

#### Phase B — Write project docs (agent only)

| File | When |
|------|------|
| `CONTEXT.md` | Updated during grill — glossary + one-line purpose (per grill-with-docs; no implementation detail) |
| `docs/OPEN-QUESTIONS.md` | Create if anything deferred at Q9 |
| `work/kickoff/WR-001.md` | Optional summary of grill answers for intake (agent-authored) |

**CONTEXT.md** example after grill:

```markdown
# my-app

Notification preferences for end users — control email, push, and quiet hours.

## Language

**Preference**:
A per-user setting for how and when notifications are delivered.
_Avoid_: Setting, config

**Quiet hours**:
A time window when push notifications are suppressed.
_Avoid_: Do not disturb, DND
```

#### Phase C — Present summary to user (5 lines max)

Agent says:

```text
Kickoff complete. Here is what I captured:
• Problem: …
• Platforms: …
• API: …
• MVP in scope: …
• Out of scope: …
• Open questions: … (or "none")

Reply: "yes" to continue to intake, or correct one thing.
```

User replies **`yes`** or gives a short correction (agent updates `CONTEXT.md`, no re-grill unless major).

#### Phase D — Run intake silently (agent only)

Agent runs `PB-intake-classify` **without exposing spec docs to the user**:

- Load `09-system-prompt.md` + `04-io-contract.md` internally
- Use grill answers + `CONTEXT.md` as input
- Write `work/intake/WR-001.md` + `work/WR-001.md`
- Present **3-line INT summary** + recommended workflow

Agent runs intake + discovery + planning **silently** (`USER-FLOW.md`). User does **not** say Approve intake.

At forks only → **A / B / C** question with recommendation.

**Do not** paste gate jargon unless user asks.

#### Phase E — Spec + tasks (automatic)

Agent runs discovery, PRD, decompose internally. User sees:

- Option questions when paths diverge
- Short **task list** (not full specs)
- **Start AFK** before batch implementation (`/task-run`)

---

## 2. Existing project kickoff

Via **`/setup-ads`** → **`/grill-with-docs`**. Full script: [SETUP-ADS.md](./SETUP-ADS.md) Phase 3B.

1. User: `/setup-ads` + `Existing project: <what they want to do>`
2. Agent: `ai-new` → explore codebase → **`/grill-with-docs`**
3. Questions focus on: **goal**, module scope, current behavior vs code, pain/gaps, constraints, domain terms, assumptions
4. Update `CONTEXT.md` glossary; create OS files if missing
5. Alignment summary → **`yes`** → silent spec + tasks per [USER-FLOW.md](./USER-FLOW.md)
6. If `existing_project` / onboard path → `PB-onboard-project` silently before discovery

---

## 3. Then the OS takes over

See **[USER-FLOW.md](./USER-FLOW.md)** — user-facing phases:

```
understand → spec (silent) → tasks → Start AFK → /task-run → PRs opened → done (merge when ready)
```

| Phase | User does | Agent does |
|-------|-----------|------------|
| Understand | Answer grill + `yes` on summary | `CONTEXT.md`, kickoff |
| Spec | Answer **A/B/C** only at forks | intake, discovery, PRD → `work/` |
| Tasks | Confirm split via **A/B/C** | decompose → `work/` (user never reads) |
| Code | **Start AFK** (batch) or **Start coding** (bug) | `/task-run` or `/tdd` |
| Done | `Done.` optional | verify silently |

**Removed:** Approve intake, frame, plan, decompose, implement.

### Implementation (code)

| Rule | Detail |
|------|--------|
| **Gate** | Batch: **Start AFK** + `/task-run`. Bug: **Start coding** |
| **Skill** | Agent loads **`/tdd`** |
| **Loop** | Per **task**: failing test → minimal code → pass → refactor |
| **User role** | Pick options; never read spec files |

Agent handles playbooks internally. User never loads `09-system-prompt.md`.

---

## 4. Agent session card (new project)

Paste once at start of a new-project chat:

```text
NEW PROJECT KICKOFF — AI Development OS v1.0

AI_DEV_OS_HOME: /data/project/ai-development-system
project_root: <absolute path>

Flow:
1. Run /grill-me or /grill-with-docs — one question at a time; A/B/C at forks
2. Summarize kickoff in ≤5 lines; wait for my "yes"
3. Run spec + planning silently — never ask me to read work/ files
4. Show short task list; Start AFK on server (`task-run-server.sh`)
5. Never ask me to read playbook files

My idea: <one sentence>
```

---

## 5. What NOT to do

| Bad | Good |
|-----|------|
| "Read GETTING-STARTED §2" | Ask Q1 |
| "Approve H-INTAKE" (first message) | Grill → summary → then intake |
| "Revise API before discovery" as user homework | Ask Q4, write to CONTEXT |
| Load all 01–11 playbooks | Load 09+04 internally only |
| Chat-only artifacts | Always write `work/` + `CONTEXT.md` |

---

## 6. Ubuntu quick start (user)

```bash
export AI_DEV_OS_HOME=/data/project/ai-development-system

# From ANY folder — add OS to current directory:
cd ~/projects/my-app
ai-new
grok

# Or create subfolder here:
cd ~/projects
ai-new my-app "Notification preferences"
cd my-app && grok
```

**Antigravity:** open the project folder in the IDE instead of `grok`.

In chat: **`start`**

---

## References

| Doc | Role |
|-----|------|
| `grill-with-docs` skill | Interview + CONTEXT.md updates |
| `docs/GETTING-STARTED.md` | OS install + gates reference (agents read, not users) |
| `playbooks/intake-classify/` | Agent runs after kickoff |
| `playbooks/discovery-research/` | Agent runs after approved intake |