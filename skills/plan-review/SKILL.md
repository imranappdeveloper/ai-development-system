---
name: plan-review
description: Autonomous preflight for PRD and issue breakdown before publish. Replaces human approval in /plan-synthesis --auto. Stamps children for AFK preflight skip at execution. Supports --lean for relaxed epic checks and held slices.
---

# Plan Review

Validate a drafted PRD and vertical-slice breakdown **without human approval**. On `READY`, children receive an AFK preflight stamp — execution skips duplicate `issue-spec-review` when the stamped spec is unchanged.

## When to run

- **Mandatory:** `/plan-synthesis --auto` Step 3
- **Optional:** manually before publishing any draft plan

Default: validate epic + children against approved `work/requirement-lock.md` — Agreed change in issues must match lock doc entries.

Pass `--lean` only when called from legacy `/plan-to-issue-v2 --auto --lean`.

## Input

- Draft PRD body
- Draft child issue list (title, type, blocked-by, body)
- `CONTEXT.md` and relevant ADRs (if they exist)
- `docs/agents/engineering-standards.md` (for product vs implementation boundary — do not duplicate in PRD)
- Phase 1 context (`--lean`: glossary draft, milestone count target)

## Decision policy (product only — no assumptions)

Apply before scoring checklists. **Product and business behaviour only** — logging, errors, architecture, SOLID are enforced via `engineering-standards.md` at PR time, not in this review.

### Resolve in this order

1. **Codebase** — existing modules, patterns, similar features
2. **`CONTEXT.md` / ADRs** — domain terms and documented decisions
3. **`docs/agents/`** — domain briefs, issue tracker
4. **Framework defaults** — only for unambiguous product-adjacent choices
5. **Block** — no source → blocking unknown (do not guess)

### Auto-decide (never block planning)

Standard engineering practices (logging, errors, validation, naming, test seams) — **omit from PRD** in `--lean`; reference `engineering-standards.md`. In full `--auto`, may appear in epic `## Standard Decisions` only when repo is silent.

### Block (never auto-decide)

Flag as **blocking unknown** only when **all** are true:

1. **Important** — materially changes product behaviour, data model, or reversibility
2. **No standard** — not in repo, docs, ADRs, or framework idioms
3. **Multiple valid approaches** — no clear winner from evidence

In `--auto`, do not ask the user — use `needs-info` on epic or hold slice (`--lean`).

## PRD checklist

### Full mode

| # | Criterion | Fail if |
|---|---|---|
| 1 | Problem statement concrete | Vague |
| 2 | Happy path scenario | Missing |
| 3 | ≥3 edge cases documented | Fewer than 3 in PRD or flagged unknowns |
| 4 | Out of scope explicit | Missing |
| 5 | User stories complete | Stories missing for described behaviour |
| 6 | Implementation decisions bounded | Undocumented **product** choices required |
| 7 | Testing decisions present | No seams |
| 8 | Glossary alignment | Conflicts with `CONTEXT.md` |
| 9 | No unresolved blocking unknowns | Open important forks |
| 10 | Standard decisions documented | Repo-silent **product-adjacent** practices not recorded (not logging/errors — see engineering-standards) |

### Lean mode (`--lean`)

| # | Criterion | Fail if |
|---|---|---|
| L1 | Problem statement concrete | Vague |
| L2 | Solution summary present | Missing |
| L3 | Out of scope explicit | Missing |
| L4 | Child issue table present | Missing or empty |
| L5 | Testing seams listed | Missing |
| L6 | No unresolved blocking unknowns | Open important forks |
| L7 | Glossary draft consistent | Conflicts with existing `CONTEXT.md` |
| L8 | Engineering standards pointer | Epic missing link to `docs/agents/engineering-standards.md` |

Skip full-mode checks 3, 5, 6, 10. No `## Standard Decisions` on lean epics.

## Issue breakdown checklist

Score each draft child issue:

| # | Criterion | Fail if |
|---|---|---|
| 1 | Vertical / milestone slice | Layer-only |
| 2 | `## What to build` bounded | Unclear end-to-end behaviour |
| 3 | ≥2 testable acceptance criteria | Vague or &lt;2 |
| 4 | Dependencies acyclic | Circular blockers |
| 5 | Edge cases in ACs (`--lean`) | Happy path only, no error/edge ACs |
| 6 | HITL justified | HITL without hard-blocker citation |
| 7 | Passes issue-spec-review dry-run | Would fail checks 1–8 |
| 8 | No hidden **product** decisions | Undocumented business/architecture choices not in issue, PRD, or ADRs |

In `--lean`, failing issue → **hold** (do not publish), not `needs-triage`.

### Milestone count (`--lean`)

Warn and suggest merge if child count exceeds Phase 1 target by more than 1. Fail only if a slice is clearly horizontal or unimplementable.

## Outcomes

### `READY`

All applicable PRD checks + all AFK children pass.

```
Plan review: READY<lean: (lean)>
Issues: <count> ready for ready-for-agent
```

Publish with AFK preflight stamp per `plan-synthesis` Step 4 (all `--auto` modes).

### `READY_WITH_TRIAGE` (full mode only)

Partial pass — publish passing AFK as `ready-for-agent` (with stamp), uncertain as `needs-triage`.

### `READY_WITH_HELD` (lean mode)

PRD passes; some children fail. Do not publish failing children.

### `NEEDS_SPEC` / `NEEDS_REVISION`

Unchanged from prior behaviour.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read skills | `Read` → `$AI_DEV_OS_HOME/skills/<name>/SKILL.md` | `view_file` + `IsSkillFile: true` |

SSOT: `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md`