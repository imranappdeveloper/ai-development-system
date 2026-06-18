---
scenario_id: HT-01
skill_id: PB-survey-codebase
prompt_version: 1.0.0
inputs:
  intake_artifact: work/intake/WR-FEATURE-001.md
  work_id: WR-FEATURE-001
  context_md: CONTEXT.md
expected_outputs:
  out_01_path: work/survey/WR-FEATURE-001.md
  checklist_result: pass
  exit_gate: none
  recommended_next_skill: PB-discovery-research
---

---
document_id: SURVEY-WR-FEATURE-001
work_id: WR-FEATURE-001
survey_type: feature_context
workflow_id: WF-FEATURE
survey_confidence: high
scan_depth: standard
status: complete
revision: 0
created: 2026-06-18T15:00:00Z
upstream_int_path: work/intake/WR-FEATURE-001.md
context_md_path: CONTEXT.md
scan_manifest:
  paths_read:
    - src/api/routes/users.ts
    - src/auth/oauth.ts
    - package.json
    - tests/api/users.test.ts
  files_touched: 4
  t3_budget_pct: 18
---

# Codebase Survey — User profile feature context

## 1. Summary

Node/Express API with OAuth in `src/auth/`. No `users/profile` routes yet. Recommend PB-discovery-research with this SURVEY as structural input.

## 2. Survey Scope & Scan Manifest

| Bound | Value |
|-------|-------|
| Allowlist | `src/**`, `tests/**`, `package.json` per 05-context.md |
| Files touched | 4 / 40 cap |
| Focus | User-related API surface |

## 3. Repository Structure

```
src/
  api/routes/   # HTTP handlers
  auth/         # OAuth middleware
tests/api/      # API integration tests
```

## 4. Module Map

| Module | Purpose | Key paths |
|--------|---------|-----------|
| `src/api` | HTTP routes | `src/api/routes/users.ts` |
| `src/auth` | OAuth | `src/auth/oauth.ts` |
| `tests/api` | API tests | `tests/api/users.test.ts` |

## 5. Technology Stack

| Layer | Evidence |
|-------|----------|
| Runtime | Node 20 (`package.json` engines) |
| Framework | Express 4 (`package.json` dependencies) |
| Auth | OAuth2 client (`src/auth/oauth.ts:12`) |

## 6. Dependencies & Integrations

| Integration | Source |
|-------------|--------|
| PostgreSQL | `package.json` → `pg` |
| OAuth provider | `src/auth/oauth.ts` env `OAUTH_ISSUER` |

## 7. Patterns & Conventions

- Route files export `Router()` factory (`src/api/routes/users.ts:8`)
- Tests use supertest pattern (`tests/api/users.test.ts:5`)

## 8. Risk & Complexity Signals

| Signal | Severity | Evidence |
|--------|----------|----------|
| No profile route module | medium | `src/api/routes/` lacks `profile.ts` |
| GDPR consent not in code paths scanned | low | Not found in allowlist scope |

## 9. Gaps & Unknowns

- Frontend SPA not in repo (API-only survey)
- Notification subsystem not scanned (out of `scan_focus`)

## 6.2 Intake Classification Alignment

```yaml
intake_classification_alignment:
  intake_work_type: feature
  intake_workflow_id: WF-FEATURE
  alignment: aligned
  mismatch_summary: null
```

## 10. Advisory Handoff

| Field | Value |
|-------|-------|
| exit_gate | none |
| recommended_next_skill | PB-discovery-research |
| WR status | survey_complete |

No human gate required. Orchestrator may invoke PB-discovery-research when ready.