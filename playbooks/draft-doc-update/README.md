# PB-draft-doc-update

**Documentation Planner** — Plan-phase playbook producing the Documentation Update Plan (DOC-PLAN) for WF-DOCS.

| Field | Value |
|-------|-------|
| skill_id | `PB-draft-doc-update` |
| display_name | Documentation |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-DOC-UPDATE` |
| template | `templates/doc-plan/template.md` (TP-doc-plan) |
| path | `{AI_DEV_OS_HOME}/playbooks/draft-doc-update/` |

---

## Quick Reference

```text
Invoke  → approved INT (documentation) + work_id + project_root + AI_DEV_OS_HOME
          REVIEW / SEC-REVIEW / PERF-REVIEW linked (soft)
Produce → DOC-PLAN + updated Work Record + Validation + Handoff
Gate    → CL-DOC-UPDATE (agent) then H-PLAN (human)
Stop    → await H-PLAN; WF-DOCS terminal — human executes plan
```

## Workflows

`WF-DOCS` — Intake → H-INTAKE → Plan (this skill) → H-PLAN

## Quality-Chain Position

Authored **after** PB-perf-review per `LIFECYCLE.md`. Runtime entry requires **INT only**; PB-perf-review may recommend this skill for docs-only follow-up.

## Distinction

| Skill | Phase | Produces | Edits doc bodies? |
|-------|-------|----------|-------------------|
| PB-draft-doc-update | Plan | DOC-PLAN | No — plan only |
| Human post-H-PLAN | Execute | Updated `docs/**` | Yes |
| PB-prepare-release | Release | RELEASE | Release notes packaging |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & inventory rules |
| [06-quality.md](./06-quality.md) | ACs & CL-DOC-UPDATE map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (27 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | P0 resolution & promotion (88/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden DOC-PLAN + anti-patterns |
| [fixtures/](./fixtures/) | `wf-docs-alpha` test project (INT-only) |
| [test-runs/](./test-runs/) | Latest promotion gate record |