# wf-security-alpha — Context

## Stack

- Runtime: Node.js 20
- Framework: Express 4
- Auth: JWT access + refresh tokens
- Test runner: `npm test`

## Security Conventions

- Session middleware: `src/middleware/session.ts`
- Rate limiting: `src/lib/rate-limit.ts`
- No secrets in logs — use `[REDACTED]` for token values