# PB-prepare-release — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 04-io-contract |

**Contract rule:** Undocumented I/O is forbidden.

---

## Input Summary

| Category | IDs used |
|----------|----------|
| Invocation | IN-01, IN-02, IN-60–IN-62 |
| Human / request | IN-10, IN-11, IN-12 |
| Environment | IN-20, IN-21 |
| OS artifacts | IN-30–IN-33 |
| Project artifacts | IN-40–IN-49 |
| Revise / loop | IN-50–IN-54 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-11 | `release_template` | `{ai_dev_os_home}/templates/release/template.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_release` | `{ai_dev_os_home}/checklists/release.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/prepare-release/` |
| IN-41 | `code_artifact` | **Required** — CODE linked in WR |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-12 | `semver_hint` | Human provides target version |
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-42 | `test_rpt_artifact` | **Soft** — `work/testing/{work_id}.md`; waived `WF-RELEASE` |
| IN-43 | `prd_artifact` | When PRD linked (soft) |
| IN-44 | `issue_artifacts` | When ISS / ISS-* linked (soft) |
| IN-45 | `review_artifact` | When REVIEW linked (soft chain) |
| IN-46 | `sec_review_artifact` | When SEC-REVIEW linked (soft chain) |
| IN-47 | `perf_review_artifact` | When PERF-REVIEW linked (soft chain) |
| IN-48 | `doc_plan_artifact` | When DOC-PLAN linked (soft chain) |
| IN-49 | `prior_rel` | `mode: revise` |
| IN-50 | `human_revise_notes` | H-SHIP soft revise |
| IN-51 | `test_rpt_waiver` | WF-RELEASE or documented verify skip |
| IN-52 | `release_type_hint` | major \| minor \| patch \| hotfix |
| IN-53 | `included_work_ids` | Multi-work release bundle |
| IN-54 | `deploy_target_hint` | staging \| production environment names |
| IN-60 | `orchestrator_ref` | ORCH-PROJECT invocation |
| IN-61 | `workflow_id` | WF-FEATURE \| WF-RELEASE |
| IN-62 | `quality_chain_waivers` | WR notes for skipped verify sub-skills |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | REL artifact | `{project_root}/work/release/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — REL frontmatter

```yaml
document_id: REL-{work_id}
work_id: WR-###
workflow_id: WF-*
release_type: major | minor | patch | hotfix
semver: x.y.z
status: draft | in_review | approved | released
revision: 0
created: ISO-8601
upstream_code_paths: [<CODE paths — mandatory>]
upstream_test_rpt_path: <TEST-RPT path or null>
upstream_review_paths: [<REVIEW paths — soft>]
release_confidence: high | medium | low
template_ref: templates/release/template.md
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

| § | Title | Required | Release rule |
|---|-------|----------|--------------|
| 1 | Release Summary | yes | One paragraph; quality chain note |
| 2 | Release Scope | yes | §2.1 table from WR artifacts |
| 3 | Versioning | yes | semver + bump_rationale |
| 4 | Changelog | yes | At least one non-empty subsection |
| 5 | Breaking Changes & Migration | when applicable | API/schema changes |
| 6 | Dependencies | yes | Runtime / service deps |
| 7 | Deployment | yes | Plan only — no live commands |
| 8 | Verification | yes | §8.1 from TEST-RPT or waiver |
| 9 | Communication | yes | Audiences listed |
| 10 | Risks | yes | At least one row or explicit none |
| 11 | Open Items | yes | Blockers from upstream reviews |
| — | Human Approval | yes | `decision: pending` at handoff |
| — | Post-Release (H-OPERATE) | yes | Placeholder for human |

### OUT-02 — Work Record additions

```yaml
status: release_in_progress | release_pending | release_approved | release_rejected
artifacts:
  - type: REL
    path: <OUT-01 path>
os_refs:
  skill: PB-prepare-release
  workflow_phase: Ship
approvals:
  - gate_id: H-SHIP
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-RELEASE
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, REL + WR paths, OUT-03, §11 blocker count, `gate_id: H-SHIP`, `decision: pending`, quality-chain note (last skill). **Must NOT** include H-SHIP `approve`, deploy commands, or `kubectl`/`terraform apply`/`npm publish` execution.

### OUT-05 — Escalation

Triggered after 3 failed CL-RELEASE attempts or irrecoverable CODE/TEST-RPT gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-SHIP `approve` on REL evidence | Human only |
| H-SHIP `approve` / `revise` / `reject` | Human only |
| WR `approvals[]` final H-SHIP decision | Human appends after review |
| Production deploy execution | Human or approved pipeline |
| H-OPERATE smoke verification | Human at operate phase |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-FEATURE
  current_phase: Ship
playbook_invocation:
  skill_id: PB-prepare-release
  mode: new | resume | revise
work_id: WR-FEATURE-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
semver_hint: 1.2.0
release_type_hint: minor
artifact_refs:
  - type: CODE
    path: work/implement/backend/WR-FEATURE-ALPHA.md
  - type: TEST-RPT
    path: work/testing/WR-FEATURE-ALPHA.md
  - type: REVIEW
    path: work/review/WR-FEATURE-ALPHA.md
token_budget_remaining: 120000
```