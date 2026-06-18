# PB-perf-baseline — Context

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 05-context |

Per **STD-PERF-001** — token and context discipline for orchestration; application runtime profiling is out of scope.

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | INT artifact, WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | Soft upstream (PRD NFR), CONTEXT.md | ≤10% session |
| T3 | Bounded module map paths (no full repo scan) | ≤10% session |

**Total budget:** ≤30% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/performance/{work_id}.md` | Prior artifact on revise |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/intake/{work_id}.md` | INT performance signals |
| `{project_root}/CONTEXT.md` | Stack, module map |
| Upstream paths per 04-io-contract | SSOT inputs |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full implementation dumps | Scope violation — Plan phase |
| Production PII logs | Security |
| Benchmark result databases | Execution data — Verify phase |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| INT body | ≤6 KB effective | Extract perf signals table |
| PRD NFR slice | ≤4 KB effective | Target digest only |
| CONTEXT.md | ≤2 KB effective | Stack digest |
| Module map paths | ≤15 file paths | List only — no file bodies |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | PERF-BASE file + Work Record |
| Session | Cache INDEX + checklist for run duration |
| Revise | Load `prior_artifact`; preserve `approvals[]` append-only |
| Digest | If INT >6KB, cite path + SHA digest per STD-PERF-001 |