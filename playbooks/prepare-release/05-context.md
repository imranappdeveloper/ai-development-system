# PB-prepare-release — Context

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `semver_hint`, `revision` | Fixed |
| T1 | CODE, TEST-RPT (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: deploy conventions, semver policy, comms channels | ≤10% session |
| T3 | Bounded reads: CODE §4 changed files — changelog grounding only | ≤20% session |

**Total release budget:** ≤45% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT |
| `{project_root}/work/release/{work_id}.md` | Prior REL on revise |
| `{project_root}/work/testing/{work_id}.md` | TEST-RPT evidence (soft) |
| `{project_root}/work/review/{work_id}.md` | REVIEW open items (soft) |
| `{project_root}/work/security-review/{work_id}.md` | SEC-REVIEW (soft) |
| `{project_root}/work/perf-review/{work_id}.md` | PERF-REVIEW (soft) |
| `{project_root}/work/doc-plan/{work_id}.md` | DOC-PLAN (soft) |
| `{project_root}/work/prd/{work_id}.md` | PRD scope (soft) |
| `{project_root}/work/issues/*.md` | ISS scope (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project conventions |
| CODE §4 listed paths | File list for changelog — not full audit |
| `{ai_dev_os_home}/templates/release/template.md` | Output shape |
| `{ai_dev_os_home}/standards/engineering/STD-PROD-001.md` | Prod readiness |
| `{ai_dev_os_home}/standards/engineering/STD-CI-001.md` | CI evidence |
| `{ai_dev_os_home}/workflows/project-orchestrator/gates.yaml` | WF-RELEASE waivers |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials, kubeconfig | Security |
| Unrelated projects | Isolation |
| Production logs / live metrics | Security + out of scope |
| Vendor chat history as SSOT | Must persist REL |
| Full unrelated module bodies | Budget — CODE §4 paths only |
| CI/CD secret values | Redact references only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| CODE body | ≤6 KB effective | Extract §2 AC + §4 paths + §6 validation notes |
| TEST-RPT body | ≤5 KB effective | Extract §8 pass/fail summary only |
| REVIEW / SEC / PERF bodies | ≤4 KB each | Extract §5 blockers + §11 open items |
| PRD body | ≤4 KB effective | Extract scope table only |
| ISS bodies (all in scope) | ≤6 KB effective | One summary row per issue |
| CONTEXT.md | ≤3 KB effective | Deploy/semver digest |
| Changed source file names | ≤15 KB list | Group by module; no full file bodies |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | REL file + Work Record — not chat |
| Session | Cache INDEX + CL-RELEASE for run duration only |
| Evidence | Cite TEST-RPT row IDs in §8.1 — not full log dump |
| Revise | Load `prior_rel`; preserve `approvals[]` append-only |
| Digest | Multi-lane CODE → one §2.1 row per lane work_id |