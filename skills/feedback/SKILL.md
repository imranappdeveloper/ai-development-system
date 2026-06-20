---
name: feedback
description: >
  Submit on-demand feedback about AI Dev OS friction — classify, log to work/feedback/,
  sync anonymized rollup, optionally open GitHub issue. Use when user runs /feedback,
  wants to report OS issues, or after a usage snapshot nudge.
---

# Feedback — On-Demand OS Feedback

Capture explicit user friction anytime. Complements passive telemetry and milestone snapshots.

---

## When to use

- User runs `/feedback` or describes OS/skill/workflow friction
- User replies to a snapshot **nudge** with details (not `skip`)
- User says "this skill was confusing", "AFK stalled", "grill asked too much"

---

## Flow

1. **Listen** — preserve user wording; do not paraphrase away intent
2. **Classify** — pick one category:
   - `skill-bug` — skill behaved wrong or contradicted docs
   - `workflow-friction` — steps unclear, too many commands, wrong order
   - `spec-quality` — lock doc, issues, or overview mismatch
   - `afk-reliability` — task-run, stall, needs-info, PR failures
   - `feature-request` — missing capability (not a bug)
3. **Severity** — `low` | `medium` | `high`
4. **Confirm** — one line: category + severity + optional GitHub issue (high or `--issue`)
5. **Persist** — run CLI (from project root):

```bash
usage-feedback.sh feedback \
  --category <category> \
  --severity <severity> \
  --text "<user words>" \
  [--skill <skill-name>] \
  [--milestone grill|tasks-published|afk-run] \
  [--issue]
```

6. **Report** — show feedback ID (`ENTRY:FB-…`) and issue number if created

---

## Triage routing

| Category | Severity | Action |
|----------|----------|--------|
| `skill-bug` | high | Log + GitHub issue (default) |
| `afk-reliability` | high | Log + issue; mention task-run log path |
| any | medium | Log only unless user asks for issue |
| `feature-request` | any | Log; issue only if user requests |
| any | low | Log only |

**Never** edit `$AI_DEV_OS_HOME` without explicit user approval.

---

## Agent classification hints

| User says | Category |
|-----------|----------|
| "wrong skill triggered" | workflow-friction |
| "grill-me too many questions" | spec-quality or workflow-friction |
| "issue body didn't match lock doc" | spec-quality |
| "task-run hung" | afk-reliability |
| "want weekly digest" | feature-request |

If unclear, ask **one** question: *"Is this a bug (A), friction (B), or feature request (C)?"* — then proceed.

---

## References

- Schema: `$AI_DEV_OS_HOME/templates/feedback/entry-schema.yaml`
- CLI: `$AI_DEV_OS_HOME/scripts/usage-feedback.sh`
- Rollup: `$AI_DEV_OS_HOME/.usage/rollup.jsonl` (anonymized — no verbatim user text)