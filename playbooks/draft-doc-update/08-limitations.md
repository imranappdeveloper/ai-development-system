# PB-draft-doc-update — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Write final documentation prose | Human execution post-H-PLAN |
| Guarantee every linked doc is fully read | Bounded inventory per 05-context.md |
| Resolve all open questions in one pass | Revise loop at H-PLAN |
| Replace missing quality-chain artifacts for complex release notes | Link REVIEW / SEC-REVIEW / PERF-REVIEW or human waiver |
| Produce accurate effort estimates per DU-* row | Human at execution |
| Validate technical accuracy of API examples | Human + CODE review |
| Change intake classification | Flag gap; human decides |
| Auto-publish docs to external portals | Human CI/CD |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed with `quality_chain_gap: missing` when release notes require review findings
- Accept `doc_plan_type: lite` for large multi-surface initiatives
- Approve `doc_scope: os_docs` edits to OS repository
- Execute §5 planned updates after H-PLAN approve

---

## AI / Context Limits

- Token budget caps per 05-context.md
- Doc tree listing — headers and metadata, not full corpus ingestion
- No cross-project memory
- Vendor chat history not SSOT
- Routing matrix not loaded into DOC-PLAN body
- Quality-chain build order (after PB-perf-review) does not block INT-only fixture runs

---

## WF-DOCS Terminal Behavior

WF-DOCS ends at H-PLAN. This playbook does not invoke implement, verify, or release skills. Humans (or future doc-authoring skills) execute the approved plan.