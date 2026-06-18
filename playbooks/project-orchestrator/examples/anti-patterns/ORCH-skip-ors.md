# Anti-pattern — Skip ORS persistence

**Violation:** NEVER #3 — tick completes without writing ORS.

## Bad behavior

```markdown
## Tick summary
Invoked PB-intake-classify successfully. Next: run discovery when ready.
```

No YAML ORS block; no file at `work/orchestrator/{work_id}.ors.md`.

## Why wrong

- AC-OUT-02 fail
- Work cannot `resume` after session ends
- Chat becomes implicit SSOT

## Correct behavior

Output order **strict**:

1. ORS YAML state block (ORCH-OUT-01)
2. Tick summary
3. Hold or next action

Persist to `{project_root}/work/orchestrator/{work_id}.ors.md` before narrative.