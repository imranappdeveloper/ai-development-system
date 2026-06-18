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
1. check-cli       → if fail: stop, tell user to run install-cli.sh
2. ai-paths check
3. ai-new          → AGENTS.md, ai-dev-os.yaml, work/, docs/
4. Grill           → new: grill-me | existing: grill-with-docs
5. Summary card    → you: yes
6. Spec (silent)   → agent writes work/ — you never read it
7. Fork questions  → A / B / C only when paths diverge
8. Task list       → short bullets → you pick an option
9. Start AFK       → new chat `/task-run` (or Start coding for bugs only)
```

You answer **one question at a time** with **A / B / C**. Agent recommends each time. Full rules: [USER-FLOW.md](./USER-FLOW.md)

---

## What you say

| Step | You say |
|------|---------|
| After alignment summary | `yes` |
| When agent asks a fork | `A` / `B` / `C` |
| Before batch code | **Start AFK local / server** |
| Before bug fix code | **Start coding** |
| After work complete | `Done.` (optional) |

**No** Approve intake / frame / plan / decompose — agent handles those silently.

---

## Install the skill (once per machine)

```bash
cd ~/ai-development-system && git pull
./scripts/install-cli.sh    # installs ai-new, ai-paths, check-cli, setup-ads skill
source ~/.zshrc             # Mac
```

Verify: `check-cli && ai-paths check`

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