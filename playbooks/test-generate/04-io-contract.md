# PB-test-generate — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
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
| IN-11 | `test_plan_artifact` | `{project_root}/work/testing/plan/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_test_gen` | `{ai_dev_os_home}/checklists/test-generate.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/test-generate/` |
| IN-33 | `test_plan_gate_record` | `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `code_artifact` | When CODE linked in WR (soft) |
| IN-42 | `api_artifact` | When contract tests reference API (soft) |
| IN-43 | `arch_artifact` | Optional component boundaries |
| IN-44 | `issue_ids` | Explicit ISS-* list from orchestrator |
| IN-45 | `prior_test_gen` | `mode: revise` |
| IN-46 | `target_issue_id` | Single ISS scope for partial generation |
| IN-47 | `code_gap_waiver` | CODE absent; human documents `code_gap: waiver` |
| IN-48 | `plan_gap_waiver` | TEST-PLAN incomplete; human documents `plan_gap: waiver` |
| IN-50 | `human_revise_notes` | Revise loop |
| IN-51 | `implement_lane_hint` | Disambiguate CODE path when multiple lanes |
| IN-52 | `existing_test_paths` | Pre-existing tests to reference as `existing` |
| IN-53 | `generation_scope` | `full` \| `unit_only` \| `contract_only` override |
| IN-54 | `skip_file_write` | Dry-run catalog only — human ack required |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | TEST-GEN artifact | `{project_root}/work/testing/generate/{work_id}.md` |
| OUT-02 | Test source files | Paths under `{project_root}` per §3 catalog |
| OUT-03 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-04 | Validation Record | Embedded in handoff |
| OUT-05 | Handoff Package | Human channel |
| OUT-06 | Escalation Package | On EXIT_ESC |

### OUT-01 — TEST-GEN frontmatter

```yaml
document_id: TEST-GEN-{work_id}
work_id: WR-###
test_phase: generate
test_scope: unit | integration | contract | e2e | regression | security | perf | a11y | mixed
workflow_id: WF-*
test_confidence: high | medium | low
status: draft | in_review | complete
revision: 0
created: ISO-8601
upstream_test_plan_path: work/testing/plan/{work_id}.md
upstream_code_paths: [<CODE paths or empty>]
generated_file_count: <integer>
template_ref: null
```

### OUT-01 — Plan alignment block (when TEST-PLAN present)

```yaml
plan_alignment:
  test_plan_document_id: <from TEST-PLAN>
  test_plan_work_id: <from TEST-PLAN>
  alignment: aligned | partial_mismatch | requires_plan_revise
  mismatch_summary: <if not aligned>
  test_plan_path: <relative path — mandatory when TEST-PLAN linked>
code_gap: none | missing | waiver
```

### OUT-01 — Required sections

| § | Title | Required | Generate-phase rule |
|---|-------|----------|---------------------|
| 1 | Overview | yes | Purpose, scope, TEST-PLAN reference |
| 2 | Generation Strategy | yes | Layers generated vs deferred from plan |
| 3 | Generated Files Catalog | yes | Path, `file_action`, TC-* refs, layer |
| 4 | Fixtures Generated | when plan §8 lists fixtures | Paths and purpose |
| 5 | Gaps / Deferred | yes | TC-* not generated with reason |
| 6 | Execution Evidence | yes | **Empty or `generate_only` placeholder only** |
| 7 | Handoff | yes | PB-verify primary; PB-review alternate |

### OUT-02 — Test source files

Each file in §3 catalog with `file_action: created | updated` must exist on disk before handoff (unless `persist: pending` with human ack).

### OUT-03 — Work Record additions

```yaml
status: test_gen_in_progress | test_gen_pending_review | test_gen_complete | test_gen_rejected
artifacts:
  - type: TEST-GEN
    test_phase: generate
    path: <OUT-01 path>
os_refs:
  skill: PB-test-generate
  workflow_phase: Verify
  exit_gate: none
```

**Must NOT** append H-VERIFY `decision: approve` to `approvals[]`.

### OUT-04 — Validation Record

```yaml
checklist_id: CL-TEST-GEN
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-05 — Handoff

Must include: summary ≤10 lines, TEST-GEN + WR paths, OUT-04, generated file count, TC coverage count, `recommended_next_skill: PB-verify`, `alternate_next_skill: PB-review`, `exit_gate: none`. **Must NOT** include test execution results, pass/fail counts, coverage numbers from live runs, or H-VERIFY `decision: approve`.

### OUT-06 — Escalation

Triggered after 3 failed CL-TEST-GEN attempts or irrecoverable plan/CODE gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` | Human only — after PB-verify TEST-RPT |
| WR `approvals[]` H-VERIFY decision | Human appends after execution evidence |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Verify
playbook_invocation:
  skill_id: PB-test-generate
  mode: new | resume | revise
  test_phase: generate
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: TEST-PLAN
    path: work/testing/plan/WR-FEATURE-ALPHA.md
  - type: CODE
    path: work/implement/backend/WR-FEATURE-ALPHA.md
issue_ids:
  - ISS-BE-001
token_budget_remaining: 120000
```