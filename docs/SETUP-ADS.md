# Setup ADS — New & Existing Project Flow

**One command in chat:** `/setup-ads`

Binds AI Development OS, grills until user and AI agree, writes files, then intake.

| Mode | Grill skill | Focus |
|------|-------------|-------|
| **New project** | `/grill-me` | Problem, use cases, flows, MVP, assumptions — **not** standard practices |
| **Existing project** | `/grill-with-docs` | Explore code, glossary, goals, clear assumptions |

---

## User — what to say

### New project

```bash
cd ~/projects/my-app    # empty or new folder
grok
```

```text
/setup-ads
New project: <one-line idea>
```

### Existing project (e.g. Odoo auction module)

```bash
cd /path/to/auction
grok
```

```text
/setup-ads
Existing project: Odoo auction addon — <what you want to do>
```

---

## What happens (automatic)

```
1. ai-paths check
2. ai-new          → AGENTS.md, ai-dev-os.yaml, work/, docs/
3. Grill session   → new: grill-me | existing: grill-with-docs
4. Write           → CONTEXT.md, OPEN-QUESTIONS.md, work/kickoff/
5. Summary card    → you: yes
6. Intake (silent) → you: Approve intake.
```

You answer **one question at a time**. Agent recommends an answer each time.

---

## What you approve

| Step | You say |
|------|---------|
| After alignment summary | `yes` |
| After intake summary | `Approve intake.` |
| Later work | See [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) §3 |

---

## Install the skill (once per machine)

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh    # installs ai-new, ai-paths, setup-ads skill
source ~/.zshrc             # Mac
```

Verify: `ls ~/.grok/skills/setup-ads/SKILL.md`

---

## vs old flow

| Old | New (/setup-ads) |
|-----|------------------|
| Manual `ai-new` then `start` | `/setup-ads` runs ai-new + grill |
| New used grill-with-docs | New uses **grill-me** (requirements) |
| Existing ad-hoc | Existing uses **grill-with-docs** (codebase) |
| User might skip files | Always creates OS files + CONTEXT |

---

## References

| Doc | Topic |
|-----|-------|
| [MULTI-MACHINE.md](./MULTI-MACHINE.md) | Mac + Ubuntu paths |
| [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) | After intake |
| [BUG-FIX.md](./BUG-FIX.md) | Bugs (separate flow) |