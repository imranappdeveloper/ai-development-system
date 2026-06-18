# PB-draft-api — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | ARCH full text, PRD (soft), DB (soft), WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: stack, API conventions, module map; optional DISC | ≤10% session |
| T3 | Bounded API reads (`openapi.yaml` index, route file headers) | ≤15% session |

**Total API budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/architecture/{work_id}.md` | ARCH SSOT |
| `{project_root}/work/prd/{work_id}.md` | PRD requirement grounding (soft) |
| `{project_root}/work/database/{work_id}.md` | DB entity grounding (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/discovery/{work_id}.md` | Optional upstream context |
| `{project_root}/CONTEXT.md` | API base URL, auth conventions |
| `{project_root}/openapi.yaml` | **Index only** — path list, version |
| `{project_root}/**/routes/**` | **Markers only** — route names, HTTP methods |
| `{project_root}/docs/**` | Existing API notes (cite path) |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full handler implementations for copy-paste | EC-SCP-01 — design not code |
| Production API traffic logs | Security + out of scope |
| Vendor chat history as SSOT | Must persist API |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| ARCH body | ≤5 KB effective | Summarize data flows + component table; cite ARCH path |
| PRD body | ≤4 KB effective | Extract FR/NFR IDs for operations; cite PRD path |
| DB body | ≤4 KB effective | Extract entity/model names; cite DB path |
| CONTEXT.md | ≤3 KB effective | API base URL + auth digest with `source_sha` |
| API markers | ≤20 route paths | List only; no handler body dumps |
| OpenAPI index | ≤30 operation IDs | Link path; do not paste full spec |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | API file + Work Record — not chat |
| Session | Cache INDEX + CL-API + TP-api for run duration only |
| Evidence | Record in API §4 with `source` + `reference` |
| Revise | Load `prior_api_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use API conventions digest with `source_sha` |