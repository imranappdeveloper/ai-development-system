# PB-onboard-project — Context

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | INT full text, WR frontmatter, INDEX workflow row | ≤8% session |
| T2 | **CONTEXT.md full read** (required) | ≤15% session |
| T3 | Bounded repo markers | ≤12% session |

**Total onboard budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/intake/{work_id}.md` | INT SSOT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | **Required** project domain SSOT |
| `{project_root}/README.md` | Stack and entry hints |
| `{project_root}/docs/**` | Evidence (cite path) |
| `{project_root}/src/**`, `{project_root}/lib/**`, `{project_root}/app/**` | **Markers only** — directory listing, package names |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full file dumps of large codebases | Token budget — use module map |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | ONBOARD file + Work Record — not chat |
| CONTEXT.md | Cite section headings; record `context_md_sha` when available |
| Session | Cache INDEX + CL-ONBOAR for run duration only |
| Revise | Load `prior_onboard_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >8KB, summarize with section refs; never skip read |