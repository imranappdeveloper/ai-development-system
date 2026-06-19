---
name: plan-synthesis
description: Synthesize an approved requirement lock doc into a PRD and right-sized vertical-slice issues. Overview gate before publish. Supports --auto --lean as legacy opt-in only.
---

# Plan Synthesis

Turn shared understanding into a published GitHub epic and child issues.

## Prerequisites

- `/grill-for-planning` exit checklist passed
- **`work/requirement-lock.md` approved** (default path) — or legacy `--auto --lean` context
- `/setup-project-agents` has run in the repo

## Load downstream skills (read only — do not edit)

Before starting, read:

- `$AI_DEV_OS_HOME/skills/to-prd/SKILL.md`
- `$AI_DEV_OS_HOME/skills/to-issues/SKILL.md`
- `$AI_DEV_OS_HOME/templates/requirement-lock/template.md` (default path)

Also read:

- `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md`

Follow their templates and rules. Overrides in **this** skill take precedence where noted.

## Step 1 — Draft PRD from lock doc (silent — default)

Read `work/requirement-lock.md`. Draft epic body from lock doc sections — **do not paraphrase** agreed changes.

### Default epic template (from lock doc)

```markdown
## Problem Statement

<from lock doc>

## Solution

<2–4 sentences summarising agreed changes across screens>

## Requirement lock

work/requirement-lock.md (approved <approved_at>)

## Child issues

| # | Title | Depends on |
|---|---|---|
| 1 | <title> | None |
| 2 | <title> | #1 |

## Testing approach

<from lock doc>

## Out of Scope

<from lock doc>

## Engineering standards

Implementation practices (logging, errors, architecture): see `docs/agents/engineering-standards.md`.
```

Do **not** publish yet.

### Legacy `--auto --lean` epic template

Use only when `--auto --lean` was explicitly requested. See previous lean epic format in `plan-review` skill. Child issues hold implementation detail; no requirement lock.

## Step 2 — Draft issue breakdown (silent)

Slice the lock doc into issues mechanically. Follow `/to-issues` steps 1–3. **Skip** `/to-issues` step 4 (quiz) — overview gate replaces it.

### Hybrid sizing (default)

- **Combine** when same screen + same files + small scope
- **Split** when one slice would exceed ~3 days OR mixes unrelated journeys
- Each slice delivers a demoable increment (vertical, not layer-only)
- **Default AFK** — HITL only when body cites hard blocker

### Issue body (default — from lock doc)

Every child issue includes:

```markdown
## Parent

#<epic-number>

## Requirement lock

work/requirement-lock.md — section: <Screen or journey name>

## What to build

<Agreed change from lock doc entry — copy faithfully>

## Acceptance criteria

- [ ] <testable criterion from agreed change>
- [ ] <edge/error path when applicable>
- [ ] <≥2 checkboxes per behaviour area>

## Files to spot-check

<from lock doc Files / components field>

## Blocked by

<dependency or "None - can start immediately">
```

Copy **Agreed change** and **Confirmed forks** from the lock doc — do not re-interpret.

## Step 3 — Overview gate (default — mandatory)

Present **overview only**:

1. **Per-screen one-liners** — `<Screen> → <agreed change in few words>`
2. **Task table** — title + blocked-by per draft issue (no full ACs)

```text
A) Publish and Start AFK on server (grok)
B) Publish and Start AFK on server (agy)
C) Not yet — change something
```

**Wait for user choice** before Step 4.

| User choice | Action |
|---|---|
| **A / B** | Run plan-review, publish, hand off to task-run |
| **C — small fix** | Edit lock doc + issue drafts; show overview again |
| **C — scope change** | Re-grill affected lock-doc sections; regenerate drafts; show overview again |

### Legacy `--auto --lean`

Run `/plan-review --lean`. Max 2 `NEEDS_REVISION` loops. Publish without overview gate.

## Step 4 — Publish

Run `/plan-review` before publish (default and legacy). Max 2 `NEEDS_REVISION` loops.

Publish epic + children. Label `ready-for-agent` or `ready-for-human`. Publish in dependency order.

| Outcome | Action |
|---|---|
| `READY` | Epic + all children + AFK stamp |
| `READY_WITH_TRIAGE` | Publish certain; hold uncertain (list in epic comment) |
| `NEEDS_SPEC` | Epic only → `needs-info` |

### AFK preflight stamp (all READY publishes)

Append to every published `ready-for-agent` child **after** plan-review passes:

1. Let `SPEC` = full issue body **before** the stamp
2. Compute `spec-sha256` = first 16 hex chars of SHA-256 of `SPEC`

```markdown
## AFK preflight

- plan-review: READY
- requirement-lock: work/requirement-lock.md
- lean: <true if legacy --lean, else false>
- stamped-at: <ISO-8601 UTC>
- spec-sha256: <16-char hex prefix>
```

Do NOT close or modify the parent issue after publishing children.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read skills | `Read` → `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` | `view_file` + `IsSkillFile: true` |
| Publish issues | `gh issue create` via shell | `gh issue create` via shell |

SSOT: `$AI_DEV_OS_HOME/skills/plan-synthesis/SKILL.md`