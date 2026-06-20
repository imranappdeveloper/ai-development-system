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
- Full issue body available (acceptance criteria for reviewer)

## Procedure

### 1. Load review skill

Read bundled review skill (PR mode):

```
~/.grok/bundled/skills/review/SKILL.md
```

Follow it end-to-end for `--pr <number>`, with **reviewer prompt additions** below injected into the subagent prompt (after persona, before diff instructions).

### 2. Reviewer prompt additions (E package)

Append to the review subagent prompt:

```markdown
## AFK review package (required sections in review output)

Write these sections to the review file **before** `## Issues`.

### What changed
3–5 sentences: what the PR does, user-visible impact, dominant risk areas.

### Acceptance criteria
Map each checkbox from the issue body:
- [x] or [ ] <criterion> — <file/area> — <one-line evidence>

Issue #<N> body:
<paste acceptance criteria section>

### Risks
Bullet list: security, perf, breaking changes, test gaps. Write `none identified` if clean.

### Recommendation
Exactly one line:
- `✅ Safe to merge` — criteria met, no bugs found
- `⚠️ Fix before merge` — bugs or unmet criteria

The `## Summary` section (required by review skill) must be a 2–4 sentence overall assessment.
It may repeat the headline from **What changed** — do not omit **Acceptance criteria**, **Risks**, or **Recommendation**.
```

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