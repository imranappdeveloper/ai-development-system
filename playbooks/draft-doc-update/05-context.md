# PB-draft-doc-update — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `doc_plan_type`, `doc_scope` | Fixed |
| T1 | INT full text, WR frontmatter, INDEX workflow row, quality-chain artifact summaries (soft) | ≤10% session |
| T2 | CONTEXT.md: summary, module map; doc tree listing | ≤12% session |
| T3 | Bounded doc file reads (headers + drift check) | ≤10% session |

**Total DOC-PLAN budget:** ≤32% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/intake/{work_id}.md` | INT SSOT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Project domain |
| `{project_root}/README.md` | Entry and stack hints |
| `{project_root}/docs/**` | Inventory headers, TOC, metadata — **not full rewrite** |
| `{project_root}/CHANGELOG.md` | Changelog doc_plan_type seed |
| `{project_root}/work/review/{work_id}.md` | REVIEW findings (soft) |
| `{project_root}/work/security-review/{work_id}.md` | SEC-REVIEW findings (soft) |
| `{project_root}/work/perf-review/{work_id}.md` | PERF-REVIEW findings (soft) |
| `{project_root}/work/implement/**/{work_id}.md` | CODE §4 paths for doc targets (soft) |
| `{ai_dev_os_home}/standards/engineering/STD-DOC-001.md` | Document classes |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/workflows/project-orchestrator/routing-matrix.yaml` | Do not duplicate in outputs |
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full `src/**` implementation audit | Out of scope — cite CODE §4 paths only when linked |

---

## Inventory Survey Rules

| Rule | Action |
|------|--------|
| List before plan | §4 inventory precedes §5 DU-* rows |
| Drift signal | `green` = current; `yellow` = stale TOC/metadata; `red` = missing or contradicts INT |
| Path evidence | Every §4 row cites existence check or explicit `missing` |
| No content paste | Do not copy full doc bodies into DOC-PLAN — summarize change intent |
| OS docs | `doc_scope: os_docs` requires explicit INT scope signal — default `project_docs` |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | DOC-PLAN file + Work Record — not chat |
| Session | Cache INDEX + CL-DOC-UPDATE for run duration only |
| Upstream | Record INT path in DOC-PLAN §3 |
| Revise | Load `prior_doc_plan`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >4KB, use module-map digest with `source_sha` |
| Quality-chain absent | Set `quality_chain_gap`; do not fabricate findings |