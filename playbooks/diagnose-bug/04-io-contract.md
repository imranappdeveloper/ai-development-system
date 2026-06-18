# PB-diagnose-bug — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-diagnose-bug |
| version | 1.0.0 |
| status | active |
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
| Project artifacts | IN-40–IN-46 |
| Revise / loop | IN-50–IN-52 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `int_artifact` | `{project_root}/work/intake/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist` | `{ai_dev_os_home}/checklists/diagnose.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/diagnose-bug/` |
| IN-33 | `routing_matrix` | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` (read-only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / upstream artifact |
| IN-40 | `context_md` | When project exists |

| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_artifact` | Revise loop — prior DIAG path |
| IN-52 | `human_waiver` | Documented upstream gate waiver in WR |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | DIAG artifact | `{project_root}/work/diagnose/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — Frontmatter

```yaml
document_id: DIAG-{work_id}
work_id: WR-###
workflow_id: WF-*
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <when applicable>
upstream_prd_path: <when applicable>
upstream_diag_path: <when applicable or null>
```

### OUT-01 — Required sections

| Section | Content |
|---------|---------|
| Summary | One paragraph — purpose of artifact |
| Details | Domain-specific body per skill (see README) |
| Acceptance Criteria | Testable criteria table where applicable |
| Scope | `in` / `out` tables |
| References | Upstream artifact paths |
| Open Questions | Human-owned unknowns |
| Human Approval | `gate_id: H-PLAN`, `decision: pending` |

### OUT-04 — Handoff fields

```yaml
skill_id: PB-diagnose-bug
artifact_type: DIAG
artifact_path: work/diagnose/{work_id}.md
checklist_id: CL-DIAGNO
checklist_result: pass | fail
gate_id: H-PLAN
decision: pending
recommended_next_skill: PB-draft-issue
```

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-*
  current_phase: Plan
playbook_invocation:
  skill_id: PB-diagnose-bug
  mode: new | resume | revise
work_id: WR-###
project_root: <path>
ai_dev_os_home: <path>
artifact_refs:
  - type: DIA
    path: work/diagnose/{work_id}.md
```
