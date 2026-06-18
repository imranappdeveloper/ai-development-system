# PB-project-orchestrator (ORCH-PROJECT)

**Project Orchestrator** — central brain of the AI Dev OS. Routes, sequences, gates, and recovers work across workflows.

| Field | Value |
|-------|-------|
| skill_id | `PB-project-orchestrator` |
| orchestrator_id | `ORCH-PROJECT` |
| version | `0.2.0` |
| prompt_version | `0.2.0` |
| status | `active` |
| exit_gate | `none` |
| checklist_id | `CL-ORCH` |
| path | `{AI_DEV_OS_HOME}/playbooks/project-orchestrator/` |

---

## Quick Reference

```text
Commands → start | resume | tick | record_gate | abort | rewind
Persist  → ORS + WR orchestrator fields every tick
Invoke   → exactly one PB-* per tick (when not gated)
Gate     → CL-ORCH (agent, 8 checks); H-* via human record_gate only
Stop     → after each tick; never auto-chain playbooks
```

---

## Overview

ORCH-PROJECT sits **above** atomic playbooks and **below** the human. It converts an approved work item into the next eligible skill invocation — without writing INT, DISC, PRD, code, or tests.

```
Human command → LOAD substrate → CL-ORCH → ROUTE → INVOKE one PB-* → INGEST → PERSIST ORS → hold or next tick
```

### Single responsibility

> **Route, sequence, gate, and recover work. Invoke exactly one playbook per tick. Persist ORS. Stop.**

### When to use

| Condition | Command |
|-----------|---------|
| New orchestrated workflow run | `start` |
| Continue existing `work_id` | `resume` then `tick` |
| Advance one step | `tick` |
| Human gate decision | `record_gate` (human only) |
| Cancel run | `abort` |
| Reset phase without deleting artifacts | `rewind` |

### When not to use

| Situation | Use instead |
|-----------|-------------|
| Classify raw request | PB-intake-classify (via orchestrator `tick` at Intake) |
| Run one playbook standalone | Invoke playbook directly — then `resume` to reconcile ORS |
| Approve H-* without human | Forbidden — governance bypass |

### Design references

| Doc | Path |
|-----|------|
| Normative design | `workflows/project-orchestrator/DESIGN.md` |
| Routing SSOT | `workflows/project-orchestrator/routing-matrix.yaml` |
| Gates | `workflows/project-orchestrator/gates.yaml` |
| Integrations | `workflows/project-orchestrator/integrations.md` |
| Skill graph | `workflows/project-orchestrator/skill-dependency-graph.yaml` |

---

## Commands

| Command | Purpose |
|---------|---------|
| `start` | Create WR + ORS; begin at workflow Intake phase |
| `resume` | Load ORS + WR; reconcile standalone runs if needed |
| `tick` | One orchestrator cycle — may invoke one child playbook |
| `record_gate` | Human records H-* decision; unblock or rewind |
| `abort` | Terminate with `run_status: aborted` |
| `rewind` | Reset `current_phase` — artifacts preserved |

Detail: [03-workflow.md](./03-workflow.md)

---

## Inputs & Outputs

### Invoke template

```yaml
command: tick
work_id: WR-FEATURE-001
project_root: /absolute/path/to/project
ai_dev_os_home: /data/project/ai-development-system
```

### Key outputs (fixed order)

| # | Output | Destination |
|---|--------|-------------|
| 1 | ORS | `{project_root}/work/orchestrator/{work_id}.ors.md` |
| 2 | Invocation envelope | Child playbook adapter |
| 3 | Tick log | `{project_root}/work/orchestrator/logs/{run_id}.md` |
| 4 | Human hold | When gated or blocked |
| 5 | Escalation | Recovery exhausted |
| 6 | Done package | Terminal workflow |

Detail: [04-io-contract.md](./04-io-contract.md)

---

## Examples

| Path | Purpose |
|------|---------|
| [examples/golden/ORS-tick-intake-hold-001.md](./examples/golden/ORS-tick-intake-hold-001.md) | Golden ORS after intake tick + H-INTAKE hold |
| [examples/anti-patterns/ORCH-auto-chain.md](./examples/anti-patterns/ORCH-auto-chain.md) | Anti-pattern: auto-chaining playbooks |
| [examples/anti-patterns/ORCH-self-approve-gate.md](./examples/anti-patterns/ORCH-self-approve-gate.md) | Anti-pattern: agent approves H-* |
| [examples/anti-patterns/ORCH-skip-ors.md](./examples/anti-patterns/ORCH-skip-ors.md) | Anti-pattern: skip ORS persist |

Fixture project: [fixtures/projects/wf-feature-alpha/](./fixtures/projects/wf-feature-alpha/)

Full catalog: [examples/README.md](./examples/README.md) · Tests: [11-test-plan.md](./11-test-plan.md)

---

## WF-FEATURE happy path (abbreviated)

| Step | Actor | Action |
|------|-------|--------|
| 1 | Human | `start` + `tick` → PB-intake-classify |
| 2 | Human | `record_gate` H-INTAKE approve |
| 3 | Human | `tick` → PB-discovery-research |
| 4 | Human | `record_gate` H-FRAME approve |
| 5 | Human | `tick` → next phase playbook (blocked if `planned`) |
| … | … | Until terminal H-SHIP + DOD |

Planned playbooks emit hold (`ORCH-S7`) until promoted or human ack.

---

## Common Mistakes

| Mistake | Consequence | Correct approach |
|---------|-------------|------------------|
| Auto-chain intake → discovery | H-INTAKE skipped | One `tick` per playbook; human `record_gate` between |
| Agent calls `record_gate approve` | Governance bypass | Human channel only |
| Skip ORS write | Cannot resume | Persist ORS every tick |
| Invoke during `awaiting_human_gate` | CL-ORCH #6 fail | Emit hold; wait for `record_gate` |
| Invoke `planned` PB-draft-prd | Wrong-phase delivery | Hold until skill `active` or human ack |
| Orchestrator drafts INT | SRP violation | Delegate to PB-intake-classify |

---

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why orchestrator exists |
| [02-responsibilities.md](./02-responsibilities.md) | ORCH-P/S/O duties, NEVER table |
| [03-workflow.md](./03-workflow.md) | Commands, tick flow, recovery |
| [04-io-contract.md](./04-io-contract.md) | ORCH-IN/OUT, envelopes |
| [05-context.md](./05-context.md) | T0–T3 budgets |
| [06-quality.md](./06-quality.md) | AC-*, G-ORCH, promotion gate |
| [07-edge-cases.md](./07-edge-cases.md) | 20 EC-* scenarios |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review |
| [11-test-plan.md](./11-test-plan.md) | Validation & promotion |
| [registry.yaml](./registry.yaml) | Machine SSOT |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Complete spec 01–11; examples; fixtures; promoted `active` |
| 0.1.0 | 2026-06-18 | Scaffold from DESIGN; substrate P0 |

### Promotion status

| Milestone | Status |
|-----------|--------|
| Spec complete (01–11) | ✅ |
| README + examples + fixtures | ✅ |
| G-ORCH + G-WF-05 + HT/ET/FT | ✅ |
| `status: active` | ✅ |