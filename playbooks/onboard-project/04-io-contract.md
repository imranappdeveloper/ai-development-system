# PB-onboard-project — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
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
| IN-31 | `checklist_onboard` | `{ai_dev_os_home}/checklists/onboard.md` |
| IN-40 | `context_md` | `{project_root}/CONTEXT.md` — **required** |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-41 | `prior_disc_artifact` | When DISC linked (soft — cross-reference only) |
| IN-50 | `human_revise_notes` | H-FRAME revise |
| IN-51 | `prior_onboard_artifact` | Revise loop |
| IN-52 | `human_waiver` | INT not yet approved but human directs onboard |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | ONBOARD artifact | `{project_root}/work/onboard/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — ONBOARD frontmatter

```yaml
document_id: ONBOARD-{work_id}
work_id: WR-###
onboarding_type: existing_project
workflow_id: WF-PROJECT-EXISTING
onboarding_confidence: high | medium | low
context_drift: none | minor | major
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
context_md_path: CONTEXT.md
context_md_sha: <optional digest>
```

### OUT-01 — Required alignment block (§6.2)

```yaml
intake_classification_alignment:
  intake_work_type: <from INT>
  intake_workflow_id: <from INT>
  alignment: aligned | partial_mismatch | requires_re_intake
  mismatch_summary: <if not aligned>
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Summary | yes |
| 2 | Project Snapshot | yes — stack, repo layout from CONTEXT.md |
| 3 | CONTEXT.md Assessment | yes — drift, gaps, **proposed updates** (no writes) |
| 4 | Module Map | yes — ≥3 modules or documented exception |
| 5 | OS Adoption Checklist | yes — table with evidence |
| 6 | Gap Analysis | yes — adoption blockers |
| 6.2 | Intake Classification Alignment | yes — YAML block |
| 7 | Open Questions | yes |
| 8 | Human Approval | yes — H-FRAME pending only |

### OUT-02 — Work Record additions

```yaml
status: onboard_in_progress | onboard_pending_review | onboard_approved | onboard_rejected
artifacts:
  - type: ONBOARD
    path: <OUT-01 path>
os_refs:
  skill: PB-onboard-project
  workflow_phase: Frame
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-ONBOAR
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, ONBOARD + WR paths, OUT-03, decisions for H-FRAME, `recommended_next_skill`, `gate_id: H-FRAME`, `decision: pending`.