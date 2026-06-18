---
name: grill-for-planning
description: Enhanced grilling for the plan-to-issue pipeline — one question at a time, exit checklist, open-questions tracking, and shared-understanding gate. Supports --auto for autonomous discovery and --lean to defer doc writes and shift edge cases to child issue ACs.
---

# Grill for Planning

Issue-ready grilling session. Builds on the existing grill skills without replacing them.

## Which base skill to load first

Read **one** base grill skill before starting — do not modify those files; follow them as written, then apply the additions below.

| Repo state | Read first |
|---|---|
| Has `CONTEXT.md`, `docs/adr/`, or meaningful `src/` to explore | `$AI_DEV_OS_HOME/skills/grill-with-docs/SKILL.md` |
| Greenfield — no repo, no code, no domain docs yet | `$AI_DEV_OS_HOME/skills/grill-me/SKILL.md` |

All agents load the same SSOT path. `install-cli.sh` symlinks `~/.grok/skills/` and `~/.gemini/config/skills/` to `$AI_DEV_OS_HOME/skills/` for slash discovery only.

The base skill provides interviewing style. This skill adds the **exit bar** required before PRD/issue creation.

## Rules (always apply on top of the base skill)

- Ask **one question at a time** (interactive mode only)
- **Wait for the user's answer** before the next question — never batch questions (interactive mode only)
- Provide a **recommended answer** with each question (interactive mode only)
- If a question can be answered by exploring the codebase, explore instead of asking
- Maintain a running **open questions** list; resolve or explicitly flag each item
- Update `CONTEXT.md` and ADRs inline as decisions crystallise (per `grill-with-docs` — **unless `--lean`**)

## Exit checklist

All must be true before proposing handoff to synthesis:

- [ ] Problem statement is precise (not vague)
- [ ] Happy path described with a concrete scenario
- [ ] At least 3 edge cases discussed — **or** (`--lean`) edge cases drafted for child issue ACs
- [ ] Out-of-scope explicitly listed
- [ ] Dependencies on existing code identified
- [ ] Testing approach agreed (which behaviors matter, preferred seams)
- [ ] No conflicting terms in `CONTEXT.md` (or glossary draft if greenfield / `--lean` epic draft)
- [ ] HITL vs AFK slices identifiable — **or** (`--lean`) default AFK; HITL only with hard blocker
- [ ] Product blocking unknowns flagged (`--auto`) — engineering practices deferred to `engineering-standards.md` when `--lean`
- [ ] No unresolved **blocking unknowns** (`--auto`)

## Lean mode (`--lean`)

Requires `--auto`. Minimize planning ceremony without weakening execution specs.

### Defer file writes

- Do **not** write `CONTEXT.md` or ADRs during planning
- Draft new terms in a running **glossary draft** for the thin epic's `## Terms` section
- Note in handoff: update `CONTEXT.md` **after first child PR merges**

### Edge cases

- Do not invent synthetic edge cases to satisfy a count on the epic
- Capture real edge cases discovered during exploration as **draft AC lines** per planned child issue
- Checklist item "≥3 edge cases" passes when child drafts collectively cover meaningful boundaries

### Slicing hint

Estimate feature size from exploration. Pass to synthesis:

| Estimated effort | Target child count |
|---|---|
| &lt; 3 days | 1–2 milestone issues |
| 3–7 days | 2–3 milestone issues |
| &gt; 7 days | 3–5 milestone issues (still vertical, not layer-only) |

### Engineering practices (`--lean`)

Do **not** draft `## Standard Decisions` on the epic. Logging, errors, and architecture are enforced via `docs/agents/engineering-standards.md` at PR time. Phase 1 focuses on **product behaviour** only.

## Interactive mode (default)

When **not** running `--auto`:

### Completion gate

When the checklist is complete, say:

> I believe we have shared understanding.
> Open items: [none — or list any flagged unknowns]
> Ready to synthesize PRD and create GitHub issues?

**Wait for explicit user confirmation** before handing off to `/plan-synthesis`.

## Auto mode (`--auto`)

Autonomous discovery. **No user questions.** Used by `/plan-to-issue-v2 --auto`.

Read `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md` decision policy first — same rules apply here.

### Discovery loop (replaces interview)

Work through the exit checklist systematically:

1. **Explore** — codebase, `CONTEXT.md`, ADRs, `docs/agents/`, tests, similar features
2. **Decide** — product behaviour only; defer engineering practices to `engineering-standards.md` when `--lean`
3. **Document** — `CONTEXT.md` / ADRs inline (**skip file writes when `--lean`**; use glossary draft)
4. **Flag** — blocking unknowns only when important, no standard, multiple valid approaches

Do **not** use `AskQuestion` (Grok) or `ask_question` (AntiGravity).

### What to auto-decide (never ask)

Product-adjacent choices from repo/docs only. In `--lean`, do not record logging/errors/architecture on the epic.

### What to flag (never guess)

**Blocking unknown** — add to open questions list with what, why, evidence checked, and options.

### Self-certify and proceed

```
Phase 1 complete (auto)<lean: — lean>.
- Glossary draft: <count> terms
- Child issue drafts: <count> milestones
- Engineering standards: deferred to docs/agents/engineering-standards.md   # lean only
- Blocking unknowns: <none | list>
```

Proceed to `/plan-synthesis --auto` (add `--lean` when set) **without** waiting for user confirmation.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read base grill skill | `Read` → `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` | `view_file` + `IsSkillFile: true` |
| User questions | conversation (interactive only) | conversation (interactive only) |

SSOT: `$AI_DEV_OS_HOME/skills/grill-for-planning/SKILL.md`