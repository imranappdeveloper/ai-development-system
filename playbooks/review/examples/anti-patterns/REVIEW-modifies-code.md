---
anti_pattern_id: REVIEW-modifies-code
severity: P0
related_ec: EC-SCP-01
fails_checklist: 9
---

# Anti-Pattern — Code Modified During Review

## What goes wrong

Agent applies a fix to source code while producing REVIEW:

```text
Files written:
- work/review/WR-FEATURE-ALPHA.md
- src/routes/preferences.py  ← FORBIDDEN
```

Or handoff states: "Fixed logging in preferences.py during review."

## Symptoms

- CL-REVIEW #9 fail
- Implement/review scope conflation
- CODE artifact stale vs actual repository state
- H-IMPLEMENT traceability broken

## Correct pattern

Document finding only — route fix to implement:

```markdown
### 5.2 Should-Fix

| ID | Location | Finding | Suggested action |
|----|----------|---------|------------------|
| S-1 | `src/routes/preferences.py:42` | Missing request_id in error log | PB-implement-backend: add structured log |
```

Handoff: `recommended_next_skill: PB-implement-backend` when human accepts finding.

## Prevention

- `09-system-prompt.md` NEVER MODIFY CODE
- CL-REVIEW #9 binding
- Anti-pattern linked from `11-test-plan.md` FT-05