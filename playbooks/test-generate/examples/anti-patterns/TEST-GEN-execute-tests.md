---
anti_pattern_id: TEST-GEN-execute-tests
severity: P0
related_ec: EC-SCP-01
fails_checklist: 6
---

# Anti-Pattern — Execute Tests During Generation

## What goes wrong

Agent runs test commands and populates §6 Execution Evidence during PB-test-generate:

```markdown
## 6. Execution Evidence

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| pytest tests/contract/test_preferences_api.py -v | 0 | 2026-06-18T21:05:00Z |

### Results Summary

| Metric | Value |
|--------|-------|
| total | 4 |
| passed | 4 |
| failed | 0 |
```

## Symptoms

- CL-TEST-GEN #6 fail
- Generate/evidence conflation — STD-TEST-002 violation
- PB-verify cannot produce authoritative TEST-RPT
- Duplicate execution may mask flaky tests

## Correct pattern

```markdown
## 6. Execution Evidence

_generate_only — no tests executed during PB-test-generate. Evidence populated by PB-verify._
```

## Prevention

- CL-TEST-GEN check #6
- AC-EXE-01 + AC-EXE-02 in 06-quality.md
- N4 + N5 non-responsibilities in 02-responsibilities.md