# PB-implement-frontend

**Implement Frontend** — Implement-phase lane playbook producing frontend CODE (components, pages, client UI).

| Field | Value |
|-------|-------|
| skill_id | `PB-implement-frontend` |
| display_name | Frontend Engineer |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-IMPLEMENT` (human) |
| checklist | `CL-IMPLEMENT-FRONTEND` |
| implement_lane | `frontend` |
| path | `{AI_DEV_OS_HOME}/playbooks/implement-frontend/` |

---

## Quick Reference

```text
Invoke  → ISS or ISS-* + work_id + project_root + AI_DEV_OS_HOME
          UIUX linked or uiux_gap / uiux_gap waiver (soft)
Require → Issue artifact; H-DECOMPOSE or H-PLAN (soft)
Produce → CODE at work/implement/frontend/{work_id}.md + updated WR + handoff
Gate    → CL-IMPLEMENT-FRONTEND (agent) then H-IMPLEMENT (human)
Stop    → await H-IMPLEMENT; recommend PB-verify only — NEVER deploy
```

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-FEATURE | New screens and components per UIUX |
| WF-ENHANCEMENT | Additive web UI changes |
| WF-REFACTOR | Breaking UI refactors per ISS |
| WF-SECURITY | Client-side auth hardening, XSS controls |
| WF-BUGFIX | Single ISS UI fix |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-IMPLEMENT, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-IMPLEMENT-FRONTEND map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (18 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (75/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden CODE + anti-patterns |
| [fixtures/](./fixtures/) | wf-feature-alpha with ISS + UIUX stub |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-implement-backend `test-runs/latest-gate.md` VERDICT PASS |