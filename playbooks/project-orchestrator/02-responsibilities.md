# PB-project-orchestrator — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| name | Project Orchestrator |
| version | 0.2.0 |
| status | active |
| document | 02-responsibilities |
| normative_ref | `workflows/project-orchestrator/DESIGN.md` §2 |

---

## Responsibility Model

| Actor | Role in orchestration |
|-------|----------------------|
| **Agent** | Executes tick steps (LOAD → BRANCH), invokes one child playbook, persists ORS, runs CL-ORCH, emits hold/escalation packages |
| **Human** | Triggers commands (`start`, `tick`, `record_gate`, …), **approves / revises / rejects / waives** H-* gates, decides on alternates and waivers |
| **Child playbooks** | Perform domain work; return handoff packages; never chain to next playbook |

On conflict with this file, `DESIGN.md` §2 wins.

---

## Primary Responsibilities

Must execute on every applicable command/tick. Failure blocks ORS persist or next invoke.

| # | Responsibility | Agent action | Done when |
|---|----------------|--------------|-----------|
| ORCH-P1 | **Accept work** | Validate invocation envelope for `start` / `resume` / `tick` / `record_gate` / `abort` / `rewind` | `work_id` + `project_root` resolvable; command legal for current ORS state |
| ORCH-P2 | **Bind workflow** | Set `workflow_id` from human-approved INT | H-INTAKE `approve` in `gate_history`; matches INT `workflow_id` |
| ORCH-P3 | **Maintain run state** | Create or update ORS at `{project_root}/work/orchestrator/{work_id}.ors.md` | ORS fields per **STD-ARTIFACT-001** / TP-ORS |
| ORCH-P4 | **Compute next playbook** | ROUTE from `workflows/{workflow_id}/phases.yaml` + `routing-matrix.yaml` + artifacts + `gate_history` | `next_playbook_id` identified or terminal/hold determined |
| ORCH-P5 | **Assemble invocation envelope** | CONTEXT step — T0–T3 per **STD-CTX-001** for target playbook | Envelope matches child `04-io-contract.md` invoke template |
| ORCH-P6 | **Invoke one playbook** | INVOKE exactly one `PB-*` per tick on same `work_id` | INV-01 satisfied; no parallel mutating playbooks |
| ORCH-P7 | **Ingest handoff** | Validate child OUT-* against `integrations.md` + playbook contract | Handoff accepted or categorized failure |
| ORCH-P8 | **Advance or hold phase** | TRANSITION — update `current_phase`, `run_status` | Phase move legal in phases.yaml; or `awaiting_human_gate` set |
| ORCH-P9 | **Record gate decisions** | On `record_gate`, append WR `approvals[]` + ORS `gate_history` | Append-only; duplicate same content = no-op |
| ORCH-P10 | **Execute recovery** | Apply E-ORCH / E-WF-* / E-PLAYBOOK policy; max retries per DESIGN §9 | `run_status` ∈ {`running`, `recovering`, `awaiting_human`} — not silent stall |
| ORCH-P11 | **Emit human hold** | When blocked (gate, preflight, escalation), produce ORCH-OUT-04 / ORCH-OUT-05 | Human sees required decision + context |
| ORCH-P12 | **Terminate run** | On Definition of Done or `abort`, set `run_status: done` \| `aborted` | DOD-01–DOD-07 satisfied or human abort recorded |

### Tick invariant (every ORCH-P3 / ORCH-P6)

Before ORS persist after any tick:

1. Run **CL-ORCH** (all 8 checks)
2. If fail → ORCH-P10 recovery; do not advance phase

---

## Secondary Responsibilities

Expected when applicable. Skip only with explicit N/A in tick log.

| # | Responsibility | When applicable | Agent action |
|---|----------------|-----------------|--------------|
| ORCH-S1 | **Present routing alternates** | Child handoff lists `recommended_next_skill` ∉ single legal next | Surface options from `routing-matrix.yaml` `next_candidates`; human picks |
| ORCH-S2 | **Rewind on re-intake** | DISC `alignment: requires_re_intake` | Reset `current_phase` → Intake; clear `awaiting_human_gate`; do not delete artifacts |
| ORCH-S3 | **Fan-out child runs** | Maintenance batch / multi `work_id` | Create child ORS with `parent_run_id`; depth ≤ 2 (**OD-04**) |
| ORCH-S4 | **Apply gate waiver** | WR documents waiver + `gates.yaml` allowlist | Log waiver in `gate_history`; advance per workflow spec |
| ORCH-S5 | **Stale artifact refresh** | PREFLIGHT detects revision mismatch | Hold; recommend refresh playbook or human ack |
| ORCH-S6 | **Degrade context tier** | Token budget exceeded (**STD-CTX-001**) | Drop to lower tier; log in tick log |
| ORCH-S7 | **Block or warn on skill status** | Next playbook `status: planned` or unacknowledged `draft` | Block invoke; require human ack in WR before proceed |
| ORCH-S8 | **Cross-work dependency block** | Child run waiting on parent gate/artifact | Set hold; link `parent_run_id` in ORS |

---

## Optional Responsibilities

MAY perform when zero ambiguity cost or human explicitly requests. Never required for tick completion.

| # | Responsibility | Trigger | Constraint |
|---|----------------|---------|------------|
| ORCH-O1 | **Emit tick log** | Every tick | ORCH-OUT-03 to `work/orchestrator/logs/` — audit only |
| ORCH-O2 | **Summarize run for human** | `resume` after long idle | Read ORS + WR; no new domain content |
| ORCH-O3 | **Suggest waive eligibility** | Stuck at skippable gate | Cite `gates.yaml` `waivable_gates` — human decides |
| ORCH-O4 | **Pre-flight INDEX drift check** | LOAD step | Warn if catalog version ≠ WR `os_refs` — do not auto-migrate |
| ORCH-O5 | **Reconcile standalone playbook** | `resume` finds WR artifacts without matching `playbook_history` | Rebuild ORS from WR; do not re-run completed playbooks |

---

## Explicit Non-Responsibilities

Forbidden actions. Violation is an orchestrator defect.

### Domain work

| # | Non-responsibility | Owner |
|---|-------------------|-------|
| ORCH-N1 | Classify `work_type` / propose `workflow_id` | PB-intake-classify |
| ORCH-N2 | Write INT, DISC, PRD, ARCH, ISS, CODE, TEST-RPT, REVIEW, REL, MAINT | Respective `PB-*` playbooks |
| ORCH-N3 | Approve, revise, reject, or waive H-* gates | Human via `record_gate` |
| ORCH-N4 | Modify playbooks, standards, routing-matrix, or phases.yaml | OS Maintainer / Workflow Owner |
| ORCH-N5 | Invoke two mutating playbooks concurrently on same `work_id` | — |
| ORCH-N6 | Change `workflow_id` or override INT/DISC without rewind + re-approval | Human + ORCH-S2 / `rewind` |
| ORCH-N7 | Invoke playbook when PREFLIGHT entry criteria fail | — |
| ORCH-N8 | Complete tick without persisting ORS (when state changed) | — |
| ORCH-N9 | Treat chat transcript as authoritative run state | WR + ORS only (**STD-MEM-001**) |
| ORCH-N10 | Copy or fork OS into `project_root` | Global `AI_DEV_OS_HOME` |

### Orchestration anti-patterns

| # | Non-responsibility | Why forbidden |
|---|-------------------|---------------|
| ORCH-N11 | Pass `auto_start_next: true` to child playbooks | INV-R3 — governance bypass |
| ORCH-N12 | Treat `recommended_next_skill` as mandatory route | INV-R4 — ROUTE validates |
| ORCH-N13 | Embed work_type → workflow matrix in prompt | SSOT: `routing-matrix.yaml` |
| ORCH-N14 | Auto-approve gates from test/CI results | Advisory model (**docs/GOVERNANCE.md**) |
| ORCH-N15 | Delete domain artifacts on `rewind` | Rewind resets phase only — artifacts remain for audit |

---

## Human vs Agent Responsibility Matrix

| Task | Agent | Human |
|------|-------|-------|
| Issue `start` / `resume` / `tick` | executes when commanded | **initiates** commands |
| LOAD routing-matrix, gates, phases | yes | — |
| Select `next_playbook_id` | computes per SSOT | may override via `rewind` / abort |
| Invoke child playbook | yes (one per tick) | — |
| Write domain artifact content | never | — (via child playbook) |
| Set `awaiting_human_gate` after child exit | yes | — |
| `record_gate` approve / revise / reject / waive | never | **only human** |
| Acknowledge `planned` / `draft` skill invoke | may surface ORCH-S7 hold | **explicit ack** in WR |
| Choose among routing alternates (ORCH-S1) | presents options | **decides** |
| Abort run | sets `aborted` on command | **commands** `abort` |
| Declare run Done | checks DOD-01–07 | **confirms** via Done / final gate |
| CL-ORCH self-check | executes | reviews escalation if fail |

---

## Required Dependencies

Must be available before tick. Missing **required** dependency → hold + ORCH-OUT-05 (no silent skip).

### OS dependencies (machine SSOT)

| ID | Dependency | Path | Required |
|----|------------|------|----------|
| D-ORCH-01 | AI Dev OS home | `AI_DEV_OS_HOME` | yes |
| D-ORCH-02 | Routing matrix | `workflows/project-orchestrator/routing-matrix.yaml` | yes |
| D-ORCH-03 | Gate registry | `workflows/project-orchestrator/gates.yaml` | yes |
| D-ORCH-04 | Integration contracts | `workflows/project-orchestrator/integrations.md` | yes |
| D-ORCH-05 | Workflow phase DAG | `workflows/{workflow_id}/phases.yaml` | yes after ORCH-P2 |
| D-ORCH-06 | Skill graph | `workflows/project-orchestrator/skill-dependency-graph.yaml` | yes (planning alignment) |
| D-ORCH-07 | Catalog index | `INDEX.md` | yes |
| D-ORCH-08 | Orchestrator checklist | `checklists/orchestrator.md` (CL-ORCH) | yes before ORS persist |
| D-ORCH-09 | Design normative ref | `workflows/project-orchestrator/DESIGN.md` | yes |
| D-ORCH-10 | Self spec | `playbooks/project-orchestrator/` | yes |

### Project dependencies

| ID | Dependency | Path | Required |
|----|------------|------|----------|
| D-ORCH-11 | Work Record | `{project_root}/work/{work_id}.md` | yes (except `start` creating new) |
| D-ORCH-12 | ORS | `{project_root}/work/orchestrator/{work_id}.ors.md` | yes after `start` |
| D-ORCH-13 | Approved INT | WR `artifacts[]` → INT path | yes before Frame+ routing |
| D-ORCH-14 | Phase artifacts | Per `routing-matrix.yaml` `requires_artifacts` | yes at PREFLIGHT |

### Command-specific dependencies

| Command | Additional required |
|---------|---------------------|
| `start` | `raw_request` or human intent; optional pre-existing WR |
| `resume` | Existing ORS + WR |
| `tick` | ORS not `aborted`; if `awaiting_human_gate` → stop (no invoke) |
| `record_gate` | `gate_id`, `decision`, `work_id`; WR + ORS |
| `rewind` | Target phase name; human authorization in envelope |
| `abort` | Human reason (recommended) |

### Tool dependencies (abstract)

| ID | Capability | Purpose |
|----|------------|---------|
| D-TL-01 | `read_file` | LOAD substrate + WR + ORS + artifacts |
| D-TL-02 | `write_file` | Persist ORS, tick log, WR approval append |
| D-TL-03 | `dispatch_skill` | INVOKE child playbook with envelope |

### Downstream consumers (orchestrator produces for)

| ID | Consumer | Requires |
|----|----------|----------|
| D-DN-01 | All `PB-*` playbooks | Valid invocation envelope from INVOKE step |
| D-DN-02 | Human operator | Hold / escalation / Done packages |
| D-DN-03 | WR | Updated `artifacts[]`, `approvals[]`, orchestrator extension fields |

---

## Artifacts Owned vs Delegated

### Orchestrator OWNS (creates/updates)

| Artifact | Template | Action |
|----------|----------|--------|
| ORS | TP-ORS | create/update every state-changing tick |
| Tick log | — | optional ORCH-O1 |
| WR orchestrator fields | TP-WR | sync `orchestrator.*`, `approvals[]` on `record_gate` |

### Orchestrator DELEGATES (indexes only)

| Artifact | Producer | Orchestrator role |
|----------|----------|-------------------|
| INT | PB-intake-classify | PREFLIGHT path check; index in WR |
| DISC | PB-discovery-research | Gate H-FRAME bind |
| PRD, CODE, … | Phase playbooks | PREFLIGHT + phase transition |

Orchestrator MUST NOT author body content of delegated artifacts.

---

## Gate Recording Responsibilities (ORCH-P9)

On `record_gate`, agent MUST:

| Step | Action |
|------|--------|
| 1 | Validate `gate_id` exists in `gates.yaml` |
| 2 | Validate `gate_id` matches `awaiting_human_gate` (or document mismatch → E-STATE) |
| 3 | Append to ORS `gate_history` — never mutate prior entries |
| 4 | Mirror to WR `approvals[]` with `approver`, `date`, `decision`, `notes` |
| 5 | On `approve` / `waive` → clear `awaiting_human_gate`; set `run_status: running` |
| 6 | On `revise` → trigger rewind per gate (DESIGN §3 rewind table) |
| 7 | On `reject` → `run_status: aborted` or hold per human instruction |

Agent MUST NOT set `decision: approve` without human-supplied `record_gate` input.

---

## Recovery Responsibilities (ORCH-P10)

| Failure class | Code | Agent action |
|---------------|------|--------------|
| Preflight / missing artifact | E-WF-PREFLIGHT | Hold; list missing `requires_artifacts` |
| Illegal gate transition | E-WF-GATE | Abort tick; preserve ORS |
| Child playbook escalation | E-PLAYBOOK | Delegate to playbook recovery; retry ≤ 3 |
| Planned skill blocked | E-WF-PLANNED | ORCH-S7 hold |
| Re-intake signal | E-WF-REWIND | ORCH-S2 → Intake |
| CL-ORCH fail | E-ORCH-INV | `run_status: recovering`; ORCH-OUT-05 |
| State conflict | E-STATE | Human resolution required |

---

## Responsibility Completion Checklist

Before marking a tick complete:

- [ ] Applicable ORCH-P1–P12 executed for command type
- [ ] Applicable ORCH-S1–S8 executed or N/A logged
- [ ] No ORCH-N1–N15 violated
- [ ] D-ORCH-01–10 satisfied
- [ ] CL-ORCH passed (if ORS mutated)
- [ ] At most one playbook invoked
- [ ] ORS persisted when state changed
- [ ] Human hold emitted if `awaiting_human_gate` set

---

## Cross-References

| Document | Relationship |
|----------|--------------|
| [01-purpose.md](./01-purpose.md) | Why these responsibilities exist |
| [03-workflow.md](./03-workflow.md) | Tick steps and commands |
| [04-io-contract.md](./04-io-contract.md) | ORCH-IN-* / ORCH-OUT-* |
| `workflows/project-orchestrator/DESIGN.md` | Normative ORCH-P/S/N definitions |
| `checklists/orchestrator.md` | CL-ORCH enforcement |
| `docs/GOVERNANCE.md` | H-* gate semantics |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Full responsibilities per STD-SKILL-001 §4.1 |
| 0.1.0 | 2026-06-18 | Stub pointing to DESIGN.md |