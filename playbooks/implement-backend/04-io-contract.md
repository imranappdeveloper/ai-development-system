# PB-implement-backend — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-implement-backend |
| version | 1.0.0 |
| status | draft |
| document | 04-io-contract |

**Contract rule:** Undocumented I/O is forbidden.

---

## Input Summary

| Category | IDs used |
|----------|----------|
| Invocation | IN-01, IN-02 |
| Human / request | IN-10, IN-11 |
| Environment | IN-20, IN-21 |
| OS artifacts | IN-30–IN-33 |
| Project artifacts | IN-40–IN-47 |
| Revise / loop | IN-50–IN-54 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `issue_artifacts` | `{project_root}/work/issues/{issue_id}.md` or ISS index in WR |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_implement_backend` | `{ai_dev_os_home}/checklists/implement-backend.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/implement-backend/` |
| IN-33 | `implement_umbrella` | `{ai_dev_os_home}/playbooks/implement/` (lane context only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `api_artifact` | When API linked in WR (soft) |
| IN-42 | `db_artifact` | When DB linked in WR (soft) |
| IN-43 | `arch_artifact` | When ARCH linked (optional context) |
| IN-44 | `existing_code_markers` | When route/migration files present |
| IN-45 | `issue_ids` | Explicit ISS-* list from orchestrator |
| IN-46 | `security_baseline` | WF-SECURITY with SEC-ASSESS linked |
| IN-47 | `prior_code_artifact` | `mode: revise` |
| IN-50 | `human_revise_notes` | H-IMPLEMENT revise |
| IN-51 | `human_waiver` | ISS absent but human directs implement (WF-BUGFIX edge) |
| IN-52 | `api_gap_waiver` | API absent; human documents `api_gap: waiver` |
| IN-53 | `db_gap_waiver` | DB absent; human documents `db_gap: waiver` |
| IN-54 | `target_issue_id` | Single ISS scope for partial implement run |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | CODE artifact | `{project_root}/work/implement/backend/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — CODE frontmatter

```yaml
document_id: CODE-BE-{work_id}
work_id: WR-###
implement_lane: backend
implement_scope: api_handlers | migrations | server_logic | mixed_backend
workflow_id: WF-*
implement_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_issue_paths: [<ISS paths>]
upstream_api_path: <API path or null>
upstream_db_path: <DB path or null>
```

### OUT-01 — Required API alignment block (when API present)

```yaml
api_alignment:
  api_document_id: <from API>
  api_work_id: <from API>
  alignment: aligned | partial_mismatch | requires_api_revise
  mismatch_summary: <if not aligned>
  api_path: <relative path — mandatory when API linked>
api_gap: none | missing | waiver
```

### OUT-01 — DB alignment block (when DB present)

```yaml
db_alignment:
  db_document_id: <from DB>
  db_work_id: <from DB>
  alignment: aligned | partial_mismatch | requires_db_revise
  mismatch_summary: <if not aligned>
  db_path: <relative path>
db_gap: none | missing | waiver
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Overview | yes |
| 2 | Issue Traceability | yes |
| 3 | Implementation Log | yes |
| 4 | Files Changed | yes |
| 5 | Migrations & Rollback | when migrations |
| 6 | Testing Notes | yes — never empty |
| 7 | Security Notes | when auth/data changes |
| 8 | Open Questions | when applicable |
| 9 | Human Approval | yes |

### OUT-02 — Work Record additions

```yaml
status: implement_backend_in_progress | implement_backend_pending_review | implement_approved | implement_rejected
artifacts:
  - type: CODE
    lane: backend
    path: <OUT-01 path>
os_refs:
  skill: PB-implement-backend
  workflow_phase: Implement
  implement_lane: backend
approvals:
  - gate_id: H-IMPLEMENT
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-IMPLEMENT-BACKEND
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, CODE + WR paths, OUT-03, tests summary, `recommended_next_skill: PB-verify`, `gate_id: H-IMPLEMENT`, `decision: pending`. **Must NOT** include deploy commands or release steps.

### OUT-05 — Escalation

Triggered after 3 failed CL-IMPLEMENT-BACKEND attempts or irrecoverable API/DB gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-IMPLEMENT `approve` / `revise` / `reject` | Human only — never agent |
| Production deployment | Human only — never agent |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Implement
playbook_invocation:
  skill_id: PB-implement-backend
  mode: new | resume | revise
  implement_lane: backend
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: ISS
    path: work/issues/ISS-BE-001.md
  - type: API
    path: work/api/WR-FEATURE-ALPHA.md
  - type: DB
    path: work/database/WR-FEATURE-ALPHA.md
issue_ids:
  - ISS-BE-001
token_budget_remaining: 120000
```