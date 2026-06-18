# SSOT Hierarchy

| Field | Value |
|-------|-------|
| document_id | DOC-SSOT-001 |
| version | 1.0.0 |
| status | active |
| updated | 2026-06-18 |

---

## Ownership Table

| Concern | SSOT | Owner | Consumers |
|---------|------|-------|-----------|
| Skill contract | `standards/SKILL-CONTRACT.md` | Platform Architect | All `PB-*` |
| Meta contract | `standards/META-SKILL-CONTRACT.md` | Platform Architect | All `MS-*` |
| Engineering standards | `standards/engineering/STD-*.md` | Per-standard owner | OS + project authoring |
| Engineering catalog | `standards/engineering/README.md` | Platform Architect | Standard index |
| Artifact types & paths | `ARTIFACT-REGISTRY.yaml` | Platform Architect | Playbooks, templates, orchestrator |
| Artifact shapes (WR, ORS) | `standards/ARTIFACT-CONTRACT.md` | Platform Architect | All skills producing WR/ORS |
| Human gates | `workflows/project-orchestrator/gates.yaml` | Platform Architect | Orchestrator, playbooks |
| Skill routing | `workflows/project-orchestrator/routing-matrix.yaml` | Maintainer | Orchestrator; playbooks reference by ID |
| Skill dependencies | `workflows/project-orchestrator/skill-dependency-graph.yaml` | Maintainer | Planning; routing-matrix derived from this |
| Workflow specifications | `workflows/specs/WF-*.yaml` | Workflow Owner | Intake, orchestrator, review |
| Workflow registry | `workflows/WORKFLOW-REGISTRY.yaml` | Workflow Owner | INDEX, orchestrator |
| Workflow phases | `workflows/{WF-*}/phases.yaml` | Workflow Owner | Orchestrator |
| Per-skill machine record | `playbooks/{name}/registry.yaml` | Skill Author | Promotion, INDEX |
| Intake enums + work_type routing | `playbooks/intake-classify/registry.yaml` | Intake Author | PB-intake-classify prompt (reference only) |
| Per-skill validation | `checklists/{short}.md` | Skill Author | Agent self-check |
| Document shape | `templates/{type}/template.md` | Template Owner | Playbook OUT-* |
| Orchestrator behaviour | `workflows/project-orchestrator/DESIGN.md` | Platform Architect | ORCH playbook operationalizes |
| OS catalog | `INDEX.md` | Maintainer | All agents |
| Foundation manifest | `FOUNDATION.md` | Principal Architect | Freeze / version |
| Repository governance | `docs/REPOSITORY-GOVERNANCE.md` | Principal Architect | Contributors, MS-repository-review |
| Contribution process | `docs/CONTRIBUTING.md` | Maintainer | Authors landing changes |
| Ownership registry | `docs/OWNERSHIP.yaml` | Maintainer | Path owner lookup |

---

## Dedup Rules

1. **Routing:** `routing-matrix.yaml` is the only orchestrator routing SSOT. Playbooks MUST NOT embed work_type → workflow matrices; use `registry.yaml` or reference routing-matrix by ID.
2. **Checklists:** `checklists/<short>.md` is SSOT for CL-* items; `03-workflow` and `09-system-prompt` reference — do not duplicate verbatim in three places.
3. **Graph vs matrix:** `skill-dependency-graph.yaml` is authoritative for dependencies; `routing-matrix.yaml` is generated/aligned from it — not hand-authored divergent copies.
4. **DESIGN vs playbook:** On conflict, `DESIGN.md` wins; `playbooks/project-orchestrator/` operationalizes for adapter deployment.

---

## Prohibited SSOT Locations

| Path | Reason |
|------|--------|
| `skills/*/01-purpose.md` | Adapters only |
| `prompts/` as sole spec | Derived from `09-system-prompt.md` |
| Project repo `playbooks/` | OS is global |
| Chat history | Never durable SSOT |