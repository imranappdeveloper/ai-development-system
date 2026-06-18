# PB-prepare-release

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| display_name | Release Manager |
| status | draft |
| phase | Ship |
| exit_gate | H-SHIP |
| produces | REL at `work/release/{work_id}.md` |

---

## Summary

Structured release preparation playbook producing **REL** per `templates/release/template.md` from **CODE** (required) and **TEST-RPT** (soft). Release-prep only — no deploy execution. **CL-RELEASE** 10 checks gate handoff.

**Quality chain:** **Last skill** — after PB-test-plan → PB-test-generate → PB-review → PB-security-review → PB-perf-review → PB-draft-doc-update → PB-verify.

**WF-RELEASE:** H-VERIFY and TEST-RPT waived per `gates.yaml` — document in REL §8.1.

---

## Document Index

| Doc | Purpose |
|-----|---------|
| [01-purpose.md](./01-purpose.md) | Problem, boundaries, when to use |
| [02-responsibilities.md](./02-responsibilities.md) | P/S/O/N responsibilities |
| [03-workflow.md](./03-workflow.md) | 11-step workflow + H-SHIP gate |
| [04-io-contract.md](./04-io-contract.md) | IN/OUT contract; REL path |
| [05-context.md](./05-context.md) | Context layers and budget |
| [06-quality.md](./06-quality.md) | ACs and CL-RELEASE map |
| [07-edge-cases.md](./07-edge-cases.md) | 30 EC-* scenarios |
| [08-limitations.md](./08-limitations.md) | Cannot do; human required |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (79/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

---

## Artifacts

| Type | Path |
|------|------|
| Output | `{project_root}/work/release/{work_id}.md` |
| Template | `templates/release/template.md` |
| Checklist | `checklists/release.md` |
| Examples | `examples/golden/`, `examples/anti-patterns/` |
| Fixtures | `fixtures/projects/wf-feature-alpha/`, `wf-release-alpha/` |

---

## Orchestrator Integration

| Field | Value |
|-------|-------|
| Phase | Ship |
| Requires gates | H-VERIFY (soft for WF-RELEASE) |
| Requires artifacts | CODE, TEST-RPT (soft) |
| Produces | REL |
| Exit gate | H-SHIP |
| Next | PB-maintenance-triage (post H-SHIP, recommend only) |