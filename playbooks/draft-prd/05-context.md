# PB-draft-prd — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `prd_type` | Fixed |
| T1 | INT full text, DISC (if linked), WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: summary, module map, conventions | ≤12% session |
| T3 | Bounded evidence reads | ≤10% session |

**Total PRD budget:** ≤32% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/intake/{work_id}.md` | INT SSOT |
| `{project_root}/work/discovery/{work_id}.md` | DISC SSOT (when linked) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project domain |
| `{project_root}/README.md` | Stack and entry hints |
| `{project_root}/docs/**` | Evidence (cite path) |
| `{project_root}/src/**` | **Markers only** — module boundaries for scope; no implementation detail |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| `{AI_DEV_OS_HOME}/workflows/project-orchestrator/routing-matrix.yaml` | Do not duplicate in outputs |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Prior ARCH/API/DB specs as SSOT for new PRD | Downstream artifacts — cite only if revise |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | PRD file + Work Record — not chat |
| Session | Cache INDEX + CL-PRD for run duration only |
| Upstream | Record INT/DISC paths in PRD §2 References table |
| Revise | Load `prior_prd_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >4KB, use module-map digest with `source_sha` |
| DISC absent | Set `discovery_gap`; do not fabricate discovery evidence |