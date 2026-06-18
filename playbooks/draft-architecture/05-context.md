# PB-draft-architecture — Context

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision` | Fixed |
| T1 | PRD full text, WR frontmatter, INDEX workflow row | ≤10% session |
| T2 | CONTEXT.md: summary, module map, conventions; optional DISC | ≤12% session |
| T3 | Bounded structure reads (`src/**` markers, `docs/adr/`) | ≤18% session |

**Total architecture budget:** ≤40% of session `token_budget_total`.

---

## Allowed Reads

| Path | Purpose |
|------|---------|
| `{project_root}/work/prd/{work_id}.md` | PRD SSOT |
| `{project_root}/work/{work_id}.md` | Work Record |
| `{project_root}/work/discovery/{work_id}.md` | Optional upstream context |
| `{project_root}/CONTEXT.md` | Project domain & module map |
| `{project_root}/README.md` | Stack hints |
| `{project_root}/docs/**` | ADRs, existing architecture notes (cite path) |
| `{project_root}/docs/adr/**` | Decision references — index only, no duplication |
| `{project_root}/src/**` | **Markers only** — package layout, public exports, module headers |

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| Secrets, `.env`, credentials | Security |
| Unrelated projects | Isolation |
| Full source file dumps for implementation | EC-SCP-01 — architecture not code |
| Vendor chat history as SSOT | Must persist ARCH |

---

## Budget Table

| Resource | Cap | Overflow action |
|----------|-----|-------------------|
| PRD body | ≤6 KB effective | Summarize goals + FR IDs; cite PRD path |
| CONTEXT.md | ≤4 KB effective | Module-map digest with `source_sha` |
| `src/**` scan | ≤30 file markers | List top-level modules only |
| ADR index | ≤10 ADR titles | Link paths; do not paste full ADR text |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | ARCH file + Work Record — not chat |
| Session | Cache INDEX + CL-ARCH + TP-architecture for run duration only |
| Evidence | Record in ARCH §2 with `source` + `reference` |
| Revise | Load `prior_arch_artifact`; preserve `approvals[]` append-only |
| Digest | If CONTEXT.md >4KB, use module-map digest with `source_sha` |