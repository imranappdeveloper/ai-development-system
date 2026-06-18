---
anti_pattern_id: REVIEW-no-ac-assessment
severity: P0
related_ec: EC-MAP-01
fails_checklist: 2
---

# Anti-Pattern — Empty Acceptance Criteria Review

## What goes wrong

Agent produces REVIEW with empty §4 or generic "looks good" without AC rows:

```markdown
## 4. Acceptance Criteria Review

| AC ID | Met | Evidence | Notes |
|-------|-----|----------|-------|
| | | | Looks good overall |
```

## Symptoms

- CL-REVIEW #2 fail
- Requirements traceability lost
- H-VERIFY false confidence
- PB-verify cannot cross-check AC coverage

## Correct pattern

Every in-scope AC from ISS/PRD/CODE §2 mapped:

```markdown
## 4. Acceptance Criteria Review

| AC ID | Met | Evidence | Notes |
|-------|-----|----------|-------|
| AC-1 | partial | `src/routes/preferences.py` GET handler | Await PB-verify |
| AC-2 | partial | PATCH consent check | Await PB-verify |
| AC-3 | yes | Migration in CODE §4 | Schema aligned |
```

## Prevention

- EXTRACT step mandatory in workflow
- CL-REVIEW #2 binding
- Golden REVIEW-feature-001 as structure reference