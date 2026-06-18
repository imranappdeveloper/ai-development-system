# AI Development OS — This Project

This project uses **AI Development OS v1.0** with **grill-first kickoff**.

> Grok reads this file automatically from the project directory. Antigravity: open this folder as the workspace.

## Path resolution (Mac / Ubuntu — every session)

Resolve before loading any OS doc:

| Priority | Source |
|----------|--------|
| 1 | `$AI_DEV_OS_HOME` environment variable (**required on each machine**) |
| 2 | `ai-dev-os.local.yaml` in this directory (optional, gitignored) |
| 3 | `project_root` = directory containing this `AGENTS.md` |

If `$AI_DEV_OS_HOME` is unset: tell user to run `$OS_REPO/scripts/install-cli.sh` on this machine, or `ai-paths machine-setup`.

Committed `ai-dev-os.yaml` uses `env:AI_DEV_OS_HOME` — **never** hardcode `/Users/...` or `/data/...` in project files.

## Config

Read `ai-dev-os.yaml` + `work_id` in this directory.

## When the user reports a bug

Message starts with **`Bug Fix:`**, **`bug:`**, **`fix:`**, or describes something broken/failing.

Follow **`$AI_DEV_OS_HOME/docs/BUG-FIX.md`** exactly:

1. **`/triage`** — classify; one clarifying question only if repro impossible
2. **`/diagnose`** — reproduce + root cause (automatic)
3. Silent **`PB-intake-classify`** → **`PB-diagnose-bug`** → **`PB-draft-issue`** → `work/`
4. Show **Fix Plan** card → wait for **`yes`**
5. **`/tdd`** + **`PB-implement-*`** → show **Fix Summary** card → wait for **`Approve fix.`**
6. Silent **`PB-verify`** → show **Done** card

User never reads playbooks. Max **3 approval cards** per bug.

## When the user runs `/setup-ads`, `start`, or `new project`

Follow **`/setup-ads`** skill (`~/.grok/skills/setup-ads/SKILL.md`) — SSOT: **`$AI_DEV_OS_HOME/docs/SETUP-ADS.md`**.

| Mode | Grill | Focus |
|------|-------|-------|
| **New** | `/grill-me` | Use cases, flows, MVP, assumptions — **not** standard practices |
| **Existing** | `/grill-with-docs` | Explore codebase, glossary, goals, clear assumptions |

Flow: `check-cli` (stop + ask install-cli if fail) → `ai-new` → grill → `CONTEXT.md` → summary → **`yes`** → intake

### Required behavior (if /setup-ads not invoked manually)

1. Run **`ai-new`** + path check first
2. **New:** **`/grill-me`** one question at a time | **Existing:** **`/grill-with-docs`** + explore code
3. Update **`CONTEXT.md`** (glossary only); defer to **`docs/OPEN-QUESTIONS.md`**
4. Alignment summary card → wait for **`yes`**
5. **`PB-intake-classify`** silently → **3-line INT summary** → **`Approve intake.`**

### Implementation (PB-implement-* lanes)

When writing application code for an ISS:

1. Load **`/tdd`** skill (`~/.grok/skills/tdd/SKILL.md`)
2. Per ISS **vertical slice**: one failing test → minimal code → pass → refactor
3. Never horizontal "all tests then all code"
4. Document tests in CODE §6; stop at **H-IMPLEMENT** (`Approve implement.`)

### OS status footer (last line — every response)

The **absolute last line** of every reply — one line, nothing after it. Full spec: **`$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`**.

```text
**AI Dev OS:** {✅ Used | ⚠️ Partial | ❌ Not used} | {skill/playbook} | {work_id} | {artifact or reason}
```

Be honest. Never claim `✅ Used` without loading OS docs/skills and writing required artifacts.

### Never

- Ask the user to read files under `$AI_DEV_OS_HOME/playbooks/`
- Omit the OS status footer
- Dump gate IDs (`H-INTAKE`) unless user asks
- Self-approve gates
- Skip grill on greenfield projects
- Use absolute OS paths baked for another machine

### User approvals (plain English)

| User says | Gate |
|-----------|------|
| Approve intake. | H-INTAKE |
| Approve frame. | H-FRAME |
| Approve plan. | H-PLAN |
| Approve implement. | H-IMPLEMENT |
| `yes` (bug fix plan) | H-INTAKE + H-PLAN |
| `Approve fix.` | H-IMPLEMENT |
| `Done.` | H-VERIFY |

## Project idea (if provided at scaffold)

{{PROJECT_IDEA}}