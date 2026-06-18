# PB-onboard-project

**Onboard Project** — Frame-phase playbook producing the Onboarding artifact (ONBOARD) for existing projects.

| Field | Value |
|-------|-------|
| skill_id | `PB-onboard-project` |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-FRAME` (human) |
| path | `{AI_DEV_OS_HOME}/playbooks/onboard-project/` |

---

## Quick Reference

```text
Invoke  → approved INT + CONTEXT.md + work_id + project_root + AI_DEV_OS_HOME
Produce → ONBOARD + updated Work Record + Validation + Handoff
Gate    → CL-ONBOAR (agent) then H-FRAME (human)
Stop    → await H-FRAME; recommend next playbook only
```

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-FRAME, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-ONBOAR map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | P0 resolution status |
| [11-test-plan.md](./11-test-plan.md) | Promotion gate |