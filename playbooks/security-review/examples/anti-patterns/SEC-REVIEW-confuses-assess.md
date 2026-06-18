---
anti_pattern_id: SEC-REVIEW-confuses-assess
severity: P0
related_ec: EC-SCP-02
fails_checklist: 9
---

# Anti-Pattern — Confuse PB-security-assess with PB-security-review

## What goes wrong

Agent produces Plan-phase SEC-ASSESS instead of Verify-phase SEC-REVIEW:

```yaml
document_id: SEC-ASSESS-WR-SECURITY-ALPHA
# written to work/security/WR-SECURITY-ALPHA.md
```

Or invokes threat modeling without reading CODE:

```markdown
## Threat Model
Attacker may exploit SSRF via webhook callback...
```

## Symptoms

- CL-SECURITY-REVIEW #9 fail
- Wrong artifact type and path
- Plan-phase work during Verify
- No CODE §4 file traceability

## Correct pattern

| Playbook | Phase | Output path |
|----------|-------|-------------|
| PB-security-assess | Plan | `work/security/{work_id}.md` |
| PB-security-review | Verify | `work/security-review/{work_id}.md` |

Security review reads CODE, cites §4 files, produces SEC-REVIEW with findings — not a new threat model.