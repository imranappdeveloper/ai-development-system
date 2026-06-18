# PB-project-orchestrator — Context

| Field | Value |
|-------|-------|
| skill_id | PB-project-orchestrator |
| orchestrator_id | ORCH-PROJECT |
| version | 0.2.0 |
| status | active |
| document | 05-context |
| normative_ref | `workflows/project-orchestrator/DESIGN.md` §8; **STD-CTX-001** |

---

## Principles

1. **Orchestrator loads minimal context** — routing + state only (~5% session budget).
2. **Playbooks own deep context** — per playbook `05-context.md`.
3. **No duplicate loads** — ORS stores `context_digest_refs[]` from child handoffs.
4. **Project isolation** — `project_root` boundary enforced; no cross-project reads.
5. **Chat is never SSOT** — WR + ORS + artifacts only (**STD-MEM-001**).

---

## Context tiers (per tick)

| Tier | Contents | Budget | Load when |
|------|----------|--------|-----------|
| **T0** | `command`, `work_id`, ORS state block, `current_phase`, `awaiting_human_gate` | Fixed small | Every command |
| **T1** | WR frontmatter, `orchestrator` block, last `playbook_history[-1]` summary | ≤5% | `resume`, `tick`, `record_gate` |
| **T2** | Artifact paths + digests from WR `artifacts[]` — **not** full PRD/DISC bodies | ≤8% | PREFLIGHT + INVOKE |
| **T3** | Delegated to invoked playbook | Remainder | INVOKE only — via envelope `artifact_refs` |

### Tier degradation (ORCH-S6)

When `token_budget_remaining` insufficient:

1. Drop T2 digests → paths only
2. Drop T1 handoff summary → frontmatter only
3. Hold with `hold_reason: token_budget` — do not invoke playbook with incomplete preflight

---

## Load list (INIT / LOAD step)

| # | Resource | Path | Tier |
|---|----------|------|------|
| L1 | Work Record | `{project_root}/work/{work_id}.md` | T1 |
| L2 | ORS | `{project_root}/work/orchestrator/{work_id}.ors.md` | T0 |
| L3 | INDEX | `{ai_dev_os_home}/INDEX.md` | T0 |
| L4 | Routing matrix | `{ai_dev_os_home}/workflows/project-orchestrator/routing-matrix.yaml` | T0 |
| L5 | Gate registry | `{ai_dev_os_home}/workflows/project-orchestrator/gates.yaml` | T0 |
| L6 | Phase DAG | `{ai_dev_os_home}/workflows/{workflow_id}/phases.yaml` | T0 |
| L7 | Integrations | `{ai_dev_os_home}/workflows/project-orchestrator/integrations.md` | T0 |
| L8 | Linked artifacts | WR `artifacts[]` paths | T2 |
| L9 | CONTEXT.md | `{project_root}/CONTEXT.md` module map | T1 (slice only) |

---

## Forbidden paths and content

| Forbidden | Reason |
|-----------|--------|
| `src/**`, `node_modules/**`, `.git/**` | Domain survey belongs in child playbooks |
| Full PRD / DISC / ARCH bodies in orchestrator prompt | Token waste; SRP violation |
| Secrets, credentials, `.env` | Security |
| Unrelated `work_id` artifacts | Project isolation |
| Vendor chat history as classification input | SSOT violation |
| Playbook `09-system-prompt.md` bodies | Adapter loads per invoke |

---

## Envelope assembly (CONTEXT step)

Before INVOKE, orchestrator builds ORCH-OUT-02 with:

| Check | Rule |
|-------|------|
| C1 | `artifact_refs` includes all types required by child `04-io-contract.md` |
| C2 | Digests computed when file exists; `persist: pending` flagged when not |
| C3 | `human_gate_context` populated after `revise` decision |
| C4 | `mode` = `revise` when resuming from gate revise loop |
| C5 | `token_budget_remaining` passed through for child budget split |
| C6 | No fields beyond child invoke template + `orchestrator_ref` |

---

## Memory and session continuity

| Concern | SSOT | Orchestrator writes |
|---------|------|---------------------|
| Run control | ORS | yes |
| Work metadata | WR | orchestrator fields + artifact index only |
| Gate decisions | WR `approvals[]` + ORS `gate_history` | append on `record_gate` |
| Domain content | INT, DISC, PRD, … | never |

On `resume`, orchestrator reads ORS + WR only — does not reconstruct state from chat.

### Standalone playbook reconciliation (EC-ORCH-11)

When WR shows artifacts from a playbook run outside ORCH-PROJECT:

1. Compare WR `artifacts[]` to ORS `playbook_history`
2. Append missing entries to `playbook_history` with `source: reconcile`
3. Set `current_phase` from phases.yaml given last completed playbook
4. Hold if ambiguous — human confirms before next `tick`

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 0.2.0 | 2026-06-18 | Full tiers, load list, forbidden paths, envelope checks |
| 0.1.0 | 2026-06-18 | Stub budget table |