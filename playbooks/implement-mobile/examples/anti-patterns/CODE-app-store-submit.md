---
anti_pattern_id: CODE-app-store-submit
severity: P0
related_ec: EC-SCP-02
fails_checklist: 6
---

# Anti-Pattern — App Store Submit Without Gate

## What goes wrong

Agent completes implementation and includes app store submission:

```bash
# ⛔ FORBIDDEN in PB-implement-mobile output
eas submit --platform ios --latest
fastlane deliver --submit_for_review true
```

Or in CODE §6:

```yaml
release:
  store: App Store
  status: submitted
  build_number: 42
```

## Symptoms

- H-IMPLEMENT and H-VERIFY bypassed
- Untested build submitted to store review
- CL-IMPLEMENT-MOBILE #6 fail
- Release incident risk before PB-verify

## Correct pattern

Document tests in §6; hand off with `decision: pending`. App store submission is **human-only** after H-VERIFY and release process.

```yaml
gate_id: H-IMPLEMENT
decision: pending
recommended_next_skill: PB-verify
# No app store submit commands
```

## Prevention

- CL-IMPLEMENT-MOBILE check #6
- 09-system-prompt NEVER app store submit binding
- N8 in 02-responsibilities.md
- STOP step in 03-workflow.md