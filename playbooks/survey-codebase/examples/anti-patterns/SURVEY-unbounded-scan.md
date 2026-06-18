# Anti-pattern — Unbounded codebase scan

**Violation:** CL-SURVEY #4 — paths must stay within 05-context.md allowlist and caps.

## Bad scan manifest

```yaml
scan_manifest:
  paths_read:
    - node_modules/lodash/index.js
    - .git/HEAD
    - vendor/acme/internal/all-sources.tar
    - src/legacy/  # 200 files read recursively
  files_touched: 247
```

## Why wrong

- `node_modules/`, `.git/`, `vendor/` are **forbidden** in 05-context.md
- 247 files exceeds **40-file cap**
- Full recursive dumps blow T3 budget and leak noise

## Correct behavior

```yaml
scan_manifest:
  paths_read:
    - src/api/routes/users.ts
    - package.json
  files_touched: 2
  t3_budget_pct: 12
```

Stop at cap; list unscanned areas in §9 Gaps. Set `survey_confidence: medium` if material gaps remain.