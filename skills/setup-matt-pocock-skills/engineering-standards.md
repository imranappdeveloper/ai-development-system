# Engineering Standards

Implementation-time standards for AFK agents (`/work-to-pr-v2`). **Not** planning requirements — child issue acceptance criteria define *what* to build; this file defines *how* to code it in **this** repo.

## Priority (always apply in this order)

1. **Neighbouring code** in the area you are touching — match patterns, naming, and structure
2. **This file** — where repo-wide conventions are recorded
3. **Framework idioms** — only when 1 and 2 are silent on a standard practice (logging, validation, etc.)
4. **Textbook patterns** (SOLID, clean architecture) — **never** override 1–3; never introduce via drive-by refactor

## Precautions (mandatory)

- **Do not force clean architecture** on a repo that does not already use it
- **Do not restructure** modules, layers, or folders to match an ideal pattern — unless the issue explicitly requires it
- **No scope creep** — a bugfix or small feature does not justify architecture migration
- **When the repo is inconsistent** — match the **local neighbourhood** (same package/folder), note inconsistency in the PR body, do not "fix the whole repo"
- **When unsure** — follow the closest existing example in `src/`; prefer the older/more-used pattern over a newer outlier

## Architecture profile

<!-- Filled by /setup-matt-pocock-skills from codebase detection. One of: -->

**Profile:** `<!-- conventional | layered | mvc-service | modular-monolith | unknown -->`

**Summary:** <!-- e.g. "Flat src/ with feature folders; no domain/infrastructure split" -->

**Dependency rule for this repo:** <!-- e.g. "Features import shared lib; no cross-feature imports" OR "N/A — match neighbours" -->

### What this profile means for agents

| Profile | Agent behaviour |
|---|---|
| `layered` | Respect documented layer boundaries; depend inward only where the repo already does |
| `mvc-service` | Controllers → services → data access; match existing separation |
| `conventional` / `modular-monolith` | Match feature-folder structure; no new global layers |
| `unknown` | **Match neighbours only** — do not infer or impose architecture |

**Clean architecture:** Apply **only** when profile is `layered` **and** the repo already has domain/use-case/infrastructure (or equivalent) folders. Otherwise **ignore** clean-architecture guidance.

## Logging

<!-- Filled from detection or left as framework default -->

- **Logger:** <!-- e.g. `src/lib/logger.ts` — winston / pino / logrus / @/utils/log -->
- **Format:** <!-- structured JSON | plain text | match existing -->
- **Levels:** <!-- when to use debug / info / warn / error -->
- **Where to log:** Boundaries (API entry/exit, external I/O, job start/end). Not every helper line.
- **Where not to log:** Hot loops, tight domain logic, secrets/PII

If no project logger exists: use the framework's standard logger idiomatically; do not introduce a new logging library in a feature issue.

## Error handling

- **Pattern:** <!-- e.g. Result<T,E> | exceptions + AppError | Go error returns | HTTP Problem Details -->
- **Reference:** <!-- path to exemplar file -->
- **API/middleware mapping:** <!-- how domain errors become HTTP/status codes, if applicable -->
- **Rules:**
  - Never swallow errors silently (empty `catch`, log-and-ignore)
  - Do not leak stack traces or internal details to clients
  - Match existing error types in the same layer

## Validation & types

- **Input validation:** <!-- zod / joi / pydantic / bean validation / etc. — cite location -->
- **Types:** Prefer strict typing where the repo already uses it; do not rewrite untyped areas in unrelated issues

## Testing

- **Style:** Follow `/tdd` and tests in the same module (see `docs/agents/domain.md`)
- **Seams:** Prefer highest existing seam; do not add test-only dependency injection frameworks

## SOLID (actionable, profile-aware)

Apply only as concrete checks — not as refactoring mandates:

- **Single responsibility:** New files/modules should do one job; do not split existing stable modules unless the issue requires it
- **Open/closed:** Extend via existing patterns (subclasses, hooks, config) — do not redesign extension points
- **Liskov / Interface segregation / DIP:** Follow existing interfaces and ports **if the repo has them**; do not introduce new port/adapter layers in a `conventional` profile repo

## PR hygiene

- Diff scoped to the issue — no drive-by formatting or renames outside touch area
- No new dependencies unless the issue requires them or neighbours already use the same package
- No commented-out code, debug prints, or `TODO` without issue reference

## Examples in this repo

<!-- Setup fills from detection — 2–4 paths agents should mimic -->

| Concern | Exemplar |
|---|---|
| Feature module | `<!-- path -->` |
| Error handling | `<!-- path -->` |
| Logging | `<!-- path -->` |
| Tests | `<!-- path -->` |

## When this file is missing

If `docs/agents/engineering-standards.md` does not exist: match neighbouring code and framework idioms only; do not impose clean architecture or SOLID restructuring.