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

_TBD — will add widget tests later._
```

Or removes §6 entirely, assuming PB-verify will handle testing on devices later.

## Symptoms

- CL-IMPLEMENT-MOBILE #5 fail
- PB-verify cannot determine what was validated
- False confidence at H-IMPLEMENT
- STD-TEST-001 violation

## Correct pattern

Always document tests — run, added, or explicitly `pending_device` / `pending_ci` with commands:

```markdown
## 6. Testing Notes

| test_type | command / path | status | notes |
|-----------|----------------|--------|-------|
| unit | `npm test -- preferencesStore.test.ts` | added | 5 cases pass locally |
| widget | `npm test -- PreferencesScreen.test.tsx` | added | 4 UI states |
| integration | `detox test e2e/preferences.e2e.ts` | pending_device | Requires simulator |
```

## Prevention

- CL-IMPLEMENT-MOBILE check #5
- TEST-DOC mandatory step in workflow
- AC-TST-01 / AC-TST-02 in 06-quality.md