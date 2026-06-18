# AI Development OS — This Project

This project uses **AI Development OS v1.0** with **grill-first kickoff**.

> Grok reads this file automatically from the project directory. Antigravity: open this folder as the workspace.

## Config

Read `ai-dev-os.yaml` in this directory for paths and `work_id`.

## When the user says `start`, `new project`, or describes an idea

Follow **`{{AI_DEV_OS_HOME}}/docs/PROJECT-KICKOFF.md`** exactly.

### Required behavior

1. Run **`/grill-with-docs`** — **one question at a time**; include your recommendation each time
2. Update **`CONTEXT.md`** as terms are resolved (glossary only — no implementation detail)
3. Defer unknowns to **`docs/OPEN-QUESTIONS.md`**
4. After Q1–Q8: **5-line summary** → wait for user **`yes`**
5. Run **`PB-intake-classify`** silently (load 09+04+checklist internally) → **3-line INT summary**
6. Wait for **`Approve intake.`** — do not run discovery until user confirms
7. Offer discovery with **`yes` / `not yet`**

### Implementation (PB-implement-* lanes)

When writing application code for an ISS:

1. Load **`/tdd`** skill (`~/.grok/skills/tdd/SKILL.md`)
2. Per ISS **vertical slice**: one failing test → minimal code → pass → refactor
3. Never horizontal "all tests then all code"
4. Document tests in CODE §6; stop at **H-IMPLEMENT** (`Approve implement.`)

### Never

- Ask the user to read files under `{{AI_DEV_OS_HOME}}/playbooks/`
- Dump gate IDs (`H-INTAKE`) unless user asks
- Self-approve gates
- Skip grill on greenfield projects

### User approvals (plain English)

| User says | Gate |
|-----------|------|
| Approve intake. | H-INTAKE |
| Approve frame. | H-FRAME |
| Approve plan. | H-PLAN |
| Approve implement. | H-IMPLEMENT |

## Project idea (if provided at scaffold)

{{PROJECT_IDEA}}