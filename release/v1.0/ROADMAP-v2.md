# AI Development OS — Roadmap v2

| Field | Value |
|-------|-------|
| baseline | v1.0.0 (frozen 2026-06-18) |
| roadmap_version | 2.0 |
| status | active |
| updated | 2026-06-18 |

---

## Vision (Unchanged)

A production-grade, vendor-agnostic AI Development Operating System — from intake through delivery, with human gates and durable artifacts.

---

## v1.0 — Foundation ✅ FROZEN

**Shipped 2026-06-18.** No further architectural changes to v1.0 substrate.

- [x] 32 active delivery playbooks (full spine)
- [x] 14 workflows with normative specs
- [x] 18 standards (4 contracts + 14 engineering)
- [x] CI: catalog, routing sync, simulate-workflow, skill verify
- [x] Orchestrator + gates + routing-matrix + dependency graph
- [x] Foundation freeze sign-off

**Release bundle:** `release/v1.0/`

---

## v1.1 — Execution Depth (Q3 2026 target)

Focus: make the frozen specs **runnable** by agents, not just structurally valid.

| # | Initiative | Deliverable | Priority |
|---|------------|-------------|----------|
| 1.1 | Platform adapter stubs | `skills/` symlinks + vendor mapping doc per PB-* | P0 |
| 1.2 | Runtime E2E harness | Agent invocation test against fixture `wf-feature-alpha` | P0 |
| 1.3 | `12-qa-scenarios.md` rollout | ST suite on 31 remaining active skills (≥80% pass) | P1 |
| 1.4 | Checklist promotion | CL-* draft → active for quality + implement lanes | P1 |
| 1.5 | Promotion gate automation | HT/ET runner script wired to CI (non-blocking) | P2 |

**Exit criterion:** One live agent E2E run documented in orchestrator `11-test-plan.md`.

---

## v1.2 — Meta Layer (Q4 2026 target)

Focus: OS self-improvement skills.

| # | Initiative | Deliverable | Priority |
|---|------------|-------------|----------|
| 2.1 | MS-architecture-review | Full spec + active promotion | P1 |
| 2.2 | MS-dependency-analysis | Graph drift detection vs routing-matrix | P1 |
| 2.3 | MS-workflow-review | WF spec ↔ phases.yaml consistency checker | P2 |
| 2.4 | MS-standards-review | Standards compliance audit skill | P2 |
| 2.5 | MS-repository-review | Repo hygiene + SSOT integrity | P2 |
| 2.6 | MS-quality-review | Cross-skill quality regression | P2 |

**Exit criterion:** H-META gate exercised on at least one meta skill promotion.

---

## v1.3 — Scale & Polish (2027 target)

| # | Initiative | Deliverable |
|---|------------|-------------|
| 3.1 | Expanded examples | `examples/` per workflow archetype |
| 3.2 | Prompt libraries | `prompts/` curated patterns |
| 3.3 | Archetype playbooks | Enterprise / mobile / SaaS stress fixtures |
| 3.4 | Real-usage feedback | WR/ORS telemetry schema (opt-in) |
| 3.5 | Multi-team overlays | Optional `CONTEXT.md` governance extensions |

---

## v2.0 — Platform (Future)

Deferred until v1.x execution depth proven:

- Plugin registry for third-party playbooks
- Org governance overlays
- Automated H-* gate blocking in project CI (optional hard mode)
- Multi-orchestrator federation

See `FUTURE-ENHANCEMENTS.md` for detailed backlog.

---

## Version Policy

| Release | Trigger |
|---------|---------|
| v1.0.x | Patch — spec clarifications, fixture fixes, checklist promotion |
| v1.x.0 | Minor — new playbook, new workflow, meta skill active |
| v2.0.0 | Major — breaking contract, gate, or routing change |

Frozen snapshots under `release/v1.0/` are immutable reference points.