---
anti_pattern_id: CODE-skip-tests
severity: P0
related_ec: EC-TST-01
fails_checklist: 5
---

# Anti-Pattern — Skip Tests Documentation

## What goes wrong

Agent produces CODE record with empty or omitted §6 Testing Notes:

```markdown
## 6. Testing Notes

_TBD — will add tests later._
```

Or removes §6 entirely, assuming PB-verify will handle testing later.

## Symptoms

- CL-IMPLEMENT-BACKEND #5 fail
- PB-verify cannot determine what was validated
- False confidence at H-IMPLEMENT
- STD-TEST-001 violation

## Related anti-pattern

**Horizontal TDD** — writing all tests in bulk, then all implementation. Produces brittle tests disconnected from behavior. Use **`/tdd`** vertical slices: one test → one code change per ISS.

## Correct pattern

Always document tests — run, added, or explicitly `pending_ci` with commands:

```markdown
## 6. Testing Notes

| test_type | command / path | status | notes |
|-----------|----------------|--------|-------|
| unit | `pytest tests/unit/test_preferences_repository.py -v` | added | 4 cases pass locally |
| contract | `pytest tests/contract/test_preferences_api.py -v` | added | API-001, API-002 |
| integration | `pytest tests/integration/ -v` | pending_ci | Requires CI DB |
```

## Prevention

- CL-IMPLEMENT-BACKEND check #5
- TEST-DOC mandatory step in workflow
- AC-TST-01 / AC-TST-02 in 06-quality.md