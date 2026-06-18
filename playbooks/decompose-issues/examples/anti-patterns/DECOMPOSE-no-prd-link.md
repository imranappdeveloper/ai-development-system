---
anti_pattern_id: DECOMPOSE-no-prd-link
severity: P0
related_ec: EC-LNK-01
fails_checklist: 4
---

# Anti-Pattern — Missing PRD Traceability

## What goes wrong

ISS-* artifact omits PRD reference:

```yaml
document_id: ISS-BE-001
work_id: WR-FEATURE-ALPHA
issue_type: backend
lane: backend
status: pending_review
# upstream_prd_path missing
```

References section:

```markdown
| artifact | path |
|----------|------|
| API | work/api/WR-FEATURE-ALPHA.md |
```

Manifest lacks `prd_alignment.prd_path`.

## Symptoms

- CL-DECOMP #4 fail
- Coverage map cannot be audited
- Implement lane loses requirement grounding
- H-DECOMPOSE reviewer cannot verify FR/NFR mapping

## Correct pattern

Every ISS-* and manifest must link PRD:

```yaml
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
```

```yaml
prd_alignment:
  prd_path: work/prd/WR-FEATURE-ALPHA.md
  alignment: aligned
```

## Prevention

- CL-DECOMP check #4
- AC-ACC-03 in 06-quality.md
- EC-LNK-01 in 07-edge-cases.md