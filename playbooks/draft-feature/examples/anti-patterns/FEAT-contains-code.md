---
document_id: FEAT-WR-BAD-CODE
work_id: WR-BAD-FEAT-001
feat_type: new
feat_scope: narrow_slice
status: pending_review
upstream_disc_path: work/discovery/WR-BAD-FEAT-001.md
discovery_alignment: aligned
---

# FEAT — BAD EXAMPLE (contains code)

## User-Visible Behavior

Users update notification preferences.

```typescript
async function savePrefs(userId: string, prefs: Prefs) {
  await db.update('users', userId, { notification_prefs: prefs });
}
```

**Why anti-pattern:** CL-DRAFT #7 — no application code in FEAT. Defer to PB-implement after H-PLAN.