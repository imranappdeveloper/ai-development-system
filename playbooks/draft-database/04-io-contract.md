# PB-draft-database — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
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
| Project artifacts | IN-40–IN-44 |
| Revise / loop | IN-50–IN-52 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `arch_artifact` | `{project_root}/work/architecture/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_database` | `{ai_dev_os_home}/checklists/database.md` |
| IN-32 | `template_database` | `{ai_dev_os_home}/templates/database/template.md` |
| IN-33 | `self_spec` | `{ai_dev_os_home}/playbooks/draft-database/` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / ARCH |
| IN-40 | `context_md` | When project exists |
| IN-41 | `prd_artifact` | When PRD linked in WR (soft — recommended) |
| IN-42 | `existing_schema_markers` | When `migrations/` or ORM models present |
| IN-43 | `discovery_artifact` | When DISC linked in WR (optional context) |
| IN-44 | `perf_baseline` | WF-PERF with existing baseline artifact |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_db_artifact` | Revise loop |
| IN-52 | `human_waiver` | ARCH not yet approved but human directs database design |
| IN-53 | `prd_gap_waiver` | PRD absent; human documents `prd_gap: waiver` |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | DB artifact | `{project_root}/work/database/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — DB frontmatter

```yaml
document_id: DB-{work_id}
work_id: WR-###
change_type: new_schema | migration | optimization
workflow_id: WF-*
database_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_arch_path: <ARCH path>
upstream_prd_path: <PRD path or null>
template_id: TP-database
```

### OUT-01 — Required ARCH alignment block (§1.3)

```yaml
arch_alignment:
  arch_document_id: <from ARCH>
  arch_work_id: <from ARCH>
  alignment: aligned | partial_mismatch | requires_arch_revise
  mismatch_summary: <if not aligned>
  arch_path: <relative path — mandatory>
```

### OUT-01 — PRD alignment block (§1.3 — when PRD present)

```yaml
prd_alignment:
  prd_document_id: <from PRD>
  prd_work_id: <from PRD>
  alignment: aligned | partial_mismatch | requires_prd_revise | not_applicable
  mismatch_summary: <if not aligned>
  prd_path: <relative path>
prd_gap: none | missing | waiver
```

### OUT-02 — Work Record additions

```yaml
status: database_in_progress | database_pending_review | plan_approved | database_rejected
artifacts:
  - type: DB
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-database
  workflow_phase: Plan
approvals:
  - gate_id: H-PLAN
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-DATABASE
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, DB + WR paths, OUT-03, decisions for H-PLAN, `recommended_next_skill`, `gate_id: H-PLAN`, `decision: pending`.

### OUT-05 — Escalation

Triggered after 3 failed CL-DATABASE attempts or irrecoverable ARCH gap. Includes: failed checks, blocker summary, recommended human action (`revise ARCH`, `waive PRD`, `abort`).

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-PLAN `approve` / `revise` / `reject` | Human only — never agent |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Plan
playbook_invocation:
  skill_id: PB-draft-database
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: ARCH
    path: work/architecture/WR-FEATURE-ALPHA.md
  - type: PRD
    path: work/prd/WR-FEATURE-ALPHA.md
token_budget_remaining: 120000
```