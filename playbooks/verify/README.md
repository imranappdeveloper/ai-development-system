# PB-verify

**Test Executor / Verify** — Verify-phase playbook executing test suites and producing **TEST-RPT** (`test_phase: evidence`) — documents execution evidence only; **never approves H-VERIFY**.

| Field | Value |
|-------|-------|
| skill_id | `PB-verify` |
| display_name | Test Executor / Verify |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-VERIFY` (soft — evidence sub-artifact) |
| checklist | `CL-VERIFY` |
| path | `{AI_DEV_OS_HOME}/playbooks/verify/` |

---

## Quick Reference

```text
Invoke  → TEST-PLAN + TEST-GEN (soft) + work_id + project_root + AI_DEV_OS_HOME
          CODE (soft) when implementation present
Require → PB-test-generate gate PASS; H-IMPLEMENT approved (soft)
Produce → TEST-RPT at work/testing/{work_id}.md (test_phase: evidence) + updated WR + handoff
Gate    → CL-VERIFY (agent) then H-VERIFY decision: pending — human approves evidence
Stop    → await human H-VERIFY; NEVER approve gate or auto-ship
```

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-FEATURE | Full suite per TEST-PLAN layers + TEST-GEN catalog |
| WF-ENHANCEMENT | Regression + new TC-* execution |
| WF-REFACTOR | Regression stability evidence |
| WF-SECURITY | Security test layer execution |
| WF-BUGFIX | Single ISS reproduction + fix verification |
| WF-PERF | Performance scenario execution when planned |
| WF-TESTING | Dedicated verification workflow |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-VERIFY evidence, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-VERIFY map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (31 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (76/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden TEST-RPT + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha with TEST-PLAN + TEST-GEN + CODE stubs |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | active (2026-06-18) |
| gate evidence | `test-runs/latest-gate.md` VERDICT PASS |
| prerequisite | PB-test-generate `test-runs/latest-gate.md` VERDICT PASS |