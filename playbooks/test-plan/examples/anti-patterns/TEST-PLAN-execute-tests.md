---
anti_pattern_id: TEST-PLAN-execute-tests
severity: P0
related_ec: EC-SCP-01
fails_checklist: 5
---

# Anti-Pattern — Execute Tests During Plan Phase

## What goes wrong

Agent runs test commands and populates §9 Execution Evidence during PB-test-plan:

```markdown
## 9. Execution Evidence

### 9.1 Commands Run

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| `pytest tests/contract/test_preferences_api.py -v` | 0 | 2026-06-18T20:15:00Z |

### 9.2 Results Summary

| Metric | Value |
|--------|-------|
| total | 6 |
| passed | 6 |
| failed | 0 |
```

## Symptoms

- CL-TEST-PLAN #5 fail
- `test_phase: plan` conflated with evidence
- PB-test-generate may duplicate or conflict with existing tests
- STD-TEST-002 plan/evidence separation violated

## Correct pattern

Leave §9 empty or explicit plan-only placeholder; document planned commands in §3.2 expected results only:

```markdown
## 9. Execution Evidence

_plan_only — no tests executed during PB-test-plan. Evidence populated by PB-verify._
```

## Prevention

- CL-TEST-PLAN check #5
- NEVER EXECUTE TESTS binding in 09-system-prompt.md
- AC-EXE-01 / AC-EXE-02 in 06-quality.md