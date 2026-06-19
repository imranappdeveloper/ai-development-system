---
name: issue-spec-review
description: Preflight check that a GitHub issue body is complete enough for autonomous implementation. Skipped when AFK preflight stamp and spec-sha256 match. Use at /work-to-pr-v2 before claiming, or manually on any issue.
---

# Issue Spec Review

Validate an issue before an AFK agent claims it. Catches spec gaps early — before spawning a TDD subagent.

## When to run

- **Mandatory:** `/work-to-pr-v2` per-issue loop, before `in-progress` label — unless AFK preflight skip applies
- **Skipped:** when issue has valid `## AFK preflight` stamp and `spec-sha256` matches body before stamp (see `work-to-pr-v2` AFK preflight skip)
- **Optional:** manually on any issue: `/issue-spec-review 42`

Legacy stamps without `spec-sha256` → run full review once.

## Input

Fetch the full issue via `gh issue view <N> --json title,body,labels`.

Also read `CONTEXT.md` when it exists (glossary for ambiguous-term checks).

When issue has `## Requirement lock`, read that section of `work/requirement-lock.md` and verify issue **What to build** matches lock doc **Agreed change**.

## Checklist

Score each item pass/fail:

| # | Criterion | Fail if |
|---|---|---|
| 1 | `## What to build` present | Section missing or empty |
| 2 | `## Acceptance criteria` present | Section missing |
| 3 | Criteria are testable | Any criterion is vague ("works well", "looks good") or untestable |
| 4 | At least 2 acceptance criteria | Fewer than 2 checkboxes |
| 5 | Scope is bounded | No clear end-to-end behavior described |
| 6 | `## Blocked by` resolvable | References non-existent issue numbers (when not "None") |
| 7 | Glossary alignment | Uses terms that conflict with `CONTEXT.md` without defining them |
| 8 | No hidden **product** decisions | Body requires business/architecture choices not documented in issue, epic, or ADRs |

Engineering practices (logging, errors) are **not** checked here — `pr-readiness-check` + `engineering-standards.md` handle those.

## Outcomes

### All pass → `READY`

```
Issue #<N>: READY
All <count> checks passed. Safe to claim and implement.
```

### Any fail → `NEEDS_SPEC`

Do **not** claim. Comment on issue, label `needs-info`, remove `ready-for-agent`.

### Partial pass with minor gaps → `READY_WITH_NOTES`

Cosmetic failures only; all ACs testable. Proceed sparingly.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Fetch issue | `gh issue view` via shell | `gh issue view` via shell |
| Read CONTEXT.md | `Read` | `view_file` |

SSOT: `$AI_DEV_OS_HOME/skills/issue-spec-review/SKILL.md`