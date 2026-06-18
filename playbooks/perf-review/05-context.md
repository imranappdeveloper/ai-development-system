# PB-perf-review — Context

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `implement_lane_hint` | Fixed |
| T1 | CODE, PERF-BASE (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, DB, perf conventions | ≤10% session |
| T3 | Bounded reads: CODE §4 changed files — static analysis only | ≤25% session |

**Total review budget:** ≤50% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT |
| `{project_root}/work/performance/{work_id}.md` | PERF-BASE targets (soft) |
| `{project_root}/work/prd/{work_id}.md` | NFR section (soft) |
| `{project_root}/work/testing/plan/{work_id}.md` | Planned perf scenarios (soft) |
| `{project_root}/work/testing/{work_id}.md` | TEST-RPT evidence (soft) |
| `{project_root}/work/architecture/{work_id}.md` | Component boundaries (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Stack, ORM, query patterns |
| `{project_root}/**/src/**` | Changed hot-path files from CODE §4 only |
| `{project_root}/**/migrations/**` | Schema/index review when in CODE §4 |
| `{ai_dev_os_home}/templates/review/template.md` | Output shape |
| `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` | Prerequisite gate |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production APM / traffic dumps | Security + out of scope |
| Full unrelated module trees | Budget — CODE §4 scoped only |
| CI benchmark job output as SSOT | Execution — human/PB-verify domain |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| CODE body | ≤6 KB effective | Extract §4 paths + §3 issue map |
| PERF-BASE body | ≤5 KB effective | Extract target table only |
| PRD NFR excerpt | ≤3 KB effective | NFR IDs + thresholds |
| CONTEXT.md | ≤3 KB effective | Stack + DB digest |
| Changed source files | ≤8 files / ≤12 KB each | Prioritize CODE §4 order |
| TEST-PLAN perf § | ≤3 KB effective | Scenario IDs only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | PERF-REVIEW file + Work Record — not chat |
| Session | Cache INDEX + CL-PERF-REVIEW for run duration only |
| Evidence | §6 remains `review_only` — never benchmark output |
| Revise | Load `prior_perf_review`; preserve `approvals[]` append-only |
| Digest | If PERF-BASE >5KB, target digest with `source_sha` |