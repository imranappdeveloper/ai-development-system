# PB-discovery-research — Context

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | INT full text, WR frontmatter, INDEX workflow row | ≤8% session |
| T2 | CONTEXT.md: summary, module map, conventions | ≤12% session |
| T3 | Bounded evidence reads | ≤15% session |

**Total discovery budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/intake/{work_id}.md` | INT SSOT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project domain |
| `{project_root}/README.md` | Entry-mode / stack hints |
| `{project_root}/docs/**` | Evidence (cite path) |
| `{project_root}/src/**` | **Markers only** — file list, public API exports, module headers; no full-file dumps |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Premature PRD/architecture in project | EC-DOC-05 — flag anomaly, do not use as SSOT |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | DISC file + Work Record — not chat |
| Session | Cache INDEX + CL-DISCOVERY for run duration only |
| Evidence | Record in DISC §3.2 table with `source` + `reference` |
| Revise | Load `prior_disc_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >4KB, use module-map digest with `source_sha` |