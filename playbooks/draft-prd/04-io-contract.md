# PB-draft-prd — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
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
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_prd` | `{ai_dev_os_home}/checklists/prd.md` |
| IN-32 | `template_prd` | `{ai_dev_os_home}/templates/prd/template.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-40 | `context_md` | When project exists |
| IN-41 | `discovery_artifact` | When DISC linked in WR |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_prd_artifact` | Revise loop |
| IN-52 | `discovery_waiver` | DISC absent but workflow allows proceed |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | PRD artifact | `{project_root}/work/prd/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — PRD frontmatter

```yaml
document_id: PRD-{work_id}
work_id: WR-###
prd_type: full | lite
workflow_id: WF-*
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
upstream_disc_path: <DISC path | null>
discovery_gap: none | missing | waiver | stale
```

### OUT-01 — Required traceability block (§2 Background)

```yaml
upstream_traceability:
  intake_work_type: <from INT>
  intake_workflow_id: <from INT>
  discovery_linked: true | false
  discovery_alignment: aligned | partial | not_applicable
```

### OUT-02 — Work Record additions

```yaml
status: plan_in_progress | plan_pending_review | plan_approved | plan_rejected
artifacts:
  - type: PRD
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-prd
  workflow_phase: Plan
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-PRD
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, PRD + WR paths, OUT-03, decisions for H-PLAN, `recommended_next_skill`, `gate_id: H-PLAN`, `decision: pending`.

**Forbidden in OUT-04:** embedded routing-matrix rows — reference orchestrator only.