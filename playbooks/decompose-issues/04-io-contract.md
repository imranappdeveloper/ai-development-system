# PB-decompose-issues — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
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
| IN-31 | `checklist_decompose` | `{ai_dev_os_home}/checklists/decompose.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/decompose-issues/` |
| IN-33 | `routing_matrix` | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` (read-only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / PRD |
| IN-40 | `context_md` | When project exists |
| IN-41 | `arch_artifact` | When ARCH linked in WR (soft) |
| IN-42 | `api_artifact` | When API linked in WR (soft) |
| IN-43 | `db_artifact` | When DB linked in WR (soft) |
| IN-44 | `uiux_artifact` | When UIUX linked in WR (soft) |
| IN-45 | `discovery_artifact` | When DISC linked in WR (optional context) |
| IN-46 | `human_lane_hint` | Human requests lane emphasis |
| IN-50 | `human_revise_notes` | H-DECOMPOSE revise |
| IN-51 | `prior_issue_artifacts` | Revise loop |
| IN-52 | `human_waiver` | PRD approved path waiver documented |
| IN-53 | `decompose_waiver` | Single-issue path with human ack at H-PLAN |
| IN-54 | `issue_id_prefix` | Orchestrator supplies explicit ID list (optional) |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | ISS-* artifacts | `{project_root}/work/issues/{issue_id}.md` |
| OUT-01b | Decomposition manifest | `{project_root}/work/issues/_manifest-{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — ISS-* frontmatter

```yaml
document_id: ISS-{LANE}-{SEQ}
work_id: WR-###
issue_type: backend | frontend | mobile | devops
lane: backend | frontend | mobile | devops
status: draft | pending_review | approved | rejected
priority: P0 | P1 | P2 | P3
revision: 0
created: ISO-8601
upstream_prd_path: <PRD path — mandatory>
upstream_arch_path: <ARCH path or null>
upstream_api_path: <API path or null>
upstream_db_path: <DB path or null>
upstream_uiux_path: <UIUX path or null>
```

### OUT-01 — Required sections

| Section | Content |
|---------|---------|
| Summary | One paragraph — implementable unit |
| Acceptance Criteria | Table: `id`, `criterion`, `verify` — testable |
| Scope | `in` / `out` tables |
| Tags | Searchable labels |
| References | PRD + soft Plan artifact paths |

### OUT-01b — Manifest frontmatter

```yaml
document_id: MANIFEST-{work_id}
work_id: WR-###
decompose_scope: single_lane | multi_lane | full_stack
decompose_confidence: high | medium | low
status: pending_review
created: ISO-8601
issue_ids:
  - ISS-BE-001
  - ISS-FE-001
```

### OUT-01b — PRD alignment block

```yaml
prd_alignment:
  prd_document_id: <from PRD>
  prd_work_id: <from PRD>
  alignment: aligned | partial_mismatch | requires_prd_revise
  mismatch_summary: <if not aligned>
  prd_path: <relative path — mandatory>
prd_gap: none | missing | waiver
```

### OUT-01b — Coverage map (required)

| PRD ref | ISS-* AC ids | Notes |
|---------|--------------|-------|
| FR-01 | ISS-BE-001 AC-1 | … |

### OUT-02 — Work Record additions

```yaml
status: decompose_in_progress | decompose_pending_review | decompose_approved | decompose_rejected
artifacts:
  - type: ISS-BE
    path: work/issues/ISS-BE-001.md
  - type: ISS-FE
    path: work/issues/ISS-FE-001.md
os_refs:
  skill: PB-decompose-issues
  workflow_phase: Decompose
approvals:
  - gate_id: H-DECOMPOSE
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-DECOMP
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, manifest + ISS-* paths, OUT-03, coverage map digest, `recommended_next_skill` (lane child), `gate_id: H-DECOMPOSE`, `decision: pending`.

### OUT-05 — Escalation

Triggered after 3 failed CL-DECOMP attempts or irrecoverable PRD gap. Includes: failed checks, blocker summary, recommended human action (`revise PRD`, `waive scope`, `abort`).

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-DECOMPOSE `approve` / `revise` / `reject` | Human only — never agent |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Decompose
playbook_invocation:
  skill_id: PB-decompose-issues
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: PRD
    path: work/prd/WR-FEATURE-ALPHA.md
  - type: ARCH
    path: work/architecture/WR-FEATURE-ALPHA.md
token_budget_remaining: 120000
```