# PB-draft-database — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | ARCH full text, PRD (soft), WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: stack, datastore, module map; optional DISC | ≤10% session |
| T3 | Bounded schema reads (`migrations/**`, ORM model headers, `schema.sql` index) | ≤15% session |

**Total database budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/architecture/{work_id}.md` | ARCH SSOT |
| `{project_root}/work/prd/{work_id}.md` | PRD entity grounding (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/discovery/{work_id}.md` | Optional upstream context |
| `{project_root}/CONTEXT.md` | Datastore type, conventions |
| `{project_root}/migrations/**` | **Headers only** — version list, table names |
| `{project_root}/**/models/**` | **Markers only** — entity class names, table mappings |
| `{project_root}/schema.sql` | **Index only** — table list if present |
| `{project_root}/docs/**` | Existing data dictionary notes (cite path) |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full migration file bodies for copy-paste | EC-SCP-01 — design not DDL |
| Production database connections | Security + out of scope |
| Vendor chat history as SSOT | Must persist DB |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| ARCH body | ≤5 KB effective | Summarize data flows + component table; cite ARCH path |
| PRD body | ≤4 KB effective | Extract FR/NFR IDs for entities; cite PRD path |
| CONTEXT.md | ≤3 KB effective | Datastore + naming digest with `source_sha` |
| Schema markers | ≤20 table names | List only; no column dumps |
| Migration index | ≤15 migration filenames | Link paths; do not paste SQL |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | DB file + Work Record — not chat |
| Session | Cache INDEX + CL-DATABASE + TP-database for run duration only |
| Evidence | Record in DB §2 with `source` + `reference` |
| Revise | Load `prior_db_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use datastore digest with `source_sha` |