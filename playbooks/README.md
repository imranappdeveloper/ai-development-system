# Playbooks (Skills)

Atomic capabilities for the AI Dev OS. Platform adapters map playbooks to vendor "skills."

**Every playbook MUST comply with [STD-SKILL-001](../standards/SKILL-CONTRACT.md)** (Universal Skill Contract). New skills: copy [`_contract-scaffold/`](./_contract-scaffold/).

## Skill Spec Naming Convention

All skill specification documents use **numbered prefixes**:

| File | Section |
|------|---------|
| `01-purpose.md` | Purpose |
| `02-responsibilities.md` | Responsibilities |
| `03-workflow.md` | Internal workflow |
| `04-io-contract.md` | Inputs & outputs |
| `05-context.md` | Context & knowledge requirements |
| `06-quality.md` | Quality standards & acceptance criteria |
| `07-edge-cases.md` | Edge cases & failure scenarios |
| `08-limitations.md` | Skill limitations |
| `09-system-prompt.md` | Production system prompt |
| `10-review.md` | Architect review |
| `11-test-plan.md` | Validation & test plan |
| `12-qa-scenarios.md` | Large scenario catalogs (SHOULD) |
| `registry.yaml` | Machine SSOT — **required at promotion** |
| `fixtures/` | Test fixtures — **required at promotion** |
| `examples/` | Golden + anti-patterns — **required at promotion** |
| `README.md` | Skill index |

Legacy optional sections (prefer merging into 03/04/06): constraints, handoff-only files, separate validation docs.

## Path Convention

| Rule | Location |
|------|----------|
| **SSOT** | `playbooks/<kebab-name>/` — numbered specs 01–11 + README |
| **Adapters** | `skills/` — platform copies or symlinks only; not authoritative |

## Build program

Lifecycle: **Design → Review → Gap → Improve → Test → Stress → Freeze → Publish**  
Catalog: `skills/meta-skill/SKILL-CATALOG.yaml`

**Order:** Meta skills (6) → Orchestrator → Discovery publish → delivery skills.

## Catalog

### Meta (`MS-*`)

| skill_id | Path | Status |
|----------|------|--------|
| MS-architecture-review | `meta-architecture-review/` | draft / design |
| MS-dependency-analysis | `meta-dependency-analysis/` | draft / design |
| MS-standards-review | `meta-standards-review/` | draft / design |
| MS-workflow-review | `meta-workflow-review/` | draft / design |
| MS-repository-review | `meta-repository-review/` | draft / design |
| MS-quality-review | `meta-quality-review/` | draft / design |

### Orchestrator

| skill_id | Path | Status |
|----------|------|--------|
| PB-project-orchestrator | `project-orchestrator/` | **active** |

### Delivery (`PB-*`)

| skill_id | Path | Status | Spec progress |
|----------|------|--------|---------------|
| PB-intake-classify | `intake-classify/` | **active** | Foundation reference skill |
| PB-discovery-research | `discovery-research/` | **active** | Foundation reference skill |
| PB-onboard-project | `onboard-project/` | active | H-FRAME |
| PB-decompose-issues | `decompose-issues/` | active | full |
| PB-draft-feature | `draft-feature/` | **active** | 1.0.0 FEAT path |
| PB-draft-issue | `draft-issue/` | active | full |
| PB-diagnose-bug | `diagnose-bug/` | active | full |
| PB-security-assess | `security-assess/` | active | SEC-ASSESS |
| PB-perf-baseline | `perf-baseline/` | **active** | 1.0.0 |
| PB-bootstrap-project | `bootstrap-project/` | active | full |
| PB-survey-codebase | `survey-codebase/` | **active** | 1.0.0 SURVEY |
| PB-draft-prd | `draft-prd/` | draft | spec ready — gate pending |
| PB-feature-planner | `feature-planner/` | draft (umbrella) | gate pending |
| PB-draft-architecture | `draft-architecture/` | draft | spec ready — gate pending |
| PB-draft-database | `draft-database/` | **active** | 1.0.0 |
| PB-draft-api | `draft-api/` | **active** | 1.0.0 |
| PB-draft-ui-ux | `draft-ui-ux/` | **active** | 1.0.0 |
| PB-implement | `implement/` | **active** (umbrella) | 1.0.0 |
| PB-implement-backend | `implement-backend/` | **active** | 1.0.0 |
| PB-implement-frontend | `implement-frontend/` | **active** | 1.0.0 |
| PB-implement-mobile | `implement-mobile/` | **active** | 1.0.0 |
| PB-implement-devops | `implement-devops/` | **active** | 1.0.0 |
| PB-test-plan | `test-plan/` | **active** | 1.0.0 |
| PB-test-generate | `test-generate/` | **active** | 1.0.0 |
| PB-verify | `verify/` | planned | scaffold |
| PB-review | `review/` | **active** | 1.0.0 |
| PB-security-review | `security-review/` | **active** | 1.0.0 |
| PB-perf-review | `perf-review/` | **active** | 1.0.0 |
| PB-draft-doc-update | `draft-doc-update/` | **active** | 1.0.0 |
| PB-prepare-release | `prepare-release/` | **active** | 1.0.0 |
| PB-maintenance-triage | `maintenance-triage/` | active | H-OPERATE |