# AI Development OS — Future Enhancements

| Field | Value |
|-------|-------|
| baseline | v1.0.0 (frozen) |
| updated | 2026-06-18 |
| status | backlog |

Enhancements below are **explicitly out of v1.0 scope**. They do not require architectural changes to the frozen substrate — they extend it.

---

## Category A — Execution & Automation

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-A01 | Platform adapter bundles under `skills/` | Map PB-* to Cursor/Claude/Grok skill formats | v1.1 |
| FE-A02 | Runtime agent E2E harness | Prove agents follow 09-system-prompt + CL-* under real invocation | v1.1 |
| FE-A03 | Automated HT/ET gate runners | Reduce manual promotion evidence burden | v1.1 |
| FE-A04 | `simulate-workflow.sh` → fixture walk | Validate artifact path creation per WF step | v1.2 |
| FE-A05 | ORS tick daemon (optional) | Persistent orchestrator state machine | v2.0 |

---

## Category B — Quality Depth

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-B01 | `12-qa-scenarios.md` on 31 skills | LIFECYCLE phase 6 stress coverage (currently 1/32) | v1.1 |
| FE-B02 | Checklist draft → active (20 CL-*) | Quality/implement lanes use placeholder checks | v1.1 |
| FE-B03 | Cross-skill integration test suite | Automated handoff validation INT→DISC→PRD→… | v1.2 |
| FE-B04 | Archetype stress fixtures | Enterprise, mobile, SaaS, legacy migration trees | v1.3 |
| FE-B05 | Golden artifact expansion | Per-workflow golden library under `examples/` | v1.3 |

---

## Category C — Meta & Self-Improvement

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-C01 | Promote 6 MS-* meta skills | OS review loop via H-META | v1.2 |
| FE-C02 | Graph drift CI check | `skill-dependency-graph.yaml` auto-diff on PR | v1.2 |
| FE-C03 | Standards compliance scanner | Audit playbooks against STD-* AC tables | v1.2 |
| FE-C04 | Substrate readiness dashboard | Live score from CI scripts | v1.3 |

---

## Category D — Developer Experience

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-D01 | `prompts/` library | Reusable prompt patterns outside playbooks | v1.3 |
| FE-D02 | Skill scaffold generator | `create-skill` CLI from _contract-scaffold | v1.2 |
| FE-D03 | Workflow visualizer | Render phases.yaml as interactive DAG | v1.3 |
| FE-D04 | CONTEXT.md bootstrap wizard | Onboard existing projects faster | v1.2 |
| FE-D05 | Work Record browser | Human UI for WR/ORS/gate history | v2.0 |

---

## Category E — Distribution & Governance

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-E01 | Signed release bundles | Cryptographic freeze manifests | v1.2 |
| FE-E02 | Multi-team governance overlays | Org-specific gate policies | v2.0 |
| FE-E03 | Plugin registry | Third-party playbook packs | v2.0 |
| FE-E04 | Hard-mode enforcement | CI blocks on CL-* fail in target repos | v2.0 |
| FE-E05 | Semver auto-bump on registry change | STD-VER-001 automation | v1.2 |

---

## Category F — Workflow Extensions

| ID | Enhancement | Rationale | Target |
|----|-------------|-----------|--------|
| FE-F01 | WF-MIGRATION slice | Legacy system migration path | v1.3 |
| FE-F02 | WF-HOTFIX fast path | Expedited bugfix with waived gates | v1.2 |
| FE-F03 | WF-AUDIT operate class | Compliance audit workflow | v1.3 |
| FE-F04 | Parallel lane implement | Multi-lane H-IMPLEMENT coordination | v1.2 |
| FE-F05 | WF-FEATURE FEAT-path variant | Canonical E2E using PB-draft-feature instead of PRD | v1.1 |

---

## Explicitly Not Planned

| Item | Reason |
|------|--------|
| Embedded routing in playbook output | SSOT violation — frozen out |
| Chat-as-SSOT | Architectural invariant |
| Copying OS into project repos | Deployment model invariant |
| JSON skill schemas | Markdown-only spec format (OD-01) |

---

## Prioritization Matrix

| Impact / Effort | Low effort | High effort |
|-----------------|------------|-------------|
| **High impact** | FE-B02 checklist promotion, FE-A01 adapter stubs | FE-A02 runtime E2E, FE-C01 meta skills |
| **Medium impact** | FE-B01 qa-scenarios rollout | FE-D05 WR browser |
| **Low impact** | FE-D03 visualizer | FE-E03 plugin registry |

**Recommended v1.1 sprint order:** FE-A01 → FE-A02 → FE-B01 → FE-B02 → FE-F05