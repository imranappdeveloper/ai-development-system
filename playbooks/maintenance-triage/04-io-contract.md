# PB-maintenance-triage — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 04-io-contract |

**Contract rule:** Undocumented I/O is forbidden.

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `intake_artifact` | `{project_root}/work/intake/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-12 | `maintenance_template` | `{ai_dev_os_home}/templates/maintenance/template.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_maint` | `{ai_dev_os_home}/checklists/maintenance.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-40 | `context_md` | When project exists (soft) |
| IN-42 | `rel_artifact` | Post-release / WF-RELEASE (soft) |
| IN-50 | `human_revise_notes` | H-OPERATE revise |
| IN-51 | `prior_maint_artifact` | Revise loop |
| IN-52 | `cycle_type_hint` | scheduled \| reactive \| hygiene |
| IN-53 | `child_work_ids_hint` | Human provides existing children |
| IN-54 | `human_waiver` | INT not yet approved but human directs triage |
| IN-61 | `workflow_id` | WF-MAINTENANCE \| WF-RELEASE |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | MAINT artifact | `{project_root}/work/maintenance/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — MAINT frontmatter

```yaml
document_id: MAINT-{work_id}
work_id: WR-###
workflow_id: WF-MAINTENANCE | WF-RELEASE
cycle_type: scheduled | reactive | hygiene
triage_confidence: high | medium | low
status: draft | active | closed
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
upstream_rel_path: <REL path or null>
template_ref: templates/maintenance/template.md
batch_depth: 0-2
```

### OUT-01 — Required sections (from TP-maintenance)

| § | Title | Required |
|---|-------|----------|
| 1 | Cycle Overview | yes |
| 2 | Health Snapshot | yes — all 5 signals in §2.1 |
| 3 | Maintenance Backlog | yes — §3.1 ≥1 item; §3.2 approved; §3.3 deferred |
| 4 | Dependency & Security Hygiene | yes |
| 5 | Technical Debt Review | yes — ≥1 row or explicit none |
| 6 | Documentation & Context Drift | when CONTEXT present |
| 7 | Child Work Records | proposals only — no spawn |
| 10 | Follow-Ups | yes |
| Human Approval | Cycle Close | `gate_id: H-OPERATE`, `decision: pending` |

### OUT-02 — Work Record additions

```yaml
status: maintenance_in_progress | maintenance_pending_review | maintenance_complete | maintenance_rejected
artifacts:
  - type: MAINT
    path: <OUT-01 path>
os_refs:
  skill: PB-maintenance-triage
  workflow_phase: Operate
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-MAINT
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, MAINT + WR paths, OUT-03, §3.2 approved items, `gate_id: H-OPERATE`, `decision: pending`. No deploy commands.