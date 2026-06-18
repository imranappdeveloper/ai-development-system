# Workflow Specification Schema

| Field | Value |
|-------|-------|
| document_id | WF-SCHEMA-001 |
| version | 1.0.0 |
| status | active |
| owner | Workflow Owner |

Every workflow MUST publish `workflows/specs/WF-*.yaml` conforming to this schema. Copy `_spec-template.yaml` to author new workflows.

## Top-level fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `workflow_id` | string | yes | `WF-*` per STD-NAMING-001 |
| `display_name` | string | yes | Human label |
| `aliases` | string[] | no | Business synonyms |
| `class` | enum | yes | `end_to_end` \| `slice` \| `operate` |
| `version` | semver | yes | Spec version |
| `status` | enum | yes | `draft` \| `active` |
| `intake_work_types` | string[] | yes | Valid INT `work_type` values |
| `phases_ref` | path | yes | `../WF-*/phases.yaml` |
| `inputs` | object | yes | See below |
| `outputs` | object | yes | See below |
| `required_skills` | array | yes | Skill bindings |
| `required_templates` | array | yes | TP-* IDs |
| `required_standards` | array | yes | STD-* IDs |
| `required_checklists` | array | yes | CL-* IDs |
| `exit_criteria` | array | yes | Done conditions |
| `quality_gates` | array | yes | G-WF-* + workflow-specific |
| `failure_recovery` | array | yes | Recovery rows |
| `human_approval` | array | yes | H-* gates for this workflow |

## `inputs`

```yaml
inputs:
  required:
    - id: IN-WF-01
      name: raw_request | work_id | ...
      source: human | WR | artifact
  optional: []
  prerequisites:
    - artifact_type: CODE
      when: slice entry with upstream implement
```

## `outputs`

```yaml
outputs:
  primary_artifacts: [INT, DISC, PRD, ...]
  wr_terminal_status: done | plan_approved | ...
  ors_terminal_status: done
```

## `required_skills`

```yaml
required_skills:
  - skill_id: PB-intake-classify
    phase: Intake
    status_accept: [draft, active]
    optional: false
```

`status_accept` MAY include `planned` only when spec documents stub path with human waiver.

## `human_approval`

```yaml
human_approval:
  - gate_id: H-INTAKE
    binds: [INT]
    required: true
    skippable: false
    waivable_via: gates.yaml#waivable_gates
```