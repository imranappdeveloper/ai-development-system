---
name: work-to-pr-v2
description: Improved work-to-pr — issue branch per ticket, PR into dev, spec preflight, PR readiness gate, auto AI PR review. Task done when PR opens — do not wait for merge; start next unblocked issue immediately. Parallel work uses git worktree. Use after /plan-to-issue-v2 or standalone.
---

# Work to PR v2

Process GitHub issues autonomously. Human gates at **PR review** — never merge PRs, never ask questions mid-issue. After each AFK PR is created, run **AI PR review** (PENDING review on GitHub + issue one-liner) — see step 7.

**Called by:** `task-run` (server AFK) spawns a subagent per issue to run this skill's **Per-issue loop**. Do not skip steps when invoked from `task-run`.

**Prerequisite:** `/setup-project-agents` must have run. Read `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`, and `docs/agents/engineering-standards.md` (if present) before starting.

Ensure `done` and `in-progress` labels exist (see `docs/agents/triage-labels.md`).

## Issue state machine

```
ready-for-agent → in-progress → done
                      ↓
                  needs-info
```

| Label | Meaning |
|---|---|
| `in-progress` | Agent claimed; branch exists; work not yet PR'd |
| `done` | **Agent work complete** — PR opened into `dev`. Unblocks dependents immediately. Human merges PR when ready (agent does not wait). |
| `pr-open` | Legacy — repair to `done` on state sync if PR still open |

**Mark `done` when the PR is created** — not when it merges.

## Invocation

```
/work-to-pr-v2 43                      # single issue
/work-to-pr-v2 42                      # all unblocked children of epic #42
/work-to-pr-v2 42 --lean               # stamp-based preflight skip
/work-to-pr-v2 42 --continue           # state sync + resume queue (optional — loop does not wait for merges)
/work-to-pr-v2 42 --continue --lean
/work-to-pr-v2 --ready                 # all ready-for-agent (max 5 per run)
```

## Startup

1. Read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md` once at session start — **do not** reload full `docs/agents/*` per issue when a context pack exists
2. Read **`work/requirement-lock.md`** when epic or issues reference it (default path SSOT)
3. Fetch target issues (epic children or `--ready`; cap `--ready` at **5 issues** per run)
4. Filter children by `## Parent` when an epic number is given
5. **State sync + recovery** (always — run script before building execution queue):

```bash
"$AI_DEV_OS_HOME/scripts/afk-state-sync.sh" --issues <comma-separated-nums>
# Add --apply to execute gh label repairs (dry-run first if uncertain)
# Or: --epic <N> to sync all children
```

Script encapsulates PR search and label repair (`done` / `in-progress` / `pr-open`). Report its summary line — do not re-implement the table in agent context.

6. Build dependency graph from `## Blocked by` sections — **`done` = PR opened satisfies blocker** (merge not required)
7. Execution queue: unblocked issues labeled `ready-for-agent` only
8. Skip `ready-for-human`, `needs-info`, `done`

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

TDD, `pr-readiness-check`, `review-requirement`, and **AI PR review** (step 7) are **never** skipped.

## `--continue`

Optional — main loop does **not** wait for merges. Use to repair labels or resume after interruption:

1. Re-fetch epic and all children
2. Run **state sync + recovery**
3. Auto-infer lean from stamps
4. Rebuild dependency graph
5. Process remaining `ready-for-agent` issues

Report:

```
Continue sync: <N> done, <N> reopened, <N> ready to implement
```

## Git branching

```
main  ← production releases — human merges dev → main when ready (not per task/epic)
dev   ← all issue PRs merge here
issue/<N>-<short-slug>  ← one branch per issue; delete after merge
```

Rules:
- Always branch **from** `dev`
- Always open PRs **into** `dev` (`--base dev`)
- Never commit directly to `main` or `dev`
- **Never** open `dev` → `main` PRs — maintainer does that manually on their schedule
- Delete remote branch after human merges (optional comment on issue)

## Per-issue loop

For each executable (unblocked, `ready-for-agent`) issue:

**Observe telemetry (mandatory):** emit step boundaries so `observe watch` / `observe report` show pipeline progress. Use the active run from `/ads` or `task-run` — do not `run-start` per issue.

```bash
observe-event.sh emit --type step_start --step work-to-pr-v2/spec-review --step-index 1/7 --issue <N>
# ... step work ...
observe-event.sh emit --type step_end --step work-to-pr-v2/spec-review --issue <N> --duration-sec <SEC>
```

Repeat for steps 1–7 (`spec-review`, `claim`, `branch`, `implement`, `pr-readiness`, `review-requirement`, `pr-create`). On `telemetry.level: verbose` only, emit `tool_call` for Read/Write/Grep (`--step Read` etc.).

### 1. Spec review (before claim)

```bash
"$AI_DEV_OS_HOME/scripts/issue-spec-check.sh" --issue <N>
```

| Result | Action |
|---|---|
| `afk-preflight-skip: true` | Skip spec review |
| `NEEDS_SPEC` | Skip issue, continue queue |
| `READY` | Run semantic checks per `$AI_DEV_OS_HOME/skills/issue-spec-review/SKILL.md` only |

If semantic review → `NEEDS_SPEC` → skip, continue to next.

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

Build minimal context pack before spawning subagent:

```bash
PACK="$("$AI_DEV_OS_HOME/scripts/issue-context-pack.sh" --issue <N>)"
```

Spawn a **fresh subagent** per issue (`Task` / `invoke_subagent`).

Subagent prompt must include:
- **Context pack path** (`$PACK`) — issue body, lock section, spot-check files, CONTEXT/ADR excerpts
- `docs/agents/engineering-standards.md` when present (only this agents doc — not full `docs/agents/*`)
- Instruction to follow `/tdd`
- **Working directory path** (repo root or worktree path)
- Skip UI tests unless required

**Spot-check only (default — do not re-discover requirements):**

```
- Open files listed in ## Files to spot-check (or lock doc Files / components)
- Confirm they still match lock doc Current behavior; if drifted, follow issue + lock doc Agreed change
- Do NOT broad codebase exploration for requirement discovery — grill already did that
- Read CONTEXT.md / ADRs only when issue or lock doc references a term or decision
```

**Implementation guardrails:**

```
- Implement lock doc Agreed change literally — do not infer new product behaviour
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

### 5b. Requirement review (before PR)

Read `$AI_DEV_OS_HOME/skills/review-requirement/SKILL.md`. Run with issue context from step 4.

If **FAIL** → same subagent fix loop as step 5 (**shared max 2 retries** across pr-readiness + review-requirement). Still failing → same `needs-info` path as step 5.

On **PASS** → persist report to `work/review-requirement/issue-<N>-latest.md` for step 7.

### 6. Pull request

```bash
git push -u origin issue/<N>-<short-slug>
gh pr create --base dev \
  --title "feat: <summary> (#<N>)" \
  --body "Closes #<N>

## Acceptance criteria
<paste checkboxes, mark completed ones>"
```

Capture **PR number** and **PR URL** from `gh pr create` output.

Mark **done immediately** (unblocks dependents — do not wait for merge or AI review):

```bash
gh issue edit <N> --add-label done --remove-label in-progress
```

**Do not** post the task-complete issue comment yet — step 7 posts it with the AI review one-liner.

### 7. AI PR review (mandatory after PR)

Read `$AI_DEV_OS_HOME/skills/work-to-pr-v2/references/ai-pr-review.md` and execute fully.

Summary:

1. Format pre-PR `review-requirement` report per `references/ai-pr-review.md` (no second full diff review when report exists).
2. Post **PENDING** GitHub review (inline comments + review body).
3. On failure → **retry once**; if still failing → `--skipped` notify path.
4. Run notify script:

```bash
"$AI_DEV_OS_HOME/scripts/ai-pr-review-notify.sh" \
  --issue <N> --pr-number <PR> --pr-url "<PR URL>" --review-file "<path>"
# or --skipped after retry exhausted
```

5. On bugs found, script posts `⚠️ AI review: fix before merge` on the PR (advisory — issue stays `done`).

**Do NOT merge the PR.** Start the **next unblocked** issue without waiting for human review submit.

### Ambiguous spec (fallback during implement)

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
- Each worktree: claim → implement → PR readiness → push → `gh pr create` → `done` → AI PR review
- After each PR opened: remove worktree, **immediately** pick next unblocked issue

```bash
git worktree remove .worktrees/issue-<N>
```

Orchestrator main checkout: stay on `dev`, no parallel branch checkouts in root repo.

### Sequential (default when one issue, overlap, or uncertainty)

Single checkout flow (steps 2–7 above). **Do not** use worktrees.

**Do not wait for human merge** between issues — only wait for subagent/PR create to finish.

## Release to main (human only)

When all epic children are `done`, the agent **stops**. Do **not** open a `dev` → `main` PR.

- Issue PRs target `dev` only — one PR per issue, not per epic
- `dev` → `main` is the maintainer's manual release cadence (may batch multiple epics or skip for long periods)
- Optional one-line in the final report: "Epic #N complete on `dev` — merge issue PRs to `dev` when ready; release to `main` is manual."

## Stop conditions

- Queue empty and no new unblocked issues
- All remaining issues are `done`, `needs-info`, or blocked
- Critical unrecoverable build failure

## Autonomous mode

- No `AskQuestion` during execution
- No merging PRs
- No committing directly to `main` or `dev`
- No `dev` → `main` PRs — ever

Report summary:

```
Work complete.
- Done (PR opened): #<list>
- AI reviews posted: #<list> (PENDING on PR Files tab)
- AI review skipped (retry failed): #<list>
- PRs awaiting your merge: #<list> (informational — agent did not wait)
- Recovered stuck: #<list>
- Skipped needs-info: #<list>
```

## Skill map

| Step | Script / skill |
|---|---|
| State sync | `afk-state-sync.sh` |
| Structural preflight | `issue-spec-check.sh` |
| Semantic preflight | `issue-spec-review` (after script READY; skippable via script `afk-preflight-skip`) |
| Context pack | `issue-context-pack.sh` |
| Implement | `tdd` |
| Pre-PR | `pr-readiness-check` → `review-requirement` |
| Post-PR | `review` (bundled) + `references/ai-pr-review.md` |
| Plan gaps | `plan-to-issue-v2` |

SSOT: `$AI_DEV_OS_HOME/skills/work-to-pr-v2/SKILL.md`