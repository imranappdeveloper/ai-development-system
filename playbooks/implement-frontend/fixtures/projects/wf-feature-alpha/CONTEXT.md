# wf-feature-alpha — Project Context

| Field | Value |
|-------|-------|
| project | wf-feature-alpha |
| stack | React 18, TypeScript, Vite |
| test_runner | vitest + Playwright |
| api_base | `/api/v1` |
| auth | OAuth session cookie (client reads session state) |

## Module Map

| module | path | purpose |
|--------|------|---------|
| pages | `src/pages/` | Route-level screens |
| components | `src/components/` | Reusable UI |
| hooks | `src/hooks/` | Client logic and API clients |
| tests | `src/**/*.test.tsx`, `tests/e2e/` | component + e2e |

## Test Conventions

```bash
npm test
npx playwright test tests/e2e
```