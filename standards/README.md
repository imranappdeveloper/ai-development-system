# Engineering Standards

Normative rules for the AI Development Operating System. All playbooks, workflows, and adapters **must** comply unless a documented waiver exists in a Work Record.

## Layers

| Layer | Path | Role |
|-------|------|------|
| **Contracts** | This directory (`SKILL`, `META`, `ARTIFACT`) | What skills MUST ship |
| **Engineering** | [engineering/](./engineering/) | How work is authored and validated |
| **Orchestrator** | `workflows/project-orchestrator/DESIGN.md` | When skills run |

## Contracts

| ID | Document | Status | Applies to |
|----|----------|--------|------------|
| STD-SKILL-001 | [SKILL-CONTRACT.md](./SKILL-CONTRACT.md) | active | Every playbook (`PB-*`) |
| STD-META-001 | [META-SKILL-CONTRACT.md](./META-SKILL-CONTRACT.md) | active | Meta skills (`MS-*`) |
| STD-ARTIFACT-001 | [ARTIFACT-CONTRACT.md](./ARTIFACT-CONTRACT.md) | active | WR, ORS, INT, cross-artifact shapes |
| STD-ORCH-001 | `../workflows/project-orchestrator/DESIGN.md` | design | ORCH-PROJECT |

## Engineering Standards

Full catalog: **[engineering/README.md](./engineering/README.md)** — 14 standards covering naming, documentation, markdown, prompts, context, memory, workflow, testing, code review, architecture, security, performance, logging, versioning.

| Domain | ID |
|--------|-----|
| Naming | STD-NAMING-001 |
| Documentation | STD-DOC-001 |
| Markdown | STD-MD-001 |
| Prompt design | STD-PROMPT-001 |
| Context loading | STD-CTX-001 |
| Memory | STD-MEM-001 |
| Workflow | STD-WF-001 |
| Testing | STD-TEST-001 |
| Code review | STD-REVIEW-001 |
| Architecture | STD-ARCH-001 |
| Security | STD-SEC-001 |
| Performance | STD-PERF-001 |
| Logging | STD-LOG-001 |
| Versioning | STD-VER-001 |

## Compliance

| Level | Meaning |
|-------|---------|
| **MUST** | Required — promotion blocked if missing |
| **SHOULD** | Recommended — document exception in `10-review.md` |
| **MAY** | Optional |

New skills: copy `playbooks/_contract-scaffold/` → `playbooks/<kebab-name>/` and fill per **STD-SKILL-001**. Author prompts per **STD-PROMPT-001**; do not duplicate standards in prompt bodies.