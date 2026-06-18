# PB-draft-ui-ux — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| status | draft |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | PRD full text, ARCH (soft), DISC (soft), WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: design system, breakpoints, a11y baseline; optional API | ≤10% session |
| T3 | Bounded UI reads (component file headers, route names) | ≤15% session |

**Total UIUX budget:** ≤35% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/prd/{work_id}.md` | PRD SSOT |
| `{project_root}/work/architecture/{work_id}.md` | ARCH component grounding (soft) |
| `{project_root}/work/discovery/{work_id}.md` | DISC user research (soft) |
| `{project_root}/work/api/{work_id}.md` | Data-display constraints (optional) |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/CONTEXT.md` | Design tokens, breakpoints, a11y conventions |
| `{project_root}/**/components/**` | **Markers only** — component names, props headers |
| `{project_root}/**/pages/**` | **Markers only** — route/screen names |
| `{project_root}/docs/**` | Existing UX notes (cite path) |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full component implementations for copy-paste | EC-SCP-01 — design not code |
| Production analytics dashboards | Out of scope |
| Vendor chat history as SSOT | Must persist UIUX |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-----------------|
| PRD body | ≤5 KB effective | Extract FR/NFR IDs for journeys; cite PRD path |
| ARCH body | ≤4 KB effective | Summarize component table + data flows; cite ARCH path |
| DISC body | ≤4 KB effective | Extract personas + pain points; cite DISC path |
| CONTEXT.md | ≤3 KB effective | Design system digest with `source_sha` |
| UI markers | ≤20 component/page paths | List only; no JSX/CSS body dumps |
| API summary | ≤2 KB effective | Field names for display only |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | UIUX file + Work Record — not chat |
| Session | Cache INDEX + CL-UIUX + TP-uiux for run duration only |
| Evidence | Record in UIUX §2 with `source` + `reference` |
| Revise | Load `prior_uiux_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >3KB, use design-system digest with `source_sha` |