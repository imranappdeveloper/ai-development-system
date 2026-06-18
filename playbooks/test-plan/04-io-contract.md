# PB-test-plan — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
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
| Project artifacts | IN-40–IN-48 |
| Revise / loop | IN-50–IN-54 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-11 | `testing_template` | `{ai_dev_os_home}/templates/testing/template.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_test_plan` | `{ai_dev_os_home}/checklists/test-plan.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/test-plan/` |
| IN-33 | `devops_gate_record` | `{ai_dev_os_home}/playbooks/implement-devops/test-runs/latest-gate.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `code_artifact` | When CODE linked in WR (soft) |
| IN-42 | `prd_artifact` | When PRD linked (soft) |
| IN-43 | `issue_artifacts` | When ISS / ISS-* linked (soft) |
| IN-44 | `api_artifact` | When API linked for contract layer (soft) |
| IN-45 | `arch_artifact` | Optional component boundaries |
| IN-46 | `issue_ids` | Explicit ISS-* list from orchestrator |
| IN-47 | `prior_test_plan` | `mode: revise` |
| IN-48 | `security_baseline` | WF-SECURITY with SEC-ASSESS linked |
| IN-50 | `human_revise_notes` | H-VERIFY soft revise_plan |
| IN-51 | `code_gap_waiver` | CODE absent; human documents `code_gap: waiver` |
| IN-52 | `ac_gap_waiver` | PRD/ISS absent; human documents `ac_gap: waiver` |
| IN-53 | `target_issue_id` | Single ISS scope for partial plan run |
| IN-54 | `implement_lane_hint` | Disambiguate CODE path when multiple lanes |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | TEST-PLAN artifact | `{project_root}/work/testing/plan/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — TEST-PLAN frontmatter

```yaml
document_id: TEST-PLAN-{work_id}
work_id: WR-###
test_phase: plan
test_scope: unit | integration | contract | e2e | regression | security | perf | a11y | mixed
workflow_id: WF-*
test_confidence: high | medium | low
status: draft | in_review | approved
revision: 0
created: ISO-8601
upstream_code_paths: [<CODE paths or empty>]
upstream_prd_path: <PRD path or null>
upstream_issue_paths: [<ISS paths>]
template_ref: templates/testing/template.md
```

### OUT-01 — CODE alignment block (when CODE present)

```yaml
code_alignment:
  code_document_id: <from CODE>
  code_work_id: <from CODE>
  alignment: aligned | partial_mismatch | requires_code_revise
  mismatch_summary: <if not aligned>
  code_path: <relative path — mandatory when CODE linked>
code_gap: none | missing | waiver
```

### OUT-01 — Required sections (from template)

| § | Title | Required | Plan-phase rule |
|---|-------|----------|-----------------|
| 1 | Overview | yes | Purpose, scope, references |
| 2 | Test Strategy | yes | §2.1 layers with rationale |
| 3 | Test Cases | yes | §3.1 AC mapping + §3.2 planned details |
| 4 | Regression Scope | when CODE §4 present | Planned areas only |
| 5 | Security Testing | when WF-SECURITY | Method planned — no results |
| 6 | Performance Testing | when WF-PERF | Scenarios planned — no results |
| 7 | Accessibility Testing | when UI scope | Checks planned — no results |
| 8 | Test Environment | yes | Planned config — no live run |
| 9 | Execution Evidence | yes | **Empty or `plan_only` placeholder only** |
| 10 | Sign-Off Criteria | yes | Criteria listed — `Met` column blank or `pending` |

### OUT-02 — Work Record additions

```yaml
status: test_plan_in_progress | test_plan_pending_review | test_plan_approved | test_plan_rejected
artifacts:
  - type: TEST-PLAN
    test_phase: plan
    path: <OUT-01 path>
os_refs:
  skill: PB-test-plan
  workflow_phase: Verify
  plan_sub_artifact: true
approvals:
  - gate_id: H-VERIFY
    sub_gate: plan
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-TEST-PLAN
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, TEST-PLAN + WR paths, OUT-03, AC coverage count, `recommended_next_skill: PB-test-generate`, `gate_id: H-VERIFY`, `sub_gate: plan`, `decision: pending`. **Must NOT** include test execution results or pass/fail counts from live runs.

### OUT-05 — Escalation

Triggered after 3 failed CL-TEST-PLAN attempts or irrecoverable AC/CODE gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` on full evidence | Human only — after PB-verify |
| H-VERIFY `approve_plan` / `revise_plan` / `reject_plan` | Human only for inline plan review |
| WR `approvals[]` final H-VERIFY decision | Human appends after execution evidence |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Verify
playbook_invocation:
  skill_id: PB-test-plan
  mode: new | resume | revise
  test_phase: plan
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: CODE
    path: work/implement/backend/WR-FEATURE-ALPHA.md
  - type: PRD
    path: work/prd/WR-FEATURE-ALPHA.md
  - type: ISS
    path: work/issues/ISS-BE-001.md
issue_ids:
  - ISS-BE-001
token_budget_remaining: 120000
```