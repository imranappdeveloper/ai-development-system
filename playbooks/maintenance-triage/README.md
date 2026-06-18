# PB-maintenance-triage

**Maintenance Triage** — Operate-phase playbook producing the Maintenance artifact (MAINT).

| Field | Value |
|-------|-------|
| skill_id | `PB-maintenance-triage` |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-OPERATE` (human) |
| path | `{AI_DEV_OS_HOME}/playbooks/maintenance-triage/` |

---

## Quick Reference

```text
Invoke  → approved INT + work_id + project_root + AI_DEV_OS_HOME
Produce → MAINT + updated Work Record + Validation + Handoff
Gate    → CL-MAINT (agent) then H-OPERATE (human)
Stop    → await H-OPERATE; child work_ids as proposals only
```

## Workflows

| workflow_id | When |
|-------------|------|
| WF-MAINTENANCE | Scheduled / reactive / hygiene operate cycles |
| WF-RELEASE | Post H-SHIP operate triage (REL soft-required) |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-OPERATE, WF-RELEASE path |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-MAINT map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | P0 resolution status |
| [11-test-plan.md](./11-test-plan.md) | Promotion gate |