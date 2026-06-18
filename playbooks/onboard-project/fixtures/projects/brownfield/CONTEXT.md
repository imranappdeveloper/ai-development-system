# Brownfield API — Project Context

## Stack

Node 20, Express, PostgreSQL, Redis queue.

## Layout

- `src/api/` — HTTP routes
- `src/db/` — migrations and repositories
- `docs/` — OpenAPI spec

## Modules

| Module | Role |
|--------|------|
| api | REST surface |
| db | Persistence layer |

## Conventions

- ESLint + Prettier
- Migrations in `src/db/migrations/`
- Env via `.env.example` (no secrets in repo)

## Configuration

| Var | Purpose |
|-----|---------|
| DATABASE_URL | Postgres connection |
| PORT | HTTP listen port |