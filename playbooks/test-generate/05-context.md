# PB-test-generate — Context

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | TEST-PLAN, CODE (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, test conventions, directory layout | ≤10% session |
| T3 | Bounded reads: CODE §4 paths, existing test files, API excerpts | ≤25% session |

**Total generation budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/testing/plan/{work_id}.md` | TEST-PLAN SSOT |
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT (soft) |
| `{project_root}/work/api/{work_id}.md` | Contract test grounding (soft) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Test runner, conventions, paths |
| `{project_root}/**/tests/**` | Existing tests — read for `existing` / `skipped` |
| `{project_root}/src/**` | Implementation under test — bounded per CODE §4 |
| `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` | Prerequisite gate |
| `{ai_dev_os_home}/checklists/test-generate.md` | CL-TEST-GEN |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist + test-plan gate) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production logs / traffic | Security + out of scope |
| CI job output / test reports | Execution — PB-verify domain |
| Full unrelated module bodies | Budget — read targeted paths only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| TEST-PLAN body | ≤8 KB effective | Extract §2.1 + §3 TC-* only |
| CODE body | ≤6 KB effective | Extract §4 paths + §6 notes |
| CONTEXT.md | ≤3 KB effective | Test command + path digest |
| Existing test files | ≤30 KB cumulative | Summarize patterns; do not dump all |
| Source under test | ≤15 KB cumulative | Read signatures + imports for scaffolding |
| API excerpt | ≤4 KB effective | Operation schemas for contract tests |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | TEST-GEN file + Work Record + generated test files — not chat |
| Session | Cache INDEX + CL-TEST-GEN for run duration only |
| Evidence | Record file paths in §3 — never execution output |
| Revise | Load `prior_test_gen`; preserve `approvals[]` append-only |
| Digest | If TEST-PLAN >8KB, TC digest with `source_sha` |