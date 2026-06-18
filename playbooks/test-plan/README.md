# PB-test-plan

**Test Planner** — Verify-phase playbook producing a **TEST-PLAN** (`test_phase: plan`) — strategy and case design only; **never executes tests**.

| Field | Value |
|-------|-------|
| skill_id | `PB-test-plan` |
| display_name | Test Planner |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-VERIFY` (soft — plan sub-artifact) |
| checklist | `CL-TEST-PLAN` |
| path | `{AI_DEV_OS_HOME}/playbooks/test-plan/` |

---

## Quick Reference

```text
Invoke  → CODE (soft) + work_id + project_root + AI_DEV_OS_HOME
          PRD / ISS (soft) for AC grounding
Require → H-IMPLEMENT approved (soft); implement lane CODE when present
Produce → TEST-PLAN at work/testing/plan/{work_id}.md (test_phase: plan) + updated WR + handoff
Gate    → CL-TEST-PLAN (agent) then plan-only handoff to PB-test-generate — H-VERIFY soft pending
Stop    → await PB-test-generate / human; NEVER execute tests or populate execution evidence
```

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-FEATURE | Full AC mapping from PRD + ISS-* + CODE |
| WF-ENHANCEMENT | Regression scope for additive changes |
| WF-REFACTOR | Regression + contract stability plan |
| WF-SECURITY | Security test layer in strategy |
| WF-BUGFIX | Single ISS reproduction + fix verification plan |
| WF-PERF | Performance scenario planning (no benchmark run) |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-VERIFY soft, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-TEST-PLAN map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (18 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (74/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden TEST-PLAN + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha with CODE stub |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-implement-devops `test-runs/latest-gate.md` VERDICT PASS |