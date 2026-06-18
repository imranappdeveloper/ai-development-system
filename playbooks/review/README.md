# PB-review — Code Reviewer

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| display_name | Code Reviewer |
| status | draft |
| phase | Verify |
| exit_gate | H-VERIFY (soft, optional) |
| produces | REVIEW at `work/review/{work_id}.md` |

---

## Summary

Structured code review playbook producing **REVIEW** per `templates/review/template.md` from **CODE** and upstream ISS/PRD artifacts. Review-only — no code changes, no test execution. **CL-REVIEW** 10 checks gate handoff.

**Quality chain:** Requires **PB-test-plan** PASS (TEST-PLAN). **PB-test-generate** will gate invoke when authored.

---

## Document Index

| Doc | Purpose |
|-----|---------|
| [01-purpose.md](./01-purpose.md) | Problem, boundaries, when to use |
| [02-responsibilities.md](./02-responsibilities.md) | P/S/O/N responsibilities |
| [03-workflow.md](./03-workflow.md) | 10-step workflow + H-VERIFY soft gate |
| [04-io-contract.md](./04-io-contract.md) | IN/OUT contract; REVIEW path |
| [05-context.md](./05-context.md) | Context layers and budget |
| [06-quality.md](./06-quality.md) | ACs and CL-REVIEW map |
| [07-edge-cases.md](./07-edge-cases.md) | 28 EC-* scenarios |
| [08-limitations.md](./08-limitations.md) | Cannot do; human required |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (75/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

---

## Artifacts

| Type | Path |
|------|------|
| Output | `{project_root}/work/review/{work_id}.md` |
| Template | `templates/review/template.md` |
| Checklist | `checklists/review.md` |
| Examples | `examples/golden/`, `examples/anti-patterns/` |
| Fixtures | `fixtures/projects/wf-feature-alpha/` |