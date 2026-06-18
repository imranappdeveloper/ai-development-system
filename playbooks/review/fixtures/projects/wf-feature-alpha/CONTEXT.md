# wf-feature-alpha — Fixture Context

| Field | Value |
|-------|-------|
| project | wf-feature-alpha |
| stack | Python 3.12, FastAPI, PostgreSQL |
| test_runner | pytest |
| review_policy | STD-REVIEW-001; P0 blocks merge |

## Conventions

- Structured logging with `request_id` per STD-LOG-001
- Contract tests under `tests/contract/`
- Unit tests under `tests/unit/`