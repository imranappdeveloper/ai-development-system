# PB-decompose-issues

**Decompose Issues** — Decompose-phase playbook producing ISS-* implementable units from an approved PRD.

| Field | Value |
|-------|-------|
| skill_id | `PB-decompose-issues` |
| display_name | Issue Decomposition |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-DECOMPOSE` (human) |
| checklist | `CL-DECOMP` |
| path | `{AI_DEV_OS_HOME}/playbooks/decompose-issues/` |

---

## Quick Reference

```text
Invoke  → approved PRD + work_id + project_root + AI_DEV_OS_HOME
          ARCH / API / DB / UIUX linked or gap documented (soft)
Require → PRD artifact; H-PLAN on PRD
Produce → ISS-* at work/issues/{issue_id}.md + updated Work Record + Handoff
Gate    → CL-DECOMP (agent) then H-DECOMPOSE (human)
Stop    → await H-DECOMPOSE; recommend implement lane child only
```

## Workflows

| workflow_id | decompose_scope typical |
|-------------|-------------------------|
| WF-FEATURE | multi_lane \| full_stack |
| WF-ENHANCEMENT | single_lane \| multi_lane |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-DECOMPOSE, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-DECOMP map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (18 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (74/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden decomposition + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha project workspace |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | active |
| gate evidence | `test-runs/latest-gate.md` VERDICT PASS |
| prerequisite | PB-draft-prd `test-runs/latest-gate.md` VERDICT PASS |