# PB-survey-codebase — Context

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 05-context |

---

## Context Layers

| Layer | Sources | Budget |
|-------|---------|--------|
| T0 | Invocation envelope, `work_id`, `revision`, `scan_focus` | Fixed |
| T1 | INT full text, WR frontmatter, INDEX workflow row | ≤8% session |
| T2 | CONTEXT.md (if exists), README.md, root config markers | ≤12% session |
| T3 | **Bounded codebase reads** (allowlist below) | ≤25% session |

**Total survey budget:** ≤45% of session `token_budget_total`.

---

## T3 Path Allowlist (mandatory)

Reads **outside this list are forbidden**. Record every path in SURVEY §2 `scan_manifest.paths_read`.

| Path pattern | Purpose | Per-file cap |
|--------------|---------|--------------|
| `{project_root}/src/**` | Module structure, exports, headers | ≤80 lines or first 40 + signature block |
| `{project_root}/lib/**` | Shared libraries | ≤80 lines |
| `{project_root}/app/**` | Application entry, routes | ≤80 lines |
| `{project_root}/packages/**` | Monorepo packages (list + package.json) | package.json full; src ≤80 lines/pkg |
| `{project_root}/tests/**`, `{project_root}/test/**`, `{project_root}/__tests__/**` | Test layout, fixtures | Directory listing + 1 sample file ≤40 lines |
| `{project_root}/docs/**` | Documented architecture hints | ≤120 lines per file |
| `{project_root}/README.md` | Stack, setup | Full if ≤4KB else digest |
| `{project_root}/package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle*` | Dependency manifest | Full |
| `{project_root}/docker-compose*.yml`, `Dockerfile*` | Runtime topology | ≤60 lines |
| `{project_root}/.github/workflows/**` | CI signals | ≤60 lines per file |

### Global T3 caps

| Cap | Limit |
|-----|-------|
| Max distinct files read | **40** |
| Max total T3 lines ingested | **2,400** |
| Max single-file excerpt in SURVEY | **40 lines** |
| Directory listings | Names + one-line purpose only |

If caps approached, stop scan, document truncation in §9 Gaps, set `survey_confidence: low` if material areas unscanned.

---

## Forbidden Reads

| Path | Reason |
|------|--------|
| `{AI_DEV_OS_HOME}/playbooks/**` (except self + checklist) | OS spec noise |
| `{AI_DEV_OS_HOME}/workflows/project-orchestrator/routing-matrix.yaml` | No routing matrix in output |
| `node_modules/`, `vendor/`, `.git/`, `dist/`, `build/`, `target/` | Artifact noise |
| Secrets, `.env`, `*.pem`, `credentials*` | Security |
| Unrelated projects | Isolation |
| Binary / media blobs | No signal |
| Premature PRD/architecture in project `work/` | Flag anomaly; do not use as SSOT |

---

## Memory Strategy

| Rule | Action |
|------|--------|
| SSOT | SURVEY file + Work Record — not chat |
| Session | Cache INDEX + CL-SURVEY + scan manifest for run duration |
| Evidence | Record in SURVEY with `source` path + `reference` (line range or symbol) |
| Refresh | Load `prior_survey_artifact`; append `revision` history note |
| Digest | Large dirs → table of subdirs + file counts; no recursive dump |