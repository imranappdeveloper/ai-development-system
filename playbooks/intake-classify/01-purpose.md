# PB-intake-classify — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-intake-classify |
| name | Intake & Classify Work |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Transform an unstructured request into a **classified, routable intake record** with a suggested workflow — and stop.

---

## What Problem Does It Solve?

Work enters the AI Dev OS as raw, ambiguous input: a sentence in chat, a bug report, a feature idea, a maintenance alert, or a "fix this" with no context.

Without classification:

| Failure | Cost |
|---------|------|
| Wrong workflow invoked | Rework loops (Implement → Plan) |
| Wrong documents produced | Wasted tokens and human review time |
| Scope misread | Bug treated as feature, or vice versa |
| Missing entry mode | Greenfield vs existing-project assumptions baked in wrongly |
| No Work Record anchor | Context loss across sessions |

**This skill solves the routing problem at the front door.** It produces a single authoritative intake artifact that answers: *what is this, what type of work is it, and which workflow should run next?*

It does **not** solve planning, design, implementation, or verification.

---

## Why Does It Exist?

The OS defines eleven work types, multiple workflows, and a human-approval spine. Something must sit at **T0/T1 boundary** and convert "human intent" into "system-routable work."

Intake classification is that boundary skill because:

1. **Every downstream skill assumes classified input.** PRD drafting needs `work_type: feature`. Bug fix needs reproduction status. Release needs version scope. None of these skills should guess classification.
2. **Human approval at H-INTAKE requires a concrete artifact.** Chat agreement is not durable. The intake record is the proposal humans approve or revise.
3. **The intake router (SDLC §15) needs an executor.** The router is a diagram; this skill is its single-responsibility implementation.
4. **Context assembly depends on work type.** T2 bundles differ for `WF-BUGFIX` vs `WF-FEATURE`. Wrong type → wrong context → hallucination risk.

Without this skill, every other skill would silently absorb classification — duplicating logic, drifting behavior, and violating single responsibility.

---

## What Business Value Does It Provide?

| Value | Mechanism |
|-------|-----------|
| **Reduced rework** | Correct workflow first time; fewer Implement → Plan loops |
| **Faster human decisions** | Structured intake vs parsing chat history |
| **Session continuity** | Intake artifact persists in Work Record; no context loss |
| **Consistent routing** | Same classification rules regardless of AI provider |
| **Lower token cost** | Right workflow → right templates → no premature PRD/architecture |
| **Audit trail** | Classification rationale recorded for later "why did we treat this as X?" |

For a personal/single-team OS, the primary value is **time saved on misrouted work** and **confidence that the next skill in the chain is the right one.**

---

## When Should It Be Used?

Invoke **PB-intake-classify** when **all** of the following are true:

| Condition | Required |
|-----------|----------|
| New work item — no classified Work Record exists yet | Yes |
| Raw input exists (request, report, idea, alert) | Yes |
| Human wants to start OS-guided delivery | Yes |
| Workflow phase is **Intake** (pre-H-INTAKE) | Yes |

### Typical triggers

- User says: "I want to build X", "Fix this bug", "Prepare a release", "Onboard this repo to the OS"
- New issue/ticket created without `work_type` or `workflow_id`
- Maintenance alert or dependency audit batch arrives unclassified
- Human rejects prior classification and requests re-intake (revise loop)

### Entry modes handled (classification only — not execution)

| Entry signal | Classification output |
|--------------|----------------------|
| No project / greenfield signals | Suggest `WF-PROJECT-NEW` or route to discovery first |
| "Adopt OS on existing repo" | Suggest `WF-PROJECT-EXISTING` |
| Normal change within known project | Route to `WF-FEATURE`, `WF-BUGFIX`, etc. |

---

## When Should It NOT Be Used?

Do **not** invoke this skill when:

| Situation | Why not | Use instead |
|-----------|---------|-------------|
| Work Record already has **human-approved** classification at H-INTAKE | Re-classification wastes cycle; amend via human waiver | Downstream skill for that workflow |
| User only asks a question (no work to track) | Not intake — informational | Direct answer or docs lookup |
| Work is mid-flight (Implement, Verify, etc.) | Wrong phase; risks resetting scope | Phase-appropriate skill |
| User wants full discovery research | Classification ≠ exploration | PB-discovery-research (future) |
| User wants PRD, architecture, or issues written | Those are downstream deliverables | PB-draft-prd, PB-draft-architecture, PB-decompose-issues |
| User wants code written | Implementation is out of scope | PB-implement (future) |
| Releasing an already-scoped version | Release execution, not intake | PB-prepare-release (future) |
| Trivial typo fix with explicit "no intake needed" human waiver | Ceremony exceeds value | Direct WF-BUGFIX with human pre-approval |

### Challenge: "But classification needs some discovery"

**Partial context gathering is allowed** only to answer: *what type of work is this?*

Allowed for classification:

- Read `CONTEXT.md` module index
- Scan request text for signals (bug vs feature vs security CVE)
- Check if project/repo exists

**Not allowed** — belongs to other skills:

- Stakeholder interviews
- As-is system analysis
- Alternative evaluation
- PRD drafting
- Codebase deep-read beyond entry-mode detection

If classification cannot proceed without deep discovery, output `classification_confidence: low`, list blockers, and recommend **PB-discovery-research** before re-intake — do not absorb discovery into this skill.

---

## Single Responsibility

> **Classify incoming work and produce an approved-ready intake record. Nothing else.**

The skill ends when:

1. `work_type` is proposed with rationale
2. `workflow_id` is proposed
3. `entry_mode` is proposed (`new_project` | `existing_project` | `normal`)
4. Intake artifact structure is complete per template
5. Validation self-check passes
6. Handoff package is ready for **H-INTAKE**

---

## Responsibilities That Belong to Other Skills

Explicit boundaries — challenged and rejected from this skill:

| Temptation | Why it seems useful | Owner skill | Rejection rationale |
|------------|--------------------|--------------|--------------------|
| Write a full Discovery doc | "Helps classification" | PB-discovery-research | Discovery is multi-question research; intake only needs enough to route |
| Draft a PRD | "Feature requests need detail" | PB-draft-prd | PRD is Plan phase; premature PRD on bugs/docs wastes effort |
| Decompose into issues | "User gave a big feature" | PB-decompose-issues | Decomposition is post-H-PLAN/H-DECOMPOSE |
| Survey entire codebase | "Need context to classify" | PB-survey-codebase (future) | Entry-mode detection needs existence check, not architecture |
| Choose tech stack | "New project" | PB-bootstrap-project (future) | Planning decision, not routing |
| Assign priority/severity final value | "Triage includes priority" | Human at H-INTAKE | Agent may *suggest*; human *decides* |
| Run tests or CI | "Is this a regression?" | PB-verify / CI | Verification is Implement/Verify phase |
| Write implementation plan | "Classify then plan" | PB-draft-design / workflow Plan step | Conflates Intake with Plan |
| Approve its own output | "Move faster" | Human at H-INTAKE | Violates OS approval model |
| Start the next workflow step | "Seamless flow" | Workflow orchestrator | Skills execute one bounded job |

---

## Challenged Scope Creep (Explicit Rejections)

The following were considered and **rejected** from PB-intake-classify:

### ❌ "Smart intake" that auto-starts the next skill

**Rejected.** Seamless chaining hides human approval. The OS requires explicit H-INTAKE before any workflow phase advances.

### ❌ Severity scoring for all work types

**Rejected for mandatory scope.** Severity is essential for bugs/security; optional suggestion elsewhere. Full severity rubric belongs in `PB-triage-severity` or checklists, not intake classification.

### ❌ Filling Discovery or PRD sections "as a head start"

**Rejected.** Creates duplicate SSOT. Downstream skills would not know which sections are authoritative.

### ❌ Project onboarding execution

**Rejected.** `WF-PROJECT-EXISTING` *classification* is in scope; writing `CONTEXT.md` or gap assessment is `PB-onboard-project`.

### ❌ Duplicate detection across backlog

**Rejected.** Valuable but separate concern. Belongs in `PB-dedupe-check` (optional pre-step), not core classification.

---

## Success Criteria (Purpose Level)

This skill succeeds when a human at **H-INTAKE** can answer yes to:

| Question | |
|----------|--|
| Do I know what type of work this is? | |
| Do I agree with the suggested workflow? | |
| Is the intake record complete enough to route without re-explaining in chat? | |
| Are out-of-scope items for *this* work type clearly excluded? | |

---

## Workflow Context

| Field | Value |
|-------|-------|
| primary_workflow | All workflows (entry step) |
| workflow_phase | Intake |
| exit_gate | H-INTAKE |
| blocking | true — no workflow advances without classified, human-approved intake |

---

## Related Standards & Templates

| Ref | Relationship |
|-----|--------------|
| TP-discovery | Downstream if discovery-first path selected |
| INT / intake template | Output shape (to be defined) |
| SDLC §15 Intake Router | Orchestration diagram this skill implements |
| STD-ARCH-004 (KISS) | Classification favors simplest fitting work type |
| Context strategy T0/T1 | Skill loads minimal project context only |

---

## Open Questions (For Later Design Docs)

| # | Question | Blocks |
|---|----------|--------|
| 1 | ~~Separate classify from record?~~ **Resolved:** single skill classifies and writes INT | — |
| 2 | Mandatory fields in intake template vs TP-discovery overlap? | 06-required-documents.md |
| 3 | Confidence threshold for `low` → force discovery recommendation? | 11-failure-handling.md |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.0 | 2026-06-18 | Initial purpose definition |