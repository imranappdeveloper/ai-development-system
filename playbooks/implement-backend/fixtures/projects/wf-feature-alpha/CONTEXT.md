# wf-feature-alpha — Project Context

| Field | Value |
|-------|-------|
| project | wf-feature-alpha |
| stack | Python 3.12, FastAPI, PostgreSQL |
| test_runner | pytest |
| api_base | `/api/v1` |
| auth | OAuth session cookie (`auth/` module) |

## Module Map

| module | path | purpose |
|--------|------|---------|
| routes | `src/routes/` | HTTP handlers |
| repositories | `src/repositories/` | Data access |
| migrations | `migrations/` | SQL migrations |
| tests | `tests/` | unit, contract, integration |

## Test Conventions

```bash
pytest tests/unit -v
pytest tests/contract -v
pytest tests/integration -v  # requires TEST_DATABASE_URL
```