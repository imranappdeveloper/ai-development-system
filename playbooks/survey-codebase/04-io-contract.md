# PB-survey-codebase — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 04-io-contract |

**Contract rule:** Undocumented I/O is forbidden.

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human (explicit) |
| IN-02 | `work_id` | Work Record |
| IN-10 | `intake_artifact` | `{project_root}/work/intake/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_survey` | `{ai_dev_os_home}/checklists/survey.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-40 | `context_md` | When `{project_root}/CONTEXT.md` exists |
| IN-41 | `prior_survey_artifact` | `mode: refresh` |
| IN-42 | `scan_focus` | Human narrows survey scope (module, path prefix) |
| IN-52 | `human_waiver` | INT not yet approved but human directs survey |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | SURVEY artifact | `{project_root}/work/survey/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human / orchestrator channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — SURVEY frontmatter

```yaml
document_id: SURVEY-{work_id}
work_id: WR-###
survey_type: feature_context | existing_project | enhancement | exploratory
workflow_id: WF-*
survey_confidence: high | medium | low
scan_depth: shallow | standard | deep
status: draft | complete | failed
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
context_md_path: <CONTEXT.md path or null>
scan_manifest:
  paths_read: []
  files_touched: 0
  t3_budget_pct: <number>
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
| 2 | Survey Scope & Scan Manifest | yes — allowlist paths, caps, files_touched |
| 3 | Repository Structure | yes — top-level layout with citations |
| 4 | Module Map | yes — ≥3 modules or documented exception |
| 5 | Technology Stack | yes — languages, frameworks, build tools |
| 6 | Dependencies & Integrations | yes — external services, packages |
| 7 | Patterns & Conventions | yes — observed only; no prescriptive architecture |
| 8 | Risk & Complexity Signals | yes — coupling, legacy, test gaps |
| 9 | Gaps & Unknowns | yes — out-of-scan or inconclusive areas |
| 6.2 | Intake Classification Alignment | yes — YAML block |
| 10 | Advisory Handoff | yes — recommend next; **no gate block** |

### OUT-02 — Work Record additions

```yaml
status: survey_in_progress | survey_complete | survey_failed
artifacts:
  - type: SURVEY
    path: <OUT-01 path>
os_refs:
  skill: PB-survey-codebase
  workflow_phase: Frame
  exit_gate: none
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-SURVEY
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, SURVEY + WR paths, OUT-03, `recommended_next_skill: PB-discovery-research`, `exit_gate: none`. **Must not include** `gate_id`, `decision: approve`, or routing-matrix excerpts.