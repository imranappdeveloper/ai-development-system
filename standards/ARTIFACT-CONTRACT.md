# STD-ARTIFACT-001 — Artifact & Project State Contract

| Field | Value |
|-------|-------|
| standard_id | STD-ARTIFACT-001 |
| name | Artifact & Project State Contract |
| version | 1.0.0 |
| status | active |
| effective | 2026-06-18 |
| extends | STD-SKILL-001@1.0.0 |
| audience | Playbook authors, orchestrator, project artifact writers |

**Normative keywords:** MUST, MUST NOT, SHOULD per RFC 2119 sense.

Artifact type registry: `ARTIFACT-REGISTRY.yaml`. This standard defines **shapes** for cross-cutting project state artifacts.

---

## 1. Work Record (WR)

| Field | Value |
|-------|-------|
| template_id | TP-WR |
| path | `{project_root}/work/{work_id}.md` |
| producer | Any skill with OUT-02 Work Record |
| consumer | All skills, ORCH-PROJECT |

### Required frontmatter (minimum)

```yaml
work_id: WR-###
status: <workflow-specific enum>
work_type: <from INT enum>
workflow_id: WF-*
entry_mode: new_project | existing_project | normal
artifacts: []
approvals: []
revision: 0
os_refs:
  skill: PB-*
  spec_version: x.y.z
  prompt_version: x.y.z
```

### Orchestrator extension (when ORS active)

```yaml
orchestrator:
  run_id: RUN-###
  current_phase: Intake | Frame | Plan | Decompose | Implement | Verify | Ship | Operate | DONE
  run_status: idle | running | awaiting_human | recovering | done | aborted
  ors_path: work/orchestrator/{work_id}.ors.md
```

### Rules

- `artifacts[]` append-only for linked paths; never remove without human waiver
- `approvals[]` append-only gate audit trail
- `status` transitions MUST match producing playbook state machine

---

## 2. Orchestrator Run State (ORS)

| Field | Value |
|-------|-------|
| template_id | TP-ORS |
| path | `{project_root}/work/orchestrator/{work_id}.ors.md` |
| producer | ORCH-PROJECT (ORCH-OUT-01) |
| consumer | ORCH-PROJECT only |

### Required fields

```yaml
run_id: RUN-###
work_id: WR-###
workflow_id: WF-*
current_phase: <phase>
run_status: <status>
current_playbook_id: PB-* | null
awaiting_human_gate: H-* | null
phase_history: []
gate_history: []
playbook_history: []
retry_state: {}
revision: 0
updated: ISO-8601
```

### Invariants (ORCH-PROJECT enforces)

- `awaiting_human_gate` set ⟹ no playbook invoke
- `playbook_history` append-only
- Phase advance requires `gate_history` approve entry

---

## 3. Intake Artifact (INT)

| Field | Value |
|-------|-------|
| template_id | TP-intake |
| path | `{project_root}/work/intake/{work_id}.md` |
| producer | PB-intake-classify |
| consumer | All downstream skills |

Shape SSOT: `templates/intake/template.md`. Field semantics: `playbooks/intake-classify/04-io-contract.md` OUT-01.

---

## 4. Discovery Artifact (DISC)

| Field | Value |
|-------|-------|
| template_id | TP-discovery |
| path | `{project_root}/work/discovery/{work_id}.md` |
| producer | PB-discovery-research |
| consumer | Frame/Plan skills |

Shape SSOT: `templates/discovery/template.md`.

---

## 5. Traceability

Work Record `os_refs` SHOULD record skill version used to produce or update artifacts:

```yaml
os_refs:
  skill: PB-*
  spec_version: x.y.z
  prompt_version: x.y.z
  spec_sha: <optional>
  ai_dev_os_home: <path>
```

---

## 6. References

| Doc | Path |
|-----|------|
| Artifact registry | `ARTIFACT-REGISTRY.yaml` |
| WR template | `templates/work-record/template.md` |
| ORS template | `templates/orchestrator-run-state/template.md` |
| Orchestrator design | `workflows/project-orchestrator/DESIGN.md` §7 |