# Changelog

All notable changes to the AI Development System (AI Dev OS) are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/). Versioning aligns with `FOUNDATION.md`.

## [1.0.0] — 2026-06-18

### Frozen — AI Development OS v1.0

Platform frozen. No further architectural changes to v1.0 substrate.

### Added

- **Release bundle** `release/v1.0/`:
  - `PLATFORM-MANIFEST.md`, `VERSION-REPORT.md`, `ARCHITECTURE-REPORT.md`
  - `DEPENDENCY-GRAPH.md` + `DEPENDENCY-GRAPH.yaml`
  - `SKILL-REGISTRY.yaml`, `WORKFLOW-REGISTRY.yaml`, `STANDARDS-REGISTRY.yaml`
  - `ROADMAP-v2.md`, `FUTURE-ENHANCEMENTS.md`
- Principal Architect freeze sign-off — `FOUNDATION.md` `status: frozen`
- `spec_sha: 14d731c15af6532e` pinned in `INDEX.md`
- Repository branded **AI Development OS v1.0**

### Changed

- `ARTIFACT-REGISTRY.yaml` — PRD, ARCH, CODE, TEST-RPT → `active`
- `INDEX.md`, `README.md`, `ROADMAP.md` — v1.0 branding

## [Unreleased]

## [1.1.0] — 2026-06-19

### Frozen — AI Development OS v1.1 (Standalone Execution)

Adds runnable standalone execution on frozen v1.0 playbook substrate. Release bundle: `release/v1.1/`. `spec_sha: c969fe5de054aaac`.

### Added

- **19 bundled slash skills** — `skills/MANIFEST.yaml` SSOT; `install-cli.sh` symlinks to `~/.grok/skills/` and `~/.gemini/config/skills/`
- **`/setup-task-run` skill** — Phase 1.6 in setup-ads; `docs/agents/task-run.md`, cron example
- **Server AFK stack** — `task-run-server.sh`, `task-run-poll.sh`, `lib/task-run-agent.sh`, `lib/task-run-session.sh`
- **`setup-graphify.sh`** — graphify CLI + post-commit hook
- **`verify-standalone.sh`** — manifest, symlinks, session unit tests
- **`test-task-run-session.sh`** — poll/session helper tests
- **`docs/STANDALONE.md`** — self-contained SSOT guide
- **`docs/USER-FLOW.md`** — understand → spec → tasks → Start AFK (no spec dumps)
- **`docs/AFK-TASK-RUN.md`** — server-only AFK guide (grok/agy)
- **systemd templates** — `templates/systemd/task-run-poll@.*`
- **`docs/OS-STATUS-FOOTER.md`** — mandatory footer on every agent reply
- **`docs/BUG-FIX.md`** — bug path: `/triage` → `/diagnose` → 3 approval cards
- **`/setup-ads` skill** — ai-new + grill-me / grill-with-docs; [SETUP-ADS.md](./docs/SETUP-ADS.md)
- Portable paths — `env:AI_DEV_OS_HOME`, `ai-paths`, `ai-dev-os.local.yaml`, [MULTI-MACHINE.md](./docs/MULTI-MACHINE.md)
- `templates/project-starter/` — project template with `task_run` config
- `docs/PROJECT-KICKOFF.md` — grill-first kickoff

### Changed

- **Done-at-PR-create policy** — task `done` when PR opens; no merge wait; next issue starts immediately
- `skills/task-run/SKILL.md`, `skills/work-to-pr-v2/SKILL.md` — aligned state machine
- `install-cli.sh` — symlinks (not copies) for grok + agy skill discovery
- `check-cli.sh` — verifies symlinks point to `$AI_DEV_OS_HOME/skills/`
- `scripts/new-project.sh` — graphify + task-run setup hooks
- Deprecated `--local` AFK path — server-only batch code

## [1.0.0] — 2026-06-18 (continued)

### Added (pre-freeze)

- Four planned delivery skills promoted to **active**: `PB-survey-codebase`, `PB-draft-feature`, `PB-security-assess`, `PB-perf-baseline` — full STD-SKILL-001 specs, CL-SURVEY/CL-DRAFT/CL-SECURI/CL-PERF (10 checks each)
- Workflow specs: `workflows/specs/WF-SECURITY.yaml`, `WF-PERF.yaml`, `WF-DOCS.yaml`
- `scripts/simulate-workflow.sh` — phases.yaml playbook readiness simulation; wired in CI
- Foundation freeze sign-off section in `FOUNDATION.md` (Principal Architect gate pending)

### Added (prior batch)

- Production readiness completion: **28 active playbooks** — planning chain (PRD, architecture, feature-planner), decompose, verify, onboard, bootstrap, bugfix (diagnose, draft-issue), maintenance-triage
- CI: `.github/workflows/ci.yml`, `scripts/verify-catalog.sh`, `scripts/sync-routing-graph.sh`
- E2E-WF-FEATURE canonical path in `workflows/WF-FEATURE/phases.yaml` + orchestrator evidence

### Changed

- `gates.yaml` — H-IMPLEMENT binds lane skills; H-VERIFY binds TEST-PLAN/TEST-GEN
- `skill-dependency-graph.yaml` synced with routing-matrix and active registries
- `ARTIFACT-REGISTRY.yaml` — CODE lane paths; ONBOARD, MAINT, ISS, DIAG, SCAFFOLD active
- `FOUNDATION.md` substrate_readiness 96/100; `INDEX.md` active_skills 32
- `ARTIFACT-REGISTRY.yaml` — SURVEY, FEAT, SEC-ASSESS, PERF-BASE `active`
- `routing-matrix.yaml` + `skill-dependency-graph.yaml` — four skills `active`

### Added (prior)

- Quality skills chain (sequential gates): PB-test-plan, PB-test-generate, PB-review, PB-security-review, PB-perf-review, PB-draft-doc-update, PB-prepare-release — full 01–11 specs
- ARTIFACT-REGISTRY entries: TEST-PLAN, TEST-GEN; active promotion for REVIEW, SEC-REVIEW, PERF-REVIEW, DOC-PLAN, REL
- Quality checklists: CL-TEST-PLAN, CL-TEST-GEN, CL-REVIEW, CL-SECURITY-REVIEW, CL-PERF-REVIEW, CL-DOC-UPDATE, CL-RELEASE (10 checks each)

- Engineering skills chain (sequential gates): PB-draft-database, PB-draft-api, PB-draft-ui-ux, PB-implement umbrella, PB-implement-backend/frontend/mobile/devops — full 01–11 specs
- `templates/ui-ux/template.md` (TP-uiux)
- ARTIFACT-REGISTRY entries: DB, API, UIUX
- Lane checklists: CL-IMPLEMENT-BACKEND, CL-IMPLEMENT-FRONTEND, CL-IMPLEMENT-MOBILE, CL-IMPLEMENT-DEVOPS

### Changed

- All seven quality skills promoted to `status: active` with sequential `test-runs/latest-gate.md` VERDICT PASS
- `routing-matrix.yaml` — quality chain rows active; PB-prepare-release synced with registry (CODE required, TEST-RPT soft)
- `SKILL-CATALOG.yaml`, `INDEX.md`, `playbooks/README.md` — quality skills lifecycle `publish`
- `LIFECYCLE.md` — quality build order documented

- `routing-matrix.yaml` — Plan specs (database, api, ui-ux) + implement lane rows active
- `LIFECYCLE.md` — engineering build order

### Added (prior)

- PB-draft-prd complete spec 1.0.0 — 01–11, README, examples, fixtures; CL-PRD active
- PB-draft-architecture complete spec 1.0.0 — 01–11, README, examples, fixtures; CL-ARCH active
- PB-feature-planner umbrella spec 1.0.0 — routing identity for PB-draft-feature / PB-decompose-issues
- Intake + discovery anti-patterns (3 each) — auto-chain, self-approve, scope violations

### Changed

- Sequential promotion rule in `skills/meta-skill/LIFECYCLE.md` + `scripts/verify-skill-spec.sh`
- PB-intake-classify, PB-discovery-research sequential gates (`test-runs/latest-gate.md`)
- PB-draft-prd, PB-draft-architecture, PB-feature-planner reverted to `draft` pending sequential gates
- `routing-matrix.yaml` — PB-draft-architecture `active`
- `SKILL-CATALOG.yaml` — planning skills lifecycle `publish`

### Added (prior)

- PB-project-orchestrator complete spec 0.2.0 — 01–11, README, examples (1 golden, 3 anti-patterns), fixtures
- Orchestrator promotion evidence in `11-test-plan.md` (G-ORCH, G-WF-05, HT/ET/FT)

### Changed

- PB-project-orchestrator / ORCH-PROJECT promoted to `status: active` (spec_version 0.2.0)
- `INDEX.md`, `SKILL-CATALOG.yaml` — orchestrator lifecycle `publish`, active

### Added (prior unreleased)

- 22 checklists (`CL-META-*`, delivery stubs/scaffolds) — registry `checklist_id` integrity (P0-02)
- H-META gate in `workflows/project-orchestrator/gates.yaml` (P0-03)
- G-WF-05 structural tests T-E2E-01–06 in orchestrator `11-test-plan.md` (P0-05)
- Git repository initialized (P0-07)

### Changed

- PB-intake-classify, PB-discovery-research promoted to `status: active` (P0-06)
- 11 scaffold `registry.yaml` files → honest `planned` with routing metadata (P0-01)
- `FOUNDATION.md` — orchestrator SSOT paths, 14 workflows, architectural P0 resolution table
- `routing-matrix.yaml` + `skill-dependency-graph.yaml` — intake/discovery `active`
- `checklists/README.md` — full CL-* catalog
- `docs/GOVERNANCE.md` — H-META gate row
- `INDEX.md`, `ROADMAP.md` — foundation `p0_arch_complete`, active skills count

### Added (prior)

- Repository governance: `docs/REPOSITORY-GOVERNANCE.md` — ownership, review, approval, versioning, deprecation, breaking changes, compatibility, document/release lifecycle
- `docs/CONTRIBUTING.md` — contribution workflow and PR checklist
- `docs/OWNERSHIP.yaml` — machine ownership registry for folders, skills, workflows, templates
- Workflow engine: `workflows/ENGINE.md`, `WORKFLOW-REGISTRY.yaml`, `WORKFLOW-SPEC-SCHEMA.md`
- 12 reusable workflow specifications in `workflows/specs/` (New Project through Maintenance)
- Slice workflows: `WF-DISCOVERY` (Discovery/Research), `WF-PRD`, `WF-TESTING` with phases.yaml
- Engineering Standards layer: `standards/engineering/` — 14 standards (STD-NAMING through STD-VER)
- `standards/engineering/README.md` — layer catalog and compliance model
- `standards/README.md` — contracts vs engineering layers
- `INDEX.md`, `docs/SSOT-HIERARCHY.md`, `docs/ARCHITECTURE.md` — engineering standards registration

## [1.0.0-foundation-p0] - 2026-06-18

Foundation v1 P0 substrate complete. Substrate readiness: 78/100.

### Added

- `docs/README.md`, `docs/INDEX.md` — documentation catalog
- `docs/ARCHITECTURE.md` — Clean Architecture layers and deployment model (P0 #1, #23)
- `docs/SSOT-HIERARCHY.md` — SSOT ownership and dedup rules (P0 #3)
- `docs/GOVERNANCE.md` — human gates, waivers, promotion (P0 #25 partial)
- `INDEX.md` — Documentation and Foundation sections
- `ROADMAP.md` — Foundation v1 P0 progress tracker
- `FOUNDATION.md` — Foundation v1 manifest and P0 checklist (P0 #2)
- `standards/ARTIFACT-CONTRACT.md` — STD-ARTIFACT-001 WR/ORS/INT shapes (P0 #9, #24)
- `ARTIFACT-REGISTRY.yaml` — artifact type registry (P0 #3)
- `standards/README.md` — register STD-ARTIFACT-001
- `workflows/project-orchestrator/gates.yaml` — gate registry + waive policy OD-05 (P0 #5, #25)
- `workflows/project-orchestrator/routing-matrix.yaml` — derived from skill graph (P0 #4, #19, #20)
- `workflows/project-orchestrator/integrations.md` — per-playbook contracts (P0 #6, #20)
- `workflows/project-orchestrator/phases.yaml` — default phase spine
- `workflows/WF-*/phases.yaml` × 11 + READMEs (P0 #7)
- `workflows/README.md` — workflow catalog
- `skill-dependency-graph.yaml` — fix WF-RELEASE sequence (remove erroneous H-VERIFY) (P0 #17)
- `INDEX.md` — Orchestrator and CL-ORCH sections
- `checklists/orchestrator.md` — CL-ORCH (P0 #8)
- `checklists/README.md` — checklist catalog
- `templates/intake/template.md` — TP-intake (P0 #10)
- `templates/work-record/template.md` — TP-WR (P0 #10)
- `templates/orchestrator-run-state/template.md` — TP-ORS (P0 #10)
- `templates/README.md` — register TP-intake, TP-WR, TP-ORS
- Phantom skill stubs × 9: `onboard-project`, `survey-codebase`, `draft-feature`, `draft-issue`, `diagnose-bug`, `security-assess`, `perf-baseline`, `bootstrap-project`, `decompose-issues` (P0 #14, #18, #26)
- `playbooks/feature-planner/` — umbrella identity resolution vs PB-decompose-issues / PB-draft-feature (P0 #15)
- `INDEX.md` — register phantom playbooks
- `playbooks/intake-classify/registry.yaml` — enums + intake_next_skill SSOT (P0 #11, #16)
- `playbooks/discovery-research/registry.yaml` (P0 #11)
- Intake/discovery fixtures + golden/anti-pattern examples (P0 #12, #21)
- Intake routing dedupe in `03-workflow.md`, `09-system-prompt.md` (P0 #16)
- `playbooks/project-orchestrator/02–11` operationalized from DESIGN (P0 #13)
- Promotion gate evidence in intake/discovery `10-review.md`, `11-test-plan.md` (P0 #18, #22)
- `FOUNDATION.md` — all P0 checklist complete
- `README.md` — entry points to FOUNDATION and architecture

### Changed

- `skill-dependency-graph.yaml` — WF-RELEASE sequence corrected (P0 #17)
- `skill-dependency-graph.md` — WF-RELEASE gate table aligned
- `playbooks/intake-classify/README.md` — promotion status updated
- `playbooks/intake-classify/10-review.md` — Foundation P0 resolution appendix
- `playbooks/discovery-research/10-review.md` — P0 artifacts + readiness 72/100
- `playbooks/feature-planner/README.md` — umbrella vs routing ID clarification
- `ROADMAP.md` — Foundation v1 P0 marked complete