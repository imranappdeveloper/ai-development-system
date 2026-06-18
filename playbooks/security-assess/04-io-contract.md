# PB-security-assess — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
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
| Project artifacts | IN-40–IN-46 |
| Revise / loop | IN-50–IN-52 |

---

## Inputs

### Required

| ID | Field | Source |
|----|-------|--------|
| IN-01 | `skill_invocation` | Workflow or human |
| IN-02 | `work_id` | Work Record |
| IN-10 | `int_artifact` | `{project_root}/work/intake/{work_id}.md` |
| IN-11 | `work_record` | `{project_root}/work/{work_id}.md` |
| IN-20 | `ai_dev_os_home` | `AI_DEV_OS_HOME` |
| IN-30 | `workflow_catalog` | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist` | `{ai_dev_os_home}/checklists/security.md` |
| IN-32 | `self_spec` | `{ai_dev_os_home}/playbooks/security-assess/` |
| IN-33 | `routing_matrix` | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` (read-only) |

### Conditional

| ID | Field | When |
|----|-------|------|
| IN-21 | `project_root` | From WR / upstream artifact |
| IN-40 | `context_md` | When project exists |
| IN-41 | `security_standard` | `{ai_dev_os_home}/standards/engineering/STD-SEC-001.md` |
| IN-50 | `human_revise_notes` | H-PLAN revise |
| IN-51 | `prior_artifact` | Revise loop — prior SEC-ASSESS path |
| IN-52 | `human_waiver` | Documented upstream gate waiver in WR |

---

## Outputs (fixed order)

| ID | Name | Destination |
|----|------|-------------|
| OUT-01 | SEC-ASSESS artifact | `{project_root}/work/security/{work_id}.md` |
| OUT-02 | Work Record (updated) | `{project_root}/work/{work_id}.md` |
| OUT-03 | Validation Record | Embedded in handoff |
| OUT-04 | Handoff Package | Human channel |
| OUT-05 | Escalation Package | On EXIT_ESC |

### OUT-01 — Frontmatter

```yaml
document_id: SEC-ASSESS-{work_id}
work_id: WR-###
workflow_id: WF-SECURITY
assess_scope: auth | data_protection | api_surface | infrastructure | dependencies | supply_chain | mixed_security
threat_model_method: stride | attack_trees | pwned_model | owasp_asvs | custom_documented
assess_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
upstream_int_path: <required>
```

### OUT-01 — Required sections

| Section | Content |
|---------|---------|
| Summary | One paragraph — assessment purpose and top risks |
| Scope | `in` / `out` tables |
| Assets & Trust Boundaries | Data flows and boundary diagram or table |
| Threat Model | Method + threat enumeration (STRIDE default) |
| Security Controls | SA-* control IDs with testable requirements |
| Risk Register | ≥1 risk with severity and mitigation |
| Remediation Plan | Prioritized P0/P1/P2 actions — **no code patches** |
| References | Upstream artifact paths |
| Open Questions | Human-owned unknowns |
| Human Approval | `gate_id: H-PLAN`, `decision: pending` |

### OUT-04 — Handoff fields

```yaml
skill_id: PB-security-assess
artifact_type: SEC-ASSESS
artifact_path: work/security/{work_id}.md
checklist_id: CL-SECURI
checklist_result: pass | fail
gate_id: H-PLAN
decision: pending
recommended_next_skill: PB-implement
```

---

## Invoke Template

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-SECURITY
  current_phase: Plan
playbook_invocation:
  skill_id: PB-security-assess
  mode: new | resume | revise
work_id: WR-###
project_root: <path>
ai_dev_os_home: <path>
artifact_refs:
  - type: INT
    path: work/intake/{work_id}.md
```