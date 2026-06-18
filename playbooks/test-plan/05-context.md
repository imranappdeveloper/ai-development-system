# PB-test-plan — Context

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `issue_ids`, `revision` | Fixed |
| T1 | CODE (soft), PRD (soft), ISS/ISS-*, WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, test conventions, CI labels | ≤10% session |
| T3 | Bounded reads: CODE §4 paths, test file names from CODE §6 — **no execution** | ≤20% session |

**Total plan budget:** ≤45% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT (soft) |
| `{project_root}/work/prd/{work_id}.md` | PRD AC grounding (soft) |
| `{project_root}/work/issues/*.md` | ISS AC (soft) |
| `{project_root}/work/api/{work_id}.md` | Contract test grounding (soft) |
| `{project_root}/work/architecture/{work_id}.md` | Component boundaries (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Test runner, conventions |
| `{project_root}/**/tests/**` | File names and markers only — not full suite dump |
| `{ai_dev_os_home}/templates/testing/template.md` | Output shape |
| `{ai_dev_os_home}/playbooks/implement-devops/test-runs/latest-gate.md` | Prerequisite gate |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production logs / traffic | Security + out of scope |
| Vendor chat history as SSOT | Must persist TEST-PLAN |
| CI job output / test reports | Execution — PB-verify domain |
| Full unrelated module bodies | Budget — read targeted markers only |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| CODE body | ≤6 KB effective | Extract §2 AC + §4 paths + §6 notes |
| PRD body | ≤5 KB effective | Extract AC table only |
| ISS bodies (all in scope) | ≤8 KB effective | One AC row per issue |
| CONTEXT.md | ≤3 KB effective | Test command digest |
| Test file markers | ≤20 paths | List paths; no file bodies unless naming TC-* |
| API excerpt | ≤3 KB effective | Operation IDs for contract layer |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | TEST-PLAN file + Work Record — not chat |
| Session | Cache INDEX + CL-TEST-PLAN for run duration only |
| Evidence | Record planned TC-* in §3 — never execution output |
| Revise | Load `prior_test_plan`; preserve `approvals[]` append-only |
| Digest | If PRD >5KB, AC digest with `source_sha` |