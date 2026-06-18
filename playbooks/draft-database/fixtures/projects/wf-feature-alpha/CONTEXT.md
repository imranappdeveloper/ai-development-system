# wf-feature-alpha — Project Context (fixture)

OAuth authentication via `auth/` module. Monolith: web frontend + REST API + PostgreSQL.

## Module map

| Module | Path | Notes |
|--------|------|-------|
| auth | `src/auth/` | OAuth session; do not modify for profile v1 |
| api | `src/api/` | REST handlers |
| web | `src/web/` | React SPA |

## Datastore

| Store | Type | Notes |
|-------|------|-------|
| primary | PostgreSQL 15 | Existing `users` table; no `user_preferences` yet |

No existing `users/profile` UI. GDPR email consent required for preference changes.