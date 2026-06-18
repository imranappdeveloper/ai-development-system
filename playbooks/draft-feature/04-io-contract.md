# PB-draft-feature — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
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
| Project artifacts | IN-40–IN-42 |
| Revise / loop | IN-50–IN-52 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `discovery_artifact` | `{project_root}/work/discovery/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_draft` | `{ai_dev_os_home}/checklists/draft.md` |
| IN-32 | `template_feature` | `{ai_dev_os_home}/templates/feature/template.md` (reference — narrow subset) |
| IN-33 | `routing_matrix` | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` (read-only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / upstream artifact |
| IN-40 | `context_md` | When project exists |
| IN-41 | `intake_artifact` | When INT path cited in DISC |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_feat_artifact` | Revise loop — prior FEAT path |
| IN-52 | `human_waiver` | Documented upstream gate waiver in WR |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | FEAT artifact | `{project_root}/work/feature/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — FEAT frontmatter

```yaml
document_id: FEAT-{work_id}
work_id: WR-###
feat_type: new | enhancement
feat_scope: narrow_slice | vertical_slice
workflow_id: WF-*
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_disc_path: <DISC path>
upstream_int_path: <INT path | null>
discovery_alignment: aligned | partial | not_applicable
discovery_gap: none | stale
```

### OUT-01 — Required traceability block (§2 Upstream Context)

```yaml
upstream_traceability:
  discovery_linked: true
  discovery_alignment: aligned | partial | not_applicable
  intake_workflow_id: <from DISC or INT when linked>
  prd_waived: true
  narrow_slice_rationale: <one line from DISC recommendation>
```

### OUT-01 — Required sections (narrow FEAT subset)

| Section | Content |
|---------|---------|
| Summary | One paragraph — user-visible outcome for this slice |
| Upstream Context | Traceability block + DISC/INT reference table |
| Scope | `in` / `out` tables grounded in DISC |
| User-Visible Behavior | Flows and business rules — no component/API detail |
| Acceptance Criteria | Testable criteria table with verification method |
| Dependencies | High-level only — no architecture/API/DB spec |
| Open Questions | Human-owned unknowns |
| Human Approval | `gate_id: H-PLAN`, `decision: pending` |
| References | Upstream artifact paths |

**Forbidden sections in OUT-01:** Technical Specification (components/interfaces), Implementation Slices, architecture diagrams, code blocks, ISS-* tables.

### OUT-02 — Work Record additions

```yaml
status: plan_in_progress | plan_pending_review | plan_approved | plan_rejected
artifacts:
  - type: FEAT
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-feature
  workflow_phase: Plan
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-DRAFT
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
path: FEAT
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, FEAT + WR paths, OUT-03, decisions for H-PLAN, `recommended_next_skill`, `gate_id: H-PLAN`, `decision: pending`.

```yaml
skill_id: PB-draft-feature
artifact_type: FEAT
artifact_path: work/feature/{work_id}.md
checklist_id: CL-DRAFT
checklist_result: pass | fail
gate_id: H-PLAN
decision: pending
recommended_next_skill: PB-decompose-issues
```

**Forbidden in OUT-04:** embedded routing-matrix rows — reference orchestrator only.

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-*
  current_phase: Plan
playbook_invocation:
  skill_id: PB-draft-feature
  mode: new | resume | revise
work_id: WR-###
project_root: <path>
ai_dev_os_home: <path>
artifact_refs:
  - type: DISC
    path: work/discovery/{work_id}.md
```