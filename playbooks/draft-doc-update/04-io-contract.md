# PB-draft-doc-update — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
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
| IN-10 | `intake_artifact` | `{project_root}/work/intake/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_doc_update` | `{ai_dev_os_home}/checklists/doc-update.md` |
| IN-32 | `template_doc_plan` | `{ai_dev_os_home}/templates/doc-plan/template.md` |
| IN-33 | `std_doc_001` | `{ai_dev_os_home}/standards/engineering/STD-DOC-001.md` |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / INT |
| IN-40 | `context_md` | When project exists |
| IN-41 | `review_artifact` | When REVIEW linked in WR (soft) |
| IN-42 | `sec_review_artifact` | When SEC-REVIEW linked (soft) |
| IN-43 | `perf_review_artifact` | When PERF-REVIEW linked (soft) |
| IN-44 | `code_artifact` | When CODE linked for docs-from-implementation path (soft) |
| IN-45 | `existing_docs_tree` | Bounded listing per 05-context.md |
| IN-46 | `prior_doc_plan` | `mode: revise` |
| IN-47 | `quality_chain_waiver` | Quality-chain artifacts absent; INT-only path |
| IN-48 | `docs_target_paths` | Explicit path list from orchestrator |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `perf_review_handoff_ref` | PB-perf-review recommended_next_skill path (soft) |
| IN-52 | `doc_scope_override` | Human/orchestrator narrows scope |
| IN-53 | `release_artifact` | When release-bound doc plan (soft) |
| IN-54 | `changelog_seed` | Prior CHANGELOG path for changelog doc_plan_type |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | DOC-PLAN artifact | `{project_root}/work/doc-plan/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — DOC-PLAN frontmatter

```yaml
document_id: DOC-PLAN-{work_id}
work_id: WR-###
doc_plan_type: full | lite | changelog | api_reference | runbook | onboarding
doc_scope: project_docs | os_docs | api_docs | mixed
workflow_id: WF-DOCS
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <INT path>
quality_chain_gap: none | missing | waiver | stale
```

### OUT-01 — Required traceability block (§3)

```yaml
upstream_traceability:
  intake_work_type: <from INT>
  intake_workflow_id: <from INT>
  quality_chain_linked: true | false
  quality_chain_refs: [<paths or empty>]
  quality_chain_alignment: aligned | partial | not_applicable
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Overview | yes — summary, goals, non-goals |
| 2 | Scope & Audience | yes — `doc_scope` rationale |
| 3 | Upstream Traceability | yes — INT path; quality-chain refs or gap |
| 4 | Document Inventory | yes — paths with drift signals |
| 5 | Planned Updates | yes — ≥1 DU-* row |
| 6 | Standards & Conventions | yes — STD-DOC-001 / STD-MD-001 refs |
| 7 | Rollout & Review Plan | yes — phased execution |
| 8 | Risks & Open Questions | yes |
| 9 | Human Approval | yes — H-PLAN block |

### OUT-02 — Work Record additions

```yaml
status: plan_in_progress | plan_pending_review | plan_approved | plan_rejected
artifacts:
  - type: DOC-PLAN
    path: <OUT-01 path>
os_refs:
  skill: PB-draft-doc-update
  workflow_phase: Plan
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-DOC-UPDATE
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, DOC-PLAN + WR paths, OUT-03, DU-* count, open question count, `recommended_next_skill: null` (WF-DOCS terminal), `gate_id: H-PLAN`, `decision: pending`.

**Forbidden in OUT-04:** embedded routing-matrix rows; actual doc body content from `docs/**`; load-test or benchmark commands.

### OUT-05 — Escalation

Triggered after 3 failed CL-DOC-UPDATE attempts or irrecoverable INT/scope gap. Includes: failed checks, blocker summary, recommended human action (`human_classify | split_request | waive_quality_chain`).

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-PLAN `approve` / `revise` / `reject` | Human only — never agent |
| Edits to `docs/**`, README, API reference bodies | Human only post-H-PLAN |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-DOCS
  current_phase: Plan
playbook_invocation:
  skill_id: PB-draft-doc-update
  mode: new | resume | revise
work_id: WR-DOCS-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: INT
    path: work/intake/WR-DOCS-ALPHA.md
  - type: PERF-REVIEW
    path: work/perf-review/WR-PERF-ALPHA.md
    optional: true
token_budget_remaining: 120000
```