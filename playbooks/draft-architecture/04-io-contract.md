# PB-draft-architecture — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
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
| IN-10 | `prd_artifact` | `{project_root}/work/prd/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_architecture` | `{ai_dev_os_home}/checklists/architecture.md` |
| IN-32 | `template_architecture` | `{ai_dev_os_home}/templates/architecture/template.md` |
| IN-33 | `self_spec` | `{ai_dev_os_home}/playbooks/draft-architecture/` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / PRD |
| IN-40 | `context_md` | When project exists |
| IN-41 | `discovery_artifact` | When DISC linked in WR (optional context) |
| IN-42 | `existing_adrs` | When `docs/adr/` present |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_arch_artifact` | Revise loop |
| IN-52 | `human_waiver` | PRD not yet approved but human directs architecture |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | ARCH artifact | `{project_root}/work/architecture/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — ARCH frontmatter

```yaml
document_id: ARCH-{work_id}
work_id: WR-###
architecture_type: greenfield | as_is | delta
workflow_id: WF-*
architecture_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_prd_path: <PRD path>
template_id: TP-architecture
```

### OUT-01 — Required PRD alignment block (§1.3)

```yaml
prd_alignment:
  prd_document_id: <from PRD>
  prd_work_id: <from PRD>
  alignment: aligned | partial_mismatch | requires_prd_revise
  mismatch_summary: <if not aligned>
  prd_path: <relative path — mandatory>
```

### OUT-02 — Work Record additions

```yaml
status: architecture_in_progress | architecture_pending_review | plan_approved | architecture_rejected
artifacts:
  - type: ARCH
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-architecture
  workflow_phase: Plan
approvals:
  - gate_id: H-PLAN
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-ARCH
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, ARCH + WR paths, OUT-03, decisions for H-PLAN, `recommended_next_skill`, `gate_id: H-PLAN`, `decision: pending`.

### OUT-05 — Escalation

Triggered after 3 failed CL-ARCH attempts or irrecoverable PRD gap. Includes: failed checks, blocker summary, recommended human action (`revise PRD`, `waive`, `abort`).

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
  skill_id: PB-draft-architecture
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: PRD
    path: work/prd/WR-FEATURE-ALPHA.md
token_budget_remaining: 120000
```