# CONTEXT — wf-perf-alpha

| Field | Value |
|-------|-------|
| project | wf-perf-alpha |
| stack | Node.js API + PostgreSQL + Redis |

## Module map

| path | role |
|------|------|
| src/routes/items.ts | List endpoint handler |
| src/db/items.ts | List query |
| migrations/003_items_index.sql | `idx_items_created_at` |