---
name: setup-project-agents
description: Sets up `docs/agents/` and `## Agent skills` in AGENTS.md so bundled OS skills know this project's issue tracker, triage labels, domain layout, and engineering standards. Bundled in AI Dev OS at $AI_DEV_OS_HOME/skills/setup-project-agents/. Use --detect-only to refresh existing docs/agents/. Required before plan-to-issue-v2, work-to-pr-v2, to-issues, or task-run.
disable-model-invocation: true
---

# Setup Project Agents's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them
- **Engineering standards** — implementation-time rules (logging, errors, architecture profile) detected from the repo — **never forces clean architecture**

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write — except in `--detect-only` mode.

**AI Dev OS:** invoked automatically in **`/setup-ads` Phase 1.5** (after `ai-new`, before grill). Required before `/plan-to-issue-v2` and `/task-run`. When `AGENTS.md` has `<!-- ADS-BLOCK:* -->` markers, update `## Agent skills` in-place — do not remove other ADS blocks.

## Invocation

```
/setup-project-agents                 # full setup — interview sections A–D
/setup-project-agents --detect-only   # refresh detection only (existing docs/agents/)
```

## Process

### 0. `--detect-only` (fast path)

Use when `docs/agents/` already exists (at minimum `issue-tracker.md` + `triage-labels.md`).

1. Run **Explore** (step 1) including engineering standards detection
2. **Do not** interview the user
3. Merge into existing files only:
   - `engineering-standards.md` — update profile, logger, errors, exemplar table; **preserve** user edits to precautions and custom rules
   - `domain.md` — update layout line only if detection changed
   - Skip `issue-tracker.md` and `triage-labels.md` unless missing
4. Update `## Agent skills` block in `CLAUDE.md` / `AGENTS.md` only if engineering standards section is missing
5. Report summary:

```
Setup refresh (--detect-only) complete.
- Architecture profile: <profile>
- engineering-standards.md: updated | unchanged
- User custom rules: preserved
```

**Ask the user only when:** profile is `unknown` AND logger/errors cannot be detected — post one comment listing what was found and what needs manual input in `engineering-standards.md`.

If `docs/agents/` does not exist → fall through to full setup (step 2+).

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use

**Engineering standards detection** (for `docs/agents/engineering-standards.md`):

| Signal | Likely profile |
|---|---|
| `domain/`, `usecases/`, `infrastructure/`, `adapters/` with inward dependencies | `layered` |
| `controllers/`, `services/`, `models/`, `repositories/` | `mvc-service` |
| `src/features/<name>/` or package-per-feature | `modular-monolith` |
| Flat `src/` with mixed layout | `conventional` |
| Empty / greenfield / unclear | `unknown` |

Also detect and note paths for:

- **Logger** — search for winston, pino, logrus, zap, `Logger`, `logging.config`
- **Errors** — `AppError`, `Result`, custom exception types, problem-details handlers
- **Test exemplar** — one representative `*.test.*` / `*_test.go` near main features
- **Feature exemplar** — one typical module the agent should mimic

Do **not** recommend migrating to clean architecture during setup.

### 2. Present findings and ask

Summarise what's present and what's missing. Walk the user through decisions **one at a time**.

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-issues`, `triage`, `to-prd`, and `qa` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab** — issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

**Section B — Triage label vocabulary.**

> Explainer: When the `triage` skill processes an incoming issue, it moves it through a state machine — needs evaluation, waiting on reporter, ready for an AFK agent to pick up, ready for a human, or won't fix. To do that, it needs to apply labels (or the equivalent in your issue tracker) that match strings *you've actually configured*. If your repo already uses different label names (e.g. `bug:triage` instead of `needs-triage`), map them here so the skill applies the right ones instead of creating duplicates.

The five canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready (an agent can pick it up with no human context)
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask the user if they want to override any. If their issue tracker has no existing labels, the defaults are fine.

Also ensure workflow labels for `/work-to-pr-v2` exist on GitHub: `in-progress`, `pr-open`, `done`. Create `pr-open` if missing:

```bash
gh label create "pr-open" --description "PR open — awaiting merge into dev"
```

**Section C — Domain docs.**

> Explainer: Some skills (`improve-codebase-architecture`, `diagnose`, `tdd`) read a `CONTEXT.md` file to learn the project's domain language, and `docs/adr/` for past architectural decisions. They need to know whether the repo has one global context or multiple (e.g. a monorepo with separate frontend/backend contexts) so they look in the right place.

Confirm the layout:

- **Single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. Most repos are this.
- **Multi-context** — `CONTEXT-MAP.md` at the root pointing to per-context `CONTEXT.md` files (typically a monorepo).

**Section D — Engineering standards.**

> Explainer: `/work-to-pr-v2` uses this so every PR matches **how this repo already codes** — logging, errors, folder layout. It detects your structure and **does not** force clean architecture or major refactors. Agents match neighbours first; this file records repo-wide defaults.

Present the **detected architecture profile** and exemplar paths. Default: accept detection. User may correct profile or exemplar paths only — do not offer "migrate to clean architecture" as an option.

Precautions (always written into the file):

- Match existing architecture; no drive-by layer splits
- Clean architecture rules apply **only** when profile is `layered` and folders already exist
- Inconsistent repo → match local neighbourhood

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`, `docs/agents/engineering-standards.md`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Engineering standards

[profile name + one line]. See `docs/agents/engineering-standards.md`. Agents match existing code — no forced clean-architecture migration.
```

Then write the docs files using the seed templates in this skill folder:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping
- [domain.md](./domain.md) — domain doc consumer rules + layout
- [engineering-standards.md](./engineering-standards.md) — **fill detected profile, logger, errors, exemplars**

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

When re-running setup on a repo that already has `engineering-standards.md`, merge updates (profile, exemplars) — do not wipe user edits to precautions or custom rules.

### 5. Done

Tell the user setup is complete. Mention:

- `docs/agents/engineering-standards.md` is enforced at **PR time** via `pr-readiness-check`, not during planning
- Edit that file directly to tighten rules; use `--detect-only` to refresh profile/exemplars after major repo changes
- Clean architecture is **never** imposed — profile reflects what the repo already is
- `--detect-only` preserves user custom rules — safe to run repeatedly