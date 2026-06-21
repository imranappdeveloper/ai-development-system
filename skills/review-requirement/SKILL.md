---
name: review-requirement
description: Semantic code review against requirements — intent alignment, scope creep, bugs, risks, and standards beyond pr-readiness-check. Chained pre-PR in AFK; standalone in direct coding sessions. Use when user runs /review-requirement, asks to review code against requirement/spec, check implementation matches requirements, or validate changes before PR.
---

# Review Requirement

Semantic review layer. **Does not replace** `pr-readiness-check` — runs after it in AFK and skips all mechanical checks pr-readiness already owns.

## When to run

| Context | Trigger |
|---------|---------|
| **AFK pre-PR** | Mandatory in `/work-to-pr-v2` after `pr-readiness-check` PASS, before `gh pr create` |
| **Standalone** | `/review-requirement` during direct Antigravity/Grok coding (no PR required) |
| **Manual pre-PR** | `/review-requirement --issue N` before opening a PR yourself |

## Requirement source (waterfall)

Always read at start:

- `CONTEXT.md` (when present)
- `docs/agents/engineering-standards.md` (when present)

Requirement text — first match wins:

1. **`--issue N`** — GitHub issue body (`## What to build`, `## Acceptance criteria`)
2. **`work/requirement-lock.md`** — when `status: approved` and no `--issue` flag (**always read this path; do not require the user to pass or @-mention the file**)
3. **Session** — user request in current conversation
4. **Fail-closed** — if none of the above yield a requirement, ask one clarifying question; do not invent a spec

When an issue has `## Requirement lock`, also load the named section from `work/requirement-lock.md` for cross-check.

## Do NOT repeat (pr-readiness-check owns these)

Skip entirely if `pr-readiness-check` already passed in this issue loop:

- Running tests or build
- Checkbox AC audit (implemented? tested?)
- File-level scope list, secrets scan, debug/TODO scan
- `engineering-standards.md` table rules (architecture migration, logger, error pattern, exemplar table)

This skill owns **semantic** review only:

- Requirement **intent** vs literal checkbox completion
- Code **outside** requirement (extra features, dead code, over-engineering)
- **Bugs**, logic errors, regressions
- **Possibilities** — edge cases, security/perf risks
- **Out-of-scope** code in the diff
- Neighbour-pattern consistency beyond the pr-readiness table

## Invocation

```
/review-requirement
/review-requirement --issue <N>
/review-requirement --strict
/review-requirement --branch <name>
/review-requirement --issue <N> --strict --branch <name>
```

| Flag | Behavior |
|------|----------|
| _(default)_ | Local uncommitted diff (staged + unstaged + untracked) |
| `--issue N` | Requirement from issue #N; lock doc used only if issue references it |
| `--strict` | `WARN` severities count as `FAIL` (pre-PR-grade) |
| `--branch name` | Diff of branch vs merge-base with `dev` instead of working tree |

## Step 1 — Collect inputs

1. Resolve requirement per waterfall above
2. Collect diff:
   - Default: `git diff HEAD` + untracked (same pattern as bundled `/review` local mode)
   - `--branch`: `git diff dev...<branch>`
   - AFK: branch diff against `dev` on issue branch
3. If diff empty → report "No changes to review" and stop

## Step 2 — Launch reviewer subagent (read-only)

Spawn a **read-only** `general-purpose` subagent. Description: `[reviewer] requirement-review <target>`.

Prepend requirement text, diff summary, and paths. Subagent may `Read` source files referenced in the diff for context. Subagent must **not** edit code.

### Report format (subagent writes to review artifact)

```markdown
## Verdict
PASS | FAIL

## Requirement alignment
- Met: ...
- Missing / drift: ... (file:line refs)

## Issues

### [BLOCKER] <title>
- File: path:line
- Problem: ...
- Fix: ... (concrete steps)

### [WARN] <title>
...

### [NOTE] <title>
...

## Possibilities
(edge cases, regressions, future risks — not blockers)

## Out of scope
(code present but not required)
```

### Severity rules

| Severity | Pre-PR (AFK) | Standalone (default) |
|----------|--------------|----------------------|
| `BLOCKER` | FAIL — blocks PR | Show with fix steps |
| `WARN` | FAIL only with `--strict` | Show with fix steps |
| `NOTE` | Never fails | Show only |

**Verdict:** `FAIL` if any `BLOCKER` exists, or any `WARN` when `--strict`. Otherwise `PASS`.

## Step 3 — Outcomes

### PASS

```
Requirement review: PASS
- Requirement source: <issue #N | work/requirement-lock.md | session>
- Blockers: 0
- Warnings: <n> (ignored unless --strict)
```

AFK → proceed to `gh pr create`. Standalone → summarize to user.

### FAIL

**AFK:** Return to implement subagent with blocker list + fix hints. Re-run `pr-readiness-check` then `review-requirement`. **Shared max 2 retries** across both gates for the issue. Still failing → `needs-info`, skip PR (per `work-to-pr-v2`).

**Standalone:** Present full report with every issue's Problem + Fix. User fixes and re-runs when ready.

## Step 4 — Persist report (AFK only)

Write report to `work/review-requirement/issue-<N>-<timestamp>.md` (or `work/review-requirement/latest.md` symlink/copy). Post-PR AI review reads this file — **no second full diff analysis**.

## Platform notes

| Action | Grok | AntiGravity |
|--------|------|-------------|
| Read lock doc | `Read` → `work/requirement-lock.md` | `view_file` |
| Fetch issue | `gh issue view` | `gh issue view` |
| Spawn subagent | `Task` / subagent tool | subagent tool |

SSOT: `$AI_DEV_OS_HOME/skills/review-requirement/SKILL.md`