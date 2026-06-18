# PB-intake-classify — Principal Architect Review

| Field | Value |
|-------|-------|
| skill_id | PB-intake-classify |
| reviewer_role | Principal AI Systems Architect |
| review_date | 2026-06-18 |
| spec_range | 01-purpose through 09-system-prompt |
| document | 10-review |
| recommendation | **Approve with changes** — implement after P0 gaps closed |

---

## Executive Summary

PB-intake-classify is a **well-architected entry skill** with unusually strong specification depth for a personal AI Dev OS. Single responsibility is clear, boundaries are aggressively defended, and failure/context/quality dimensions are thought through.

**Verdict:** Ready for controlled implementation **after** closing infrastructure gaps (TP-intake, CL-INTAKE checklist, workflow INDEX, examples, downstream skill stubs). Do **not** ship prompt to production without golden-path validation.

| Dimension | Score (1–5) | Summary |
|-----------|-------------|---------|
| Single Responsibility | 4.5 | Strong; minor bundling of classify + persist + validate |
| Clarity | 4.0 | Excellent per-file; cross-file redundancy hurts navigation |
| Completeness | 3.5 | Missing template, checklist, examples, dependencies doc |
| Scalability | 3.5 | Enum/matrix sprawl across 6+ files |
| Maintainability | 3.5 | Needs SSOT registry for enums and routing |
| Reusability | 4.0 | Good OS-agnostic design; adapter-ready |
| Failure handling | 4.5 | 66 edge cases + recovery loops |
| Context management | 4.5 | Best-in-spec; budgets explicit |
| Integration | 3.0 | Downstream skills referenced but not contracted |

---

## 1. Single Responsibility Principle

### Assessment: **Strong (4.5/5)**

**What works**

- One-liner and purpose are unambiguous: *classify → INT → stop*.
- N1–N23 non-responsibilities and 08-limitations form a credible firewall.
- Explicit rejection of auto-chaining, PRD drafting, and codebase survey.
- Resolved decision: classify + write INT in one skill (not split) — correct for personal OS; avoids handoff gap.

**Concerns (minor SRP stretch)**

| Bundled concern | Lines blur with |
|-----------------|-----------------|
| Work Record lifecycle management | Thin workflow orchestrator |
| CL-INTAKE self-validation | Quality sub-skill |
| Handoff packaging | Presentation layer |
| Escalation packaging | Failure sub-skill |

These are **acceptable** if framed as *mandatory sub-steps of intake*, not separate capabilities. The spec mostly does this — but 09-system-prompt gives equal weight to 10 steps, which can feel like a mini-workflow (intentional).

**Recommendation**

- Add explicit statement in 01-purpose: *"Sub-steps (persist, validate, handoff) are part of intake completion, not separate skills."*
- Do **not** split PB-intake-classify unless revise-loop pain appears in real usage.

---

## 2. Clarity

### Assessment: **Good with navigation debt (4.0/5)**

**Strengths**

- Consistent metadata tables, IDs (`EC-*`, `AC-*`, `IN-*`, `OUT-*`), and cross-links.
- 03-workflow diagrams make execution path scannable.
- 08-limitations sets honest expectations — rare and valuable.
- 09-system-prompt is deployable without re-reading entire spec.

**Weaknesses**

| Issue | Impact |
|-------|--------|
| **Duplication** — workflow steps in 03, responsibilities in 02, prompt in 09 | Drift risk on enum/routing changes |
| **Missing INDEX** — spec references `INDEX.md`, `workflows/`, `checklists/intake.md` — not in repo | Agent cannot run CL-INTAKE against real files |
| **TP-intake undefined** — INT shape in 04-io-contract but no `templates/intake/` | Authors guess field semantics |
| **Numbering gaps** — README lists 10–17 pending; never written | Incomplete spec set vs README promise |
| **H-INTAKE** defined here but not in `workflows/` parent | Gate ownership unclear |

**Recommendation (P0)**

1. Create `templates/intake/template.md` — SSOT for INT shape.
2. Create `checklists/intake.md` — CL-INTAKE verbatim from 03-workflow VC-05.
3. ~~Add per-playbook routing-matrix~~ → **Resolved:** global `workflows/project-orchestrator/routing-matrix.yaml` + `registry.yaml` `intake_next_skill` (2026-06-18).
4. Add **Spec SSOT table** at top of README: which file owns enums, routing, CL-INTAKE.

---

## 3. Missing Responsibilities

Functions the skill **should** own but spec under-specifies:

| Gap | Risk | Suggested addition |
|-----|------|-------------------|
| **work_id generation algorithm** | Collisions (EC-ENV-02) | Document in 04-io-contract: slug + counter rule |
| **Secret/PII redaction procedure** | EC-SEC-* scattered | Single `redaction_ads` section in 04-io-contract or prompt step PARSE |
| **Anomaly detection** (premature PRD in repo) | EC-DOC-05 behavior only in edge cases | Primary responsibility S11: flag anomalies in INT |
| **Human question formatting** | EC-INC-01 REQ step vague | Standard question template in handoff |
| **Approval history append** | WR `approvals[]` on revise | Explicit OUT-H01 write responsibility on human side + agent stub |
| **spec_sha / prompt_version binding** | 09 prompt drifts from spec | WR `os_refs.spec_sha` required field |

Functions **correctly excluded** — do not add:

- Dedup, discovery execution, priority finalization, CONTEXT.md writes.

---

## 4. Redundant Responsibilities

| Redundancy | Locations | Action |
|------------|-----------|--------|
| Work type enum | 02, 03, 04, 06, 07, 09 | **Single YAML registry**; others reference |
| Next skill routing | 03, 04, 08, 09 | **routing-matrix.yaml** only |
| CL-INTAKE items | 03, 06, 09 | **checklists/intake.md** only |
| NEVER / non-responsibilities | 01, 02, 08, 09 | Keep 02 N-table as SSOT; 09 summary only |
| Context forbidden paths | 05, 08 | Keep 05; 08 links |
| Recovery loops | 03, 07, 09 | Keep 03 canonical; 07 by scenario; 09 abbreviated |
| INT required fields | 02, 04, 09 | **TP-intake** owns; 04 references template ID |

**Recommendation:** Introduce `playbooks/intake-classify/registry.yaml` as machine-readable SSOT; generate or validate 09-system-prompt against it pre-release.

---

## 5. Scalability

### Assessment: **Adequate for personal OS; needs work for growth (3.5/5)**

**Scales well today**

- Platform-agnostic playbook + adapter model.
- Advisory gates — no CI coupling.
- Progressive context disclosure — token-safe at many projects.

**Will not scale without change**

| Pressure | Break point |
|----------|-------------|
| New work_type / workflow | Edit 6+ files + prompt |
| Multi-team overrides | No overlay model (correct for personal OS) |
| 50+ downstream skills | Routing table manual |
| Batch intake (maintenance) | EC-MUL-01 human-heavy — no batch INT schema |
| Localization | EC-CTX-05 — no i18n strategy |

**Recommendations**

| Priority | Improvement |
|----------|-------------|
| P1 | `registry.yaml` for enums + routing |
| P2 | Plugin hook: `routing_extensions[]` in registry for custom work types |
| P3 | Optional `PB-intake-classify-batch` child skill for maintenance — don't bloat core |
| P4 | Document work_type addition checklist (one-page runbook) |

---

## 6. Maintainability

### Assessment: **Good spec hygiene; operational maintainability incomplete (3.5/5)**

**Strengths**

- Numbered spec files (01–09), revision history per doc.
- Measurable ACs in 06-quality — testable over time.
- prompt_version in 09 — version trace started.

**Gaps**

| Gap | Impact |
|-----|--------|
| No 17-examples.md | Cannot regression-test prompt changes |
| No automated spec ↔ prompt diff | Silent drift |
| `status: draft` on all files | No active/promotion gate |
| Downstream skills don't exist | Integration untested |
| 66 edge cases without priority tier | Maintainers can't tell P0 vs nice-to-have |

**Recommendations**

| Priority | Action |
|----------|--------|
| **P0** | Write 17-examples.md: 4 golden + 5 anti-pattern minimum |
| **P1** | Add `promotion-checklist.md`: draft → active criteria |
| **P1** | Tag edge cases: `tier: P0|P1|P2` in 07-edge-cases.md |
| **P2** | CI script: validate INT output against JSON Schema derived from TP-intake |

---

## 7. Reusability

### Assessment: **Strong design (4.0/5)**

**Reusable across**

- Any AI provider (09 adapter notes, LCD generic mode).
- Any project repo (global OS path + project CONTEXT).
- Any parent workflow needing H-INTAKE.

**Reuse blockers**

| Blocker | Fix |
|---------|-----|
| INT path convention hardcoded | Document as overridable in project CONTEXT.md |
| WR schema project-specific | Extract to `templates/work-record/` |
| Tight coupling to 11 SDLC work types | Registry abstraction |
| `recommended_next_skill` IDs assume future playbook tree | Stub README in each downstream playbook |

**Recommendation:** Publish **INT consumer contract** — minimal fields downstream skills must read:

```yaml
required_from_int:
  - work_type
  - workflow_id
  - entry_mode
  - problem_statement
  - classification_confidence
```

Add to 04-io-contract.md §Downstream contract.

---

## 8. Failure Handling

### Assessment: **Excellent (4.5/5)**

**Strengths**

- 03-workflow recovery loop with categorized failures.
- 07-edge-cases: 66 scenarios with human intervention flags.
- OUT-05 escalation template consistent across docs.
- Max 3 attempts — bounded agent loops.
- Revise loop separate from validation recovery — correct.

**Gaps**

| Gap | Recommendation |
|-----|----------------|
| No consolidated 16-failure-handling.md | Merge 03 recovery + 07 escalation catalog + OUT-05 |
| `recommended_action` outcomes not fully specified | Add outcome table: what human picks → what runs next |
| Partial INT on low confidence — CL-INTAKE pass rules fuzzy | Clarify: low + blockers = pass if items 1, 6, 7, 9, 10 pass |
| No telemetry / metrics | Optional: log `intake_duration`, `attempts`, `confidence` to WR metadata |

**Recommendation (P1):** Add failure decision tree diagram to consolidated failure doc.

---

## 9. Context Management

### Assessment: **Excellent (4.5/5)**

**Strengths**

- 05-context.md is production-grade: T0–T3, budgets, forbidden paths, digest rules.
- C1–C6 pre-handoff checks.
- WR > vendor memory — correct SSOT hierarchy.
- Entry-mode matrix reduces load.

**Gaps**

| Gap | Recommendation |
|-----|----------------|
| `context_bundles[]` in 05 not mirrored in 09 prompt tool list | Add explicit load list to prompt INIT |
| Digest generation algorithm shallow | Reference shared OS digest template |
| No session summary template linked | Add `templates/session-summary/` for EC-INC-08 |
| 12% budget — unmeasured without OUT-06 | Make OUT-06 required on generic provider |

**Recommendation:** No structural change — tighten prompt ↔ 05-context alignment in P0 prompt revision.

---

## 10. Integration with Other Skills

### Assessment: **Weak operational integration (3.0/5)**

**Designed well conceptually**

- Routing table names 11 downstream skills.
- OUT-04 recommends, never invokes — correct boundary.
- INT as SSOT for classification — right pattern.

**Not yet integrated**

| Missing integration artifact | Status |
|------------------------------|--------|
| Downstream playbooks (PB-draft-prd, etc.) | Not created |
| Parent workflow `WF-*` intake step | Not in `workflows/` |
| H-INTAKE gate in workflow gates.md | Spec-only |
| OS INDEX.md | Not populated |
| Consumer contract on downstream skills | One-way references only |
| Handoff to `PB-discovery-research` on low confidence | Skill doesn't exist |

**Recommendations (priority order)**

| P | Action |
|---|--------|
| **P0** | Create minimal `workflows/intake-router/README.md` referencing PB-intake-classify |
| **P0** | Stub downstream playbooks with `01-purpose.md` only — prove routing graph |
| **P1** | Add `integrations.md` in intake-classify: upstream (none) / downstream (list + required INT fields) |
| **P1** | Define H-INTAKE human UI: what fields human must confirm (checkbox template) |
| **P2** | Sequence diagram: intake → discovery → PRD happy path across skills |

---

## Critical Issues (Block Implementation)

| # | Issue | Severity |
|---|-------|----------|
| C1 | No `templates/intake/template.md` | **Blocker** |
| C2 | No `checklists/intake.md` (CL-INTAKE) | **Blocker** |
| C3 | No `INDEX.md` / workflow catalog in OS repo | **Blocker** |
| C4 | No 17-examples.md — prompt unvalidated | **Blocker** |
| C5 | Downstream skills are fictional IDs | **Blocker** for E2E, not for intake-only pilot |

---

## Improvement Backlog (Prioritized)

### P0 — Before first production use

1. Add `templates/intake/template.md` aligned with 04-io-contract OUT-01.
2. Add `checklists/intake.md` — CL-INTAKE 10 items.
3. Populate root `INDEX.md` with workflow IDs used in routing.
4. Add `playbooks/intake-classify/registry.yaml` (enums + routing matrix).
5. Write `17-examples.md` — goldens: feature, bugfix, new_project, low-confidence.
6. Align 09-system-prompt `spec_sha` with registry version; add validation step.

### P1 — Before calling skill `active`

7. Consolidate `16-failure-handling.md` from 03 + 07.
8. Add `integrations.md` + downstream INT consumer contract.
9. Create `workflows/intake-router/` parent workflow spec.
10. Stub downstream playbook folders (purpose only).
11. Tier P0 edge cases in 07-edge-cases.md.
12. Add promotion checklist draft → active.

### P2 — Hardening

13. JSON Schema for INT; optional validation script.
14. `templates/work-record/template.md`.
15. Batch intake child skill spec (don't expand core).
16. Conformance test plan in 06-quality appendix.
17. Generate 09-system-prompt sections from registry.yaml (DRY).

---

## Suggested Spec Structure After Changes

```
playbooks/intake-classify/
├── README.md                 # SSOT table + catalog
├── registry.yaml             # NEW — enums, routing, versions
├── 01-purpose.md
├── 02-responsibilities.md
├── 03-workflow.md
├── 04-io-contract.md         # + downstream consumer contract
├── 05-context.md
├── 06-quality.md
├── 07-edge-cases.md          # + tier tags
├── 08-limitations.md
├── 09-system-prompt.md       # validated against registry
├── 10-review.md              # this document
├── 16-failure-handling.md    # NEW — consolidated
├── 17-examples.md            # NEW — required before active
└── integrations.md           # NEW — optional P1
```

Deprecate duplicate numbering for unwritten 10-dependencies through 15-* unless still needed — merge into above.

---

## Architecture Decision Records (Suggested)

| ADR | Decision |
|-----|----------|
| ADR-IC-001 | Single skill for classify + INT (not split) — **affirm** |
| ADR-IC-002 | registry.yaml as enum SSOT — **propose** |
| ADR-IC-003 | INT template in OS templates/ not playbook — **propose** |
| ADR-IC-004 | Low confidence may pass CL-INTAKE with blockers — **clarify & document** |
| ADR-IC-005 | Downstream stubs required before `status: active` — **propose** |

---

## Final Recommendation

| Question | Answer |
|----------|--------|
| Is SRP sound? | **Yes** — keep unified intake skill |
| Is spec clear enough to implement? | **Almost** — close P0 gaps first |
| Safe to deploy 09-system-prompt now? | **No** — run against 17-examples first |
| Strongest part of spec? | Context (05) + edge cases (07) + I/O contract (04) |
| Weakest part? | Integration (downstream fiction) + missing OS artifacts |

**Proceed:** Implement OS artifacts (template, checklist, INDEX, registry, examples), then pilot intake-only on 3 real requests. Promote to `active` only after human H-INTAKE success rate acceptable and zero CL-INTAKE self-approval incidents.

---

## Foundation P0 Resolution (2026-06-18)

| Item | Status |
|------|--------|
| TP-intake | ✅ `templates/intake/template.md` |
| registry.yaml | ✅ `playbooks/intake-classify/registry.yaml` |
| Routing SSOT dedupe | ✅ `03-workflow`, `09-system-prompt` reference registry |
| Fixtures + goldens | ✅ `fixtures/`, `examples/golden/`, `examples/anti-patterns/` |
| Promotion evidence | ✅ Manual gate per `11-test-plan.md`; golden INT-feature-001 |

**Updated readiness:** 68/100 (substrate unblocked; automation pending).

---

## Sequential Gate Re-review (2026-06-18)

| Check | Result |
|-------|--------|
| `scripts/verify-skill-spec.sh` | PASS (0 fail, 0 warn after gate) |
| Fixtures ENV-04–05 | `project-alpha`, `project-greenfield`, `project-onboard` on disk |
| Golden STD §10.2 | `scenario_id: HT-01` block added |
| Anti-patterns | 3/3 (premature-prd, auto-chain, self-approved) |
| CL-INTAKE ↔ 06-quality | aligned (10 checks) |

**Sequential gate readiness: 76/100** — approved to hold `active`; automation (RT suite) remains P1.

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.1 | 2026-06-18 | Foundation P0 artifacts + routing dedupe |
| 1.0.0 | 2026-06-18 | Initial principal architect review |