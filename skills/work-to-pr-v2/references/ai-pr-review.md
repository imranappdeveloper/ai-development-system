# AI PR review — AFK post-create step

Mandatory after every AFK `gh pr create`. Advisory only — issue stays `done`; human merges.

**Lock doc:** `work/requirement-lock.md` → "AFK PR flow — auto AI review"

---

## When

- Immediately after step 6 (`gh pr create`) and `done` label applied
- Every AFK PR — no skip rules
- Manual PRs: use `/review --pr` on demand only

## Prerequisites

- `gh auth status` succeeds
- PR number and URL captured from `gh pr create` output
- Pre-PR report at `work/review-requirement/issue-<N>-latest.md` (from step 5b — **do not re-analyze the diff**)
- Full issue body available (acceptance criteria for formatting)

## Procedure

### 1. Load pre-PR report

Read `work/review-requirement/issue-<N>-latest.md`. If missing, fall back to bundled `/review --pr` (legacy path) once.

### 2. Format GitHub review body (no second semantic pass)

Transform the pre-PR `review-requirement` report into a GitHub review body:

```markdown
## Summary
2–4 sentences from pre-PR Requirement alignment + verdict.

### What changed
3–5 sentences: user-visible impact from pre-PR report.

### Acceptance criteria
Extract from pre-PR **Requirement alignment** — map each issue checkbox:
- [x] or [ ] <criterion> — <file/area> — <evidence from pre-PR report>

### Risks
From pre-PR **Possibilities** + **BLOCKER**/**WARN** issues. Write `none identified` if clean.

### Recommendation
Exactly one line:
- `✅ Safe to merge` — pre-PR verdict PASS, no blockers
- `⚠️ Fix before merge` — pre-PR verdict FAIL or blockers listed

Source: pre-PR `review-requirement` report (step 5b). Do not spawn a second full diff review subagent when the pre-PR report exists.
```

Write formatted body to a temp review file for notify script and `gh api` POST.

### 3. Post PENDING review

Complete review skill PR mode through successful `gh api …/reviews` POST.

On success: note `review_file` path until step 4 completes (review skill may delete it on success — **copy review text to a temp file before cleanup** if the skill removes it).

### 4. Retry on failure

If review subagent fails, `gh api` POST fails, or review file empty:

1. **Retry once** — full review from step 1
2. If still failing → **skipped** path (step 5)

### 5. Notify (script)

From project root:

**Success:**

```bash
"$AI_DEV_OS_HOME/scripts/ai-pr-review-notify.sh" \
  --issue <N> \
  --pr-number <PR> \
  --pr-url "<PR URL>" \
  --review-file "<path-to-review-file>"
```

**Skipped (after retry exhausted):**

```bash
"$AI_DEV_OS_HOME/scripts/ai-pr-review-notify.sh" \
  --issue <N> \
  --pr-number <PR> \
  --pr-url "<PR URL>" \
  --skipped
```

Script posts:

| Condition | PR comment | Issue one-liner |
|-----------|------------|-----------------|
| Bugs found | `⚠️ AI review: fix before merge` | `⚠️ Fix before merge` |
| No bugs | (none) | `✅ Safe to merge` |
| Skipped | `⚠️ AI review skipped` | `skipped — please review manually` |

Issue comment is the **single** task-complete message (includes PR URL + AI line). Do not post a separate pre-review issue comment.

### 6. Continue queue

Do not wait for human merge or PENDING review submit. Proceed to next unblocked issue.

---

## Do not

- Merge the PR
- Re-queue the issue on bugs (`done` stays)
- Add code comments for token savings
- Skip review for trivial diffs
- Post `REQUEST_CHANGES` automatically — PENDING only