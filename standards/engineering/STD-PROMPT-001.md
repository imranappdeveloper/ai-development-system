# STD-PROMPT-001 — Prompt Design

| Field | Value |
|-------|-------|
| standard_id | STD-PROMPT-001 |
| version | 1.0.0 |
| status | active |
| owner | Prompt Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Rules for **deployable agent prompts** derived from playbook specs — not ad-hoc chat instructions. Prompts implement standards; they do not replace them.

## Scope

- `playbooks/*/09-system-prompt.md` production prompts
- Platform adapter copies under `skills/`
- Excludes: full skill contract (**STD-SKILL-001**), context tier definitions (**STD-CTX-001**), memory persistence (**STD-MEM-001**)

## Rules

### Location (MUST)

- SSOT: `playbooks/<name>/09-system-prompt.md` only
- `prompts/` directory MAY hold derived exports — never sole SSOT (**STD-DOC-001**)

### Markers (MUST)

```markdown
<!-- PROMPT_START -->
... deployable body ...
<!-- PROMPT_END -->
```

Content outside markers is spec commentary for humans.

### Structure (MUST)

1. Role one-liner (what the skill is)
2. Boundaries (what it does not do) — reference NEVER list
3. Execution steps (numbered, maps to `03-workflow.md`)
4. Output order (fixed OUT-* sequence per `04-io-contract.md`)
5. Stop condition (gate or handoff — no auto-chain)
6. NEVER / MUST NOT list (≤15 bullets, no duplication of full `02-responsibilities.md`)

### Reference over embed (MUST)

- Routing tables → `registry.yaml` or `routing-matrix.yaml` paths
- Enums → `registry.yaml` `enums:` or "use exact values from registry"
- Checklists → `checklists/<short>.md` by ID — do not paste all CL-* items

### Version binding (MUST)

- `prompt_version` in file metadata; bump per **STD-VER-001**
- WR `os_refs.prompt_version` recorded on run

### Vendor neutrality (SHOULD)

- No vendor-specific tool names unless in `08-limitations.md` adapter notes
- Use abstract capabilities: `read_file`, `write_file`, `invoke_playbook`

## Examples

**Good — reference SSOT:**
```markdown
Load routing from `{ai_dev_os_home}/playbooks/intake-classify/registry.yaml` → `intake_next_skill`.
```

**Bad — embedded SSOT:**
```markdown
| bugfix | PB-draft-issue |
| feature | PB-discovery-research |
```

## Exceptions

- Orchestrator prompt MAY list tick steps inline — normative detail remains in `DESIGN.md`
- Meta review prompts MAY reference report templates instead of OUT-* artifact paths
- Emergency hotfix: PATCH prompt wording without spec bump if behaviour unchanged (**STD-VER-001**)

## Validation

| Gate | Criteria |
|------|----------|
| P-PR-01 | PROMPT_START/END markers present |
| P-PR-02 | Output order matches `04-io-contract.md` |
| P-PR-03 | No embedded routing/enums duplicated from registry |
| P-PR-04 | NEVER list present |
| P-PR-05 | Stop / no auto-chain explicit |

G-SKILL-06 in **STD-SKILL-001** incorporates P-PR-* for promotion.

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-SKILL-001 | Mandatory prompt file in playbook set |
| STD-CTX-001 | Context loading instructions in prompts |
| STD-MEM-001 | What to persist vs return in output |
| STD-NAMING-001 | Enum value spelling |
| STD-SEC-001 | No secrets in prompts |
| STD-PERF-001 | Token budget directives |