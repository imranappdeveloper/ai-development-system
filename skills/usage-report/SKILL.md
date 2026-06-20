---
name: usage-report
description: >
  On-demand usage rollup — telemetry, snapshots, feedback, anomaly counts, and
  concrete OS improvement recommendations. Use when user runs /usage-report or
  wants to see what is working and what to optimize.
---

# Usage Report — OS Usage Rollup

Full picture of how AI Dev OS performed in this project. Read-only unless user approves fixes.

---

## When to use

- User runs `/usage-report`
- User asks "what's working", "where should we optimize", "show usage stats"
- After reviewing a milestone snapshot and wanting the full history

**Automatic snapshots** (no invoke needed) are written by `plan-to-issue-v2` and `task-run` at milestones via `usage-feedback.sh snapshot`. Grill sessions do **not** write snapshots.

---

## Flow

1. **Generate report** (project root):

```bash
usage-feedback.sh report
```

2. **Read sources** when deeper context needed:
   - `work/telemetry/events.jsonl`
   - `work/feedback/entries.jsonl`
   - `work/feedback/snapshots/*.md`
   - `$AI_DEV_OS_HOME/.usage/rollup.jsonl` (cross-project anonymized)

3. **Summarize for user** (≤15 lines):
   - Snapshot count + anomalous count
   - Top friction categories from feedback
   - Skills/milestones with most anomalies
   - AFK outcomes (PRs, needs-info) if any afk-run snapshots exist

4. **Recommend** — 1–3 concrete, actionable proposals:
   - Which skill/doc to change
   - What rule/threshold to adjust in `ai-dev-os.yaml` `feedback:` block
   - Whether to run `/feedback` on a specific recurring pattern

5. **Meta-review gate** — check eligibility:

```bash
usage-feedback.sh meta-gate
```

Output: `true|weeks|feedback_count|anomalous_snapshots` or `false|…`

When `true`: suggest enabling MS-* meta-skill periodic review (user must still approve).

**Never** auto-edit OS without user approval.

---

## Report format (user-facing)

```text
Usage report — <project>

Snapshots: N (M anomalous)
Feedback: F entries
Top friction: <category> (count)

Recent issues:
- <one line per anomalous snapshot>

Recommendations:
1. …
2. …

Meta-review eligible: yes/no
Run /feedback anytime to add detail.
```

---

## After milestone snapshots (agent duty)

When `plan-to-issue-v2` or `task-run` writes a snapshot, show the user **only if they run `/usage-report` or ask** — do not surface snapshot paths after grill sessions.

For non-grill snapshots shown on request:

1. Path to snapshot file (short)
2. 2–3 line summary from the snapshot
3. **Nudge line only if** output contained `NUDGE:` — otherwise stay quiet

---

## References

- Telemetry schema: `$AI_DEV_OS_HOME/templates/telemetry/event-schema.yaml`
- User flow: `$AI_DEV_OS_HOME/docs/USER-FLOW.md` (usage feedback section)
- CLI: `$AI_DEV_OS_HOME/scripts/usage-feedback.sh`