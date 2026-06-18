# Anti-pattern — Proceeding without CONTEXT.md

**Violation:** CL-ONBOAR #1 and #4 — onboard completes without CONTEXT.md.

## Bad behavior

- Agent invokes with INT only
- ONBOARD §3 says "CONTEXT.md not available — inferred from README"
- `context_md_path` omitted from frontmatter

## Why wrong

- CONTEXT.md is **required** input per 04-io-contract IN-40
- EC-ENT-04 blocks invoke when CONTEXT missing
- WF-PROJECT-EXISTING quality gate G-WF-ONB-01 requires CONTEXT reference

## Correct behavior

1. Block at INIT if `{project_root}/CONTEXT.md` not readable
2. Set `context_md_path: CONTEXT.md` in frontmatter
3. Cite CONTEXT sections in §3 assessment
4. If human must create CONTEXT first — escalate OUT-05 with clear prerequisite list