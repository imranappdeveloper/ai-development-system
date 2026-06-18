---
name: plan-synthesis
description: Synthesize a grilled plan into a PRD and vertical-slice issues. Supports --auto (plan-review gate, AFK preflight stamp) and --lean (thin epic, fat children, milestone slicing). Use as Phase 2 of /plan-to-issue-v2.
---

# Plan Synthesis

Turn shared understanding into a published GitHub epic and child issues.

## Prerequisites

- `/grill-for-planning` exit checklist passed
- `/setup-project-agents` has run in the repo

## Load downstream skills (read only — do not edit)

Before starting, read:

- `$AI_DEV_OS_HOME/skills/to-prd/SKILL.md`
- `$AI_DEV_OS_HOME/skills/to-issues/SKILL.md`

In `--auto` mode, also read:

- `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md`

Follow their templates and rules. Overrides in **this** skill take precedence where noted.

## Step 1 — Draft PRD (silent)

Follow `/to-prd` to draft the PRD body from conversation context.

**Override:** Do **not** ask the user about testing seams separately. Include them in `## Testing Decisions`.

**Auto override (full mode only):** Include `## Standard Decisions` when repo was silent on a practice.

**Lean override:** Do **not** include `## Standard Decisions` on the epic — point to `docs/agents/engineering-standards.md` instead (logging, errors, architecture live there).

Do **not** publish yet.

### Lean epic template (`--lean`)

Replace the full `/to-prd` template. Child issues hold all implementation detail.

```markdown
## Problem Statement

<2–4 sentences>

## Solution

<2–4 sentences>

## Child issues

| # | Title | Depends on |
|---|---|---|
| 1 | <title> | None |
| 2 | <title> | #1 |

## Testing approach

- Seams: <bullet list>
- Prior art: <similar tests in repo>

## Out of Scope

<bullet list>

## Terms

<glossary draft — new domain terms only>

## Engineering standards

Implementation practices (logging, errors, architecture): see `docs/agents/engineering-standards.md`.

## Blocking unknowns

<none | list with options>
```

Do **not** include extensive user stories or `## Standard Decisions` on the epic.

## Step 2 — Draft issue breakdown (silent)

Follow `/to-issues` steps 1–3 to draft vertical slices.

**Override:** Skip `/to-issues` step 4 (quiz).

For each slice, prepare title, type, blocked-by, and full issue body per `/to-issues` template.

### Lean slicing (`--lean`)

- **Milestone slices** — each delivers a demoable increment, not a single layer
- Respect child count targets from Phase 1
- **Default AFK** — use HITL only when body cites hard blocker (external credential, legal, design sign-off)
- **Fat ACs** — each issue includes happy path, edge/error paths, ≥2 testable checkboxes per behaviour area
- Do **not** embed logging/error standard-decision prose — `engineering-standards.md` covers that at implementation

## Step 3 — Approval gate

### Interactive mode (default)

Present one combined PRD summary + proposed issues list. Iterate until approved.

### Auto mode (`--auto`)

Run `/plan-review` (add `--lean` when set). Max 2 `NEEDS_REVISION` loops.

## Step 4 — Publish

### Interactive mode

Publish epic + children per approved slices. Label `ready-for-agent` or `ready-for-human`.

Every child body includes:

```markdown
## Parent

#<epic-number>
```

Publish in dependency order.

### Auto mode

Follow plan-review outcome:

| Outcome | Full mode | Lean mode |
|---|---|---|
| `READY` | Epic + all children + AFK stamp | Epic + all children + AFK stamp |
| `READY_WITH_TRIAGE` | Publish uncertain as `needs-triage` | **Hold** uncertain slices — list in epic comment |
| `NEEDS_SPEC` | Epic only → `needs-info` | Epic only → `needs-info` |

### AFK preflight stamp (all `--auto` READY publishes)

Append to every published `ready-for-agent` child **after** plan-review passes. Added at publish time only.

1. Let `SPEC` = full issue body **before** the stamp (Parent, What to build, ACs, Blocked by — no stamp yet)
2. Compute `spec-sha256` = first 16 hex chars of SHA-256 of `SPEC` (shell: `printf '%s' "$SPEC" | sha256sum`)

```markdown
## AFK preflight

- plan-review: READY
- lean: <true if --lean, else false>
- stamped-at: <ISO-8601 UTC>
- spec-sha256: <16-char hex prefix>
```

**Lean hold comment** (when slices withheld):

```markdown
> *Lean plan — slices held pending spec completion.*

Held:
- <slice title>: <gap>

Resolve on epic, then re-run `/plan-to-issue-v2 --from-issue <epic> --auto --lean`
```

Do NOT close or modify the parent issue after publishing children.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read skills | `Read` → `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` | `view_file` + `IsSkillFile: true` |
| Publish issues | `gh issue create` via shell | `gh issue create` via shell |

SSOT: `$AI_DEV_OS_HOME/skills/plan-synthesis/SKILL.md`