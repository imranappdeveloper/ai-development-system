# PB-project-orchestrator — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 04-io-contract |
| normative_ref | `workflows/project-orchestrator/DESIGN.md` §4–5 |

---

## Contract Rule

The orchestrator MUST NOT rely on inputs not listed here. Undocumented I/O is forbidden. Child playbooks own domain artifacts; ORCH-PROJECT owns run control only.

On conflict, `DESIGN.md` §4–5 wins.

---

## Invoke Template

```yaml
command: start | resume | tick | record_gate | abort | rewind
work_id: WR-FEATURE-001          # required except start (agent may propose)
project_root: /absolute/path/to/project
ai_dev_os_home: /data/project/ai-development-system

# start only
raw_request: |
  <passed through to PB-intake-classify when Intake is first phase>

# record_gate only (human channel — never agent-initiated)
human_gate_decision:
  gate_id: H-INTAKE
  decision: approve | revise | reject | waive
  notes: |
    <optional>
  waiver_reason: <required if waive>

# resume only
resume_token:
  run_id: RUN-20260618-001
  ors_checksum: <sha256 of ORS state block>

# rewind only
rewind_target_phase: Intake | Frame | Plan | ...
```

---

## Inputs (ORCH-IN)

### Command inputs

| ID | Field | Required | Description |
|----|-------|----------|-------------|
| ORCH-IN-01 | `command` | yes | `start` \| `resume` \| `tick` \| `record_gate` \| `abort` \| `rewind` |
| ORCH-IN-02 | `work_id` | conditional | Required except `start` without prior WR |
| ORCH-IN-03 | `project_root` | conditional | Required when WR/INT require it |
| ORCH-IN-04 | `ai_dev_os_home` | yes | Global OS path (`AI_DEV_OS_HOME`) |
| ORCH-IN-05 | `raw_request` | `start` only | Forwarded to first Intake playbook |
| ORCH-IN-06 | `workflow_id_hint` | no | Non-binding until H-INTAKE approves INT |
| ORCH-IN-07 | `human_gate_decision` | `record_gate` | Human gate payload — see §Gate input |
| ORCH-IN-08 | `resume_token` | `resume` | ORS `run_id` + checksum for stale detection |
| ORCH-IN-09 | `session_context` | no | Provider, token budget, `correlation_id` |

### Read-only dependencies (each tick)

| ID | Source | Purpose |
|----|--------|---------|
| ORCH-IN-20 | `{project_root}/work/{work_id}.md` | Work Record |
| ORCH-IN-21 | `{project_root}/work/orchestrator/{work_id}.ors.md` | Orchestrator Run State |
| ORCH-IN-22 | `{ai_dev_os_home}/INDEX.md` | Playbook catalog + workflow IDs |
| ORCH-IN-23 | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` | Next-skill routing SSOT |
| ORCH-IN-24 | `{ai_dev_os_home}/workflows/project-orchestrator/gates.yaml` | Human gate registry |
| ORCH-IN-25 | `{ai_dev_os_home}/workflows/{workflow_id}/phases.yaml` | Phase DAG + execution sequence |
| ORCH-IN-26 | WR `artifacts[]` linked paths | Preflight upstream artifacts |
| ORCH-IN-27 | `{ai_dev_os_home}/workflows/project-orchestrator/integrations.md` | Handoff ingestion rules |
| ORCH-IN-28 | `{project_root}/CONTEXT.md` | T1 slice only when playbook requires |

### Command × input matrix

| Input | start | resume | tick | record_gate | abort | rewind |
|-------|-------|--------|------|-------------|-------|--------|
| ORCH-IN-01 command | R | R | R | R | R | R |
| ORCH-IN-02 work_id | O | R | R | R | R | R |
| ORCH-IN-03 project_root | C | C | C | C | C | C |
| ORCH-IN-04 ai_dev_os_home | R | R | R | R | R | R |
| ORCH-IN-05 raw_request | R | — | — | — | — | — |
| ORCH-IN-07 human_gate_decision | — | — | — | R | — | — |
| ORCH-IN-08 resume_token | — | R | — | — | — | — |

`R` = required · `O` = optional · `C` = conditional · `—` = not used

### Gate input (ORCH-IN-07)

```yaml
gate_id: H-INTAKE | H-FRAME | H-PLAN | H-DECOMPOSE | H-IMPLEMENT | H-VERIFY | H-SHIP | H-OPERATE | H-META
decision: approve | revise | reject | waive
actor: human                    # MUST be human — agent MUST NOT set
notes: <string>
waiver_reason: <required if waive>
```

---

## Outputs (ORCH-OUT)

Produced in **fixed order** every applicable tick:

| # | ID | Name | Destination | When |
|---|-----|------|-------------|------|
| 1 | ORCH-OUT-01 | **ORS** | `{project_root}/work/orchestrator/{work_id}.ors.md` | Every tick |
| 2 | ORCH-OUT-02 | **Invocation envelope** | Playbook adapter | INVOKE step only |
| 3 | ORCH-OUT-03 | **Tick log** | `{project_root}/work/orchestrator/logs/{run_id}.md` | Every tick |
| 4 | ORCH-OUT-04 | **Human hold package** | Human channel | `awaiting_human_gate` or preflight block |
| 5 | ORCH-OUT-05 | **Escalation package** | Human channel | Recovery exhausted |
| 6 | ORCH-OUT-06 | **Done package** | Human + WR | `run_status: done` |

### ORCH-OUT-01: ORS minimum schema

Per `templates/orchestrator-run-state/template.md` and **STD-ARTIFACT-001**:

```yaml
run_id: RUN-###
work_id: WR-###
workflow_id: WF-*
current_phase: Intake | Frame | Plan | Decompose | Implement | Verify | Ship | Operate | DONE
run_status: idle | running | awaiting_human | recovering | done | aborted
current_playbook_id: PB-* | null
awaiting_human_gate: H-* | null
phase_history: []
gate_history: []
playbook_history: []
retry_state: {}
context_digest_refs: []
parent_run_id: null
revision: 0
updated: ISO-8601
```

### ORCH-OUT-02: Invocation envelope

```yaml
orchestrator_ref:
  run_id: RUN-###
  orchestrator_id: ORCH-PROJECT
  workflow_id: WF-*
  current_phase: <phase>
  parent_command: tick
playbook_invocation:
  skill_id: PB-*
  mode: new | resume | revise
work_id: WR-###
project_root: <path>
ai_dev_os_home: <path>
artifact_refs:
  - type: INT
    path: <path>
    digest_sha: <hash>
context_reload_list: []
human_gate_context: {}
token_budget_remaining: <n>
```

### ORCH-OUT-04: Human hold package (minimum)

| Section | Content |
|---------|---------|
| `hold_reason` | `awaiting_human_gate` \| `preflight_fail` \| `planned_skill` \| `escalation_pending` |
| `gate_id` | When gate-related |
| `required_human_action` | `record_gate` \| `ack_planned_skill` \| `choose_alternate` |
| `context_summary` | ORS slice + last playbook outcome |
| `options` | Legal `next_candidates` from routing-matrix |

### ORCH-OUT-06: Done package (minimum)

- Final WR `status` + `orchestrator.run_status: done`
- Artifact index from WR
- `gate_history` audit trail
- Optional `recommended_next_work` (new `work_id` suggestion only — no auto-start)

---

## WR orchestrator extension

ORCH-PROJECT MAY update only these WR fields:

```yaml
orchestrator:
  run_id: RUN-###
  current_phase: <phase>
  run_status: <status>
  ors_path: work/orchestrator/{work_id}.ors.md
status: <workflow-level status when terminal>
artifacts: []   # append paths from child handoffs only
approvals: []   # append on record_gate only
```

---

## Downstream contract (child playbooks)

Child playbooks MUST return handoff ingestible per `integrations.md`:

| Field | Required |
|-------|----------|
| `skill_id` | yes |
| `work_id` | yes |
| `handoff_status` | `complete` \| `blocked` \| `escalate` |
| `artifacts_produced[]` | when OUT-* written |
| `exit_gate` | when human gate pending |
| `recommended_next_skill` | advisory only — orchestrator ignores for auto-chain |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Full I/O contract; invoke template; envelope shapes |
| 0.1.0 | 2026-06-18 | Stub ORCH-IN/OUT table |