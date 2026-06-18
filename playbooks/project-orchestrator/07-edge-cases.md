# PB-project-orchestrator — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 07-edge-cases |

---

## Edge case catalog

| ID | Tier | Trigger | Expected behavior | Human? |
|----|------|---------|-------------------|--------|
| EC-ORCH-01 | P0 | Second `start` same `work_id` | Resume prompt; no duplicate ORS | no |
| EC-ORCH-02 | P0 | `awaiting_human_gate` set | Emit ORCH-OUT-04; no playbook invoke | no |
| EC-ORCH-03 | P0 | Next playbook `status: planned` | Block invoke; hold with ack option (ORCH-S7) | yes |
| EC-ORCH-04 | P0 | Handoff missing required OUT-* | E-CONTRACT; retry once; then escalate | maybe |
| EC-ORCH-05 | P0 | DISC `alignment: requires_re_intake` | Rewind `current_phase` → Intake; clear gate | no |
| EC-ORCH-06 | P0 | Gate `waive` without `waiver_reason` | Reject `record_gate`; hold | yes |
| EC-ORCH-07 | P0 | Duplicate identical `record_gate` | No-op append; idempotent | no |
| EC-ORCH-08 | P0 | WR artifact path missing | Flag `persist: pending`; hold or retry | maybe |
| EC-ORCH-09 | P0 | routing-matrix no legal next | Human hold with `next_candidates` options | yes |
| EC-ORCH-10 | P0 | `parent_run_id` depth > 2 | Block batch fan-out | yes |
| EC-ORCH-11 | P0 | Standalone playbook + `resume` | Reconcile ORS from WR; hold if ambiguous | yes |
| EC-ORCH-12 | P0 | `workflow_id` drift from INT | Block advance unless human `rewind` + re-intake | yes |
| EC-ORCH-13 | P0 | Parallel mutating playbooks requested | Forbidden — INV-01; reject second invoke | no |
| EC-ORCH-14 | P0 | E-PLAYBOOK retries exhausted | Escalation ORCH-OUT-05; `recovering` | yes |
| EC-ORCH-15 | P1 | Token budget exceeded | Degrade context tier; hold if preflight incomplete | no |
| EC-ORCH-16 | P1 | Stale `resume_token` checksum | Hold; require human confirm reload | yes |
| EC-ORCH-17 | P1 | Child recommends skill ∉ routing-matrix | Surface as advisory; ROUTE from matrix only | no |
| EC-ORCH-18 | P1 | H-* `revise` at gate | Rewind to phase entry playbook; `mode: revise` | no |
| EC-ORCH-19 | P1 | H-* `reject` at gate | `run_status: aborted` or hold per workflow | yes |
| EC-ORCH-20 | P2 | Long idle `resume` | ORCH-O2 summary; no domain work | no |

---

## Recovery mapping

| Error class | First action | Max retries | Escalate |
|-------------|--------------|-------------|----------|
| E-STATE | Halt tick; CL-ORCH fail details | 0 | ORCH-OUT-05 |
| E-CONTRACT | Re-invoke child once | 1 | ORCH-OUT-05 |
| E-PREFLIGHT | Hold ORCH-OUT-04 | 0 | human ack |
| E-PLAYBOOK | `recovering`; categorized retry | 3 | ORCH-OUT-05 |
| E-GATE | Reject invalid `record_gate` | 0 | hold |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | 20 EC-* with tiers; recovery mapping |
| 0.1.0 | 2026-06-18 | 15 P0 edge cases |