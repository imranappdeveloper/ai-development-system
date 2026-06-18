# PB-implement-devops — Context

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | ISS/ISS-* full text, ARCH (soft), REL (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: CI platform, IaC tool, deploy targets | ≤10% session |
| T3 | Bounded code reads (workflow headers, terraform module names, k8s manifest filenames) | ≤25% session |

**Total implement budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/issues/*.md` | ISS SSOT |
| `{project_root}/work/architecture/{work_id}.md` | Topology and deploy boundary grounding (soft) |
| `{project_root}/work/release/{work_id}.md` | Release context grounding (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | CI platform, IaC tool, environment names |
| `{project_root}/.github/workflows/**` | CI workflow markers |
| `{project_root}/.gitlab-ci.yml` | Pipeline index |
| `{project_root}/**/terraform/**` | IaC module index — filenames and module headers |
| `{project_root}/**/k8s/**` | Manifest index — filenames only |
| `{project_root}/**/helm/**` | Chart index |
| `{project_root}/docker-compose*.yml` | Local deploy markers |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials, `*.pem`, `kubeconfig` | Security |
| Unrelated projects | Isolation |
| Production cluster state / live deploy logs | Security + out of scope |
| Vendor chat history as SSOT | Must persist CODE |
| Full unrelated module bodies | Budget — read targeted files only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| ISS body (all in scope) | ≤8 KB effective | Summarize AC per issue; cite paths |
| ARCH body | ≤5 KB effective | Extract deploy boundaries; cite ARCH path |
| REL body | ≤5 KB effective | Extract release targets; cite REL path |
| CONTEXT.md | ≤3 KB effective | CI platform + IaC tool digest |
| Code markers | ≤30 file paths | List paths; read bodies only for edit targets |
| Plan/dry-run output | ≤2 KB | Summary counts + blocking errors only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | CODE file + Work Record + repository — not chat |
| Session | Cache INDEX + CL-IMPLEMENT-DEVOPS for run duration only |
| Evidence | Record in CODE §3 with `issue_id` + `commit_ref` or `file_path` |
| Revise | Load `prior_code_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use stack digest with `source_sha` |