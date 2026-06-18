---
scenario_id: HT-01
skill_id: PB-onboard-project
prompt_version: 1.0.0
inputs:
  intake_artifact: work/intake/WR-EXISTING-001.md
  work_id: WR-EXISTING-001
  context_md: CONTEXT.md
expected_outputs:
  out_01_path: work/onboard/WR-EXISTING-001.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-draft-prd
---

---
document_id: ONBOARD-WR-EXISTING-001
work_id: WR-EXISTING-001
onboarding_type: existing_project
workflow_id: WF-PROJECT-EXISTING
onboarding_confidence: high
context_drift: minor
status: pending_review
revision: 0
created: 2026-06-18T14:00:00Z
upstream_int_path: work/intake/WR-EXISTING-001.md
context_md_path: CONTEXT.md
---

# Onboarding — Brownfield API service

## 1. Summary

Existing Node.js API with partial CONTEXT.md. OS adoption ready after minor CONTEXT refresh. Recommend PB-draft-prd after H-FRAME.

## 2. Project Snapshot

| Signal | Value | Source |
|--------|-------|--------|
| Stack | Node 20, Express, PostgreSQL | CONTEXT.md §Stack |
| Layout | `src/api`, `src/db`, `docs/` | CONTEXT.md §Layout |
| CI | GitHub Actions | README.md |

## 3. CONTEXT.md Assessment

| Check | Result | Evidence |
|-------|--------|----------|
| Module map present | partial | CONTEXT.md §Modules lists 2 of 4 top dirs |
| Conventions documented | yes | CONTEXT.md §Conventions |
| Drift | minor | `src/workers/` exists but not in CONTEXT |

**Proposed updates (human approval required — do not write):**

1. Add `src/workers/` to §Modules with queue consumer role
2. Document env var `QUEUE_URL` in §Configuration

## 4. Module Map

| Module | Purpose | Key paths |
|--------|---------|-----------|
| `src/api` | HTTP routes | `src/api/routes/` |
| `src/db` | Persistence | `src/db/migrations/` |
| `src/workers` | Async jobs | `src/workers/consumer.ts` |
| `docs` | API docs | `docs/openapi.yaml` |

## 5. OS Adoption Checklist

| Item | Status | Evidence |
|------|--------|----------|
| CONTEXT.md exists | pass | `context_md_path` |
| Work artifacts dir | pass | `work/` present |
| INT approved | pass | upstream_int_path |
| Module map ≥3 | pass | §4 |
| No secrets in CONTEXT | pass | reviewed |

## 6. Gap Analysis

| Gap | Severity | Mitigation |
|-----|----------|------------|
| CONTEXT workers section | low | PB-draft-doc-update post H-FRAME |
| No SURVEY artifact | low | Optional PB-survey-codebase |

## 6.2 Intake Classification Alignment

```yaml
intake_classification_alignment:
  intake_work_type: existing_project
  intake_workflow_id: WF-PROJECT-EXISTING
  alignment: aligned
  mismatch_summary: null
```

## 7. Open Questions

- Adopt full orchestrator now or phased Frame-only?

## 8. Human Approval

| gate_id | H-FRAME |
| decision | pending |