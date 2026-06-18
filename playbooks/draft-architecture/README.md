# PB-draft-architecture

**Draft Architecture** — Plan-phase playbook producing the Architecture artifact (ARCH).

| Field | Value |
|-------|-------|
| skill_id | `PB-draft-architecture` |
| display_name | Architecture |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-ARCH` |
| template | `templates/architecture/template.md` (TP-architecture) |
| path | `{AI_DEV_OS_HOME}/playbooks/draft-architecture/` |

---

## Quick Reference

```text
Invoke  → approved PRD + work_id + project_root + AI_DEV_OS_HOME
Require → PB-draft-prd skill; PRD artifact; H-PLAN on PRD (or waiver)
Produce → ARCH + updated Work Record + Validation + Handoff
Gate    → CL-ARCH (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend next playbook only
```

## Workflows

| workflow_id | architecture_type typical |
|-------------|---------------------------|
| WF-PROJECT-NEW | greenfield |
| WF-FEATURE | delta |
| WF-REFACTOR | delta |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-ARCH map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (23 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (74/100) |
| [11-test-plan.md](./11-test-plan.md) | Promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden ARCH + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha project workspace |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | 2026-06-18 |
| gate evidence | `11-test-plan.md` §Promotion Gate |