# Anti-pattern — Agent overrides intake workflow

**Violation:** CL-MAINT #2 — MAINT `workflow_id` disagrees with INT without documented path.

## Bad MAINT frontmatter

```yaml
workflow_id: WF-FEATURE
```

When INT says `work_type: maintenance` / `WF-MAINTENANCE`.

## Why wrong

- PB-intake-classify owns classification
- Triage may route **items** to WF-* in §3 — not change parent workflow_id

## Correct behavior

```yaml
workflow_id: WF-MAINTENANCE
```

For post-release operate with INT `WF-RELEASE`:

```yaml
workflow_id: WF-RELEASE
upstream_rel_path: work/release/WR-REL-001.md
```