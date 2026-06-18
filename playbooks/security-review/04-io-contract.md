# PB-security-review — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
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
| IN-10 | `code_artifact` | `{project_root}/work/implement/**/{work_id}.md` or lane path in WR |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_security_review` | `{ai_dev_os_home}/checklists/security-review.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/security-review/` |
| IN-33 | `review_template` | `{ai_dev_os_home}/templates/review/template.md` (structure reference) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR |
| IN-40 | `context_md` | When project exists |
| IN-41 | `sec_assess_artifact` | When SEC-ASSESS linked in WR (soft) |
| IN-42 | `test_rpt_artifact` | When TEST-RPT linked (optional) |
| IN-43 | `issue_artifacts` | When ISS paths in CODE upstream refs |
| IN-44 | `code_files` | Paths from CODE §4 Files Changed |
| IN-45 | `implement_lane` | From CODE frontmatter |
| IN-46 | `prior_sec_review` | `mode: revise` |
| IN-50 | `human_revise_notes` | H-VERIFY revise |
| IN-51 | `human_waiver` | H-VERIFY waive for optional skill |
| IN-52 | `assess_gap_waiver` | SEC-ASSESS absent; human documents `assess_gap: waiver` |
| IN-53 | `verify_waiver` | H-VERIFY soft gate waived |
| IN-54 | `target_finding_ids` | Partial re-review scope |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | SEC-REVIEW artifact | `{project_root}/work/security-review/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — SEC-REVIEW frontmatter

```yaml
document_id: SEC-REVIEW-{work_id}
work_id: WR-###
review_type: security_code
security_review_scope: auth | input_validation | data_exposure | crypto | dependencies | api_surface | mixed_security
workflow_id: WF-*
security_review_confidence: high | medium | low
review_decision: pass | changes_requested | fail | blocked
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_code_path: <CODE path — mandatory>
upstream_assess_path: <SEC-ASSESS path or null>
```

### OUT-01 — Required SEC-ASSESS alignment block (when SEC-ASSESS present)

```yaml
assess_alignment:
  assess_document_id: <from SEC-ASSESS>
  assess_work_id: <from SEC-ASSESS>
  alignment: aligned | partial_mismatch | assess_missing | not_applicable
  mismatch_summary: <if not aligned>
  assess_path: <relative path — mandatory when SEC-ASSESS linked>
assess_gap: none | missing | waiver
```

### OUT-01 — Required sections

| § | Title | Required |
|---|-------|----------|
| 1 | Review Context | yes |
| 2 | Standards Checklist | yes — STD-SEC-001 minimum |
| 3 | Review Scope | yes — CODE §4 file mapping |
| 4 | Findings | yes when issues exist; explicit "no findings" when clean |
| 5 | SEC-ASSESS Control Traceability | when SEC-ASSESS linked |
| 6 | Remediation Recommendations | when findings exist |
| 7 | Open Questions | when applicable |
| 8 | Human Approval | yes |

### OUT-02 — Work Record additions

```yaml
status: security_review_in_progress | security_review_pending | verify_approved | verify_rejected
artifacts:
  - type: SEC-REVIEW
    path: <OUT-01 path>
os_refs:
  skill: PB-security-review
  workflow_phase: Verify
  review_type: security_code
approvals:
  - gate_id: H-VERIFY
    decision: pending
```

### OUT-03 — Validation Record

```yaml
checklist_id: CL-SECURITY-REVIEW
result: pass | fail
failed_items: []
attempt: 1-3
timestamp: ISO-8601
```

### OUT-04 — Handoff

Must include: summary ≤10 lines, SEC-REVIEW + WR paths, OUT-03, findings summary, `recommended_next_skill: PB-prepare-release`, `gate_id: H-VERIFY`, `decision: pending`. **Must NOT** include code patches or deploy commands.

### OUT-05 — Escalation

Triggered after 3 failed CL-SECURITY-REVIEW attempts or irrecoverable CODE gap. Includes: failed checks, blocker summary, recommended human action.

---

## Human-Only Outputs

| Output | Rule |
|--------|------|
| H-VERIFY `approve` / `revise` / `reject` / `waive` | Human only — never agent |
| Production deployment | Human only — never agent |
| WR `approvals[]` final decision | Human appends after review |

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-SECURITY
  current_phase: Verify
playbook_invocation:
  skill_id: PB-security-review
  mode: new | resume | revise
  review_type: security_code
work_id: WR-SECURITY-ALPHA
project_root: /path/to/project
ai_dev_os_home: /path/to/ai-development-system
artifact_refs:
  - type: CODE
    path: work/implement/backend/WR-SECURITY-ALPHA.md
  - type: SEC-ASSESS
    path: work/security/WR-SECURITY-ALPHA.md
token_budget_remaining: 120000
```