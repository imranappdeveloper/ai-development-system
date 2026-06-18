# PB-implement-devops — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
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
| Project artifacts | IN-40–IN-47 |
| Revise / loop | IN-50–IN-54 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `issue_artifacts` | `{project_root}/work/issues/{issue_id}.md` or ISS index in WR |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_implement_devops` | `{ai_dev_os_home}/checklists/implement-devops.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/implement-devops/` |
| IN-33 | `implement_umbrella` | `{ai_dev_os_home}/playbooks/implement/` (lane context only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `arch_artifact` | When ARCH linked in WR (soft) |
| IN-42 | `rel_artifact` | When REL linked in WR (soft) |
| IN-43 | `api_artifact` | When API linked (optional cross-lane context) |
| IN-44 | `existing_pipeline_markers` | When CI/IaC files present |
| IN-45 | `issue_ids` | Explicit ISS-* list from orchestrator |
| IN-46 | `security_baseline` | WF-SECURITY with SEC-ASSESS linked |
| IN-47 | `prior_code_artifact` | `mode: revise` |
| IN-50 | `human_revise_notes` | H-IMPLEMENT revise |
| IN-51 | `human_waiver` | ISS absent but human directs implement (WF-BUGFIX edge) |
| IN-52 | `arch_gap_waiver` | ARCH absent; human documents `arch_gap: waiver` |
| IN-53 | `rel_gap_waiver` | REL absent; human documents `rel_gap: waiver` |
| IN-54 | `target_issue_id` | Single ISS scope for partial implement run |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | CODE artifact | `{project_root}/work/implement/devops/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — CODE frontmatter

```yaml
document_id: CODE-DO-{work_id}
work_id: WR-###
implement_lane: devops
implement_scope: ci_pipeline | infra_as_code | deploy_pipeline | mixed_devops
workflow_id: WF-*
implement_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_issue_paths: [<ISS paths>]
upstream_arch_path: <ARCH path or null>
upstream_rel_path: <REL path or null>
```

### OUT-01 — Required ARCH alignment block (when ARCH present)

```yaml
arch_alignment:
  arch_document_id: <from ARCH>
  arch_work_id: <from ARCH>
  alignment: aligned | partial_mismatch | requires_arch_revise
  mismatch_summary: <if not aligned>
  arch_path: <relative path — mandatory when ARCH linked>
arch_gap: none | missing | waiver
```

### OUT-01 — REL alignment block (when REL present)

```yaml
rel_alignment:
  rel_document_id: <from REL>
  rel_work_id: <from REL>
  alignment: aligned | partial_mismatch | requires_rel_prepare
  mismatch_summary: <if not aligned>
  rel_path: <relative path>
rel_gap: none | missing | waiver
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Overview | yes |
| 2 | Issue Traceability | yes |
| 3 | Implementation Log | yes |
| 4 | Files Changed | yes |
| 5 | Pipeline & Rollback | when IaC or deploy pipeline |
| 6 | Validation Notes | yes — never empty |
| 7 | Security Notes | when secrets/CI auth changes |
| 8 | Open Questions | when applicable |
| 9 | Human Approval | yes |

### OUT-02 — Work Record additions

```yaml
status: implement_devops_in_progress | implement_devops_pending_review | implement_approved | implement_rejected
artifacts:
  - type: CODE
    lane: devops
    path: <OUT-01 path>
os_refs:
  skill: PB-implement-devops
  workflow_phase: Implement
  implement_lane: devops
approvals:
  - gate_id: H-IMPLEMENT
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-IMPLEMENT-DEVOPS
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, CODE + WR paths, OUT-03, validation summary, `recommended_next_skill: PB-verify` (or `PB-prepare-release` when WF-RELEASE), `gate_id: H-IMPLEMENT`, `decision: pending`. **Must NOT** include prod deploy commands or release ship steps.

### OUT-05 — Escalation

Triggered after 3 failed CL-IMPLEMENT-DEVOPS attempts or irrecoverable ARCH/REL gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-IMPLEMENT `approve` / `revise` / `reject` | Human only — never agent |
| Production deployment / prod IaC apply | Human only — never agent |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Implement
playbook_invocation:
  skill_id: PB-implement-devops
  mode: new | resume | revise
  implement_lane: devops
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: ISS
    path: work/issues/ISS-DO-001.md
  - type: ARCH
    path: work/architecture/WR-FEATURE-ALPHA.md
  - type: REL
    path: work/release/WR-FEATURE-ALPHA.md
issue_ids:
  - ISS-DO-001
token_budget_remaining: 120000
```