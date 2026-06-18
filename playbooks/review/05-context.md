# PB-review — Context

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | CODE, ISS/ISS-*, PRD (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: style, review conventions, severity policy | ≤10% session |
| T3 | Bounded reads: CODE §4 changed files — markers and diff context only | ≤25% session |

**Total review budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT |
| `{project_root}/work/review/{work_id}.md` | Prior review on revise |
| `{project_root}/work/prd/{work_id}.md` | PRD AC grounding (soft) |
| `{project_root}/work/issues/*.md` | ISS AC (soft) |
| `{project_root}/work/testing/plan/{work_id}.md` | TEST-PLAN chain context (soft) |
| `{project_root}/work/testing/{work_id}.md` | TEST-RPT when linked (soft) |
| `{project_root}/work/api/{work_id}.md` | API contract review (soft) |
| `{project_root}/work/architecture/{work_id}.md` | Boundary context (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project conventions |
| CODE §4 listed source paths | Changed file bodies — bounded per budget |
| `{ai_dev_os_home}/templates/review/template.md` | Output shape |
| `{ai_dev_os_home}/standards/engineering/STD-REVIEW-001.md` | Review dimensions |
| `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` | Chain prerequisite |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production logs / traffic | Security + out of scope |
| Vendor chat history as SSOT | Must persist REVIEW |
| Full unrelated module bodies | Budget — CODE §4 paths only |
| Unchanged files outside CODE §4 | Scope creep |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| CODE body | ≤6 KB effective | Extract §2 AC + §4 paths + §6 notes |
| PRD body | ≤5 KB effective | Extract AC table only |
| ISS bodies (all in scope) | ≤8 KB effective | One AC row per issue |
| CONTEXT.md | ≤3 KB effective | Style/severity digest |
| Changed source files | ≤30 KB total | Summarize by file; cite line ranges |
| TEST-PLAN excerpt | ≤4 KB effective | TC-* cross-reference only |
| TEST-RPT excerpt | ≤4 KB effective | Pass/fail summary only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | REVIEW file + Work Record — not chat |
| Session | Cache INDEX + CL-REVIEW for run duration only |
| Evidence | Cite file:line in findings — not full file dump |
| Revise | Load `prior_review`; preserve `approvals[]` append-only |
| Digest | If CODE §4 >15 files, group by module with representative samples |