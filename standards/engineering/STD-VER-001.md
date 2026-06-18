# STD-VER-001 — Versioning

| Field | Value |
|-------|-------|
| standard_id | STD-VER-001 |
| version | 1.0.0 |
| status | active |
| owner | Maintainer |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Semver and traceability rules for specs, prompts, OS foundation, and breaking change process.

## Scope

- `spec_version`, `prompt_version`, standard `version`, `FOUNDATION.md`, `CHANGELOG.md`, `registry.yaml` `changelog[]`
- Excludes: full breaking change process detail in **STD-SKILL-001** §15 — referenced here for skills only

## Rules

### Semver (MUST)

`MAJOR.MINOR.PATCH` for: standards, playbook specs, prompts, `FOUNDATION.md`.

| Bump | When |
|------|------|
| MAJOR | Breaking contract change (skill IN/OUT, exit_gate, required fields, standard rule tightened without waiver) |
| MINOR | Additive capability, new optional fields, new EC-* |
| PATCH | Clarifications, typos, non-behaviour prompt tuning |

### Independent prompt version (MAY)

`prompt_version` MAY PATCH independently if `spec_version` unchanged and behaviour identical.

### Traceability (MUST)

WR `os_refs` SHOULD record:

```yaml
os_refs:
  skill: PB-*
  spec_version: x.y.z
  prompt_version: x.y.z
  ai_dev_os_home: <path>
```

Foundation releases pin in `FOUNDATION.md` `version`.

### Changelog (MUST)

- OS-level: `CHANGELOG.md` per release section
- Skill-level: `registry.yaml` `changelog[]` on MINOR+
- Standards: metadata `version` + `CHANGELOG.md` entry

### Breaking changes (MUST)

Skills: follow **STD-SKILL-001** §15 (MAJOR bump, migration in README, routing update).

Standards: MAJOR bump + 90-day deprecation notice in prior version header when tightening MUST rules.

### Immutability (MUST)

After skill `active`: `skill_id` immutable (**STD-NAMING-001**). Changes via version bumps only.

### Foundation freeze (MUST)

`FOUNDATION.md` `status: frozen` + version tag when P0 complete and architect signs off.

## Examples

| Change | Bump |
|--------|------|
| New optional IN-* in playbook | MINOR |
| Remove required OUT-* | MAJOR |
| Fix typo in STD-MD-001 | PATCH |
| Tighten MUST → MUST with no waiver path in STD-SEC-001 | MAJOR |

## Exceptions

- `planned` stubs use `0.0.1-stub` until first real spec
- `routing-matrix.yaml` PATCH when derived regen from graph — no MAJOR if behaviour unchanged
- Emergency security PATCH in STD-SEC-001 MAY skip notice period with WR incident record

## Validation

| Check | Pass |
|-------|------|
| V-VER-01 | version field in every STD-* and playbook metadata |
| V-VER-02 | CHANGELOG entry for MINOR+ OS changes |
| V-VER-03 | registry changelog on skill MINOR+ |
| V-VER-04 | RT suite on prompt MINOR+ |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-SKILL-001 | Skill breaking change process |
| STD-NAMING-001 | ID immutability |
| STD-DOC-001 | Document status lifecycle |
| DOC-REPO-GOV-001 | Release lifecycle and breaking change batching |
| STD-TEST-001 | RT on version bumps |
| STD-PROMPT-001 | prompt_version binding |