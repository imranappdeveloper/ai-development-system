---
name: setup-ads
description: >
  Set up AI Development OS on a project — runs ai-new, then grill session
  (new: /grill-me for requirements; existing: /grill-with-docs for codebase).
  Use when user runs /setup-ads, says "setup ads", "setup project", "bind OS",
  "new project setup", "existing project setup", or starts greenfield/brownfield kickoff.
---

# Setup ADS — AI Development System Project Binding

Bind **AI Development OS** to a project folder, align with the user via grilling, write `CONTEXT.md` + OS files, then hand off to intake.

**User never reads playbooks or spec files.** One question at a time with **A/B/C options** at forks. Batch features: **Start AFK** → `/task-run` in new chat. Bugs/single task: **Start coding**. End every reply with OS status footer — `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`.

**User interaction SSOT:** `$AI_DEV_OS_HOME/docs/USER-FLOW.md`  
**Requirement check:** `$AI_DEV_OS_HOME/docs/REQUIREMENT-CHECK.md`  
**Skills SSOT:** `$AI_DEV_OS_HOME/skills/` — never `~/.agent-skills/`

---

## Phase 0 — CLI check + requirement discipline

Before every user message in this session: apply **`$AI_DEV_OS_HOME/docs/REQUIREMENT-CHECK.md`** (restate → context → impact → use cases → edge cases → confirm if unclear).

## Phase 0b — CLI check (required before anything else)

Run:

```bash
check-cli
```

Or: `$AI_DEV_OS_HOME/scripts/check-cli.sh`

| Check | Pass | Fail |
|-------|------|------|
| `AI_DEV_OS_HOME` | set + directory exists | — |
| `ai-new` | on PATH or under OS scripts | **stop** |
| `ai-paths` | on PATH or under OS scripts | **stop** |
| `setup-ads` skill | `$AI_DEV_OS_HOME/skills/setup-ads/SKILL.md` | **stop** |
| `setup-matt-pocock-skills` | `$AI_DEV_OS_HOME/skills/setup-matt-pocock-skills/SKILL.md` | **stop** |

**If check fails — do not proceed.** Tell user exactly:

```text
AI Dev OS CLI is not installed on this machine.

Run once:
  cd <AI_DEV_OS_HOME or ~/ai-development-system>
  ./scripts/install-cli.sh
  source ~/.zshrc    # Mac
  source ~/.bashrc   # Ubuntu

Then: check-cli && ai-paths check
```

Only continue Phase 1 after `check-cli` exits 0 (or user confirms install completed and re-run check).

Then: `ai-paths check` for project paths; `project_root` = cwd or user path.

---

## Phase 1 — Scaffold (`ai-new`)

Run from `project_root`:

```bash
ai-new
```

Or: `$AI_DEV_OS_HOME/scripts/new-project.sh .`

Idempotent — creates only missing: `AGENTS.md`, `ai-dev-os.yaml`, `work/`, `docs/`, git if needed.

Then optionally: `ai-paths sync`

**Do not overwrite** existing `AGENTS.md` or user code.

---

## Phase 1.5 — Project agent config (`/setup-matt-pocock-skills`)

**Required** before `/plan-to-issue-v2`, `/to-issues`, or `/task-run`.

Load: `$AI_DEV_OS_HOME/skills/setup-matt-pocock-skills/SKILL.md`

| Project state | Action |
|---------------|--------|
| No `docs/agents/issue-tracker.md` | Full `/setup-matt-pocock-skills` |
| `docs/agents/` exists | `/setup-matt-pocock-skills --detect-only` |

**Team default (GitHub remote):** propose GitHub + default triage labels + `pr-open` label. Confirm with **A/B/C** — one section at a time per the skill (tracker → labels → domain → engineering standards).

**Writes:**

- `docs/agents/issue-tracker.md`, `triage-labels.md`, `domain.md`, `engineering-standards.md`
- `## Agent skills` block in `AGENTS.md` (merge with existing ADS blocks — do not wipe OS sections)

**Stop** Phase 3+ if `docs/agents/` incomplete and user has not completed setup.

Create GitHub labels if missing (`ready-for-agent`, `in-progress`, `pr-open`, `done`, `needs-info`).

---

## Phase 2 — Detect mode

| Mode | Signal |
|------|--------|
| **new** | Empty/greenfield repo, or user says "new project", "greenfield", "from scratch" |
| **existing** | App code present (e.g. `src/`, `models/`, `__manifest__.py`, `package.json`), or user says "existing project", "brownfield", "adopt OS" |

If unclear, ask **one** question:

```text
Is this a brand-new project or an existing codebase we're adding ADS to?
```

---

## Phase 3A — New project → `/grill-me`

Load skill: `grill-me` (`$AI_DEV_OS_HOME/skills/grill-me/SKILL.md`).

**Goal:** Shared understanding of **product** — problem, features, flows, use cases, requirements, assumptions. **Not** standard engineering practices (agent applies those silently later).

### Grill rules

| Rule | Detail |
|------|--------|
| One question at a time | Wait for answer |
| Your recommendation | End each question: "I recommend X because …" |
| No jargon | Plain language; no playbook/gate IDs |
| Write as you go | Update `CONTEXT.md` (glossary only) after each resolved term |
| Defer unknowns | `docs/OPEN-QUESTIONS.md` |
| Skip standard practices | Do NOT grill on TDD, folder structure, CI, clean architecture unless user raises them |

### New-project question script (order; skip if answered)

| # | Topic | Example |
|---|-------|---------|
| Q1 | **Problem** | Who has this pain and what happens today without your product? |
| Q2 | **Primary users** | Who uses it daily — operators, customers, admins? |
| Q3 | **Core use cases** | Name 2–3 things a user must accomplish in v1 (verbs + outcomes) |
| Q4 | **Main flows** | Walk the happy path for the most important use case — steps in plain English |
| Q5 | **MVP scope** | What is in v1 vs explicitly out? |
| Q6 | **Platforms** | Web, mobile, API, desktop? *Recommend one MVP surface.* |
| Q7 | **Integrations** | External systems (payment, email, ERP, …) or standalone? |
| Q8 | **Constraints** | Hard must-haves (stack, locale, compliance) or "no preference"? |
| Q9 | **Success** | One measurable outcome that means v1 worked |
| Q10 | **Domain language** | Name 3–5 terms we must use consistently (lock glossary) |
| Q11 | **Assumptions** | What are we assuming that might be wrong? |
| Q12 | **Open risks** | What we're least sure about → `OPEN-QUESTIONS.md` |

Stop when Q1–Q10 resolved or deferred. Write `work/kickoff/WR-001.md` summary (optional).

---

## Phase 3B — Existing project → `/grill-with-docs`

Load skill: `grill-with-docs` (`$AI_DEV_OS_HOME/skills/grill-with-docs/SKILL.md`).

**Goal:** Understand **current** codebase + docs; align on goals; clear assumptions; create/update all OS files.

### Before grilling

1. Explore repo structure (read key entry points, manifests, README)
2. Read `CONTEXT.md` if present; else create when first term resolves
3. Read `docs/adr/` if present
4. Note stack (e.g. Odoo module, Django app) in CONTEXT one-liner — not implementation detail in glossary

### Grill emphasis (existing)

| # | Topic | Example |
|---|-------|---------|
| Q1 | **Goal here** | What do you want to achieve on this codebase right now? |
| Q2 | **Module scope** | Which part of the repo is in scope (e.g. auction addon only)? |
| Q3 | **Current behavior** | How does the main flow work today — confirm against code |
| Q4 | **Pain / gap** | What's broken, missing, or must change? |
| Q5 | **Constraints** | Stack, Odoo version, APIs we must not break |
| Q6 | **Terms** | Domain words this repo uses — align glossary with code |
| Q7 | **Assumptions** | What might we be wrong about? |
| Q8 | **Deferred** | What to park in `OPEN-QUESTIONS.md`? |

Cross-reference code during grill (grill-with-docs rule). Challenge glossary conflicts.

Ensure OS files exist after grill:

- `CONTEXT.md` (updated)
- `docs/OPEN-QUESTIONS.md` (if needed)
- `ai-dev-os.yaml` / `AGENTS.md` (from ai-new; paths via env)
- `work/kickoff/WR-001.md` (grill summary)

---

## Phase 4 — Alignment summary (both modes)

Present **≤8 lines**:

```text
┌─────────────────────────────────────────────┐
│ SETUP ADS — alignment summary               │
├─────────────────────────────────────────────┤
│ Mode:      new | existing                   │
│ Problem:   …                                │
│ Scope:     …                                │
│ Use cases: …                                │
│ MVP:       …                                │
│ Glossary:  … (3–5 terms)                    │
│ Assumptions cleared: …                      │
│ Open:      … or none                        │
├─────────────────────────────────────────────┤
│ Files: CONTEXT.md, work/kickoff/, docs/     │
│ Reply: yes  |  revise: <one correction>     │
└─────────────────────────────────────────────┘
```

On **`yes`** → Phase 5. On **`revise:`** → update docs, re-show summary once.

---

## Phase 5 — Spec (silent)

Run playbooks internally — **no user document review**:

1. `PB-intake-classify` → `work/intake/`
2. `PB-discovery-research` (if needed) → `work/`
3. PRD / feature / architecture playbooks as workflow requires → `work/`

**Only interrupt user** when a real fork exists (scope, design, assumption). Use **A/B/C + recommendation** per `USER-FLOW.md`.

Do **not** ask Approve intake / frame / plan.

---

## Phase 6 — Tasks

Decompose feature into **tasks** (vertical slices). Present **short list only** (name + one line each):

```text
Tasks for <feature>:
1. …
2. …

A) Split looks good
B) Merge tasks
C) Split finer
```

User never reads ISS specs. Adjust from their option.

---

## Phase 7 — Start AFK handoff

After task list confirmed, **do not implement in this chat**. Hand off:

```text
A) Start AFK local
B) Start AFK server
C) Not yet
```

On A or B:

1. Run `task-run.sh <epic> --local|--server [--detach]` from `project_root`
2. Tell user to open **new Grok chat** and paste handoff from `work/task-run/`
3. New chat runs `/task-run` — autonomous until queue empty

For **bugs only** (no GitHub queue): fix plan A/B/C → **Start coding** in same chat.

Reference `$AI_DEV_OS_HOME/docs/AFK-TASK-RUN.md` + `USER-FLOW.md`.

---

## Never

- Skip `ai-new` / path check
- Grill on standard practices (lint rules, TDD ceremony, repo layout) unless user asks
- Dump playbooks or `work/` specs on user
- Ask Approve intake / frame / plan / decompose
- Implement batch features in setup-ads chat (use `/task-run` instead)
- Implement without **Start AFK** or **Start coding** (bugs)
- Self-approve gates (record internally when user picks options or Start AFK/coding)
- Omit OS status footer (last line)

## References (agent only)

| Doc | Path |
|-----|------|
| User flow | `$AI_DEV_OS_HOME/docs/USER-FLOW.md` |
| Kickoff | `$AI_DEV_OS_HOME/docs/PROJECT-KICKOFF.md` |
| Multi-machine | `$AI_DEV_OS_HOME/docs/MULTI-MACHINE.md` |
| Bug fix | `$AI_DEV_OS_HOME/docs/BUG-FIX.md` |
| Footer | `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md` |