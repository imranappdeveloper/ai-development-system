# AI Development OS — Catalog Index

Machine- and human-readable registry for workflows, templates, playbooks, and checklists.

| Field | Value |
|-------|-------|
| platform | **AI Development OS** |
| version | **1.0.0** |
| status | **frozen** |
| freeze_date | 2026-06-18 |
| updated | 2026-06-18 |
| spec_sha | `14d731c15af6532e` |
| engineering_standards | 14 active |
| foundation | frozen |
| active_skills | 32 |
| release_bundle | `release/v1.0/` |

---

## Foundation

| document_id | Path | Purpose |
|-------------|------|---------|
| FOUNDATION | `FOUNDATION.md` | Version manifest, freeze criteria |
| RELEASE-v1.0 | `release/v1.0/` | Frozen release bundle (manifest, registries, reports) |
| ARTIFACT-REGISTRY | `ARTIFACT-REGISTRY.yaml` | Artifact types, paths, producers |

---

## Documentation

| document_id | Path | Purpose |
|-------------|------|---------|
| DOC-KICKOFF-001 | `docs/PROJECT-KICKOFF.md` | **Start here** — grill-first kickoff (users) |
| SCR-NEW-PROJECT | `scripts/new-project.sh` | **Create project** — scaffold + `start` command |
| SCR-INSTALL-CLI | `scripts/install-cli.sh` | **Install `ai-new`** — symlink + shell alias (one-time) |
| DOC-START-001 | `docs/GETTING-STARTED.md` | OS install + agent gate reference |
| DOC-BUGFIX-001 | `docs/BUG-FIX.md` | **Bug fix** — report once, `/triage` + `/diagnose` + 3 approvals |
| DOC-OS-FOOTER-001 | `docs/OS-STATUS-FOOTER.md` | **Compliance footer** — required on every agent response |
| DOC-ARCH-001 | `docs/ARCHITECTURE.md` | Clean Architecture layers |
| DOC-SSOT-001 | `docs/SSOT-HIERARCHY.md` | SSOT ownership |
| DOC-GOV-001 | `docs/GOVERNANCE.md` | Gates, waivers, promotion |
| DOC-REPO-GOV-001 | `docs/REPOSITORY-GOVERNANCE.md` | Ownership, review, versioning, release |
| DOC-CONTRIB-001 | `docs/CONTRIBUTING.md` | Contribution guidelines |
| DOC-OWN-001 | `docs/OWNERSHIP.yaml` | Machine ownership registry |

---

## Workflows

Engine: `workflows/ENGINE.md` — Registry: `workflows/WORKFLOW-REGISTRY.yaml` — Specs: `workflows/specs/`

| workflow_id | Name | Class | Spec | Terminal |
|-------------|------|-------|------|----------|
| WF-PROJECT-NEW | New Project | end-to-end | `workflows/specs/WF-PROJECT-NEW.yaml` | H-PLAN |
| WF-PROJECT-EXISTING | Existing Project | end-to-end | `workflows/specs/WF-PROJECT-EXISTING.yaml` | H-FRAME |
| WF-DISCOVERY | Discovery / Research | slice | `workflows/specs/WF-DISCOVERY.yaml` | H-FRAME |
| WF-PRD | PRD | slice | `workflows/specs/WF-PRD.yaml` | H-PLAN |
| WF-FEATURE | Feature | end-to-end | `workflows/specs/WF-FEATURE.yaml` | H-SHIP |
| WF-ENHANCEMENT | Enhancement | end-to-end | `workflows/specs/WF-ENHANCEMENT.yaml` | H-PLAN |
| WF-BUGFIX | Bug Fix | end-to-end | `workflows/specs/WF-BUGFIX.yaml` | H-VERIFY |
| WF-REFACTOR | Refactor | end-to-end | `workflows/specs/WF-REFACTOR.yaml` | H-PLAN |
| WF-TESTING | Testing | slice | `workflows/specs/WF-TESTING.yaml` | H-VERIFY |
| WF-RELEASE | Release | operate | `workflows/specs/WF-RELEASE.yaml` | H-OPERATE |
| WF-MAINTENANCE | Maintenance | operate | `workflows/specs/WF-MAINTENANCE.yaml` | H-OPERATE |
| WF-SECURITY | Security | end-to-end | `workflows/specs/WF-SECURITY.yaml` | H-PLAN |
| WF-PERF | Performance | end-to-end | `workflows/specs/WF-PERF.yaml` | H-PLAN |
| WF-DOCS | Documentation | end-to-end | `workflows/specs/WF-DOCS.yaml` | H-PLAN |

---

## Meta Skills

| skill_id | Path | Status |
|----------|------|--------|
| MS-architecture-review | `playbooks/meta-architecture-review/` | draft |
| MS-dependency-analysis | `playbooks/meta-dependency-analysis/` | draft |
| MS-standards-review | `playbooks/meta-standards-review/` | draft |
| MS-workflow-review | `playbooks/meta-workflow-review/` | draft |
| MS-repository-review | `playbooks/meta-repository-review/` | draft |
| MS-quality-review | `playbooks/meta-quality-review/` | draft |

## Playbooks

| skill_id | Path | Status | Exit gate |
|----------|------|--------|-----------|
| PB-project-orchestrator | `playbooks/project-orchestrator/` | active | — |
| PB-intake-classify | `playbooks/intake-classify/` | active | H-INTAKE |
| PB-discovery-research | `playbooks/discovery-research/` | active | H-FRAME |
| PB-onboard-project | `playbooks/onboard-project/` | active | H-FRAME |
| PB-survey-codebase | `playbooks/survey-codebase/` | **active** | none |
| PB-draft-prd | `playbooks/draft-prd/` | **active** | H-PLAN |
| PB-draft-feature | `playbooks/draft-feature/` | **active** | H-PLAN |
| PB-feature-planner | `playbooks/feature-planner/` | **active** (umbrella) | — |
| PB-decompose-issues | `playbooks/decompose-issues/` | active | H-DECOMPOSE |
| PB-draft-issue | `playbooks/draft-issue/` | active | H-PLAN |
| PB-diagnose-bug | `playbooks/diagnose-bug/` | active | H-PLAN |
| PB-security-assess | `playbooks/security-assess/` | active | H-PLAN |
| PB-perf-baseline | `playbooks/perf-baseline/` | **active** | H-PLAN |
| PB-bootstrap-project | `playbooks/bootstrap-project/` | active | H-PLAN |
| PB-draft-architecture | `playbooks/draft-architecture/` | **active** | H-PLAN |
| PB-draft-database | `playbooks/draft-database/` | active | H-PLAN |
| PB-draft-api | `playbooks/draft-api/` | active | H-PLAN |
| PB-draft-ui-ux | `playbooks/draft-ui-ux/` | active | H-PLAN |
| PB-implement | `playbooks/implement/` | active (umbrella) | — |
| PB-implement-backend | `playbooks/implement-backend/` | active | H-IMPLEMENT |
| PB-implement-frontend | `playbooks/implement-frontend/` | active | H-IMPLEMENT |
| PB-implement-mobile | `playbooks/implement-mobile/` | active | H-IMPLEMENT |
| PB-implement-devops | `playbooks/implement-devops/` | active | H-IMPLEMENT |
| PB-test-plan | `playbooks/test-plan/` | **active** | H-VERIFY (soft — plan) |
| PB-test-generate | `playbooks/test-generate/` | **active** | none |
| PB-verify | `playbooks/verify/` | **active** | H-VERIFY (soft — evidence) |
| PB-review | `playbooks/review/` | **active** | H-VERIFY (soft — review) |
| PB-security-review | `playbooks/security-review/` | **active** | H-VERIFY (soft optional) |
| PB-perf-review | `playbooks/perf-review/` | **active** | H-VERIFY |
| PB-draft-doc-update | `playbooks/draft-doc-update/` | **active** | H-PLAN |
| PB-prepare-release | `playbooks/prepare-release/` | **active** | H-SHIP |
| PB-maintenance-triage | `playbooks/maintenance-triage/` | active | H-OPERATE |

**Path convention:** Playbook specs live under `playbooks/<kebab-name>/`. The `skills/` directory is reserved for platform adapter symlinks or copies — not the SSOT.

---

## Templates

| template_id | Path | document_type |
|-------------|------|---------------|
| TP-intake | `templates/intake/template.md` | intake |
| TP-WR | `templates/work-record/template.md` | work_record |
| TP-ORS | `templates/orchestrator-run-state/template.md` | orchestrator_run_state |
| TP-vision | `templates/vision/template.md` | vision |
| TP-discovery | `templates/discovery/template.md` | discovery |
| TP-prd | `templates/prd/template.md` | prd |
| TP-architecture | `templates/architecture/template.md` | architecture |
| TP-database | `templates/database/template.md` | database |
| TP-api | `templates/api/template.md` | api |
| TP-feature | `templates/feature/template.md` | feature |
| TP-testing | `templates/testing/template.md` | testing |
| TP-review | `templates/review/template.md` | review |
| TP-release | `templates/release/template.md` | release |
| TP-maintenance | `templates/maintenance/template.md` | maintenance |

---

## Orchestrator (ORCH-PROJECT)

| document_id | Path | Purpose |
|-------------|------|---------|
| ORCH-DESIGN | `workflows/project-orchestrator/DESIGN.md` | Normative orchestrator design |
| ORCH-ROUTING | `workflows/project-orchestrator/routing-matrix.yaml` | Per-skill routing SSOT |
| ORCH-GATES | `workflows/project-orchestrator/gates.yaml` | Human gate registry + waivers |
| ORCH-INTEG | `workflows/project-orchestrator/integrations.md` | Per-playbook contracts |
| ORCH-PHASES | `workflows/project-orchestrator/phases.yaml` | Default phase spine |
| WF-ENGINE | `workflows/ENGINE.md` | Workflow engine design |
| WF-REGISTRY | `workflows/WORKFLOW-REGISTRY.yaml` | Workflow catalog |
| WF-SCHEMA | `workflows/WORKFLOW-SPEC-SCHEMA.md` | Spec schema |

Workflow specs: `workflows/specs/WF-*.yaml` — Phase DAGs: `workflows/WF-*/phases.yaml`

---

## Skill Graph

| document_id | Path | Format |
|-------------|------|--------|
| GRAPH-SKILLS-001 | `workflows/project-orchestrator/skill-dependency-graph.md` | Human + mermaid |
| GRAPH-SKILLS-001 | `workflows/project-orchestrator/skill-dependency-graph.yaml` | Machine SSOT |

---

## Standards

### Contracts

| standard_id | Path | Applies to |
|-------------|------|------------|
| STD-SKILL-001 | `standards/SKILL-CONTRACT.md` | Every `PB-*` playbook |
| STD-META-001 | `standards/META-SKILL-CONTRACT.md` | Every `MS-*` meta skill |
| STD-ARTIFACT-001 | `standards/ARTIFACT-CONTRACT.md` | WR, ORS, artifact shapes |

### Engineering

Catalog: `standards/engineering/README.md`

| standard_id | Path | Domain |
|-------------|------|--------|
| STD-NAMING-001 | `standards/engineering/STD-NAMING-001.md` | Identifiers, paths, enums |
| STD-DOC-001 | `standards/engineering/STD-DOC-001.md` | Documentation lifecycle |
| STD-MD-001 | `standards/engineering/STD-MD-001.md` | Markdown format |
| STD-PROMPT-001 | `standards/engineering/STD-PROMPT-001.md` | Prompt structure |
| STD-CTX-001 | `standards/engineering/STD-CTX-001.md` | Context tiers T0–T3 |
| STD-MEM-001 | `standards/engineering/STD-MEM-001.md` | Persistence, session memory |
| STD-WF-001 | `standards/engineering/STD-WF-001.md` | WF-* workflow authoring |
| STD-TEST-001 | `standards/engineering/STD-TEST-001.md` | Fixtures, goldens, test plans |
| STD-REVIEW-001 | `standards/engineering/STD-REVIEW-001.md` | Code review |
| STD-ARCH-001 | `standards/engineering/STD-ARCH-001.md` | Layering, boundaries |
| STD-SEC-001 | `standards/engineering/STD-SEC-001.md` | Secrets, PII, redaction |
| STD-PERF-001 | `standards/engineering/STD-PERF-001.md` | Token and load efficiency |
| STD-LOG-001 | `standards/engineering/STD-LOG-001.md` | Audit trails, tick logs |
| STD-VER-001 | `standards/engineering/STD-VER-001.md` | Semver, traceability |

---

## Checklists

| checklist_id | Path | Used by |
|--------------|------|---------|
| CL-INTAKE | `checklists/intake.md` | PB-intake-classify |
| CL-DISCOVERY | `checklists/discovery.md` | PB-discovery-research |
| CL-ORCH | `checklists/orchestrator.md` | ORCH-PROJECT |
| CL-META-* | `checklists/meta-*.md` | MS-* meta skills |
| CL-PRD … CL-MAINT | `checklists/*.md` | Planned delivery skills — see [checklists/README.md](checklists/README.md) |