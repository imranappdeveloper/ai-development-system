---
scenario_id: HT-04
skill_id: PB-diagnose-bug
prompt_version: 1.0.0
inputs:
  work_id: WR-BUGFIX-ALPHA
  project_root: fixtures/projects/wf-bugfix-alpha
  artifact_refs:
    - type: INT
      path: work/intake/WR-BUGFIX-ALPHA.md
expected_outputs:
  artifact_path: work/diagnose/WR-BUGFIX-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-draft-issue
---

---
document_id: DIAG-WR-BUGFIX-ALPHA
work_id: WR-BUGFIX-ALPHA
workflow_id: WF-BUGFIX
repro_status: confirmed
root_cause_category: logic
diagnosis_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T15:00:00Z
upstream_int_path: work/intake/WR-BUGFIX-ALPHA.md
---

# DIAG — Login 500 for email with plus sign

## Summary

Root cause is URL-encoding mishandling of `+` in email query parameter during login — not database corruption.

## Symptoms

- HTTP 500 on POST /login when email contains `+`
- Error log: `TypeError: Cannot read property 'id' of undefined`

## Reproduction

1. Register `user+tag@test.com`
2. POST /login with same email
3. Observe 500 (per INT)

## Hypotheses

| ID | Hypothesis | Likelihood | Result |
|----|------------|------------|--------|
| H1 | `+` decoded as space breaks lookup | High | **Confirmed** |
| H2 | DB unique constraint violation | Low | Ruled out |
| H3 | OAuth token expiry | Low | Ruled out |

## Root Cause

Login handler passes email through `decodeURIComponent` without normalizing `+`, causing lookup miss and null dereference.

## Evidence

| source | observation | conclusion |
|--------|-------------|------------|
| INT repro steps | Consistent 500 with `+` email | Repro confirmed |
| Log snippet | undefined user after lookup | Null deref |
| Code marker `src/auth/login.ts` | decodeURIComponent on raw query | Encoding bug |

## Fix Direction

Normalize email before lookup (RFC-compliant plus handling) — implement in auth login path; add regression test for `+` emails. **No code in this artifact.**

## References

| artifact | path |
|----------|------|
| INT | work/intake/WR-BUGFIX-ALPHA.md |

## Human Approval

| gate_id | H-PLAN |
| decision | pending |
