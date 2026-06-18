# PB-test-generate

**Test Generator** — Verify-phase playbook producing a **TEST-GEN** record (`test_phase: generate`) — writes test source files from TEST-PLAN; **never executes tests or approves H-VERIFY**.

| Field | Value |
|-------|-------|
| skill_id | `PB-test-generate` |
| display_name | Test Generator |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `none` |
| checklist | `CL-TEST-GEN` |
| path | `{AI_DEV_OS_HOME}/playbooks/test-generate/` |

---

## Quick Reference

```text
Invoke  → TEST-PLAN + CODE (soft) + work_id + project_root + AI_DEV_OS_HOME
Require → PB-test-plan gate PASS (prerequisite)
Produce → TEST-GEN at work/testing/generate/{work_id}.md + test source files + updated WR + handoff
Gate    → CL-TEST-GEN (agent) — exit_gate none; never H-VERIFY approve
Stop    → await PB-verify / PB-review / human; NEVER execute suites or claim verification complete
```

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-FEATURE | Generate unit + contract tests from TEST-PLAN TC-* catalog |
| WF-ENHANCEMENT | Add regression tests for changed modules |
| WF-REFACTOR | Contract stability tests from plan |
| WF-SECURITY | Security-layer test stubs per plan |
| WF-BUGFIX | Reproduction + fix verification test from single ISS plan |
| WF-PERF | Perf test scaffolding (no benchmark execution) |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, recovery, routing |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-TEST-GEN map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden TEST-GEN + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha with TEST-PLAN + CODE stub |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-test-plan `test-runs/latest-gate.md` VERDICT PASS |