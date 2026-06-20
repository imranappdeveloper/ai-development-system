# Usage Feedback & Monitoring

Learn what works as you adopt AI Dev OS — passive telemetry, milestone snapshots, on-demand feedback, and usage reports.

---

## Commands (user)

| Command | When |
|---------|------|
| `/feedback` | Anytime — report friction, bugs, or ideas |
| `/usage-report` | Anytime — full rollup + recommendations |

## Automatic snapshots

Written at milestones (no invoke needed):

| Milestone | Trigger skill |
|-----------|---------------|
| `tasks-published` | `plan-to-issue-v2` — after epic + children published |
| `afk-run` | `task-run` — after batch completes |

Grill sessions (`grill-me`, `grill-for-planning`) do **not** write snapshots. Execution uses `work/requirement-lock.md` only.

Snapshots live at `work/feedback/snapshots/`. Anomalies trigger a one-line nudge: *"Run /feedback or reply skip."*

## Storage

| Location | Contents |
|----------|----------|
| `work/telemetry/events.jsonl` | Passive events (project) |
| `work/feedback/entries.jsonl` | Your feedback entries (verbatim text) |
| `work/feedback/snapshots/` | Milestone markdown summaries |
| `$AI_DEV_OS_HOME/.usage/rollup.jsonl` | Anonymized cross-project rollup |

Configure thresholds in `ai-dev-os.yaml`:

```yaml
feedback:
  nudge_grill_questions: 8
  nudge_afk_stale_minutes: 45
  rollup_sync: true
```

## Anomaly thresholds (balanced)

Nudge when any of:

- AFK stall (no log activity > `nudge_afk_stale_minutes`)
- `needs-info` on an issue
- Task-run crash
- Grill abandoned without approved lock doc
- Any `⚠️ Partial` OS footer in session
- Grill > `nudge_grill_questions` questions
- Issue-spec-review reject/retry
- AFK batch: queued work but 0 PRs opened

## Improvement loop

| Phase | Behavior |
|-------|----------|
| **Now** | `/usage-report` recommends fixes; you approve before OS edits |
| **Later** | MS-* meta-skills auto-review when ≥4 weeks **and** (≥10 feedback entries **or** ≥5 anomalous snapshots) |

Check gate: `usage-feedback.sh meta-gate`

## CLI (agents / scripts)

```bash
usage-feedback.sh snapshot --milestone grill --grill-questions 6 --lock-approved true
usage-feedback.sh feedback --category workflow-friction --severity medium --text "..."
usage-feedback.sh report
```

Schemas: `templates/telemetry/event-schema.yaml`, `templates/feedback/entry-schema.yaml`