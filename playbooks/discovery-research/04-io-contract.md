# PB-discovery-research — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
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
| IN-31 | `checklist_discovery` | `{ai_dev_os_home}/checklists/discovery.md` |
| IN-32 | `template_discovery` | `{ai_dev_os_home}/templates/discovery/template.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-40 | `context_md` | When project exists |
| IN-50 | `human_revise_notes` | H-FRAME revise |
| IN-51 | `prior_disc_artifact` | Revise loop |
| IN-52 | `human_waiver` | INT not yet approved but human directs discovery |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | DISC artifact | `{project_root}/work/discovery/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — DISC frontmatter

```yaml
document_id: DISC-{work_id}
work_id: WR-###
discovery_type: new_project | existing_onboarding | feature | enhancement
workflow_id: WF-*
discovery_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
```

### OUT-01 — Required alignment block (§6.2)

```yaml
intake_classification_alignment:
  intake_work_type: <from INT>
  intake_workflow_id: <from INT>
  alignment: aligned | partial_mismatch | requires_re_intake
  mismatch_summary: <if not aligned>
```

### OUT-02 — Work Record additions

```yaml
status: discovery_in_progress | discovery_pending_review | discovery_approved | discovery_rejected
artifacts:
  - type: DISC
    path: <OUT-01 path>
os_refs:
  skill: PB-discovery-research
  workflow_phase: Frame
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-DISCOVERY
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, DISC + WR paths, OUT-03, decisions for H-FRAME, `recommended_next_skill`, `gate_id: H-FRAME`, `decision: pending`.