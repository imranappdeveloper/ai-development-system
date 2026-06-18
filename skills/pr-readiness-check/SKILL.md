---
name: pr-readiness-check
description: Verify a branch is ready for PR creation — tests, build, acceptance criteria, diff scope, and engineering standards (match-existing, no forced clean architecture). Use in /work-to-pr-v2 before gh pr create. Wraps /check-work without modifying it.
---

# PR Readiness Check

Gate between "implementation done" and `gh pr create`. Reduces broken PRs reaching human review.

## When to run

- **Mandatory:** `/work-to-pr-v2` step between subagent completion and `gh pr create`
- **Optional:** manually before any PR: `/pr-readiness-check`

## Inputs

- Issue number and full body (acceptance criteria)
- Current branch diff against `dev`
- Subagent's test/build output
- `docs/agents/engineering-standards.md` when present (read at start of this check)

## Step 1 — Load verification skill

Read `$AI_DEV_OS_HOME/skills/check-work/SKILL.md` and follow its verification approach on the current diff.

**AntiGravity:** `~/.gemini/config/skills/check-work/SKILL.md` via `view_file` with `IsSkillFile: true`.

## Step 2 — Acceptance criteria audit

For each checkbox in the issue's `## Acceptance criteria`:

- [ ] Implemented in the diff (cite file/area)
- [ ] Covered by a test (or document why not testable)
- [ ] Not partially done

If any criterion is unmet → **FAIL**. Return to subagent fix loop. Do not open PR.

## Step 3 — Scope check

- [ ] Diff is focused on this issue's scope (no unrelated changes)
- [ ] No debug code, commented-out blocks, or TODOs introduced
- [ ] No secrets or credentials in diff

If scope creep detected → **FAIL** with list of unrelated files.

## Step 4 — Tests and build

Run project test and build commands (from repo conventions or `package.json` / `Makefile`):

- [ ] All tests pass
- [ ] Build/typecheck succeeds (if applicable)

If failing → **FAIL**. Attempt subagent fix loop (max 2 retries). Still failing → comment on issue, label `needs-info`, skip PR.

## Step 5 — Engineering standards (when `engineering-standards.md` exists)

Read `docs/agents/engineering-standards.md`. Apply **only checks that are documented and applicable** to this diff. Skip this step entirely if the file is missing — fall back to neighbour-matching only.

### Always check (from precautions)

| Check | Fail if |
|---|---|
| No architecture migration | Diff adds new top-level layers (`domain/`, `infrastructure/`, `usecases/`) in a repo whose profile is **not** `layered` |
| No drive-by refactor | Renames/moves/reformats files outside the issue's touch area |
| No new logging library | Introduces a new log framework when the repo already has one documented |
| Errors not swallowed | Empty catch blocks, log-and-ignore on errors in new code |
| Match profile | `layered` profile only: new code violates documented dependency direction |

### Check when documented in the file

| Check | Fail if |
|---|---|
| Logger | File specifies a logger path/pattern and new code uses a different ad-hoc `console.log` / `print` pattern |
| Error pattern | File specifies error types and new code throws raw strings or generic `Error` where neighbours use project types |
| Exemplar consistency | New module structure clearly diverges from cited exemplar without issue justification |

### Do NOT fail for

- Missing SOLID purity in legacy code
- Not being "clean architecture" in a `conventional` / `mvc-service` / `unknown` profile repo
- Style differences that match the **local neighbourhood** even if they differ elsewhere in the repo
- Issues that explicitly require architectural change (AC mentions migration)

If standards violation → **FAIL** with specific rule and fix hint. Do not open PR.

## Outcomes

### PASS

```
PR readiness: PASS for issue #<N>
- Acceptance criteria: <n>/<n> met
- Tests: passing
- Build: passing
- Scope: clean
- Engineering standards: <passed | skipped — no standards file>
```

Proceed to `gh pr create`.

### FAIL

```
PR readiness: FAIL for issue #<N>
- <specific failures>
```

Do not run `gh pr create`. Retry implementation or escalate per `/work-to-pr-v2` ambiguous-spec rules.

## Platform notes

| Action | Grok | AntiGravity |
|---|---|---|
| Read check-work skill | `Read` | `view_file` + `IsSkillFile: true` |
| Read engineering-standards | `Read` → `docs/agents/engineering-standards.md` | `view_file` |
| Run tests | shell | shell |

SSOT: `$AI_DEV_OS_HOME/skills/pr-readiness-check/SKILL.md`