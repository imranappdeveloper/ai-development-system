---
anti_pattern_id: SEC-REVIEW-mutates-code
severity: P0
related_ec: EC-SCP-01
fails_checklist: 6
---

# Anti-Pattern — Mutate Code During Security Review

## What goes wrong

Agent patches repository files while performing review:

```text
Applied fix to src/middleware/session.ts — added fingerprint binding.
```

Or includes a diff in handoff:

```diff
+ const fingerprint = hash(req.headers['x-client-fingerprint']);
```

## Symptoms

- CL-SECURITY-REVIEW #6 fail
- Untested code changes outside PB-implement
- H-VERIFY evidence invalid — review mixed with implement
- Audit trail conflates review and implementation

## Correct pattern

Document finding only; recommend PB-implement revise:

```markdown
| F-001 | P1 | `src/middleware/session.ts` | Missing fingerprint binding | PB-implement-backend revise per SEC-ASSESS SA-003 |
```

Agent output ends with SEC-REVIEW persist — no file edits.