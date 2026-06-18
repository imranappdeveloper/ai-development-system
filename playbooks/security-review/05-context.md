# PB-security-review — Context

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `implement_lane` | Fixed |
| T1 | CODE full text, SEC-ASSESS (soft), TEST-RPT (soft), WR frontmatter, INDEX workflow row | ≤15% session |
| T2 | CONTEXT.md: stack, auth patterns, security conventions | ≤10% session |
| T3 | Bounded code reads (CODE §4 paths only — auth handlers, validators, crypto utils) | ≤30% session |

**Total review budget:** ≤55% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/implement/**/{work_id}.md` | CODE SSOT |
| `{project_root}/work/security/{work_id}.md` | SEC-ASSESS grounding (soft) |
| `{project_root}/work/testing/{work_id}.md` | TEST-RPT (optional) |
| `{project_root}/work/issues/*.md` | ISS acceptance criteria (when linked) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Stack, auth middleware, security lint rules |
| CODE §4 cited repository paths | Security review targets only |
| `{project_root}/**/middleware/**` | Auth/session markers when in CODE §4 |
| `{project_root}/package-lock.json` | Dependency diff summary — not full tree |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Production logs / traffic | Security + out of scope |
| Vendor chat history as SSOT | Must persist SEC-REVIEW |
| Full unrelated module bodies | Budget — CODE §4 paths only |
| Plan-phase only artifacts without CODE | Wrong phase — use PB-security-assess |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| CODE body | ≤8 KB effective | Extract §4 paths + §7 security notes |
| SEC-ASSESS body | ≤5 KB effective | Extract control IDs; cite assess path |
| TEST-RPT body | ≤3 KB effective | Extract security-relevant test results |
| CONTEXT.md | ≤3 KB effective | Auth + validation digest |
| Code file bodies | ≤25 KB aggregate | Prioritize auth/input/crypto files |
| Dependency diff | ≤2 KB | List changed packages only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | SEC-REVIEW file + Work Record — not chat |
| Session | Cache INDEX + CL-SECURITY-REVIEW for run duration only |
| Evidence | Record in §4 with `file_path` + `line_range` or `symbol` |
| Revise | Load `prior_sec_review`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use security digest with `source_sha` |