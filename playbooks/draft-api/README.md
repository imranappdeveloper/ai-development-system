# PB-draft-api

**Draft API** — Plan-phase optional playbook producing the API Specification artifact (API).

| Field | Value |
|-------|-------|
| skill_id | `PB-draft-api` |
| display_name | API |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-API` |
| template | `templates/api/template.md` (TP-api) |
| path | `{AI_DEV_OS_HOME}/playbooks/draft-api/` |

---

## Quick Reference

```text
Invoke  → approved ARCH + work_id + project_root + AI_DEV_OS_HOME
          PRD + DB linked or prd_gap / db_gap waiver (soft)
Require → ARCH artifact; H-PLAN on ARCH (or waiver)
Produce → API + updated Work Record + Validation + Handoff
Gate    → CL-API (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend next playbook only
```

## Workflows

| workflow_id | change_type typical |
|-------------|---------------------|
| WF-FEATURE | new |
| WF-ENHANCEMENT | additive |
| WF-REFACTOR | breaking \| additive |
| WF-SECURITY | additive \| breaking |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-API map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (18 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (74/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden API + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha project workspace |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-draft-database `test-runs/latest-gate.md` VERDICT PASS |