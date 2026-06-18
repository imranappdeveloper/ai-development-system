# PB-implement-frontend — Context

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | ISS/ISS-* full text, UIUX (soft), API (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, component map, test conventions | ≤10% session |
| T3 | Bounded code reads (component headers, route files, test file names) | ≤25% session |

**Total implement budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/issues/*.md` | ISS SSOT |
| `{project_root}/work/uiux/{work_id}.md` | UIUX screen/interaction grounding (soft) |
| `{project_root}/work/api/{work_id}.md` | API client contract grounding (soft) |
| `{project_root}/work/architecture/{work_id}.md` | Component boundaries (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Stack, test runner, component layout |
| `{project_root}/**/components/**` | Component index — targeted reads only |
| `{project_root}/**/pages/**` | Route/page markers |
| `{project_root}/**/hooks/**` | Client logic markers |
| `{project_root}/**/tests/**` | Test file markers — not full suite dump |
| `{project_root}/**/stories/**` | Storybook index when present |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production logs / analytics PII | Security + out of scope |
| Vendor chat history as SSOT | Must persist CODE |
| Full unrelated module bodies | Budget — read targeted files only |
| Server route/migration bodies | Backend lane scope |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| ISS body (all in scope) | ≤8 KB effective | Summarize AC per issue; cite paths |
| UIUX body | ≤5 KB effective | Extract screen IDs; cite UIUX path |
| API body | ≤5 KB effective | Extract operation IDs for client calls |
| CONTEXT.md | ≤3 KB effective | Stack + test command digest |
| Code markers | ≤30 file paths | List paths; read bodies only for edit targets |
| Test output | ≤2 KB | Summary counts + failing test names |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | CODE file + Work Record + repository — not chat |
| Session | Cache INDEX + CL-IMPLEMENT-FRONTEND for run duration only |
| Evidence | Record in CODE §3 with `issue_id` + `commit_ref` or `file_path` |
| Revise | Load `prior_code_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use stack digest with `source_sha` |