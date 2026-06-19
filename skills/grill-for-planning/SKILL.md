---
name: grill-for-planning
description: Enhanced grilling for the plan-to-issue pipeline — explore first, confirm misalignment only, requirement lock doc as SSOT, open-questions tracking, and shared-understanding gate. Supports --auto --lean as legacy opt-in only.
---

# Grill for Planning

Issue-ready grilling session. Builds on the existing grill skills without replacing them.

**Default path:** interactive grill → `work/requirement-lock.md` → overview gate → publish. No autonomous guessing.

## Which base skill to load first

Read **one** base grill skill before starting — do not modify those files; follow them as written, then apply the additions below.

| Repo state | Read first |
|---|---|
| Has `CONTEXT.md`, `docs/adr/`, or meaningful `src/` to explore | `$AI_DEV_OS_HOME/skills/grill-with-docs/SKILL.md` |
| Greenfield — no repo, no code, no domain docs yet | `$AI_DEV_OS_HOME/skills/grill-me/SKILL.md` |

All agents load the same SSOT path. `install-cli.sh` symlinks `~/.grok/skills/` and `~/.gemini/config/skills/` to slash discovery paths only.

The base skill provides interviewing style. This skill adds the **exit bar** and **requirement lock doc** required before issue creation.

## Rules (always apply on top of the base skill)

### Explore first (default)

Before asking the user anything:

1. **Explore** — codebase, `CONTEXT.md`, ADRs, `docs/agents/`, tests, similar features
2. **Map** — tie user requirements to screens/components/files
3. **Detect** — misalignment, missing info, related changes the user did not mention

Do this exploration **once** here. AFK execution must not repeat it.

### When to ask the user (misalignment only)

Ask **one question at a time** with **A / B / C + recommendation** only when:

- User request **conflicts** with current implementation
- **Material** product choice is open (behavior, data, reversibility) and cannot be resolved from repo/docs
- A **related change** is required that the user did not mention

Do **not** ask for:

- Exact label copy or cosmetic choices — record agent picks in lock doc for overview review
- Standard engineering practices — defer to `docs/agents/engineering-standards.md`
- Every unspecified UI detail — intent-level input is valid; lock doc captures agreed behavior

If a question can be answered by exploring the codebase, explore instead of asking.

### Other rules

- Maintain a running **open questions** list; resolve or explicitly flag each item
- Update `CONTEXT.md` (and ADRs when warranted) as decisions crystallise
- Preserve user wording in the lock doc **Your request** fields — do not paraphrase away intent

## Requirement lock doc (mandatory — default path)

Template: `$AI_DEV_OS_HOME/templates/requirement-lock/template.md`

Write to: `work/requirement-lock.md` (or `work/requirement-lock-<feature-slug>.md` when multiple features are in flight)

Each screen/journey entry must include:

| Field | Required |
|-------|----------|
| Current behavior | Yes — from exploration |
| Your request | Yes — user's words |
| Agreed change | Yes — product language |
| Files / components | Yes — for AFK spot-check |
| Confirmed forks | Yes — `none` if N/A |

Set `status: draft` while grilling. Set `status: approved` and `approved_at` only after user confirms shared understanding.

## Exit checklist

All must be true before proposing handoff to synthesis:

- [ ] Problem statement is precise (not vague)
- [ ] Happy path described with a concrete scenario
- [ ] Edge cases captured in lock doc entries or out-of-scope (no synthetic padding)
- [ ] Out-of-scope explicitly listed
- [ ] Dependencies on existing code identified (files named in lock doc)
- [ ] Testing approach agreed (which behaviors matter, preferred seams)
- [ ] No conflicting terms in `CONTEXT.md` (update CONTEXT when new terms arise)
- [ ] HITL vs AFK slices identifiable — default AFK; HITL only with hard blocker
- [ ] No unresolved **blocking unknowns**
- [ ] **Requirement lock doc** drafted with all screen/journey entries complete

## Completion gate (default — interactive)

When the checklist is complete, say:

> I believe we have shared understanding.
> Open items: [none — or list any flagged unknowns]
> Requirement lock: work/requirement-lock.md
> Ready to draft issues from the lock doc?

**Wait for explicit user confirmation** (`yes`) before handing off to `/plan-synthesis`.

## Legacy auto mode (`--auto --lean`) — opt-in only

**Not the default.** Use only when the user explicitly requests autonomous planning (repeat/trusted work).

Autonomous discovery. **No user questions.**

Read `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md` decision policy first.

### Discovery loop

1. **Explore** — codebase, `CONTEXT.md`, ADRs, `docs/agents/`, tests
2. **Decide** — product behaviour only; defer engineering to `engineering-standards.md`
3. **Document** — glossary draft for epic; defer `CONTEXT.md` writes (`--lean`)
4. **Flag** — blocking unknowns only

Do **not** use `AskQuestion` (Grok) or `ask_question` (AntiGravity).

Proceed to `/plan-synthesis --auto --lean` **without** a requirement lock doc or user confirmation.

### Lean slicing hint (legacy only)

| Estimated effort | Target child count |
|---|---|
| &lt; 3 days | 1–2 milestone issues |
| 3–7 days | 2–3 milestone issues |
| &gt; 7 days | 3–5 milestone issues |

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read base grill skill | `Read` → `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` | `view_file` + `IsSkillFile: true` |
| User questions | conversation (interactive only) | conversation (interactive only) |

SSOT: `$AI_DEV_OS_HOME/skills/grill-for-planning/SKILL.md`