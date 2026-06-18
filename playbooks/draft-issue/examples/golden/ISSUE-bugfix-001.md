---
scenario_id: HT-04
skill_id: PB-draft-issue
prompt_version: 1.0.0
inputs:
  work_id: WR-BUGFIX-ALPHA
  project_root: fixtures/projects/wf-bugfix-alpha
  artifact_refs:
    - type: INT
      path: work/intake/WR-BUGFIX-ALPHA.md
expected_outputs:
  artifact_path: work/issue/WR-BUGFIX-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement
---

---
document_id: ISS-WR-BUGFIX-ALPHA
work_id: WR-BUGFIX-ALPHA
workflow_id: WF-BUGFIX
issue_lane: backend
fix_scope: minimal
issue_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T16:00:00Z
upstream_int_path: work/intake/WR-BUGFIX-ALPHA.md
upstream_diag_path: work/diagnose/WR-BUGFIX-ALPHA.md
---

# ISS — Fix login for email addresses containing +

## Summary

Fix auth login path to correctly handle `+` in email addresses per DIAG root cause — encoding normalization before user lookup.

## Reproduction

1. Register `user+tag@test.com`
2. POST /login with same email
3. Observe 500 (should succeed)

## Acceptance Criteria

| id | criterion | verify |
|----|-----------|--------|
| AC-1 | Login succeeds for `user+tag@test.com` after fix | integration test |
| AC-2 | Login still fails with wrong password (401) | integration test |
| AC-3 | Regression test covers `+` and `%2B` encoded emails | unit test in auth module |

## Scope

| in | out |
|----|-----|
| `src/auth/login.ts` email normalization | OAuth provider changes |
| Auth integration tests | UI login form redesign |

## References

| artifact | path |
|----------|------|
| INT | work/intake/WR-BUGFIX-ALPHA.md |
| DIAG | work/diagnose/WR-BUGFIX-ALPHA.md |

## Human Approval

| gate_id | H-PLAN |
| decision | pending |
