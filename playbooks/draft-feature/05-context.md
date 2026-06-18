# PB-draft-feature — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `feat_type`, `feat_scope` | Fixed |
| T1 | DISC full text, WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: summary, module map, conventions | ≤10% session |
| T3 | INT excerpt when linked in DISC | ≤5% session |

**Total FEAT budget:** ≤25% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/discovery/{work_id}.md` | DISC SSOT |
| `{project_root}/work/intake/{work_id}.md` | INT traceability when DISC cites |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project domain |
| `{project_root}/README.md` | Stack and entry hints |
| `{project_root}/docs/**` | Evidence (cite path) |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| `{AI_DEV_OS_HOME}/workflows/project-orchestrator/routing-matrix.yaml` | Do not duplicate in outputs |
| `{project_root}/src/**` | No codebase-driven architecture in FEAT |
| `{project_root}/work/architecture/**` | Downstream artifact |
| `{project_root}/work/api/**` | Downstream artifact |
| `{project_root}/work/database/**` | Downstream artifact |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | FEAT file + Work Record — not chat |
| Session | Cache INDEX + CL-DRAFT for run duration only |
| Upstream | Record DISC path in FEAT §References |
| Revise | Load `prior_feat_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >4KB, use module-map digest with `source_sha` |
| DISC stale | Set `discovery_gap: stale`; do not fabricate new discovery evidence |