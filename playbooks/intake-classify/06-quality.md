# PB-intake-classify — Quality Standards

| Field | Value |
|-------|-------|
| skill_id | PB-intake-classify |
| name | Intake & Classify Work |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Overview

Quality standards for **skill execution** (agent run producing OUT-01–OUT-04) and **skill specification** (this playbook set).

Each dimension has **measurable acceptance criteria** (`AC-{DIM}-###`) evaluable as **pass / fail** at CL-INTAKE or human review.

**Severity**

| Level | Meaning |
|-------|---------|
| **R** | Required — fail blocks handoff |
| **G** | Guideline — fail noted; human may waive at H-INTAKE |

---

## Quality Gate Summary

| Gate | When | Criteria set |
|------|------|--------------|
| CL-INTAKE | Agent self-check | All **R** ACs for Accuracy, Completeness, Consistency, Security, Documentation |
| C1–C6 (05-context.md) | Pre-handoff | Performance + context ACs |
| H-INTAKE | Human review | All dimensions — human judgment on G items |

```mermaid
flowchart LR
    EXEC[Skill execution] --> CL[CL-INTAKE R-ACs]
    CL -->|pass| CTX[C1-C6 context ACs]
    CTX -->|pass| HAND[Handoff]
    HAND --> H[H-INTAKE all dimensions]
```

---

## 1. Accuracy

Classification and claims must match evidence — no fabricated workflows, types, or project facts.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-ACC-01 | `workflow_id` exists in OS catalog | R |
| QS-ACC-02 | `work_type` ∈ valid enum (02-responsibilities.md) | R |
| QS-ACC-03 | `workflow_id` consistent with `work_type` + `entry_mode` per IN-33 matrix | R |
| QS-ACC-04 | Every factual claim in INT cites IN-10 quote or loaded artifact path | R |
| QS-ACC-05 | `entry_mode` evidence matches checked paths (IN-21, markers) | R |
| QS-ACC-06 | `classification_confidence` matches DP-04 rules (03-workflow.md) | R |
| QS-ACC-07 | Rejected alternative type named when confidence = `medium` | G |
| QS-ACC-08 | No invented `work_id`, CVE, version, or repro steps not in inputs | R |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-ACC-01 | Catalog match | String match `workflow_id` against IN-30 loaded index | 100% match |
| AC-ACC-02 | Enum validity | `work_type` in enum table | Exact match |
| AC-ACC-03 | Matrix consistency | Lookup work_type + entry_mode → workflow_id | Proposed ID equals matrix row |
| AC-ACC-04 | Citation coverage | Count factual sentences in INT body without `ref:` or quote block | 0 uncited facts |
| AC-ACC-05 | Entry evidence | `entry_mode` section lists ≥1 checked path or explicit absence | ≥1 evidence item |
| AC-ACC-06 | Confidence calibration | Compare signals to DP-03/DP-04 decision trees | Level matches tree outcome |
| AC-ACC-07 | Alternative documented | If `medium`: rationale contains "rejected:" + alternative type | Present when medium |
| AC-ACC-08 | Zero hallucinated IDs | Cross-check CVE/version/repro against IN-10 only | No novel identifiers |

---

## 2. Completeness

All required outputs, fields, and primary responsibilities present before handoff.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-COM-01 | All P1–P10 primary responsibilities executed (02-responsibilities.md) | R |
| QS-COM-02 | OUT-01 INT all required frontmatter + body sections (04-io-contract.md) | R |
| QS-COM-03 | OUT-02 Work Record minimum fields populated | R |
| QS-COM-04 | OUT-03 Validation Record complete | R |
| QS-COM-05 | OUT-04 Handoff all required sections | R |
| QS-COM-06 | `blockers` populated when confidence = `low` | R |
| QS-COM-07 | `open_questions` present (may be empty only if confidence = `high`) | R |
| QS-COM-08 | `recommended_next_artifacts` ≥1 row | R |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-COM-01 | Primary duties | Checklist P1–P10 against workflow steps INIT–HAND | 10/10 complete |
| AC-COM-02 | INT fields | Automated/manual field checklist vs OUT-01 schema | 100% required fields non-empty |
| AC-COM-03 | WR fields | `work_id`, `status`, `artifacts[]`, `work_type`, `workflow_id` | All present |
| AC-COM-04 | Validation record | `checklist_id`, `result`, `attempt`, `timestamp` | All present |
| AC-COM-05 | Handoff sections | 8 sections per OUT-04 | 8/8 present |
| AC-COM-06 | Low-confidence blockers | If confidence=low: `blockers` length | ≥1 blocker |
| AC-COM-07 | Open questions rule | high → may be empty; medium/low → section exists | Section header present |
| AC-COM-08 | Next artifacts | Table rows in INT | ≥1 template ID |

---

## 3. Consistency

Fields, enums, and narrative align across artifacts and sessions.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-CON-01 | `work_type`, `workflow_id`, `entry_mode` agree across INT and WR | R |
| QS-CON-02 | `work_id` identical in INT frontmatter, WR, and handoff | R |
| QS-CON-03 | `revision` consistent: WR revision = INT frontmatter revision | R |
| QS-CON-04 | `status` follows state machine (04-io-contract.md) | R |
| QS-CON-05 | Human revise: IN-50 overrides reflected in INT; no stale prior values | R |
| QS-CON-06 | `recommended_next_skill` aligns with routing table (03-workflow.md) | G |
| QS-CON-07 | Priority suggestion uses P0–P3 scale consistently | G |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-CON-01 | Cross-artifact match | Diff INT vs WR for three enum fields | 0 mismatches |
| AC-CON-02 | work_id unity | Compare IDs in OUT-01, OUT-02, OUT-04 | Exact match |
| AC-CON-03 | revision sync | INT.revision == WR.revision | Equal |
| AC-CON-04 | Valid status | WR.status ∈ allowed states for phase | Valid state |
| AC-CON-05 | Revise merge | Fields mentioned in IN-50 updated in INT | 100% IN-50 fields updated |
| AC-CON-06 | Next skill routing | Lookup approved work_type in routing table | Primary match |
| AC-CON-07 | Priority format | `urgency` / priority field | P0\|P1\|P2\|P3 |

---

## 4. Production Readiness

Skill can run reliably in real sessions with durable artifacts and clear human handoff.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-PRD-01 | INT and WR written to filesystem (not chat-only) | R |
| QS-PRD-02 | Skill completes without OS dependency failure | R |
| QS-PRD-03 | Handoff enables H-INTAKE without re-reading chat | R |
| QS-PRD-04 | Revise loop produces new revision without data loss | R |
| QS-PRD-05 | Escalation path defined when validation exhausted | R |
| QS-PRD-06 | Works with `provider: generic` (LCD mode) | G |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-PRD-01 | Persisted artifacts | File exists at OUT-01 and OUT-02 paths | Both files exist post-PERSIST |
| AC-PRD-02 | OS deps | IN-20, IN-30, IN-31 load success | 0 load failures |
| AC-PRD-03 | Handoff self-contained | Human can answer: type, workflow, problem from OUT-04 alone | 3/3 answerable |
| AC-PRD-04 | Revise integrity | `approvals[]` append-only; revision monotonic increase | No deleted approvals |
| AC-PRD-05 | Escalation template | After 3 fails: OUT-05 fields populated | Template complete |
| AC-PRD-06 | LCD path | Context ≤12% budget on generic profile (05-context.md) | ≤12% or logged justify |

---

## 5. Maintainability

Outputs and spec support future agents, humans, and skill evolution without rework.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-MNT-01 | INT uses stable field names per OUT-01 schema | R |
| QS-MNT-02 | `classification_rationale` auditable months later | R |
| QS-MNT-03 | `os_refs` in WR records skill version | G |
| QS-MNT-04 | Spec files use numbered convention (01–06) | R (spec) |
| QS-MNT-05 | No embedded prompts in spec — behavior in structured docs | R (spec) |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-MNT-01 | Schema stability | INT frontmatter keys match OUT-01 list | 100% key match |
| AC-MNT-02 | Rationale audit | Rationale contains: signals used, decision, rejected alt (if medium) | 3 components present |
| AC-MNT-03 | Version trace | WR `os_refs.skill` + `version` | Present |
| AC-MNT-04 | Spec numbering | Files in playbook dir follow `NN-name.md` | Convention met |
| AC-MNT-05 | Spec purity | No ` ```prompt ` blocks in 01–06 | 0 prompt blocks |

---

## 6. Security

Intake artifacts must not leak secrets, expose unsafe paths, or create auth bypass.

### Standards

| ID | Standard | Severity | Ref |
|----|----------|----------|-----|
| QS-SEC-01 | No secrets in INT, WR, handoff, or logs | R | STD-SEC-001 |
| QS-SEC-02 | No API keys, tokens, passwords in `raw_request` echoed verbatim — redact | R | STD-SEC-001 |
| QS-SEC-03 | `project_root` and paths stay within declared workspace | R | — |
| QS-SEC-04 | Security work type does not expose exploit details in INT | R | STD-SEC-001 |
| QS-SEC-05 | No `prompts/` or credentials paths in context loads | R | 05-context.md |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-SEC-01 | Secret scan | Pattern scan INT+WR+handoff for key/token/password patterns | 0 matches |
| AC-SEC-02 | Redaction | If IN-10 contains secret-like strings: INT shows `[REDACTED]` | 100% redacted |
| AC-SEC-03 | Path scope | All paths prefix-match `project_root` or `ai_dev_os_home` | 0 out-of-scope paths |
| AC-SEC-04 | Exploit detail | For security type: no PoC code/steps in INT | 0 exploit instructions |
| AC-SEC-05 | Forbidden loads | Context log vs forbidden list | 0 forbidden paths read |

---

## 7. Performance

Skill respects token and time budgets; avoids unnecessary I/O.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-PER-01 | Context budget ≤12% session tokens normal path | G |
| QS-PER-02 | T3 file reads ≤2 marker files | R |
| QS-PER-03 | No full `CONTEXT.md` if digest suffices | G |
| QS-PER-04 | Single CL-INTAKE pass target on happy path | G |
| QS-PER-05 | Recovery attempts ≤3 | R |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-PER-01 | Token budget | OUT-06 estimated total / session budget | ≤12% normal; ≤25% with T3 |
| AC-PER-02 | T3 cap | Count files in OUT-07 T3 entries | ≤2 files |
| AC-PER-03 | Digest use | If CTX >2KB: digest used unless full read justified in OUT-07 | Digest or justify |
| AC-PER-04 | Validation attempts | OUT-03 `attempt` on happy path | 1 |
| AC-PER-05 | Recovery cap | OUT-03 `attempt` maximum | ≤3 |

---

## 8. Testability

Every quality criterion must be verifiable; skill supports golden and anti-pattern tests.

### Standards

| ID | Standard | Severity |
|----|----------|----------|
| QS-TST-01 | Each **R** AC is objectively pass/fail | R (spec) |
| QS-TST-02 | Golden scenarios defined (12-examples.md) | G (spec) |
| QS-TST-03 | Anti-pattern scenarios defined | G (spec) |
| QS-TST-04 | CL-INTAKE maps 1:1 to **R** ACs | R |
| QS-TST-05 | Field-level INT schema enables fixture validation | R |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-TST-01 | AC measurability | Each R AC has numeric or boolean threshold | 100% R ACs measurable |
| AC-TST-02 | Golden coverage | ≥1 golden per: feature, bugfix, new_project, low confidence | ≥4 goldens (in 12-examples.md) |
| AC-TST-03 | Anti-pattern coverage | ≥3 anti-patterns documented | ≥3 |
| AC-TST-04 | CL-INTAKE mapping | VC-05 items map to AC IDs | Table in §CL-INTAKE Map |
| AC-TST-05 | Schema validation | INT frontmatter parseable as YAML | Valid YAML |

### CL-INTAKE → AC mapping

| VC-05 # | Maps to |
|---------|---------|
| 1 | AC-ACC-02, AC-COM-02 |
| 2 | AC-ACC-01, AC-ACC-03 |
| 3 | AC-ACC-05 |
| 4 | AC-MNT-02, AC-ACC-04 |
| 5 | AC-COM-02 |
| 6 | AC-COM-02 |
| 7 | AC-COM-08 |
| 8 | AC-SEC-04 (no forbidden docs) |
| 9 | AC-CON-04, AC-PRD-01 |
| 10 | AC-CON-01 (no self-approval) |

---

## 9. Documentation Quality

INT and handoff prose must be clear, actionable, and maintainable as project documentation.

### Standards

| ID | Standard | Severity | Ref |
|----|----------|----------|-----|
| QS-DOC-01 | `problem_statement` understandable standalone | R | STD-DOC-001 |
| QS-DOC-02 | `in_scope` / `out_of_scope` unambiguous at intake level | R | STD-DOC-001 |
| QS-DOC-03 | No implementation solution in INT | R | 01-purpose.md |
| QS-DOC-04 | Handoff summary ≤10 lines | R | OUT-04 |
| QS-DOC-05 | Open questions specific and actionable | G | — |
| QS-DOC-06 | Grammar and structure sufficient for human review | G | — |

### Acceptance criteria

| AC ID | Criterion | Measurement | Pass threshold |
|-------|-----------|-------------|----------------|
| AC-DOC-01 | Problem clarity | Third-party reader can state problem in 1 sentence | Human pass at H-INTAKE |
| AC-DOC-02 | Scope clarity | in/out scope non-overlapping contradictory statements | 0 direct contradictions |
| AC-DOC-03 | No solutioning | INT lacks implementation steps, code, API designs | 0 solution sections |
| AC-DOC-04 | Summary length | Handoff summary line count | ≤10 lines |
| AC-DOC-05 | Question quality | Each open question has owner or implied human | 100% actionable |
| AC-DOC-06 | Review readiness | CL-INTAKE documentation items pass | pass |

---

## Master Acceptance Scorecard

Used at CL-INTAKE and H-INTAKE.

### Required pass (all must pass for handoff)

| Dimension | Required ACs | Min pass rate |
|-----------|--------------|---------------|
| Accuracy | AC-ACC-01 – 06, 08 | 100% |
| Completeness | AC-COM-01 – 08 | 100% |
| Consistency | AC-CON-01 – 05 | 100% |
| Production readiness | AC-PRD-01 – 05 | 100% |
| Security | AC-SEC-01 – 05 | 100% |
| Performance | AC-PER-02, 05 | 100% |
| Documentation | AC-DOC-01 – 04 | 100% |

### Guideline pass (document waivers at H-INTAKE)

| Dimension | Guideline ACs |
|-----------|---------------|
| Accuracy | AC-ACC-07 |
| Consistency | AC-CON-06, 07 |
| Production readiness | AC-PRD-06 |
| Maintainability | AC-MNT-03 |
| Performance | AC-PER-01, 03, 04 |
| Testability | AC-TST-02, 03 |
| Documentation | AC-DOC-05, 06 |

### Scoring formula

```
required_pass = (passed_R_ACs / total_R_ACs) * 100
handoff_allowed = required_pass == 100 AND CL-INTAKE result == pass
```

---

## Definition of Done (Quality Lens)

Skill execution meets quality DoD when:

1. `required_pass` = 100%
2. OUT-03 `result: pass`
3. Human H-INTAKE = `approve` (or documented waiver for G failures)
4. No QS-SEC-01 through QS-SEC-05 violations
5. INT and WR persisted (QS-PRD-01)

Skill **specification** meets quality DoD when:

1. Files 01–06 complete and cross-linked
2. AC-TST-01 satisfied for all **R** ACs in this document
3. 12-examples.md provides AC-TST-02 and AC-TST-03 coverage (pending)

---

## Waiver Protocol

| Situation | Who waives | Record |
|-----------|------------|--------|
| G AC fail | Human at H-INTAKE | WR `approvals[].waiver` + AC ID + reason |
| R AC fail | **Not waivable** — fix or escalate | OUT-05 |
| Emergency intake skip | Human pre-waiver | Work Record before invoke — skill not run |

---

## Cross-References

| Document | Relationship |
|----------|--------------|
| [03-workflow.md](./03-workflow.md) | VC-05, recovery |
| [04-io-contract.md](./04-io-contract.md) | Output schemas |
| [05-context.md](./05-context.md) | C1–C6 context checks |
| 09-validation.md | CL-INTAKE expansion |
| 12-examples.md | Golden / anti-pattern tests |
| `standards/engineering/` | STD-SEC-001, STD-DOC-001 |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.0 | 2026-06-18 | Initial quality standards and ACs |