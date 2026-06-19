<!-- ADS-BLOCK:header -->
# AI Development OS — This Project

This project uses **AI Development OS v1.0** with **grill-first kickoff**.

> Grok reads this file automatically from the project directory. Antigravity: open this folder as the workspace.
<!-- /ADS-BLOCK:header -->

<!-- ADS-BLOCK:path-resolution -->
## Path resolution (Mac / Ubuntu — every session)

Resolve before loading any OS doc:

| Priority | Source |
|----------|--------|
| 1 | `$AI_DEV_OS_HOME` environment variable (**required on each machine**) |
| 2 | `ai-dev-os.local.yaml` in this directory (optional, gitignored) |
| 3 | `project_root` = directory containing this `AGENTS.md` |

If `$AI_DEV_OS_HOME` is unset: tell user to run `$OS_REPO/scripts/install-cli.sh` on this machine, or `ai-paths machine-setup`.

Committed `ai-dev-os.yaml` uses `env:AI_DEV_OS_HOME` — **never** hardcode `/Users/...` or `/data/...` in project files.
<!-- /ADS-BLOCK:path-resolution -->

<!-- ADS-BLOCK:config -->
## Config

Read `ai-dev-os.yaml` + `work_id` in this directory.
<!-- /ADS-BLOCK:config -->

<!-- ADS-BLOCK:requirement-check -->
## Requirement check (every user request)

Before acting on requirements, preferences, or changes — follow **`$AI_DEV_OS_HOME/docs/REQUIREMENT-CHECK.md`**:

1. Restate what the user wants
2. Check **context** (`CONTEXT.md`, codebase, `docs/agents/`)
3. Assess **impact**, **use cases**, **edge cases**
4. Confirm with **A/B/C** only when ambiguous or conflicting

Never implement on unclear requirements.
<!-- /ADS-BLOCK:requirement-check -->

<!-- ADS-BLOCK:skills-source -->
## Skills — project bundle only

Load skills from **`$AI_DEV_OS_HOME/skills/<name>/SKILL.md`** — see **`skills/MANIFEST.yaml`**.

| Never | Always |
|-------|--------|
| `~/.agent-skills/shared/` | `$AI_DEV_OS_HOME/skills/` |
| External skill paths | Bundled manifest skills |

`install-cli.sh` symlinks `~/.grok/skills/` + `~/.gemini/config/skills/` → `$AI_DEV_OS_HOME/skills/` for slash commands (grok + agy). **SSOT is the OS repo**.
<!-- /ADS-BLOCK:skills-source -->

<!-- ADS-BLOCK:agent-skills -->
## Agent skills

Configured by **`/setup-project-agents`** during `/setup-ads` (Phase 1.5). See `docs/agents/`.

### Issue tracker

_Setup pending — run `/setup-project-agents`._ See `docs/agents/issue-tracker.md`.

### Triage labels

See `docs/agents/triage-labels.md`.

### Domain docs

See `docs/agents/domain.md`.

### Engineering standards

See `docs/agents/engineering-standards.md`.
<!-- /ADS-BLOCK:agent-skills -->

<!-- ADS-BLOCK:afk-task-run -->
## AFK task execution (batch features)

Configured in **`/setup-ads` Phase 1.6** — see `docs/agents/task-run.md`.

After GitHub issues published and user says **Start AFK on server**:

1. On Ubuntu server: `task-run-server.sh --agent grok|agy [--epic <N>]`
2. Auto-poll (if enabled): `task-run-poll.sh` — see `work/task-run/cron.example`
3. Load **`$AI_DEV_OS_HOME/skills/task-run/SKILL.md`** as task manager
4. Poll `ready-for-agent` issues; respect `## Blocked by`
5. Subagent per issue + `/tdd`; ≤3 parallel (worktrees)
6. PR → `done` immediately; agent starts next task; user merges PRs when ready

**No questions during AFK.** `needs-info` + epic comment; continue queue.

Spec: **`$AI_DEV_OS_HOME/docs/AFK-TASK-RUN.md`**
<!-- /ADS-BLOCK:afk-task-run -->

<!-- ADS-BLOCK:user-flow -->
## User interaction (every feature & task)

Follow **`$AI_DEV_OS_HOME/docs/USER-FLOW.md`** — SSOT for how you talk to the user.

| Phase | User sees | Agent does silently |
|-------|-----------|---------------------|
| **Understand** | Grill + options at forks | `work/kickoff/`, `CONTEXT.md` |
| **Spec** | Questions only when paths diverge | intake, discovery, PRD → `work/` |
| **Tasks** | Short task list + A/B/C | decompose → `work/` (user never reads ISS) |
| **Code** | **Start AFK** (batch) or **Start coding** (bug) | `/task-run` or `/tdd` |

**Never** ask user to read spec documents. **Never** batch-implement without **Start AFK** + `/task-run`.
<!-- /ADS-BLOCK:user-flow -->

<!-- ADS-BLOCK:bug-fix -->
## When the user reports a bug

Message starts with **`Bug Fix:`**, **`bug:`**, **`fix:`**, or describes something broken/failing.

Follow **`$AI_DEV_OS_HOME/docs/BUG-FIX.md`** + **`USER-FLOW.md`**:

1. **`/triage`** — one clarifying question only if repro impossible
2. **`/diagnose`** — reproduce + root cause
3. Silent playbooks → `work/`
4. Fix plan as **A/B/C options** → **Start coding** to implement
5. Short done summary

User never reads playbooks. Max **2** decision points per bug.
<!-- /ADS-BLOCK:bug-fix -->

<!-- ADS-BLOCK:setup-ads -->
## When the user runs `/setup-ads`, `start`, or `new project`

Follow **`/setup-ads`** skill — SSOT: **`$AI_DEV_OS_HOME/docs/SETUP-ADS.md`**.

| Mode | Grill | Focus |
|------|-------|-------|
| **New** | `/grill-me` | Use cases, flows, MVP |
| **Existing** | `/grill-with-docs` | Codebase, glossary, goals |

Flow: `check-cli` → `ai-new` → grill → summary → **`yes`** → silent spec → tasks → **Start AFK**
<!-- /ADS-BLOCK:setup-ads -->

<!-- ADS-BLOCK:setup-ads-behavior -->
### Required behavior (if /setup-ads not invoked manually)

1. Run **`ai-new`** + path check first
2. Grill one question at a time; **A/B/C options** when paths diverge
3. Update **`CONTEXT.md`**; defer unknowns to **`docs/OPEN-QUESTIONS.md`**
4. Alignment summary → **`yes`**
5. Run spec + planning playbooks **silently** — no Approve intake / frame / plan
6. Publish via `/plan-to-issue-v2 --auto --lean`; Start AFK via `task-run-server.sh`
7. **Start AFK on server / not yet** — `task-run-server.sh` on Ubuntu (not inline implement)
<!-- /ADS-BLOCK:setup-ads-behavior -->

<!-- ADS-BLOCK:implementation-tdd -->
### Implementation (code)

**Batch:** only in `/task-run` chat after Start AFK. **Bug:** after Start coding in same chat.

1. Load **`$AI_DEV_OS_HOME/skills/tdd/SKILL.md`**
2. Per **task**: one failing test → minimal code → pass → refactor
3. Never horizontal "all tests then all code"
4. Record H-IMPLEMENT internally when user said Start coding
<!-- /ADS-BLOCK:implementation-tdd -->

<!-- ADS-BLOCK:os-status-footer -->
### OS status footer (last line — every response)

The **absolute last line** of every reply — one line, nothing after it. Full spec: **`$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`**.

```text
**AI Dev OS:** {✅ Used | ⚠️ Partial | ❌ Not used} | {skill/playbook} | {work_id} | {artifact or reason}
```

Be honest. Never claim `✅ Used` without loading OS docs/skills and writing required artifacts.
<!-- /ADS-BLOCK:os-status-footer -->

<!-- ADS-BLOCK:never -->
### Never

- Ask the user to read files under `$AI_DEV_OS_HOME/playbooks/` or `work/` specs
- Implement without **Start coding**
- Ask Approve intake / frame / plan / decompose
- Omit the OS status footer
- Dump gate IDs unless user asks
- Self-approve gates
- Skip grill on greenfield projects
<!-- /ADS-BLOCK:never -->

<!-- ADS-BLOCK:user-approvals -->
### User phrases (plain English)

| User says | Meaning |
|-----------|---------|
| `yes` | Kickoff alignment OK |
| `A` / `B` / `C` | Pick option on a fork question |
| **Start coding** | Begin implementation (only coding gate) |
| `Done.` | Close out current work |
| `Bug Fix: …` | Start bug path |

Internal gates (H-INTAKE, H-FRAME, H-PLAN, H-DECOMPOSE, H-IMPLEMENT) — record silently; never show user unless asked.
<!-- /ADS-BLOCK:user-approvals -->

<!-- ADS-BLOCK:project-idea -->
## Project idea (if provided at scaffold)

{{PROJECT_IDEA}}
<!-- /ADS-BLOCK:project-idea -->