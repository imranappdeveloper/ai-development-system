---
anti_pattern_id: TEST-PLAN-no-ac-mapping
severity: P0
related_ec: EC-MAP-01
fails_checklist: 2
---

# Anti-Pattern — No AC Mapping

## What goes wrong

Agent produces TEST-PLAN with empty or generic §3.1:

```markdown
### 3.1 Acceptance Criteria Mapping

| AC ID | Test case ID | Description | Type | Priority |
|-------|--------------|-------------|------|----------|
| — | TC-001 | Smoke test the API | manual | P3 |
```

No linkage to ISS AC-1, AC-2, AC-3 or PRD criteria.

## Symptoms

- CL-TEST-PLAN #2 fail
- PB-test-generate cannot trace coverage
- H-VERIFY sign-off impossible — untraceable scope
- False confidence in verification strategy

## Correct pattern

Map every in-scope AC to ≥1 TC-* with explicit AC ID from ISS/PRD:

```markdown
| AC-1 | TC-001 | GET preferences returns 200 for authenticated session | contract | P1 |
| AC-2 | TC-003 | PATCH rejects when consent_acknowledged false | contract | P1 |
| AC-3 | TC-005 | Migration creates user_preferences with indexes | unit | P1 |
```

## Prevention

- CL-TEST-PLAN check #2
- MAP mandatory step in workflow
- AC-MAP-01 in 06-quality.md