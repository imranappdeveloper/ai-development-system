# PB-security-assess — Context

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | INT, WR frontmatter, INDEX workflow row, STD-SEC-001 | ≤10% session |
| T2 | CONTEXT.md architecture slice | ≤10% session |
| T3 | Bounded module/path markers (no full source dumps) | ≤10% session |

**Total budget:** ≤30% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/security/{work_id}.md` | Prior artifact on revise |
| `{project_root}/work/intake/{work_id}.md` | Upstream INT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Stack, auth conventions, module map |
| `{ai_dev_os_home}/standards/engineering/STD-SEC-001.md` | Redaction and scope rules |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, `*.pem`, `credentials.*` | STD-SEC-001 / STD-CTX-001 |
| Unrelated projects | Isolation |
| Full `src/**` tree for copy-paste | Plan assess — not code audit |
| Production PII logs | Security |
| Implemented CODE artifacts | PB-security-review scope |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| INT body | ≤8 KB effective | Extract security signals; cite path |
| CONTEXT.md | ≤3 KB effective | Stack and auth digest |
| Architecture markers | ≤20 file paths | List only — no file bodies |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | SEC-ASSESS file + Work Record |
| Session | Cache INDEX + checklist for run duration |
| Revise | Load `prior_artifact`; preserve `approvals[]` append-only |
| Redaction | `[REDACTED]` for any credential or PII in INT |