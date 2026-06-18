# PB-intake-classify

**Intake & Classify Work** — the entry playbook for the AI Development Operating System.

| Field | Value |
|-------|-------|
| skill_id | `PB-intake-classify` |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-INTAKE` (human) |
| path | `{AI_DEV_OS_HOME}/playbooks/intake-classify/` |

---

## Table of Contents

- [Overview](#overview)
- [Responsibilities](#responsibilities)
- [Workflow](#workflow)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Common Mistakes](#common-mistakes)
- [Version History](#version-history)
- [Future Improvements](#future-improvements)
- [Specification Index](#specification-index)

---

## Overview

PB-intake-classify transforms an **unstructured work request** into a **classified, routable intake record (INT)** linked to a **Work Record**. It answers three questions before any planning or implementation:

1. **What type of work is this?** (`work_type`)
2. **Which workflow should run?** (`workflow_id`)
3. **What project context applies?** (`entry_mode`)

The skill stops after human-ready handoff. It does **not** plan, design, implement, or start the next playbook.

```
Raw request → Classify → INT + Work Record → CL-INTAKE → Handoff → H-INTAKE (human) → Next skill (recommended only)
```

### Problem it solves

Work enters the OS as raw, ambiguous input: a chat sentence, bug report, feature idea, maintenance alert, or "fix this" with no context. Without classification, wrong workflows get invoked, wrong documents get produced, scope gets misread, and session context is lost. This playbook solves **routing at the front door** — producing one authoritative intake artifact that downstream playbooks and humans can trust.

### Single responsibility

> **Classify incoming work and produce an approved-ready intake record. Nothing else.**

Sub-steps (persist, validate, handoff) are mandatory parts of intake completion — not separate playbooks.

### When to use

| Condition | Required |
|-----------|----------|
| New work item — no classified Work Record exists | Yes |
| Raw input exists (request, report, idea, alert) | Yes |
| Human wants OS-guided delivery | Yes |
| Workflow phase is **Intake** (pre-H-INTAKE) | Yes |

**Typical triggers:** "Build X", "Fix this bug", "Prepare release", "Onboard this repo to the OS"; new ticket without `work_type`; maintenance batch; H-INTAKE revise loop.

### When not to use

| Situation | Use instead |
|-----------|-------------|
| H-INTAKE already approved (unless explicit revise) | Downstream playbook for that workflow |
| Informational question only | Direct answer or docs lookup |
| Work mid-flight (Implement, Verify, etc.) | Phase-appropriate playbook |
| User wants PRD, architecture, issues, or code | PB-draft-prd, PB-draft-architecture, PB-implement, etc. |
| Deep discovery needed before routing | PB-discovery-research, then re-intake |

### Prerequisites

| Requirement | Path / variable |
|-------------|-----------------|
| AI Dev OS | `AI_DEV_OS_HOME` (default: `/data/project/ai-development-system`) |
| Workflow catalog | `{AI_DEV_OS_HOME}/INDEX.md` |
| Intake checklist | `{AI_DEV_OS_HOME}/checklists/intake.md` |
| System prompt | [09-system-prompt.md](./09-system-prompt.md) |
| Optional project context | `{project_root}/CONTEXT.md` |

---

## Responsibilities

### Responsibility model

| Actor | Role at intake |
|-------|----------------|
| **Agent** | Proposes classification, drafts INT, self-validates (CL-INTAKE), hands off |
| **Human** | Approves, revises, or rejects at **H-INTAKE**; final authority on type, workflow, entry mode, priority |
| **Workflow** | Invokes this playbook at Intake phase; advances only after human approval |

### Primary duties (P1–P10) — every run

| # | Duty | Done when |
|---|------|-----------|
| P1 | Parse raw input | Key fields identified or marked `unknown` with blocker |
| P2 | Detect entry mode | `new_project` \| `existing_project` \| `normal` proposed with evidence |
| P3 | Classify work type | One of 11 SDLC types proposed with rationale |
| P4 | Select workflow | `workflow_id` proposed; exists in OS catalog |
| P5 | Document rationale | Why this type fits; rejected alternatives noted |
| P6 | Declare confidence | `high` \| `medium` \| `low` per rules below |
| P7 | Produce INT | Complete per template and I/O contract |
| P8 | Define scope boundary | In-scope / out-of-scope at intake granularity only |
| P9 | Run CL-INTAKE | Validation record = pass, or escalate |
| P10 | Prepare handoff | Summary, outputs, open questions, approval block |

### Secondary duties (S1–S10) — when applicable

| # | Duty | When |
|---|------|------|
| S1 | Read project context | `normal` or `existing_project` — T1 CONTEXT slice only |
| S2 | Verify project exists | Entry mode detection |
| S3 | Extract reproduction signals | `work_type: bugfix` |
| S4 | Extract security signals | CVE, audit, vulnerability language |
| S5 | Extract release signals | Version, changelog, deploy language |
| S6 | Suggest priority | Any work type — suggestion only |
| S7 | Identify missing input | Blocking gaps before handoff |
| S8 | Recommend next artifacts | Template table only — no drafting |
| S9 | Link related work | Prior work_id, issue, or PR referenced |
| S10 | Handle revise loop | Incorporate human notes; increment revision |

### Explicit non-responsibilities (N1–N23)

The agent **must not**:

| Category | Forbidden |
|----------|-----------|
| Planning & design | Write PRD, discovery, architecture, feature specs, or decompose issues (N1–N6) |
| Execution & verification | Write code, run tests/CI, review code, release/deploy, onboard project (N7–N11) |
| Governance | Approve intake, advance workflow, auto-invoke next skill, waive standards, modify OS files (N12–N16) |
| Research | Deep codebase survey, stakeholder interviews, as-is analysis, root cause analysis (N17–N20) |
| Data & memory | Update CONTEXT.md, store decisions only in chat, rely on vendor AI memory as SSOT (N21–N23) |

### Agent vs human matrix

| Task | Agent | Human |
|------|-------|-------|
| Parse, classify, select workflow, set entry mode | proposes | **approves / revises / rejects** |
| Assign final priority | suggests | **decides** |
| Complete INT | drafts | **approves** at H-INTAKE |
| CL-INTAKE self-check | executes | reviews evidence |
| Advance to next workflow step | **never** | after H-INTAKE approval |

Detail: [02-responsibilities.md](./02-responsibilities.md)

---

## Workflow

### Ten-step execution

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Check entry criteria; load OS bundles (INDEX, CL-INTAKE, spec) |
| 2 | PARSE | Extract title, problem, requester, urgency from `raw_request` |
| 3 | DETECT | Determine `entry_mode` from input + project existence |
| 4 | CTX | Load CONTEXT.md slice (module map only; ≤12% token budget) |
| 5 | CLASS | Map to one `work_type` using priority rules |
| 6 | WF | Select `workflow_id` from catalog |
| 7 | DOC | Build INT (or partial handoff if `low` confidence) |
| 8 | PERSIST | Write INT + Work Record to project `work/` |
| 9 | VAL | Run CL-INTAKE (10 checks); recovery loop ≤3 attempts |
| 10 | HAND | Emit handoff package; **stop** — await H-INTAKE |

```mermaid
flowchart LR
    INIT[1 Initialize] --> PARSE[2 Parse]
    PARSE --> DETECT[3 Detect entry mode]
    DETECT --> CTX[4 Load CONTEXT slice]
    CTX --> CLASS[5 Classify]
    CLASS --> WF[6 Select workflow]
    WF --> DOC[7 Build INT]
    DOC --> PERSIST[8 Persist]
    PERSIST --> VAL[9 CL-INTAKE]
    VAL --> HAND[10 Handoff]
    HAND --> H[H-INTAKE]
```

### Classification priority

When multiple signals match, apply first strong match:

`security` → `release` → `maintenance` → `documentation` → `bugfix` → `performance` → `refactor` → `enhancement` → `feature` → `new_project` → `existing_project`

Tie-break: prefer simpler type (e.g. bugfix over feature).

### Confidence rules

| Level | Criteria | Agent obligation |
|-------|----------|------------------|
| `high` | Clear signals; one obvious type | Proceed to handoff |
| `medium` | Reasonable fit; one alternative rejected | Document alternative in rationale |
| `low` | Insufficient signal; multiple valid types | List blockers; recommend discovery — **do not guess** |

### Gates

| Gate | Type | Pass condition |
|------|------|----------------|
| **CL-INTAKE** | Agent self-check | All 10 validation items pass |
| **H-INTAKE** | Human | `approve` \| `revise` \| `reject` |

**CL-INTAKE checks (10):**

1. `work_type` set OR low-confidence path with blockers + alternatives
2. `workflow_id` exists in INDEX
3. `entry_mode` has evidence
4. `classification_rationale` ≥2 sentences; medium includes rejected alternative
5. `problem_statement` present
6. `in_scope` and `out_of_scope` present
7. `recommended_next_artifacts` table ≥1 row
8. No PRD / discovery / issue / code content
9. Work Record `status: intake_pending_review`
10. Human approval `decision: pending` only

### Revise loop

Human `revise` at H-INTAKE → re-enter at **Parse** with `human_revise_notes` → increment `revision` → full CL-INTAKE again.

### Recovery

CL-INTAKE fail → fix by category (≤3 attempts) → escalate **OUT-05** if exhausted.

Detail: [03-workflow.md](./03-workflow.md)

---

## Inputs

**Contract rule:** Agent must not rely on inputs not listed here. Undocumented I/O is forbidden.

### Invoke template

```yaml
mode: new | revise
work_id: WR-optional
project_root: /absolute/path/to/project
ai_dev_os_home: /data/project/ai-development-system

raw_request: |
  <your request>

human_revise_notes: |
  <only if mode: revise>
```

### Required inputs

| ID | Field | Source | Description |
|----|-------|--------|-------------|
| IN-01 | `skill_invocation` | Workflow or human | Intent to start intake; phase = Intake |
| IN-10 | `raw_request` | Human | **Required.** Work request text, ticket, or report |
| IN-20 | `ai_dev_os_home` | Environment | Global OS path (`AI_DEV_OS_HOME`) |
| IN-30 | `workflow_catalog` | OS | `{ai_dev_os_home}/INDEX.md` |
| IN-31 | `checklist_intake` | OS | `{ai_dev_os_home}/checklists/intake.md` |
| IN-32 | `skill_spec` | OS | This playbook directory |
| IN-33 | `work_type_matrix` | OS | SDLC routing reference |

### Conditional inputs

| ID | Field | When required |
|----|-------|---------------|
| IN-02 | `work_id` | Revise loop; optional on new (agent proposes) |
| IN-03 | `revision` | Revise loop (must equal prior + 1) |
| IN-11 | `title` | Optional — derived from `raw_request` if absent |
| IN-12 | `problem_statement` | Optional — derived if inferable |
| IN-13 | `requester` | Optional — defaults to `unknown` |
| IN-14 | `urgency_hint` | Optional — maps to suggested P0–P3 |
| IN-15 | `work_type_hint` | Optional — non-binding signal |
| IN-21 | `project_root` | **Required** for `normal` / `existing_project` |
| IN-40 | `context_md` | When project exists — T1 slice only |
| IN-41 | `work_record` | Revise loop or continuing work |
| IN-50 | `human_revise_notes` | **Required** on H-INTAKE revise |
| IN-51 | `prior_intake_artifact` | **Required** on revise loop |

### Input matrix by entry mode

| Input | new_project | existing_project | normal | revise |
|-------|-------------|------------------|--------|--------|
| IN-10 raw_request | R | R | R | R |
| IN-21 project_root | O | R | R | R |
| IN-40 context_md | — | R | R | O |
| IN-50 revise_notes | — | — | — | R |
| IN-51 prior_intake | — | — | — | R |

`R` = required · `O` = optional · `—` = skip

### Context constraints

- Load **CONTEXT.md module map only** — never `src/**`
- Token budget ≤12% of session total
- Forbidden paths: `src/**`, `node_modules/**`, `.git/**`, secrets files

Detail: [04-io-contract.md](./04-io-contract.md) · [05-context.md](./05-context.md)

---

## Outputs

Produced in **fixed order** every successful run:

| # | ID | Name | Destination |
|---|-----|------|-------------|
| 1 | OUT-01 | **INT** (intake artifact) | `{project_root}/work/intake/{work_id}.md` |
| 2 | OUT-02 | **Work Record** | `{project_root}/work/{work_id}.md` |
| 3 | OUT-03 | **Validation Record** | Embedded in handoff |
| 4 | OUT-04 | **Handoff Package** | Human review channel |
| 5 | OUT-05 | **Escalation Package** | On irrecoverable failure only |

### OUT-01: INT artifact (required fields)

**Frontmatter:**

```yaml
document_id: INT-{work_id}
work_id: WR-###
work_type: <enum>
workflow_id: WF-*
entry_mode: new_project | existing_project | normal
classification_confidence: high | medium | low
status: draft | pending_review | approved | rejected
revision: 0
created: ISO-8601
```

**Body sections:** Title · Problem statement · Classification rationale · In-scope · Out-of-scope · Suggested priority · Recommended next artifacts (table) · Open questions · Blockers (if low confidence) · Human approval block (`decision: pending`).

### OUT-02: Work Record (minimum)

```yaml
work_id: WR-###
status: intake_in_progress | intake_pending_review | intake_approved | intake_rejected
work_type: <enum>
workflow_id: WF-*
entry_mode: <enum>
artifacts:
  - type: INT
    path: <OUT-01 path>
revision: 0
os_refs:
  skill: PB-intake-classify
  workflow_phase: Intake
```

### Work types → workflow → next playbook

| work_type | workflow_id | recommended_next_skill |
|-----------|-------------|------------------------|
| `new_project` | WF-PROJECT-NEW | PB-discovery-research |
| `existing_project` | WF-PROJECT-EXISTING | PB-onboard-project |
| `feature` | WF-FEATURE | PB-discovery-research or PB-draft-prd |
| `enhancement` | WF-ENHANCEMENT | PB-draft-prd |
| `bugfix` | WF-BUGFIX | PB-draft-issue |
| `refactor` | WF-REFACTOR | PB-draft-architecture |
| `security` | WF-SECURITY | PB-security-assess |
| `performance` | WF-PERF | PB-perf-baseline |
| `documentation` | WF-DOCS | PB-draft-doc-update |
| `release` | WF-RELEASE | PB-prepare-release |
| `maintenance` | WF-MAINTENANCE | PB-maintenance-triage |

**Rule:** Next playbook is **recommended only** — never auto-started.

Detail: [04-io-contract.md](./04-io-contract.md) · [09-system-prompt.md](./09-system-prompt.md)

---

## Examples

### Example 1: Feature request (happy path)

**Input**

```text
Add OAuth2 login for enterprise customers. SAML is out of scope for v1.
```

**Classification**

```yaml
work_type: feature
workflow_id: WF-FEATURE
entry_mode: normal
classification_confidence: high
suggested_priority: P2
recommended_next_skill: PB-discovery-research
```

**INT excerpt**

```markdown
## Problem Statement
Enterprise customers need OAuth2 login. ref: raw_request

## Classification Rationale
Request describes new capability (OAuth2) on existing app — feature not enhancement.
rejected: enhancement (net-new auth method)

## Human Approval
| decision | pending |
```

---

### Example 2: Bug fix with reproduction

**Input**

```text
Login fails with 500 when email contains '+'. Steps: 1) Register user+tag@test.com 2) Login. Expected: success. Actual: 500.
```

**Classification**

```yaml
work_type: bugfix
workflow_id: WF-BUGFIX
classification_confidence: high
recommended_next_skill: PB-draft-issue
```

**Expected:** Repro steps noted in INT; no solution code or PRD content.

---

### Example 3: New project (greenfield)

**Input**

```text
Build a new inventory API from scratch.
```

**Classification**

```yaml
work_type: new_project
workflow_id: WF-PROJECT-NEW
entry_mode: new_project
project_root: null
recommended_next_skill: PB-discovery-research
```

**Expected:** No `src/**` reads; CONTEXT skip logged.

---

### Example 4: Existing project onboarding

**Input**

```text
Adopt the AI Dev OS on this repository.
```

**Fixture:** Repo exists, no `CONTEXT.md`.

```yaml
work_type: existing_project
workflow_id: WF-PROJECT-EXISTING
entry_mode: existing_project
context_gap: CONTEXT.md missing
recommended_next_skill: PB-onboard-project
```

---

### Example 5: Security CVE

**Input**

```text
CVE-2024-XXXX in libfoo 2.1 — upgrade required.
```

**Classification**

```yaml
work_type: security
workflow_id: WF-SECURITY
classification_confidence: high
recommended_next_skill: PB-security-assess
```

**Expected:** No exploit PoC copied into INT.

---

### Example 6: Low confidence — split request

**Input**

```text
Upgrade React, fix the checkout bug, and ship v2.4 on Friday.
```

**Classification**

```yaml
classification_confidence: low
blockers:
  - Three work types in one request: maintenance, bugfix, release
recommended_action: split_request
```

**Expected behavior:** List options for human; do not force single `work_type`.

---

### Example 7: Revise loop

**Setup:** Example 1 classified as `feature` → human revises: "This is enhancement not new feature."

```yaml
mode: revise
work_type: enhancement
workflow_id: WF-ENHANCEMENT
revision: 1
```

**Expected:** Prior approvals preserved; full CL-INTAKE re-run; `human_revise_notes` reflected in rationale.

Full test catalog: [11-test-plan.md](./11-test-plan.md) (HT-01–HT-09, ET-*, FT-*, RT-*, ST-*, IT-*).

---

## Best Practices

### For humans

| Practice | Why |
|----------|-----|
| State **problem**, not solution | Keeps intake-level scope clean |
| Include repro steps for bugs | Enables confident `bugfix` classification |
| Provide `project_root` for existing repos | Required for normal/onboarding detection |
| Review INT at H-INTAKE, not chat | INT is SSOT |
| Use **revise** with specific notes | Vague "try again" causes loops (EC-HUM-01) |
| Split unrelated requests | One `work_type` per Work Record |

### For agents / prompt deployers

| Practice | Why |
|----------|-----|
| Use prompt temperature 0–0.2 | Reduces classification drift |
| Persist INT + WR before handoff | AC-PRD-01; session continuity |
| Load CONTEXT module-map only | 05-context budget |
| Cite `raw_request` quotes in rationale | AC-ACC-04 anti-hallucination |
| Always `decision: pending` | EC-CLS-06 |
| End at stop marker — no next skill | EC-CLS-07 |

### For maintainers

| Practice | Why |
|----------|-----|
| Run HT + ET(P0) before prompt bump | 11-test-plan promotion gate |
| Keep enums in one registry (planned) | Avoid multi-file drift |
| Version `prompt_version` with spec | Traceability |

Quality bar: [06-quality.md](./06-quality.md)

---

## Common Mistakes

| Mistake | Consequence | Correct approach |
|---------|-------------|------------------|
| Agent approves its own intake | Governance bypass | `decision: pending` only |
| Auto-start PB-draft-prd after intake | Skips H-INTAKE | Recommend in handoff |
| Classify everything as `feature` | Ceremony bloat | Use classification priority + KISS |
| Draft PRD inside INT | SSOT violation; CL-INTAKE fail | Templates table only |
| Read entire codebase to classify | Scope creep; token waste | CONTEXT slice + markers only |
| Guess on ambiguous input | Wrong workflow rework | `low` + blockers |
| Rely on chat history | Context loss | INT + Work Record |
| Copy secrets into INT | Security fail | Redact `[REDACTED]` |
| Re-intake after approve | Duplicate work | Waiver or amend WR |
| "Fix it" with no context | Blocking gap | Request problem statement |
| Absorb discovery into intake | SRP violation | Recommend PB-discovery-research |
| Self-set `intake_approved` | NEVER-list violation | Human only at H-INTAKE |

Edge catalog: [07-edge-cases.md](./07-edge-cases.md) (66 scenarios) · Limits: [08-limitations.md](./08-limitations.md)

---

## Version History

### Skill specification

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-06-18 | Initial complete spec (01–11); draft status; architect review Approve with changes |

### Prompt

| prompt_version | Date | Changes |
|----------------|------|---------|
| 1.0.0 | 2026-06-18 | Production prompt synthesized from specs 01–08; 10-step execution; CL-INTAKE 10 checks |

### Promotion status

| Milestone | Status |
|-----------|--------|
| Spec complete (01–11) | ✅ Done |
| Final README (this document) | ✅ Done |
| OS artifacts (TP-intake, CL-INTAKE, INDEX) | ✅ Done |
| `registry.yaml` + golden examples | ✅ Done |
| Test plan execution (promotion gate) | ✅ Foundation P0 evidence recorded |
| `status: active` | 🔒 Pending full RT suite automation |

**Promotion gate:** `HT 100%` AND `ET(P0) 100%` AND `FT 100%` AND `RT 100%` AND `IT 100%` AND `ST-01, ST-02` pass.

---

## Future Improvements

Prioritized from [10-review.md](./10-review.md):

### P0 — Before `active`

- [ ] `templates/intake/template.md` — INT SSOT template
- [ ] `checklists/intake.md` — CL-INTAKE checklist file
- [ ] Root `INDEX.md` — workflow catalog
- [ ] `registry.yaml` — enums + routing matrix (single source)
- [ ] `17-examples.md` — golden snapshots + anti-patterns
- [ ] Execute [11-test-plan.md](./11-test-plan.md) promotion gate

### P1 — Hardening

- [ ] `integrations.md` — downstream INT consumer contract
- [ ] `workflows/intake-router/` — parent workflow
- [ ] Stub downstream playbooks (PB-draft-prd, PB-onboard-project, etc.)
- [ ] Consolidated `16-failure-handling.md`
- [ ] `registry.yaml` → prompt validation script

### P2 — Scale

- [ ] JSON Schema validator for INT frontmatter
- [ ] `PB-intake-classify-batch` for maintenance batches
- [ ] Conformance CI on prompt changes
- [ ] i18n strategy for non-English requests

---

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists; boundaries |
| [02-responsibilities.md](./02-responsibilities.md) | P/S/O duties, N1–N23, gates |
| [03-workflow.md](./03-workflow.md) | Steps, decisions, recovery |
| [04-io-contract.md](./04-io-contract.md) | Canonical inputs & outputs |
| [05-context.md](./05-context.md) | Context loading & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-INTAKE map |
| [07-edge-cases.md](./07-edge-cases.md) | 66 failure scenarios |
| [08-limitations.md](./08-limitations.md) | Honest boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Principal architect review |
| [11-test-plan.md](./11-test-plan.md) | Validation & promotion gate |

---

## Quick Reference

```text
Invoke  → raw_request + project_root (if existing) + AI_DEV_OS_HOME
Produce → INT + Work Record + Validation + Handoff (fixed order)
Gate    → CL-INTAKE (agent, 10 checks) then H-INTAKE (human)
Stop    → await H-INTAKE; recommend next skill only — never auto-start
```