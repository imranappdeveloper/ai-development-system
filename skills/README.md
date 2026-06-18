# Bundled Skills — AI Dev OS

**SSOT:** `$AI_DEV_OS_HOME/skills/<name>/SKILL.md`  
**Manifest:** [MANIFEST.yaml](./MANIFEST.yaml)  
**Install:** `./scripts/install-cli.sh` symlinks to `~/.grok/skills/` and `~/.gemini/config/skills/` for slash-command discovery (grok + agy).

Agents **always** load from `$AI_DEV_OS_HOME/skills/` — never `~/.agent-skills/shared/`.

## Required skills (19)

| Group | Skills |
|-------|--------|
| OS bind | `setup-ads`, `setup-project-agents`, `setup-task-run` |
| Grill | `grill-me`, `grill-with-docs` |
| Plan + publish | `plan-to-issue-v2`, `grill-for-planning`, `plan-synthesis`, `plan-review`, `to-issues`, `to-prd` |
| AFK execute | `task-run`, `work-to-pr-v2`, `issue-processor`, `issue-spec-review`, `pr-readiness-check`, `tdd` |
| Bug | `triage`, `diagnose` |

Verify: `check-cli`