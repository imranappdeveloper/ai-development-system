# STD-CTX-001 — Context Loading

| Field | Value |
|-------|-------|
| standard_id | STD-CTX-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Define **how much** and **which** files agents load per invocation — tiered, budgeted, minimal-by-default.

## Scope

- Playbook `05-context.md` policies
- Orchestrator envelope assembly (`DESIGN.md` §8)
- Excludes: what to persist (**STD-MEM-001**), prompt wording (**STD-PROMPT-001**)

## Rules

### Tiers (MUST)

| Tier | Contents | Budget share | Loader |
|------|----------|--------------|--------|
| T0 | IDs, phase, command, skill_id | fixed minimal | Orchestrator or skill |
| T1 | WR frontmatter, last handoff summary | ≤ 5% | Skill |
| T2 | Artifact paths + digests (not full bodies) | ≤ 8% | Skill |
| T3 | Deep reads per playbook policy | remainder | Skill only |

Orchestrator MUST NOT load T3 for domain playbooks.

### Load order (MUST)

1. `AI_DEV_OS_HOME` INDEX slice (workflow + skill status)
2. WR for `work_id`
3. Required upstream artifacts per `04-io-contract.md` IN-*
4. `CONTEXT.md` slice only if playbook `05-context.md` allows
5. Never load unrelated project directories

### Forbidden paths (MUST NOT)

- `.env`, credentials, private keys
- `node_modules/`, `vendor/`, build artifacts (unless skill is survey/implement with explicit scope)
- Other projects' `work/` trees
- Full git history or all closed WRs

### Context plan (SHOULD)

Playbooks with T2+ SHOULD document `context_reload_list` in handoff for next session.

### Degradation (MUST)

On budget exceed: drop T3 → summarize T2 → escalate per orchestrator E-CONTEXT (**STD-PERF-001**).

## Examples

| Skill | T1 | T2 | T3 |
|-------|----|----|-----|
| PB-intake-classify | WR | INT on revise | CONTEXT.md module map only |
| PB-discovery-research | WR + INT path | INT digest | CONTEXT.md bounded |
| ORCH-PROJECT | ORS + WR header | artifact index paths | none |

## Exceptions

- `PB-survey-codebase` / `PB-implement` MAY expand T3 with explicit path allowlist in `05-context.md`
- Chat-only agents: full artifact in OUT-* with `persist: pending` — see **STD-MEM-001**
- Meta skills reviewing OS repo MAY load full `standards/` at T3

## Validation

| Check | Pass |
|-------|------|
| C-CTX-01 | `05-context.md` declares tiers and % caps |
| C-CTX-02 | Forbidden paths listed |
| C-CTX-03 | No full PRD/DISC in orchestrator envelope |
| C-CTX-04 | `context_reload_list` in handoff when T2+ used |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-MEM-001 | Persisted vs loaded context |
| STD-PERF-001 | Token budgets and degradation |
| STD-SEC-001 | Forbidden credential paths |
| STD-PROMPT-001 | How prompts reference load lists |
| STD-ARTIFACT-001 | WR `artifacts[]` index |