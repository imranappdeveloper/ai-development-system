# PB-implement-mobile — Context

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `platform_target`, `revision` | Fixed |
| T1 | ISS/ISS-* full text, UIUX (soft required), API (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: mobile stack, module map, test conventions | ≤10% session |
| T3 | Bounded code reads (screen headers, navigation config, test file names) | ≤25% session |

**Total implement budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/issues/*.md` | ISS SSOT |
| `{project_root}/work/uiux/{work_id}.md` | UIUX screen flow grounding (soft required) |
| `{project_root}/work/api/{work_id}.md` | API contract for data-fetch (soft) |
| `{project_root}/work/architecture/{work_id}.md` | Component boundaries (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Mobile stack, test runner, module layout |
| `{project_root}/**/screens/**` | Screen registration markers |
| `{project_root}/**/navigation/**` | Navigator config markers |
| `{project_root}/**/__tests__/**` | Test file markers — not full suite dump |
| `{project_root}/**/e2e/**` | E2E test index when present |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials, keystore paths | Security |
| Unrelated projects | Isolation |
| Production analytics / crash logs with PII | Security + out of scope |
| Vendor chat history as SSOT | Must persist CODE |
| Full unrelated module bodies | Budget — read targeted files only |
| Backend route/migration bodies | Wrong lane — cite API path only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| ISS body (all in scope) | ≤8 KB effective | Summarize AC per issue; cite paths |
| UIUX body | ≤6 KB effective | Extract screen IDs and states; cite UIUX path |
| API body | ≤4 KB effective | Extract operation IDs for data-fetch; cite API path |
| CONTEXT.md | ≤3 KB effective | Stack + test command digest |
| Code markers | ≤30 file paths | List paths; read bodies only for edit targets |
| Test output | ≤2 KB | Summary counts + failing test names |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | CODE file + Work Record + repository — not chat |
| Session | Cache INDEX + CL-IMPLEMENT-MOBILE for run duration only |
| Evidence | Record in CODE §3 with `issue_id` + `commit_ref` or `file_path` |
| Revise | Load `prior_code_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use stack digest with `source_sha` |