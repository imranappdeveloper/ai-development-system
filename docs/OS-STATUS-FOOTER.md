# OS Status Footer — Required on Every Agent Response

**For agents:** The **absolute last line** of every reply must be the OS status footer. **One line only.** No text, blank lines, or signatures after it. Never omit.

**For users:** Read the last line of any agent reply to see if AI Development OS was used.

---

## Footer template (exactly one line — must be last)

```text
**AI Dev OS:** {STATUS} | {DETAIL}
```

Replace `{STATUS}` and `{DETAIL}` per rules below. This is the **final line** of the message.

---

## Status values

| STATUS | When |
|--------|------|
| `✅ Used` | `AI_DEV_OS_HOME` resolved; current turn followed a doc/skill/playbook from the OS; artifacts persisted when required |
| `⚠️ Partial` | OS path set but this turn skipped playbooks, chat-only output, or missing required `work/` write |
| `❌ Not used` | No `AI_DEV_OS_HOME` / `ai-dev-os.yaml`; user request not routed through OS docs; pure improvisation |

---

## DETAIL format by status

### ✅ Used

```text
✅ Used | {skill_or_playbook} | {work_id} | {artifact_path_or_action}
```

Examples:

```text
✅ Used | BUG-FIX checkpoint 1 | WR-003 | work/diagnose/WR-003.md
✅ Used | PB-intake-classify | WR-004 | work/intake/WR-004.md
✅ Used | /diagnose | WR-003 | repro confirmed
✅ Used | /tdd + PB-implement-backend | WR-003 | work/implement/backend/WR-003.md
✅ Used | PROJECT-KICKOFF grill | — | CONTEXT.md updated
```

### ⚠️ Partial

```text
⚠️ Partial | {what ran} | {what's missing}
```

Examples:

```text
⚠️ Partial | chat summary only | work/intake/WR-003.md not written
⚠️ Partial | code changed | no /tdd; no CODE artifact
⚠️ Partial | PB-intake-classify | self-approved H-INTAKE without user yes
```

### ❌ Not used

```text
❌ Not used | {reason}
```

Examples:

```text
❌ Not used | AI_DEV_OS_HOME not set
❌ Not used | general coding request — no OS doc loaded
❌ Not used | project missing AGENTS.md and ai-dev-os.yaml
```

---

## Rules

| Rule | Detail |
|------|--------|
| Last line only | Footer is the **single final line** — nothing may follow |
| No separator | Do not add `---` or extra blank lines after the footer |
| Honest | If you improvised, say `❌ Not used` — never fake `✅ Used` |
| One line | Keep `DETAIL` on one line; no playbook dumps |
| Paths real | Artifact paths must exist or say `pending persist` |
| Multi-skill turn | List primary skill; note `+N more` if needed |

---

## Quick agent self-check before sending

```
[ ] AI_DEV_OS_HOME or ai-dev-os.yaml read?
[ ] Right doc for trigger? (BUG-FIX / PROJECT-KICKOFF / playbook)
[ ] Required work/ file written this turn?
[ ] Footer matches truth?
```

---

## References

| Doc | Trigger |
|-----|---------|
| [BUG-FIX.md](./BUG-FIX.md) | `Bug Fix:` |
| [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) | `start`, new project |
| [GETTING-STARTED.md](./GETTING-STARTED.md) | OS setup |