---
anti_pattern_id: PERF-REVIEW-no-code-grounding
severity: P0
related_ec: EC-FND-01
fails_checklist: 2
---

# Anti-Pattern — Findings Without CODE Grounding

## What goes wrong

Agent lists generic performance advice with no CODE §4 path traceability:

```markdown
| PF-001 | should_fix | (general) | Consider caching | Add Redis |
```

## Symptoms

- CL-PERF-REVIEW #2 fail
- Findings not actionable for implement lane
- H-VERIFY cannot map to required fixes

## Correct pattern

Every finding must reference a CODE §4 path (or §3 issue_id). Use `src/routes/items.py` not `(general)`.