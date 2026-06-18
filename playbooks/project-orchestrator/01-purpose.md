# PB-project-orchestrator — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| name | Project Orchestrator |
| version | 0.2.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

**Route, sequence, gate, and recover** work across the AI Dev OS — invoke exactly one atomic playbook per tick, persist durable run state, and stop; never perform domain work.

---

## What Problem Does It Solve?

Individual playbooks (`PB-intake-classify`, `PB-discovery-research`, `PB-draft-prd`, `PB-implement`, etc.) are intentionally **single-responsibility**. Each classifies, frames, plans, builds, or verifies — then **hands off and stops**.

Without a central coordinator:

| Failure | Cost |
|---------|------|
| Playbooks auto-chain | H-* gates skipped; governance bypass |
| Humans manually track “what’s next” | Wrong skill invoked; context lost between sessions |
| No durable run state | Work cannot resume mid-workflow after chat ends |
| Inconsistent retry/recovery | Duplicate artifacts; stuck `work_id` |
| Ad-hoc context loading | Token waste; cross-project leakage |
| Standalone playbook runs orphan WR | ORS out of sync with artifacts produced outside orchestrator |

**This skill solves the coordination problem.** It owns *which* playbook runs *when*, under *which* workflow, with *which* human gates recorded — while every domain artifact remains the responsibility of the invoked playbook.

It does **not** solve classification, discovery, planning, implementation, or verification.

---

## Why Does It Exist?

The OS defines fourteen workflows, eight phase-boundary human gates, and a routing graph derived from skill dependencies. Something must sit **above** atomic playbooks and **below** the human — converting “approved work item” into “next eligible skill invocation” without absorbing their jobs.

The Project Orchestrator exists because:

1. **Workflow paths are machine SSOT.** `workflows/WF-*/phases.yaml` and `routing-matrix.yaml` define legal sequences; a coordinator must enforce them — not chat improvisation.
2. **Human gates are advisory but durable.** Humans decide; the orchestrator surfaces holds, records `gate_history`, and blocks invoke until `record_gate` — per `docs/GOVERNANCE.md`.
3. **Run state must survive sessions.** `ORS` (Orchestrator Run State) is the authoritative progress record; chat is not SSOT (**STD-MEM-001**).
4. **Exactly one mutating playbook per `work_id` per tick** prevents race conditions on WR artifacts and phase transitions.
5. **Recovery must be categorized.** Preflight failures, gate rejects, playbook escalations, and `requires_re_intake` rewind each need a defined orchestrator response — not ad-hoc retries.

Without this skill, every playbook would silently chain to the next — duplicating routing logic, drifting from the graph, and violating single responsibility.

---

## What Business Value Does It Provide?

| Value | Mechanism |
|-------|-----------|
| **Governed delivery** | H-* gates cannot be skipped by eager agents |
| **Resumable work** | `start` / `resume` / `tick` on any `work_id` with ORS |
| **Correct routing** | `routing-matrix.yaml` + `gates.yaml` + approved INT `workflow_id` |
| **Lower rework** | Wrong-phase invoke blocked at preflight |
| **Audit trail** | `phase_history`, `gate_history`, `playbook_history` in ORS |
| **Token discipline** | Context envelope T0–T3 assembled once per tick (**STD-CTX-001**) |
| **Honest blocking** | `planned` skills blocked (ORCH-S7) until human ack or promotion |

For a personal or team OS, the primary value is **not losing the thread** on multi-day feature work while keeping humans in control at every phase boundary.

---

## When Should It Be Used?

Invoke **PB-project-orchestrator** (ORCH-PROJECT) when **any** of the following are true:

| Condition | Command |
|-----------|---------|
| New work needs orchestrated workflow execution | `start` |
| Existing `work_id` has ORS and human wants to continue | `resume` then `tick` |
| Child playbook completed; advance to next step | `tick` |
| Human approved, revised, rejected, or waived a gate | `record_gate` |
| DISC alignment or human requests phase rollback | `rewind` |
| Work must stop permanently | `abort` |
| Standalone playbook ran outside orchestrator; ORS must reconcile | `resume` (reconcile mode) |

### Typical triggers

- Human: “Run WF-FEATURE for work_id X”
- Agent completed PB-intake-classify; human approved H-INTAKE; orchestrator should invoke PB-discovery-research
- Session ended mid-workflow; human returns and says “continue work_id X”
- Human records “approve” at H-FRAME after reviewing DISC
- Maintenance batch fans out child runs (ORCH-S3)

### Prerequisites (orchestrator-level)

| Prerequisite | When |
|--------------|------|
| `AI_DEV_OS_HOME` resolvable | Always |
| `work_id` + WR exist | `resume`, `tick`, `record_gate` |
| Approved INT with `workflow_id` | After H-INTAKE before Frame+ phases (ORCH-P2) |
| `workflows/{workflow_id}/phases.yaml` exists | ROUTE step |
| `routing-matrix.yaml`, `gates.yaml` loadable | LOAD step |

---

## When Should It NOT Be Used?

Do **not** use the orchestrator as a substitute for atomic playbooks:

| Situation | Why not | Use instead |
|-----------|---------|-------------|
| Raw request unclassified | Orchestrator binds `workflow_id` from approved INT only | PB-intake-classify |
| User wants discovery research only | Domain work, not coordination | PB-discovery-research (WF-DISCOVERY slice) |
| User wants a PRD written | Plan-phase deliverable | PB-draft-prd |
| User wants code implemented | Implement-phase deliverable | PB-implement |
| User wants OS architecture audit | Meta scope | MS-architecture-review |
| Single-shot question with no `work_id` | No run state to own | Direct answer |
| Human has not decided at pending H-* gate | Orchestrator must hold (INV-03) | Human `record_gate` first |

### Challenge: “But the orchestrator could just do intake quickly”

**Rejected.** ORCH-N1 — classification is PB-intake-classify. The orchestrator may *invoke* intake; it must not *perform* intake logic or write INT content itself.

### Challenge: “Skip orchestrator for simple bug fix”

**Allowed only with human waiver** documented in WR. Default path for tracked work is ORCH-PROJECT so ORS and gate history stay complete. Ad-hoc playbook runs require `resume` reconcile.

---

## Single Responsibility

> **Own run state, phase progression, playbook selection, invocation envelopes, gate recording, and recovery — for one `work_id` per tick. Nothing else.**

The orchestrator succeeds on a tick when:

1. ORS invariants INV-01–06 hold (**CL-ORCH**)
2. At most one playbook invoked (or hold emitted)
3. Next playbook ∈ `routing-matrix.yaml` with entry criteria met
4. Handoff from completed playbook ingested and validated
5. `awaiting_human_gate` consistent with child playbook `exit_gate`
6. ORS persisted before tick returns

The orchestrator does **not** succeed when it produces INT, DISC, PRD, CODE, or other domain artifacts — those are child playbook outcomes indexed in WR.

---

## Responsibilities That Belong to Other Skills

Explicit boundaries — challenged and rejected from this skill:

| Temptation | Why it seems useful | Owner | Rejection rationale |
|------------|---------------------|-------|---------------------|
| Classify `work_type` / `workflow_id` | “Start workflow faster” | PB-intake-classify | Binding requires H-INTAKE-approved INT (ORCH-P2) |
| Write or revise DISC/PRD | “Fill gaps between steps” | Plan/Frame playbooks | Domain SSOT lives in artifacts, not ORS |
| Approve H-* gates | “Unblock the queue” | Human | ORCH-N3 — advisory model; human records decision |
| Modify routing-matrix or phases | “This project is special” | Workflow Owner + Architect | ORCH-N4 — OS maintainer only |
| Run two playbooks same tick | “Parallel speed” | — | ORCH-N5 — one mutating playbook per `work_id` |
| Override INT/DISC without rewind | “Skip re-intake ceremony” | Human + rewind rules | ORCH-N6 — `requires_re_intake` → Intake |
| Invoke `planned` skill silently | “Stub is good enough” | — | ORCH-S7 — block or explicit human ack |
| Use chat as progress record | “ORS is overhead” | — | ORCH-N9 — WR/ORS only |

---

## Challenged Scope Creep (Explicit Rejections)

### ❌ “Smart orchestrator” that auto-approves gates when tests pass

**Rejected.** CI and verify results inform humans; they do not replace H-VERIFY or other gates (**docs/GOVERNANCE.md**).

### ❌ Embedded work_type → workflow matrix in orchestrator prompt

**Rejected.** Routing SSOT is `routing-matrix.yaml` — playbooks reference by ID only (**docs/SSOT-HIERARCHY.md** dedup rule).

### ❌ Executable long-running orchestrator service (v1)

**Rejected for Foundation v1.** Spec-only coordinator: human-triggered `tick` / `record_gate` (**OD-02**). Service implementation is a future infrastructure concern.

### ❌ Copying playbook system prompts into ORS

**Rejected.** Prompts remain in child `09-system-prompt.md`; orchestrator passes invocation envelope only.

---

## Design SSOT vs Playbook Spec

| Layer | Path | Role |
|-------|------|------|
| **Normative design** | `workflows/project-orchestrator/DESIGN.md` | Authoritative on conflict |
| **Machine substrate** | `routing-matrix.yaml`, `gates.yaml`, `skill-dependency-graph.yaml`, `WF-*/phases.yaml` | ROUTE / PREFLIGHT inputs |
| **Playbook spec (this folder)** | `playbooks/project-orchestrator/01–11` | STD-SKILL-001 adapter deployment |
| **Checklist** | `checklists/orchestrator.md` (CL-ORCH) | Per-tick self-check |

This `01-purpose.md` operationalizes DESIGN §1 for skill-contract compliance. It does not replace DESIGN.

---

## Success Criteria (Purpose Level)

A run is well-orchestrated when a human can answer yes to:

| Question | |
|----------|--|
| Do I know which phase this `work_id` is in? | |
| Do I know which playbook ran last and which gate (if any) is pending? | |
| Can I resume tomorrow without re-explaining the workflow in chat? | |
| Were only legal playbooks invoked for this `workflow_id`? | |
| Is every gate decision recorded in WR/ORS, not only in chat? | |

---

## Workflow Context

| Field | Value |
|-------|-------|
| primary_workflow | All `WF-*` in INDEX (orchestrator selects per approved INT) |
| orchestrator_phase | Meta — spans Intake through Operate |
| exit_gate | `none` (orchestrator holds on child gates; does not own H-*) |
| checklist_id | CL-ORCH |
| produces | ORS (`TP-ORS`) |
| consumes | WR (`TP-WR`), child handoff packages, human gate decisions |

---

## Related Standards & Artifacts

| Ref | Relationship |
|-----|--------------|
| STD-SKILL-001 | Universal skill contract — this playbook inherits |
| STD-ARTIFACT-001 | WR and ORS shapes |
| STD-CTX-001 | T0–T3 envelope per tick |
| STD-MEM-001 | Chat ≠ SSOT; ORS persists |
| STD-WF-001 | Workflow phases and terminal gates |
| docs/GOVERNANCE.md | H-* gate semantics, waivers |
| TP-ORS | Orchestrator Run State template |
| TP-WR | Work Record — artifact index |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Full purpose per STD-SKILL-001 §4.1 — problem, boundaries, when/when not |
| 0.1.0 | 2026-06-18 | Initial stub purpose |