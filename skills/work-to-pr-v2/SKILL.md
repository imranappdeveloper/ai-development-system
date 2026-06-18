---
name: work-to-pr-v2
description: Improved work-to-pr — issue branch per ticket, PR into dev, spec preflight, PR readiness gate, merge-aware --continue. Uses pr-open until PR merges; done only after merge. Parallel work uses git worktree. Use after /plan-to-issue-v2 or standalone.
---

# Work to PR v2

Process GitHub issues autonomously. Human gates at **PR review** — never merge PRs, never ask questions mid-issue.

**Prerequisite:** `/setup-project-agents` must have run. Read `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`, and `docs/agents/engineering-standards.md` (if present) before starting.

Ensure the `pr-open` label exists in the tracker (see `docs/agents/triage-labels.md`). Create it via `gh label create "pr-open" --description "PR open — awaiting human merge"` if missing.

## Issue state machine

```
ready-for-agent → in-progress → pr-open → done
                      ↓              ↓
                  needs-info    (human merges PR)
```

| Label | Meaning |
|---|---|
| `in-progress` | Agent claimed; branch exists; work not yet PR'd |
| `pr-open` | PR opened into `dev` — **awaiting human merge** |
| `done` | PR **merged** into `dev` — set only by sync/`--continue`, never at PR create |

**Do NOT** add `done` when opening a PR.

## Invocation

```
/work-to-pr-v2 43                      # single issue
/work-to-pr-v2 42                      # all unblocked children of epic #42
/work-to-pr-v2 42 --lean               # stamp-based preflight skip
/work-to-pr-v2 42 --continue           # after human merged PRs — sync + next issues
/work-to-pr-v2 42 --continue --lean
/work-to-pr-v2 --ready                 # all ready-for-agent (max 5 per run)
```

## Startup

1. Read `docs/agents/*` (including `engineering-standards.md` when present) and `CONTEXT.md` (+ ADRs if referenced)
2. Fetch target issues (epic children or `--ready`; cap `--ready` at **5 issues** per run)
3. Filter children by `## Parent` when an epic number is given
4. **State sync + recovery** (always — required before building execution queue):

### State sync + recovery

For each fetched issue, find its PR:

```bash
gh pr list --search "closes #<N>" --state all --json number,state,mergedAt,headRefName,url --limit 5
```

| Issue labels | PR state | Action |
|---|---|---|
| `pr-open` | `MERGED` | `done` + remove `pr-open`. Comment: merged PR link |
| `pr-open` | `OPEN` | Skip — awaiting human merge |
| `pr-open` | `CLOSED` (not merged) | Remove `pr-open`, add `ready-for-agent`. Comment: PR closed unmerged — re-run work |
| `in-progress` | `OPEN` | Add `pr-open`, remove `in-progress` (fix label drift) |
| `in-progress` | `MERGED` | `done` + remove `in-progress` |
| `in-progress` | none | **Stuck recovery** — remove `in-progress`, add `ready-for-agent`, comment with branch name if known |
| `done` | not `MERGED` | **Legacy repair** — remove `done`, add `pr-open` if PR open else `ready-for-agent` |

```
State sync: <N> merged → done, <N> awaiting merge, <N> recovered stuck in-progress
```

5. Build dependency graph from `## Blocked by` sections
6. Execution queue: unblocked issues labeled `ready-for-agent` only
7. Skip `ready-for-human`, `needs-info`, `pr-open` (awaiting human), `done`

### Auto-infer lean

If any queue issue has a valid `## AFK preflight` stamp, enable preflight skip (see below). `--continue` always auto-infers.

## AFK preflight skip

Before full `issue-spec-review`, check whether duplicate preflight can be skipped.

### Valid stamp

`## AFK preflight` with `plan-review: READY`, `stamped-at`, `spec-sha256` (16 hex chars).

### Spec unchanged

1. `SPEC` = body text before `## AFK preflight` (trim trailing whitespace)
2. Current hash = first 16 hex chars of SHA-256 of `SPEC`
3. Skip only if hash equals stamp's `spec-sha256`

**Always** run full `issue-spec-review` when stamp missing, invalid, or hash mismatch.

TDD and `pr-readiness-check` are **never** skipped.

## `--continue`

Use after merging one or more issue PRs into `dev`:

1. Re-fetch epic and all children
2. Run **state sync + recovery** (marks newly merged PRs as `done`)
3. Auto-infer lean from stamps
4. Rebuild dependency graph — newly unblocked children enter queue
5. Process remaining `ready-for-agent` issues

Report:

```
Continue sync: <N> newly done (merged), <N> still pr-open, <N> ready to implement
```

## Git branching

```
main  ← releases only (dev → main when epic fully done)
dev   ← all issue PRs merge here
issue/<N>-<short-slug>  ← one branch per issue; delete after merge
```

Rules:
- Always branch **from** `dev`
- Always open PRs **into** `dev` (`--base dev`)
- Never commit directly to `main` or `dev`
- Delete remote branch after human merges (optional comment on issue)

## Per-issue loop

For each executable (unblocked, `ready-for-agent`) issue:

### 1. Spec review (before claim)

If valid AFK preflight stamp → skip. Else run `$AI_DEV_OS_HOME/skills/issue-spec-review/SKILL.md`.

If `NEEDS_SPEC` → skip, continue to next.

### 2. Claim

```bash
git checkout dev && git pull
gh issue edit <N> --add-label in-progress --remove-label ready-for-agent
```

### 3. Branch (worktree when parallel — see Parallelism)

**Sequential (default):**

```bash
git checkout -b issue/<N>-<short-slug>
```

**Parallel:** use isolated worktree (never share one working tree across subagents).

### 4. Implement (subagent + TDD)

Spawn a **fresh subagent** per issue (`Task` / `invoke_subagent`).

Subagent prompt must include:
- Full issue body (acceptance criteria are the spec)
- `CONTEXT.md` and relevant ADRs
- `docs/agents/engineering-standards.md` when present
- Instruction to follow `/tdd`
- **Working directory path** (repo root or worktree path)
- Skip UI tests unless required

**Implementation guardrails:**

```
- Match neighbouring code — same patterns, naming, structure
- Do NOT introduce clean architecture or folder restructures unless the issue requires it
- Do NOT drive-by refactor unrelated files
- Logging/errors: engineering-standards.md or neighbours
```

### 5. PR readiness check (before PR)

Read `$AI_DEV_OS_HOME/skills/pr-readiness-check/SKILL.md`.

If **FAIL** → subagent fix loop (max 2 retries). Still failing:

```bash
gh issue comment <N> --body "> *PR readiness failed after 2 retries.*

Branch: issue/<N>-<short-slug>
<failures>"
gh issue edit <N> --add-label needs-info --remove-label in-progress
```

Do not open PR. Leave branch for human or delete locally.

### 6. Pull request

```bash
git push -u origin issue/<N>-<short-slug>
gh pr create --base dev \
  --title "feat: <summary> (#<N>)" \
  --body "Closes #<N>

## Acceptance criteria
<paste checkboxes, mark completed ones>"
```

Then — **pr-open, not done:**

```bash
gh issue edit <N> --add-label pr-open --remove-label in-progress
gh issue comment <N> --body "> *PR ready for review.*

<PR URL>"
```

**Do NOT merge the PR.** **Do NOT** add `done`.

### 7. Ambiguous spec (fallback)

```bash
gh issue comment <N> --body "> *Blocked by missing spec during work.*

Need clarification on: <specific questions>"
gh issue edit <N> --add-label needs-info --remove-label in-progress
```

## Parallelism

**Rule:** never run parallel subagents in the same working tree.

### File overlap

Before parallel batch, compare expected touch areas (paths/modules in issue bodies). If overlap → run those issues **sequentially**.

### Parallel batch (max 3, no overlap)

For each issue in the batch:

```bash
git fetch origin dev
git worktree add .worktrees/issue-<N> -b issue/<N>-<short-slug> origin/dev
```

- Subagent runs in `.worktrees/issue-<N>/`
- Each worktree: claim → implement → PR readiness → push → `gh pr create` → `pr-open`
- After batch PRs opened:

```bash
git worktree remove .worktrees/issue-<N>
```

Orchestrator main checkout: stay on `dev`, no parallel branch checkouts in root repo.

### Sequential (default when one issue, overlap, or uncertainty)

Single checkout flow (steps 2–6 above). **Do not** use worktrees.

Wait for all PRs in a parallel batch before starting the next batch.

## Epic release (dev → main)

When **all** child issues are labeled `done` **and** state sync confirms every issue has a merged PR into `dev`:

```bash
gh pr create --base main --head dev --title "release: <epic title> (#<epic>)"
```

Tell the user to review and merge. Do not merge yourself.

If any child is `pr-open` or `in-progress` → epic not ready for release.

## Stop conditions

- Queue empty and no new unblocked issues
- All remaining issues are `pr-open` (awaiting human), `done`, `needs-info`, or blocked
- Critical unrecoverable build failure

## Autonomous mode

- No `AskQuestion` during execution
- No merging PRs
- No committing directly to `main` or `dev`

Report summary:

```
Work complete.
- PRs opened: #<list> (labeled pr-open)
- Merged → done (sync): #<list>
- Awaiting your merge: #<list>
- Recovered stuck: #<list>
- Skipped needs-info: #<list>
```

## Skill map

| Step | Skill |
|---|---|
| Preflight | `issue-spec-review` (skippable via AFK stamp) |
| Implement | `tdd` |
| Pre-PR | `pr-readiness-check` |
| Plan gaps | `plan-to-issue-v2` |

SSOT: `$AI_DEV_OS_HOME/skills/work-to-pr-v2/SKILL.md`