---
anti_pattern_id: TEST-GEN-no-file-paths
severity: P0
related_ec: EC-MAP-02
fails_checklist: 5
---

# Anti-Pattern — Empty Generated Files Catalog

## What goes wrong

Agent writes test files but omits paths from TEST-GEN §3:

```markdown
## 3. Generated Files Catalog

| Path | file_action | Layer | TC-* refs | Notes |
|------|-------------|-------|-----------|-------|
| — | — | — | — | Tests written to project |
```

Or claims generation without persisting catalog rows.

## Symptoms

- CL-TEST-GEN #5 fail
- PB-verify cannot locate generated tests
- PB-review lacks traceability to TC-*
- Audit trail broken at H-VERIFY

## Correct pattern

Every `created` / `updated` file must appear in §3:

```markdown
## 3. Generated Files Catalog

| Path | file_action | Layer | TC-* refs | Notes |
|------|-------------|-------|-----------|-------|
| tests/contract/test_preferences_api.py | created | contract | TC-001–TC-004 | Preferences API contract suite |
| tests/unit/test_preferences_repository.py | created | unit | TC-005, TC-006 | Repository + migration |
```

## Prevention

- CL-TEST-GEN check #5
- AC-FIL-01 + AC-FIL-02 in 06-quality.md
- P5 + P7 primary responsibilities in 02-responsibilities.md