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

**User never reads playbooks.** One question at a time. End every reply with OS status footer — `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`.

---

## Phase 0 — Resolve paths

1. `ai-paths check` or verify `$AI_DEV_OS_HOME` is set and directory exists
2. If unset → tell user: run `$AI_DEV_OS_HOME/scripts/install-cli.sh` (or `ai-paths machine-setup`)
3. `project_root` = directory containing this work (cwd or user path)

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

Load skill: `grill-me` (`~/.grok/skills/grill-me/SKILL.md`).

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

Load skill: `grill-with-docs` (`~/.grok/skills/grill-with-docs/SKILL.md`).

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

## Phase 5 — Intake (silent)

Run `PB-intake-classify` internally (`09` + `04` + checklist). Write `work/intake/WR-001.md`, `work/WR-001.md`.

Present **3-line INT summary** + recommended workflow. Wait for:

```text
Approve intake.
```

Do not auto-chain to discovery.

---

## Phase 6 — Handoff

After intake approved, offer next step in plain English (discovery, feature, or bug per workflow). Reference `$AI_DEV_OS_HOME/docs/PROJECT-KICKOFF.md` §3 internally.

---

## Never

- Skip `ai-new` / path check
- Grill on standard practices (lint rules, TDD ceremony, repo layout) unless user asks
- Dump playbooks on user
- Self-approve gates
- Omit OS status footer (last line)

## References (agent only)

| Doc | Path |
|-----|------|
| Kickoff | `$AI_DEV_OS_HOME/docs/PROJECT-KICKOFF.md` |
| Multi-machine | `$AI_DEV_OS_HOME/docs/MULTI-MACHINE.md` |
| Bug fix | `$AI_DEV_OS_HOME/docs/BUG-FIX.md` |
| Footer | `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md` |