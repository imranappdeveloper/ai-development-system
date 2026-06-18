# PB-review — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-review |
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
| IN-11 | `review_template` | `{ai_dev_os_home}/templates/review/template.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_review` | `{ai_dev_os_home}/checklists/review.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/review/` |
| IN-33 | `test_plan_gate_record` | `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `code_artifact` | **Required** — CODE linked in WR |
| IN-42 | `prd_artifact` | When PRD linked (soft) |
| IN-43 | `issue_artifacts` | When ISS / ISS-* linked (soft) |
| IN-44 | `test_plan_artifact` | When TEST-PLAN linked (soft chain) |
| IN-45 | `test_rpt_artifact` | When TEST-RPT linked (soft) |
| IN-46 | `arch_artifact` | Optional boundary context |
| IN-47 | `prior_review` | `mode: revise` |
| IN-48 | `security_baseline` | WF-SECURITY with SEC-ASSESS linked |
| IN-50 | `human_revise_notes` | H-VERIFY soft revise |
| IN-51 | `review_waiver` | Human documents skip/waive review |
| IN-52 | `target_issue_id` | Single ISS scope for partial review |
| IN-53 | `implement_lane_hint` | Disambiguate CODE path when multiple lanes |
| IN-54 | `diff_ref` | PR link or commit range when available |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | REVIEW artifact | `{project_root}/work/review/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — REVIEW frontmatter

```yaml
document_id: REVIEW-{work_id}
work_id: WR-###
review_type: code | design | security | doc | release_readiness
workflow_id: WF-*
review_confidence: high | medium | low
status: draft | in_review | approved
revision: 0
created: ISO-8601
upstream_code_paths: [<CODE paths — mandatory>]
upstream_prd_path: <PRD path or null>
upstream_issue_paths: [<ISS paths>]
upstream_test_plan_path: <TEST-PLAN path or null>
review_target: <PR link or CODE path>
template_ref: templates/review/template.md
```

### OUT-01 — CODE alignment block (when CODE present)

```yaml
code_alignment:
  code_document_id: <from CODE>
  code_work_id: <from CODE>
  alignment: aligned | partial_mismatch | requires_code_revise
  mismatch_summary: <if not aligned>
  code_path: <relative path — mandatory>
```

### OUT-01 — Required sections (from template)

| § | Title | Required | Review rule |
|---|-------|----------|-------------|
| 1 | Review Context | yes | Summary, scope, references |
| 2 | Reviewers | yes | Agent as reviewer type `agent`; human pending |
| 3 | Standards Checklist | yes | Applicable STD-* rows evaluated |
| 4 | Acceptance Criteria Review | yes | AC met/partial/no with evidence |
| 5 | Findings | yes | B-/S-/N- tables; empty only when none |
| 6 | Scope & Risk Assessment | yes | All questions answered |
| 7 | Agent Pre-Review | optional | CL-VERIFY / CL-SECURITY advisory |
| 8 | Resolution | when revise | Fixed findings tracked |
| 9 | Outcome | yes | `recommendation: approve \| revise \| reject` |
| — | Human Approval | yes | `decision: pending` at handoff |

### OUT-02 — Work Record additions

```yaml
status: review_in_progress | review_pending | review_approved | review_rejected
artifacts:
  - type: REVIEW
    path: <OUT-01 path>
os_refs:
  skill: PB-review
  workflow_phase: Verify
  review_sub_artifact: true
approvals:
  - gate_id: H-VERIFY
    sub_gate: review
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-REVIEW
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, REVIEW + WR paths, OUT-03, P0 blocker count, `gate_id: H-VERIFY`, `sub_gate: review`, `decision: pending`, quality-chain note (PB-test-plan PASS; PB-test-generate future gate). **Must NOT** include H-VERIFY `approve` or source code patches.

### OUT-05 — Escalation

Triggered after 3 failed CL-REVIEW attempts or irrecoverable CODE/AC gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` on full evidence | Human only — after PB-verify TEST-RPT |
| H-VERIFY `approve` / `revise` / `reject` on review findings | Human only |
| WR `approvals[]` final H-VERIFY decision | Human appends after verify evidence |
| Implement fixes for findings | Human routes to PB-implement-* |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Verify
playbook_invocation:
  skill_id: PB-review
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: CODE
    path: work/implement/backend/WR-FEATURE-ALPHA.md
  - type: ISS
    path: work/issues/ISS-BE-001.md
  - type: TEST-PLAN
    path: work/testing/plan/WR-FEATURE-ALPHA.md
issue_ids:
  - ISS-BE-001
token_budget_remaining: 120000
```