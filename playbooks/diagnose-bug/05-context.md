# PB-diagnose-bug — Context

| Field | Value |
|-------|-------|
| skill_id | PB-diagnose-bug |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | Upstream artifact, WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | Soft upstream, CONTEXT.md | ≤10% session |
| T3 | Bounded code markers (paths only) | ≤10% session |

**Total budget:** ≤30% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/diagnose/{work_id}.md` | Prior artifact on revise |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Stack, module map |
| Upstream paths per 04-io-contract | SSOT inputs |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full implementation dumps for copy-paste | Scope violation |
| Production PII logs | Security |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| Upstream body | ≤6 KB effective | Extract tables; cite path |
| CONTEXT.md | ≤2 KB effective | Stack digest |
| Code markers | ≤15 file paths | List only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | DIAG file + Work Record |
| Session | Cache INDEX + checklist for run duration |
| Revise | Load `prior_artifact`; preserve `approvals[]` append-only |
