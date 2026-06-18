# wf-perf-alpha — Fixture Context

| Field | Value |
|-------|-------|
| stack | Python 3.12, FastAPI, PostgreSQL 16 |
| orm | SQLAlchemy 2.x |
| perf_conventions | List endpoints must paginate; default limit 25; max 100 |

## Test / benchmark notes

- Staging URL: `http://localhost:8000` (fixture only)
- Perf targets documented in `work/performance/WR-PERF-ALPHA.md`