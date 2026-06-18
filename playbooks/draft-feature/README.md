# PB-draft-feature

**Draft Feature** — Plan-phase playbook producing a narrow-slice Feature Specification (FEAT).

| Field | Value |
|-------|-------|
| skill_id | `PB-draft-feature` |
| display_name | Feature Spec (narrow slice) |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-DRAFT` |
| template | `templates/feature/template.md` (narrow subset — see 04-io-contract) |
| path | `{AI_DEV_OS_HOME}/playbooks/draft-feature/` |
| alternative_to | `PB-draft-prd` |

---

## Quick Reference

```text
Invoke  → approved DISC + H-FRAME + work_id + project_root + AI_DEV_OS_HOME
Produce → FEAT at work/feature/{work_id}.md + updated WR + Validation + Handoff
Gate    → CL-DRAFT FEAT path (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend PB-decompose-issues only
```

## Workflows

`WF-FEATURE`, `WF-ENHANCEMENT` (narrow slice per feature-planner DM-01)

## Boundaries

- **No** architecture, API, or database detail
- **No** application code or pseudo-code
- **No** issue decomposition (ISS-*) — defer to PB-decompose-issues
- **No** self-approve H-PLAN

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-DRAFT map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | P0 resolution & promotion |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden FEAT + anti-patterns |
| [fixtures/](./fixtures/) | `wf-feat-narrow` test project |

## Related

- Umbrella routing: `playbooks/feature-planner/`
- Prerequisite: `PB-discovery-research` (DISC, H-FRAME)
- Next candidate: `PB-decompose-issues`