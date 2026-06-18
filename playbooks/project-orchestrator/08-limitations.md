# PB-project-orchestrator — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 08-limitations |

---

## Honest boundaries

| Limitation | Implication |
|------------|-------------|
| **Spec-only coordinator in v1** | No executable service daemon — human or adapter triggers each `tick` |
| **Human-triggered ticks only (OD-03)** | No autonomous background orchestration loop |
| **Advisory gates** | No CI enforcement of H-* — governance via durable records + human discipline |
| **Cannot invoke `planned` playbooks** | Domain work blocked until skill promoted or human ack (ORCH-S7) |
| **Cannot auto-approve H-* gates** | `record_gate` is human-channel only |
| **Does not replace playbook prompts** | Child `09-system-prompt.md` owns domain behavior |
| **Chat is never SSOT** | Session loss requires WR + ORS on disk |
| **One mutating playbook per tick** | No parallel implement + verify on same `work_id` |
| **No domain artifact authoring** | Never writes INT, DISC, PRD, code, or test results |
| **Routing SSOT external** | Edits to sequences require Maintainer update to `phases.yaml` / graph — not inline in tick |
| **exit_gate: none** | Orchestrator has no H-* of its own — humans gate via child playbooks |

---

## NEVER list (agent)

The orchestrator agent MUST NOT:

1. Auto-chain playbooks without human `tick` between each
2. Approve or waive human gates without human `record_gate`
3. Skip ORS persistence after a tick
4. Classify intake, run discovery, draft PRD, implement, or verify
5. Delete artifacts on `rewind` — phase reset only
6. Override approved INT `workflow_id` without re-intake
7. Invoke two mutating playbooks in one tick
8. Use chat history as substitute for WR/ORS

Detail in [09-system-prompt.md](./09-system-prompt.md) and [02-responsibilities.md](./02-responsibilities.md) N-table.

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Expanded limitations + NEVER list |
| 0.1.0 | 2026-06-18 | Initial bullet list |