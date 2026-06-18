# Minimal context (survey fixture)

OAuth via `src/auth/oauth.ts`. Express API under `src/api/routes/`. PostgreSQL via `pg`. No existing `users/profile` route module.

## Modules

| Path | Role |
|------|------|
| `src/api` | HTTP routes |
| `src/auth` | OAuth middleware |
| `tests/api` | Integration tests |