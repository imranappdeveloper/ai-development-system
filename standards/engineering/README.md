# Engineering Standards Layer

Normative engineering rules for the AI Dev OS and projects it operates on. These are **standards, not prompts** — playbooks reference them; adapters do not replace them.

## Layer Position

```text
Contracts (skill, meta, artifact)  →  what skills MUST ship
Engineering standards (this layer) →  how all work is authored and validated
Workflow / orchestrator            →  when skills run
Playbooks                          →  who does the work
```

## Catalog

| ID | Standard | Owner | Primary concern |
|----|----------|-------|-----------------|
| STD-NAMING-001 | [Naming](./STD-NAMING-001.md) | Platform Architect | Identifiers, paths, enums |
| STD-DOC-001 | [Documentation](./STD-DOC-001.md) | Platform Architect | Doc types, ownership, lifecycle |
| STD-MD-001 | [Markdown](./STD-MD-001.md) | Platform Architect | Markdown syntax and structure |
| STD-PROMPT-001 | [Prompt Design](./STD-PROMPT-001.md) | Prompt Architect | Deployable prompt structure |
| STD-CTX-001 | [Context Loading](./STD-CTX-001.md) | Platform Architect | T0–T3 tiers and budgets |
| STD-MEM-001 | [Memory](./STD-MEM-001.md) | Platform Architect | Persistence and session continuity |
| STD-WF-001 | [Workflow](./STD-WF-001.md) | Workflow Owner | WF-* and phase DAG authoring |
| STD-TEST-001 | [Testing](./STD-TEST-001.md) | Quality Lead | Fixtures, goldens, promotion tests |
| STD-REVIEW-001 | [Code Review](./STD-REVIEW-001.md) | Engineering Lead | Review of code artifacts |
| STD-ARCH-001 | [Architecture](./STD-ARCH-001.md) | Principal Architect | Layering and boundaries |
| STD-SEC-001 | [Security](./STD-SEC-001.md) | Security Lead | Secrets, PII, safe handling |
| STD-PERF-001 | [Performance](./STD-PERF-001.md) | Platform Architect | Token and load efficiency |
| STD-LOG-001 | [Logging](./STD-LOG-001.md) | Platform Architect | Audit trails and run logs |
| STD-VER-001 | [Versioning](./STD-VER-001.md) | Maintainer | Semver and traceability |

## Contracts (separate — not duplicated here)

| ID | Path | Scope |
|----|------|-------|
| STD-SKILL-001 | `../SKILL-CONTRACT.md` | Playbook folder, I/O, promotion |
| STD-META-001 | `../META-SKILL-CONTRACT.md` | Meta skills |
| STD-ARTIFACT-001 | `../ARTIFACT-CONTRACT.md` | WR, ORS, INT shapes |

## Compliance

| Level | Meaning |
|-------|---------|
| **MUST** | Required for `active` promotion or merge |
| **SHOULD** | Default; waiver in WR or `10-review.md` |
| **MAY** | Optional |

## Review

All engineering standards: **quarterly** review by owner unless noted in the standard.