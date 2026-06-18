# PB-perf-review — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
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
| IN-31 | `checklist_perf_review` | `{ai_dev_os_home}/checklists/perf-review.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/perf-review/` |
| IN-33 | `test_plan_gate_record` | `{ai_dev_os_home}/playbooks/test-plan/test-runs/latest-gate.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `code_artifact` | CODE linked in WR (required) |
| IN-42 | `perf_base_artifact` | When PERF-BASE linked (soft) |
| IN-43 | `prd_artifact` | When PRD NFR section needed (soft) |
| IN-44 | `test_plan_artifact` | When TEST-PLAN §6 perf scenarios linked (soft) |
| IN-45 | `test_rpt_artifact` | When TEST-RPT linked (soft) |
| IN-46 | `arch_artifact` | Optional component boundaries |
| IN-47 | `prior_perf_review` | `mode: revise` |
| IN-48 | `implement_lane_hint` | Disambiguate CODE path when multiple lanes |
| IN-50 | `human_revise_notes` | H-VERIFY revise |
| IN-51 | `baseline_gap_waiver` | PERF-BASE absent; human documents `baseline_gap: waiver` |
| IN-52 | `code_gap_waiver` | CODE absent edge — should block; waiver rare |
| IN-53 | `target_hotspot_path` | Single-file scope for partial review |
| IN-54 | `nfr_ids` | Explicit NFR list from orchestrator |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | PERF-REVIEW artifact | `{project_root}/work/perf-review/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — PERF-REVIEW frontmatter

```yaml
document_id: PERF-REVIEW-{work_id}
work_id: WR-###
perf_review_scope: api_latency | database | memory | concurrency | frontend_render | mobile | infra | mixed
workflow_id: WF-*
perf_confidence: high | medium | low
status: draft | in_review | approved | rejected
revision: 0
created: ISO-8601
upstream_code_paths: [<CODE paths>]
upstream_perf_base_path: <PERF-BASE path or null>
review_type: performance
template_ref: templates/review/template.md
```

### OUT-01 — CODE alignment block

```yaml
code_alignment:
  code_document_id: <from CODE>
  code_work_id: <from CODE>
  alignment: aligned | partial_mismatch | requires_code_revise
  mismatch_summary: <if not aligned>
  code_path: <relative path — mandatory>
```

### OUT-01 — Baseline alignment block (when PERF-BASE present)

```yaml
baseline_alignment:
  perf_base_document_id: <from PERF-BASE>
  perf_base_work_id: <from PERF-BASE>
  alignment: aligned | partial_mismatch | requires_baseline_revise | not_applicable
  mismatch_summary: <if not aligned>
  perf_base_path: <relative path>
baseline_gap: none | missing | waiver
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Review Context | yes — scope, references, CODE paths |
| 2 | Performance Scope | yes — `perf_review_scope` rationale |
| 3 | NFR & Baseline Targets | when PERF-BASE or PRD NFR present |
| 4 | Findings | yes — severity-tagged table |
| 5 | Hotspot Inventory | yes — ranked list with CODE paths |
| 6 | Benchmark Evidence | yes — **empty or `review_only` only** |
| 7 | Recommendations | yes — static fixes + suggested human benchmarks |
| 8 | Outcome | yes — `review_outcome: pending` until human |
| 9 | Human Approval | yes — H-VERIFY block |

### OUT-02 — Work Record additions

```yaml
status: perf_review_in_progress | perf_review_pending | perf_review_approved | perf_review_rejected
artifacts:
  - type: PERF-REVIEW
    path: <OUT-01 path>
os_refs:
  skill: PB-perf-review
  workflow_phase: Verify
approvals:
  - gate_id: H-VERIFY
    sub_gate: perf_review
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-PERF-REVIEW
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, PERF-REVIEW + WR paths, OUT-03, blocker count, `recommended_next_skill: PB-prepare-release` (or PB-draft-doc-update when docs-only), `gate_id: H-VERIFY`, `sub_gate: perf_review`, `decision: pending`. **Must NOT** include load-test commands or benchmark metrics from live runs.

### OUT-05 — Escalation

Triggered after 3 failed CL-PERF-REVIEW attempts or irrecoverable CODE/baseline gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` / `revise` / `reject` | Human only — never agent |
| Production performance tuning deploy | Human only |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-PERF
  current_phase: Verify
playbook_invocation:
  skill_id: PB-perf-review
  mode: new | resume | revise
work_id: WR-PERF-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: CODE
    path: work/implement/backend/WR-PERF-ALPHA.md
  - type: PERF-BASE
    path: work/performance/WR-PERF-ALPHA.md
token_budget_remaining: 120000
```