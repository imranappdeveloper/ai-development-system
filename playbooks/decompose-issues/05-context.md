# PB-decompose-issues — Context

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | PRD full text, WR frontmatter, INDEX workflow row, manifest prior | ≤10% session |
| T2 | ARCH/API/DB/UIUX (soft), CONTEXT.md, optional DISC | ≤10% session |
| T3 | Bounded code markers (module names, route list) | ≤10% session |

**Total decompose budget:** ≤30% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/prd/{work_id}.md` | PRD SSOT |
| `{project_root}/work/architecture/{work_id}.md` | Lane and component hints (soft) |
| `{project_root}/work/api/{work_id}.md` | Endpoint boundaries for ISS-BE (soft) |
| `{project_root}/work/database/{work_id}.md` | Migration scope hints (soft) |
| `{project_root}/work/uiux/{work_id}.md` | Screen inventory for ISS-FE (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/discovery/{work_id}.md` | Optional upstream context |
| `{project_root}/CONTEXT.md` | Stack, module map |
| `{project_root}/work/issues/*.md` | Prior issues on revise |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full handler/UI implementations for copy-paste | EC-SCP-01 — design not code |
| Production logs | Security + out of scope |
| Vendor chat history as SSOT | Must persist ISS-* |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| PRD body | ≤6 KB effective | Extract FR/NFR/US table; cite PRD path |
| ARCH body | ≤3 KB effective | Component table digest; cite ARCH path |
| API body | ≤3 KB effective | Endpoint IDs only; cite API path |
| DB body | ≤2 KB effective | Entity names only; cite DB path |
| UIUX body | ≤3 KB effective | Screen IDs only; cite UIUX path |
| CONTEXT.md | ≤2 KB effective | Stack digest with `source_sha` |
| Code markers | ≤15 file paths | List only; no source dumps |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | ISS-* files + manifest + Work Record — not chat |
| Session | Cache INDEX + CL-DECOMP for run duration only |
| Evidence | Record in manifest coverage map with PRD ref |
| Revise | Load `prior_issue_artifacts`; preserve `approvals[]` append-only |
| Digest | If PRD >6KB, use FR/NFR index with `source_sha` |