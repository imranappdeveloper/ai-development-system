# PB-draft-prd

**Draft PRD** — Plan-phase playbook producing the Product Requirements Document (PRD).

| Field | Value |
|-------|-------|
| skill_id | `PB-draft-prd` |
| display_name | PRD |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-PRD` |
| template | `templates/prd/template.md` (TP-prd) |
| path | `{AI_DEV_OS_HOME}/playbooks/draft-prd/` |

---

## Quick Reference

```text
Invoke  → approved INT + work_id + project_root + AI_DEV_OS_HOME
          DISC linked or discovery_gap waiver (soft)
Produce → PRD + updated Work Record + Validation + Handoff
Gate    → CL-PRD (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend next playbook only
```

## Workflows

`WF-PROJECT-NEW`, `WF-FEATURE`, `WF-ENHANCEMENT`, `WF-PRD`

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-PRD map |
| [07-edge-cases.md](./07-edge-cases.md) | P0/P1 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | P0 resolution & promotion |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden PRD + anti-patterns |
| [fixtures/](./fixtures/) | `wf-feature-alpha` test project |