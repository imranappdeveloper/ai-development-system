# STD-MD-001 — Markdown

| Field | Value |
|-------|-------|
| standard_id | STD-MD-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Normative **markdown syntax and structure** for OS and project artifacts. Content semantics belong in other standards.

## Scope

- All `.md` files under `AI_DEV_OS_HOME` and project `work/` artifacts
- Excludes: YAML registries (`.yaml`), prompt marker conventions inside prompts (**STD-PROMPT-001**)

## Rules

### Metadata block (MUST)

OS standards and templates start with a metadata table or YAML frontmatter:

```markdown
| Field | Value |
|-------|-------|
| standard_id | STD-MD-001 |
| version | 1.0.0 |
```

Templates use YAML frontmatter per `templates/README.md` (`template_id`, `version`, `status`).

### Heading hierarchy (MUST)

- Single H1 (`#`) per file — title only
- Sections increment by one level — no skipped levels (H1 → H3 forbidden)
- Playbook specs: H1 matches filename topic; numbered files use consistent section IDs in prose (`EC-*`, `AC-*`) not in headings

### Tables (SHOULD)

- Use GFM tables for field catalogs, I/O contracts, checklists
- Align pipes for readability in SSOT files
- Wide tables MAY split into subsections — avoid horizontal scroll in review

### Code fences (MUST)

- Declare language on fenced blocks: `yaml`, `markdown`, `bash`, `mermaid`
- Mermaid for state/sequence in workflow and orchestrator docs only — not for normative rules
- Placeholder syntax in templates: `{{field}}` — instruction syntax: `[TODO: …]` per templates README

### Links (MUST)

- Relative links within repo: `[text](./path.md)` — no bare paths
- Standard references: by ID first (`STD-NAMING-001`), path second
- No URL shorteners in SSOT

### Line length (SHOULD)

- Prose lines ≤ 120 chars where practical
- Do not hard-wrap code blocks or tables

### Prohibited (MUST NOT)

- HTML entities in literals (`&amp;` for `&`) — use actual characters
- Embedding routing matrices as markdown tables when SSOT is YAML — reference file instead (**STD-NAMING-001** dedup)
- Secrets or live tokens in any markdown file (**STD-SEC-001**)

## Examples

```markdown
# Good — metadata + H2 sections
| Field | Value |
| version | 1.0.0 |

## Rules
```

```markdown
# Bad — skipped heading level
# Title
### Subsection
```

## Exceptions

- `09-system-prompt.md` MAY use `<!-- PROMPT_START -->` markers (**STD-PROMPT-001**) without H1 inside the prompt block
- Checklists MAY use numbered lists instead of tables for CL-* items
- Golden examples in `examples/golden/` MAY omit full metadata table if frontmatter YAML is present

## Validation

| Check | Pass |
|-------|------|
| M-MD-01 | One H1 per file |
| M-MD-02 | Fenced blocks have language tag |
| M-MD-03 | No secrets pattern (`api_key`, `password=`) |
| M-MD-04 | Template placeholders use `{{}}` not `{}` alone |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-DOC-001 | Which documents must exist |
| STD-PROMPT-001 | Prompt file markers |
| STD-ARTIFACT-001 | Artifact frontmatter fields |
| STD-NAMING-001 | File and path naming |