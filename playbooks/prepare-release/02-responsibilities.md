# PB-prepare-release — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | CODE linked; TEST-RPT soft satisfied or WF-RELEASE waiver; Ship phase |
| P2 | Load CODE + TEST-RPT + upstream verify artifacts | T1/T2 bundles per 05-context.md |
| P3 | Define release scope from WR artifacts | §2 Included / Excluded tables populated |
| P4 | Determine version and bump rationale | §3 Versioning complete with semver |
| P5 | Build changelog from CODE §4 and ISS/PRD | §4 Added/Changed/Fixed/Security rows |
| P6 | Document deployment and rollback plan | §7 plan-only — owners and steps listed |
| P7 | Map TEST-RPT evidence to pre-release checks | §8.1 rows cite TEST-RPT pass/fail |
| P8 | Produce REL (OUT-01) | Complete per 04-io-contract at release path |
| P9 | Run CL-RELEASE | Validation record = pass |
| P10 | Prepare handoff for H-SHIP | `decision: pending`; recommend PB-maintenance-triage |

### release_type enum

| release_type | From signal |
|--------------|-------------|
| `major` | Breaking API/schema changes in CODE or REL §5 |
| `minor` | New features; backward compatible |
| `patch` | Bugfixes only |
| `hotfix` | WF-BUGFIX urgent production fix |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference REVIEW / SEC-REVIEW / PERF-REVIEW when linked | Open items in §11 |
| S2 | Document breaking changes and migration | §5 when API/DB/schema changes |
| S3 | Note communication plan | §9 audiences and channels |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Include DOC-PLAN doc update scope in changelog | WF-DOCS or doc delta linked |
| O2 | Suggest release freeze window | Multi-lane WF-FEATURE with parallel CODE |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Execute deploy, kubectl, terraform apply, CI trigger | Human after H-SHIP |
| N2 | Run smoke tests in production | Human at H-OPERATE |
| N3 | Approve H-SHIP or H-OPERATE | Human |
| N4 | Auto-invoke next playbook | Human after gate |
| N5 | Modify source code or infra | PB-implement-* |
| N6 | Produce TEST-RPT or execute test suites | PB-verify |
| N7 | Write or modify PRD, ISS, CODE | Respective playbooks |
| N8 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N9 | Assign or change `workflow_id` | PB-intake-classify |
| N10 | Modify OS repository files | OS maintainer |
| N11 | Store release plan only in chat | Must persist REL |
| N12 | Self-approve H-SHIP | Human gate |
| N13 | Skip CL-RELEASE or §8 verification rows | Never |
| N14 | Copy secrets into REL | Redact `[REDACTED]` |
| N15 | Invent version without WR / human semver hint | Flag open item in §11 |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| REL draft & release record | proposes | approves / revises / rejects at H-SHIP |
| Semver bump and release_type | proposes | confirms or overrides |
| Deployment window and owners | proposes | confirms; executes deploy |
| Open blocker severity | proposes | P0 in §11 blocks H-SHIP approve |
| Production deploy execution | **never** | human or approved pipeline |
| Next playbook | recommends PB-maintenance-triage | decides after H-SHIP |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| CODE | artifact | Required — any implement lane path |
| TEST-RPT | artifact (soft) | Verify evidence — waived `WF-RELEASE` |
| H-VERIFY | gate (soft) | When full verify chain ran — waived `WF-RELEASE` |
| REVIEW / SEC-REVIEW / PERF-REVIEW | artifact (soft) | Quality chain context |
| Quality chain skills | skill (soft) | PB-verify, PB-review, etc. — document waivers |
| CL-RELEASE | checklist | Handoff blocker |
| STD-PROD-001, STD-CI-001 | standard | §8 pre-release checks |