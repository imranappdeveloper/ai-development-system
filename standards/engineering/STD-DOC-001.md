# STD-DOC-001 — Documentation

| Field | Value |
|-------|-------|
| standard_id | STD-DOC-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Define **what documents exist**, who owns them, and when they are required — without prescribing markdown syntax (see **STD-MD-001**).

## Scope

- OS repo: `docs/`, `standards/`, `INDEX.md`, `FOUNDATION.md`, playbooks, workflows
- Project repo: `CONTEXT.md`, `work/` artifacts
- Excludes: prompt body text (**STD-PROMPT-001**), artifact field schemas (**STD-ARTIFACT-001**)

## Rules

### Document classes (MUST)

| Class | Location | Owner | Required when |
|-------|----------|-------|---------------|
| Foundation manifest | `FOUNDATION.md` | Principal Architect | Always at OS root |
| Catalog | `INDEX.md` | Maintainer | Any INDEX-listed asset changes |
| Architecture | `docs/ARCHITECTURE.md` | Platform Architect | Foundation+ |
| SSOT hierarchy | `docs/SSOT-HIERARCHY.md` | Platform Architect | Foundation+ |
| Governance | `docs/GOVERNANCE.md` | Principal Architect | Foundation+ |
| Repository governance | `docs/REPOSITORY-GOVERNANCE.md` | Principal Architect | Foundation+ |
| Contributing | `docs/CONTRIBUTING.md` | Maintainer | Any contributor |
| Standard | `standards/**/STD-*.md` | Standard owner | Normative rule exists |
| Playbook spec | `playbooks/*/01–11` | Skill author | Every `PB-*` / `MS-*` |
| Workflow DAG | `workflows/WF-*/phases.yaml` | Workflow owner | Every `WF-*` in INDEX |
| Checklist | `checklists/*.md` | Skill author | CL-* referenced by skill |
| Template | `templates/*/template.md` | Template owner | TP-* produces artifact |
| Project context | `{project_root}/CONTEXT.md` | Project team | Existing codebase work |

### Folder index (MUST)

Every new top-level or standards folder MUST include `README.md` stating purpose, owner, and catalog link.

### Ownership (MUST)

Each document metadata table includes: `document_id` or `standard_id`, `version`, `status`, `owner`, `updated`.

### Lifecycle statuses

`draft` | `active` | `design` | `planned` | `deprecated` | `frozen` — semantics per **STD-VER-001**.

### Single purpose (MUST)

One document = one primary purpose. Cross-link; do not merge orchestrator design into a playbook README.

### Drift control (SHOULD)

When a spec references an OS file, verify the path exists before `active` promotion. Stale "pending" tables in READMEs MUST be updated when dependency lands.

## Examples

| Good | Bad |
|------|-----|
| `docs/GOVERNANCE.md` owns gate policy; `gates.yaml` owns machine registry | Gate rules duplicated in 5 playbooks |
| `workflows/README.md` indexes all WF-* | WF-* folders without README |
| Playbook `10-review.md` records architect score | Review only in chat |

## Exceptions

- Scaffold playbooks (`planned`) MAY have README + `01-purpose` stub only until build phase
- Generated tick logs are documents but need no upfront authoring — see **STD-LOG-001**
- `CHANGELOG.md` MAY omit playbook-internal typo fixes at PATCH level

## Validation

| Gate | Criteria |
|------|----------|
| D-DOC-01 | New folder has README |
| D-DOC-02 | INDEX row for every cataloged asset |
| D-DOC-03 | Owner field present in standard/skill metadata |
| D-DOC-04 | No orphan doc (unlinked from INDEX or parent README) |

MS-repository-review checks D-DOC-* during OS audits.

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-MD-001 | Format of all markdown documents |
| STD-NAMING-001 | Document and path IDs |
| STD-VER-001 | Document version bumps |
| STD-ARCH-001 | Architecture doc placement in layer model |
| STD-WF-001 | Workflow documentation requirements |
| DOC-REPO-GOV-001 | Repository document lifecycle and release |