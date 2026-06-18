# PB-draft-ui-ux — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
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
| Project artifacts | IN-40–IN-46 |
| Revise / loop | IN-50–IN-54 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `prd_artifact` | `{project_root}/work/prd/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_uiux` | `{ai_dev_os_home}/checklists/uiux.md` |
| IN-32 | `template_uiux` | `{ai_dev_os_home}/templates/ui-ux/template.md` |
| IN-33 | `self_spec` | `{ai_dev_os_home}/playbooks/draft-ui-ux/` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / PRD |
| IN-40 | `context_md` | When project exists |
| IN-41 | `arch_artifact` | When ARCH linked in WR (soft — recommended) |
| IN-42 | `disc_artifact` | When DISC linked in WR (soft — recommended) |
| IN-43 | `api_artifact` | When API linked in WR (optional context for data-display) |
| IN-44 | `existing_ui_markers` | When component or route files present |
| IN-45 | `design_system_refs` | When project has token or pattern SSOT |
| IN-46 | `db_artifact` | When DB linked in WR (optional field-display context) |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_uiux_artifact` | Revise loop |
| IN-52 | `human_waiver` | PRD not yet approved but human directs UIUX design |
| IN-53 | `arch_gap_waiver` | ARCH absent; human documents `arch_gap: waiver` |
| IN-54 | `disc_gap_waiver` | DISC absent; human documents `disc_gap: waiver` |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | UIUX artifact | `{project_root}/work/uiux/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — UIUX frontmatter

```yaml
document_id: UIUX-{work_id}
work_id: WR-###
change_type: new | additive | redesign
uiux_type: screen_flow | design_system | responsive
workflow_id: WF-*
uiux_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_prd_path: <PRD path>
upstream_arch_path: <ARCH path or null>
upstream_disc_path: <DISC path or null>
template_id: TP-uiux
```

### OUT-01 — Required PRD alignment block

```yaml
prd_alignment:
  prd_document_id: <from PRD>
  prd_work_id: <from PRD>
  alignment: aligned | partial_mismatch | requires_prd_revise
  mismatch_summary: <if not aligned>
  prd_path: <relative path — mandatory>
```

### OUT-01 — ARCH alignment block (when ARCH present)

```yaml
arch_alignment:
  arch_document_id: <from ARCH>
  arch_work_id: <from ARCH>
  alignment: aligned | partial_mismatch | requires_arch_revise | not_applicable
  mismatch_summary: <if not aligned>
  arch_path: <relative path>
arch_gap: none | missing | waiver
```

### OUT-01 — DISC alignment block (when DISC present)

```yaml
disc_alignment:
  disc_document_id: <from DISC>
  disc_work_id: <from DISC>
  alignment: aligned | partial_mismatch | not_applicable
  mismatch_summary: <if not aligned>
  disc_path: <relative path>
disc_gap: none | missing | waiver
```

### OUT-02 — Work Record additions

```yaml
status: uiux_in_progress | uiux_pending_review | plan_approved | uiux_rejected
artifacts:
  - type: UIUX
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-ui-ux
  workflow_phase: Plan
approvals:
  - gate_id: H-PLAN
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-UIUX
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, UIUX + WR paths, OUT-03, decisions for H-PLAN, `recommended_next_skill`, `gate_id: H-PLAN`, `decision: pending`.

### OUT-05 — Escalation

Triggered after 3 failed CL-UIUX attempts or irrecoverable PRD gap. Includes: failed checks, blocker summary, recommended human action (`revise PRD`, `waive ARCH`, `waive DISC`, `abort`).

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
  skill_id: PB-draft-ui-ux
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: PRD
    path: work/prd/WR-FEATURE-ALPHA.md
  - type: ARCH
    path: work/architecture/WR-FEATURE-ALPHA.md
  - type: DISC
    path: work/discovery/WR-FEATURE-ALPHA.md
token_budget_remaining: 120000
```