# PB-bootstrap-project

**Project Bootstrap** — Plan-phase playbook producing SCAFFOLD artifacts.

| Field | Value |
|-------|-------|
| skill_id | `PB-bootstrap-project` |
| display_name | Project Bootstrap |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-BOOTST` |
| path | `{AI_DEV_OS_HOME}/playbooks/bootstrap-project/` |

---

## Quick Reference

```text
Invoke  → approved PRD + work_id + project_root + AI_DEV_OS_HOME
Produce → SCAFFOLD at work/scaffold/{work_id}.md
Gate    → CL-BOOTST (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend PB-onboard-project
```

## Workflows

| workflow_id | Notes |
|-------------|-------|
| WF-PROJECT-NEW | Primary path |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget |
| [06-quality.md](./06-quality.md) | ACs & checklist map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden + anti-patterns |
| [fixtures/](./fixtures/) | wf-project-new project workspace |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| promoted | active |
| gate evidence | `test-runs/latest-gate.md` VERDICT PASS |
| prerequisite | PB-draft-prd `test-runs/latest-gate.md` VERDICT PASS |
