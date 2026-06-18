# Project Kickoff — Question-First (No Long Docs)

**For users:** You answer short questions. The agent writes `CONTEXT.md` and project files. You never read playbook specs.

**For agents:** Run **`/grill-with-docs`** first on every **new project**, then OS intake. One question at a time. OS status footer on the **last line** of every reply — [OS-STATUS-FOOTER.md](./OS-STATUS-FOOTER.md).

| Project type | Start here |
|--------------|------------|
| **New project** | [§1 New project kickoff](#1-new-project-kickoff) |
| **Existing project** | [§2 Existing project kickoff](#2-existing-project-kickoff) |
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
start
```

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

#### Phase A — `/grill-with-docs` (required)

Load skill: `grill-with-docs` (Grok skills path: `~/.grok/skills/`).

**Rules:**

| Rule | Detail |
|------|--------|
| One question at a time | Wait for answer before next |
| Short questions | No jargon; plain language |
| Your recommendation | End each question with "I recommend X because …" |
| No spec dumping | Never ask user to read `playbooks/*` or `04-io-contract.md` |
| Write as you go | Update `CONTEXT.md` after each resolved topic |
| Explore if needed | If repo has code, read it; greenfield has none — skip |

**New-project question script** (ask in order; skip if already answered):

| # | Topic | Example question |
|---|-------|------------------|
| Q1 | **Problem** | Who has this problem and what pain do they feel today? |
| Q2 | **Users** | Who uses it — end users, admins, both? |
| Q3 | **Platforms** | Web, mobile (iOS/Android), API-only, or combo? *Recommend one MVP platform.* |
| Q4 | **API surface** | REST, GraphQL, or no public API yet? *Recommend for MVP.* |
| Q5 | **MVP scope** | What is in v1 vs explicitly out? |
| Q6 | **Constraints** | Must-use stack, cloud, auth, or "no preference"? |
| Q7 | **Success** | How do we know v1 succeeded? (one measurable outcome) |
| Q8 | **Language** | Name 3–5 domain terms (e.g. "preference", "quiet hours") — lock glossary |
| Q9 | **Open risks** | What are we least sure about? |

Stop grilling when Q1–Q8 are resolved or explicitly deferred. Log deferred items in `docs/OPEN-QUESTIONS.md`.

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

User only says:

```text
Approve intake.
```

or

```text
Revise intake: <one correction>
```

**Do not** paste "Human gate H-INTAKE" jargon unless user asks.

#### Phase E — Discovery (next turn)

After intake approved, agent asks:

```text
Intake approved. Ready for discovery research (problem evidence and options)?
Reply: yes / not yet
```

On **yes** → run `PB-discovery-research` internally; present DISC summary at H-FRAME.

---

## 2. Existing project kickoff

Same pattern, different grill emphasis:

1. User: `Existing project: <path or folder> — <what they want to do>`
2. Agent: `/grill-with-docs` — explore codebase + read `CONTEXT.md` if present
3. Questions focus on: **what's broken / what to add**, alignment with existing modules, constraints from current stack
4. Update `CONTEXT.md` glossary (don't rewrite architecture in CONTEXT)
5. Run `PB-intake-classify` → summary → user `Approve intake`
6. If `existing_project` / onboard path → `PB-onboard-project` before discovery (agent explains in one sentence why)

---

## 3. Then the OS takes over

After kickoff + approved intake:

| Gate | User says |
|------|-----------|
| After discovery | `Approve frame.` or `Revise: …` |
| After PRD | `Approve plan.` or `Revise: …` |
| After decompose | `Approve decompose.` or `Revise: …` |
| After implement | `Approve implement.` or `Revise: …` |
| After verify | `Approve ship.` / `Looks good.` (per workflow) |
| … | Same pattern — **short plain English** |

### Implementation phase (code)

When the workflow reaches **PB-implement-*** (backend, frontend, mobile, or devops):

| Rule | Detail |
|------|--------|
| **Mandatory skill** | Agent loads **`/tdd`** (`~/.grok/skills/tdd/SKILL.md`) |
| **Loop** | Per ISS: one failing test → minimal code → pass → refactor (vertical slices) |
| **Forbidden** | Writing all tests first, then all code (horizontal slices) |
| **User role** | Review summary + changed files; say `Approve implement.` — no test jargon required |

Agent handles playbooks, checklists, and file paths. User never loads `09-system-prompt.md`.

---

## 4. Agent session card (new project)

Paste once at start of a new-project chat:

```text
NEW PROJECT KICKOFF — AI Development OS v1.0

AI_DEV_OS_HOME: /data/project/ai-development-system
project_root: <absolute path>

Flow:
1. Run /grill-with-docs — one question at a time; update CONTEXT.md as we go
2. Summarize kickoff in ≤5 lines; wait for my "yes"
3. Run PB-intake-classify silently; show 3-line INT summary
4. Wait for "Approve intake" — do not run discovery until I say so
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