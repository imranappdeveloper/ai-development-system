# PB-verify — Context

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | TEST-PLAN, TEST-GEN, CODE (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, test commands, CI labels | ≤10% session |
| T3 | Bounded reads: generated test files, CODE §4 paths — **execution allowed** | ≤25% session |

**Total verify budget:** ≤50% of session `token_budget_total` (excluding command output captured in §9).

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/testing/plan/{work_id}.md` | TEST-PLAN SSOT (soft) |
| `{project_root}/work/testing/generate/{work_id}.md` | TEST-GEN SSOT (soft) |
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT (soft) |
| `{project_root}/work/api/{work_id}.md` | Contract test grounding (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Test runner commands, env vars |
| `{project_root}/**/tests/**` | Generated and existing tests — read for execution |
| `{project_root}/src/**` | Implementation under test — bounded per CODE §4 |
| `{ai_dev_os_home}/templates/testing/template.md` | Output shape |
| `{ai_dev_os_home}/playbooks/test-generate/test-runs/latest-gate.md` | Prerequisite gate |
| `{ai_dev_os_home}/checklists/verify.md` | CL-VERIFY |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist + test-gen gate) | OS spec noise |
| Secrets, `.env`, credentials | Security — use env var names only |
| Unrelated projects | Isolation |
| Production logs / live traffic | Security + out of scope |
| Vendor chat history as SSOT | Must persist TEST-RPT |
| Full unrelated module bodies | Budget — read targeted paths only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| TEST-PLAN body | ≤6 KB effective | Extract §2.1 + §3 TC-* only |
| TEST-GEN body | ≤6 KB effective | Extract §3 catalog paths |
| CODE body | ≤4 KB effective | Extract §4 paths + §6 notes |
| CONTEXT.md | ≤3 KB effective | Test command digest |
| Test file bodies | ≤20 KB cumulative | Read targeted files from TEST-GEN §3 |
| Command output | Capture in §9 — truncate stack traces >2KB per failure | Summarize in §9.3 |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | TEST-RPT file + Work Record — not chat |
| Session | Cache INDEX + CL-VERIFY for run duration only |
| Evidence | Record commands and results in §9 — authoritative for H-VERIFY |
| Revise | Load `prior_test_rpt`; preserve `approvals[]` append-only |
| Digest | If TEST-PLAN >6KB, TC digest with `source_sha` |