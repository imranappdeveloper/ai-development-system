# Requirement Check — Before Acting on User Input

**For agents:** SSOT. Apply on **every** user message that states a requirement, preference, or change.

**For users:** The agent will validate your request against context before implementing — and ask **A/B/C** when anything is unclear.

---

## When to run

| Trigger | Check |
|---------|--------|
| New feature / task | Full check |
| Change to prior decision | Full check + impact on open tasks |
| Bug report | Lighter check (repro + scope) |
| "Yes" / option pick | Confirm still matches last summary |

---

## Checklist (agent — silent unless gap found)

1. **Restate** — one line: what the user wants
2. **Context** — read `CONTEXT.md`, `docs/agents/`, codebase touchpoints
3. **Impact** — what files, tasks, deps, or PRs change
4. **Use cases** — who benefits; happy path in plain English
5. **Edge cases** — failures, empty states, permissions, multi-machine, Odoo/version constraints
6. **Confirm** — only if a fork, ambiguity, or conflict exists

---

## Confirm format (user sees this only at forks)

```text
You asked: <restate>

Impact: <1–2 lines>
Use cases: <who + outcome>
Edge case: <main risk>

A) <recommended>
B) <alternative>
C) Something else — tell me

I recommend A because …
```

One question per message. Never dump spec files.

---

## Rules

| Do | Don't |
|----|-------|
| Verify against repo + `CONTEXT.md` | Assume undocumented behaviour |
| Ask before implementation if unsure | Code on ambiguous requirements |
| Record decisions in `CONTEXT.md` glossary | Ask user to read `work/` or playbooks |
| Defer unknowns to `docs/OPEN-QUESTIONS.md` | Skip check on "small" requests |

---

## Skills source

Load skills from **`$AI_DEV_OS_HOME/skills/<name>/SKILL.md`** only — see `skills/MANIFEST.yaml`.