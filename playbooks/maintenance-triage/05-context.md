# PB-maintenance-triage — Context

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | INT full text, WR frontmatter, INDEX workflow row | ≤8% session |
| T2 | REL (when linked), CONTEXT.md slice | ≤12% session |
| T3 | Evidence markers (deps, alerts, metrics) | ≤15% session |

**Total triage budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/intake/{work_id}.md` | INT SSOT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/release/{work_id}.md` | REL (soft, post-release) |
| `{project_root}/work/maintenance/{work_id}.md` | Prior MAINT (revise) |
| `{project_root}/CONTEXT.md` | Docs drift §6 |
| `{project_root}/package.json`, `requirements.txt`, `go.mod` | Dependency hygiene markers |
| `{project_root}/docs/**` | Runbook drift evidence |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| Production credentials, `.env` | Security |
| Live production APIs for mutation | N2 — no operate execution |
| Unrelated projects | Isolation |
| Full codebase dumps | Use cited markers only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | MAINT file + Work Record — not chat |
| REL | Cite version and §8 verification when post-release |
| Session | Cache INDEX + CL-MAINT for run duration only |
| Batch | Track `batch_depth` ≤ 2 per G-WF-MNT-01 |
| Revise | Load `prior_maint_artifact`; preserve `approvals[]` append-only |