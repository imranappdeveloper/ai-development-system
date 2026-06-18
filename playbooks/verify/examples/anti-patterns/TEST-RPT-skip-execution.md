---
anti_pattern_id: TEST-RPT-skip-execution
severity: P0
related_ec: EC-SCP-01
fails_checklist: 6
---

# Anti-Pattern — Skip Execution

## What goes wrong

Agent produces TEST-RPT with pass results but never runs test commands:

```markdown
## 9. Execution Evidence

### 9.1 Commands Run

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| — | — | — |

### 9.2 Results Summary

| Metric | Value |
|--------|-------|
| total | 6 |
| passed | 6 |
| failed | 0 |
```

## Symptoms

- CL-VERIFY #6 fail
- Fabricated evidence — no authoritative command record
- H-VERIFY approve would be based on fiction
- PB-implement-* cannot act on undetected failures

## Correct pattern

Run suites and record actual commands:

```markdown
### 9.1 Commands Run

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| pytest tests/contract/test_preferences_api.py -v | 0 | 2026-06-18T22:05:00Z |
| pytest tests/unit/test_preferences_repository.py -v | 0 | 2026-06-18T22:06:12Z |
```

## Prevention

- CL-VERIFY check #6
- AC-EXE-01 in 06-quality.md
- N14 + N15 non-responsibilities in 02-responsibilities.md