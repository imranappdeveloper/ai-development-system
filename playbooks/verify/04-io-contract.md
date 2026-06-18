# PB-verify — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
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
| IN-31 | `checklist_verify` | `{ai_dev_os_home}/checklists/verify.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/verify/` |
| IN-33 | `test_gen_gate_record` | `{ai_dev_os_home}/playbooks/test-generate/test-runs/latest-gate.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `test_plan_artifact` | `{project_root}/work/testing/plan/{work_id}.md` (soft) |
| IN-42 | `test_gen_artifact` | `{project_root}/work/testing/generate/{work_id}.md` (soft) |
| IN-43 | `code_artifact` | When CODE linked in WR (soft) |
| IN-44 | `api_artifact` | When contract tests reference API (soft) |
| IN-45 | `issue_ids` | Explicit ISS-* list from orchestrator |
| IN-46 | `prior_test_rpt` | `mode: revise` |
| IN-47 | `plan_gap_waiver` | TEST-PLAN absent; human documents `plan_gap: waiver` |
| IN-48 | `gen_gap_waiver` | TEST-GEN absent; human documents `gen_gap: waiver` |
| IN-49 | `code_gap_waiver` | CODE absent; human documents `code_gap: waiver` |
| IN-50 | `human_revise_notes` | H-VERIFY revise |
| IN-51 | `execution_scope` | `full` \| `unit_only` \| `contract_only` \| `failed_only` override |
| IN-52 | `skip_execution_waiver` | Human documents skip with reason — rare |
| IN-53 | `target_issue_id` | Single ISS scope for partial verify run |
| IN-54 | `ci_mode` | Run via CI command vs local per CONTEXT |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | TEST-RPT artifact | `{project_root}/work/testing/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — TEST-RPT frontmatter

```yaml
document_id: TEST-RPT-{work_id}
work_id: WR-###
test_phase: evidence
test_scope: unit | integration | contract | e2e | regression | security | perf | a11y | mixed
workflow_id: WF-*
test_confidence: high | medium | low
execution_result: pass | fail | partial | blocked | skipped
status: draft | in_review | complete
revision: 0
created: ISO-8601
upstream_test_plan_path: work/testing/plan/{work_id}.md
upstream_test_gen_path: work/testing/generate/{work_id}.md
upstream_code_paths: [<CODE paths or empty>]
template_ref: templates/testing/template.md
```

### OUT-01 — Plan / generation alignment blocks

```yaml
plan_alignment:
  test_plan_document_id: <from TEST-PLAN>
  test_plan_work_id: <from TEST-PLAN>
  alignment: aligned | partial_mismatch | requires_plan_revise | not_applicable
  mismatch_summary: <if not aligned>
  test_plan_path: <relative path — mandatory when TEST-PLAN linked>
gen_alignment:
  test_gen_document_id: <from TEST-GEN>
  test_gen_work_id: <from TEST-GEN>
  alignment: aligned | partial_mismatch | requires_gen_revise | not_applicable
  mismatch_summary: <if not aligned>
  test_gen_path: <relative path — mandatory when TEST-GEN linked>
code_gap: none | missing | waiver
plan_gap: none | missing | waiver
gen_gap: none | missing | waiver
```

### OUT-01 — Required sections (from template)

| § | Title | Required | Evidence-phase rule |
|---|-------|----------|---------------------|
| 1 | Overview | yes | Purpose, scope, upstream refs |
| 2 | Test Strategy | yes | §2.1 layers executed vs deferred |
| 3 | Test Cases | yes | §3.1 mapping + §3.2 actual results |
| 4 | Regression Scope | when TEST-PLAN §4 present | Areas run with results |
| 5 | Security Testing | when WF-SECURITY | Results when executed |
| 6 | Performance Testing | when WF-PERF | Results when executed |
| 7 | Accessibility Testing | when UI scope | Results when executed |
| 8 | Test Environment | yes | Actual branch/commit/config used |
| 9 | Execution Evidence | yes | **Commands, exit codes, summary, failure log** |
| 10 | Sign-Off Criteria | yes | Criteria with evidence column — `Met` may be yes/no |

### OUT-02 — Work Record additions

```yaml
status: verify_in_progress | verify_pending_review | verify_complete | verify_rejected
artifacts:
  - type: TEST-RPT
    test_phase: evidence
    path: <OUT-01 path>
os_refs:
  skill: PB-verify
  workflow_phase: Verify
  evidence_sub_artifact: true
approvals:
  - gate_id: H-VERIFY
    sub_gate: evidence
    decision: pending
```

**Must NOT** set H-VERIFY `decision: approve` — human only.

### OUT-03 — Validation Record

```yaml
checklist_id: CL-VERIFY
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, TEST-RPT + WR paths, OUT-03, `execution_result`, pass/fail counts from §9.2, `gate_id: H-VERIFY`, `sub_gate: evidence`, `decision: pending`, `recommended_next_skill: PB-review` or `PB-prepare-release`. **Must NOT** include H-VERIFY `decision: approve` or claim verification gate passed.

### OUT-05 — Escalation

Triggered after 3 failed CL-VERIFY attempts or irrecoverable env/plan gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` | Human only — after reviewing TEST-RPT |
| H-VERIFY `revise` / `reject` | Human only |
| WR `approvals[]` final H-VERIFY decision | Human appends |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Verify
playbook_invocation:
  skill_id: PB-verify
  mode: new | resume | revise
  test_phase: evidence
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: TEST-PLAN
    path: work/testing/plan/WR-FEATURE-ALPHA.md
  - type: TEST-GEN
    path: work/testing/generate/WR-FEATURE-ALPHA.md
  - type: CODE
    path: work/implement/backend/WR-FEATURE-ALPHA.md
issue_ids:
  - ISS-BE-001
token_budget_remaining: 120000
```