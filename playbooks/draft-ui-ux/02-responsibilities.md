# PB-draft-ui-ux — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved PRD linked in WR; ARCH/DISC or gap waivers documented |
| P2 | Load PRD + ARCH + DISC slice + CONTEXT | T1/T2 bundles per 05-context.md |
| P3 | Set `change_type` and `uiux_type` | Maps from PRD scope, workflow, and surface signals |
| P4 | Map journeys to requirements | §2 journeys trace to PRD FR/NFR |
| P5 | Define screen inventory and IA | §3–§4 align with ARCH when present |
| P6 | Document interaction states and accessibility | §5–§6 per TP-uiux + STD-A11Y-001 |
| P7 | Produce UIUX (OUT-01) | Complete per TP-uiux + 04-io-contract |
| P8 | Update Work Record | Link UIUX; status `uiux_pending_review` |
| P9 | Run CL-UIUX | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend next playbook only |

### change_type enum

| change_type | From signal |
|-------------|-------------|
| `new` | Greenfield screens or flows; typical WF-FEATURE |
| `additive` | New screens or states without full redesign; WF-ENHANCEMENT |
| `redesign` | Material layout or flow change replacing existing UX |

### uiux_type enum

| uiux_type | From signal |
|-----------|-------------|
| `screen_flow` | Feature screens and user journeys (default) |
| `design_system` | Tokens, components, pattern library extension |
| `responsive` | Cross-platform or breakpoint-specific layout plan |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Document responsive/platform notes | Web + mobile or multi-breakpoint scope |
| S2 | Flag PRD gaps blocking UX design | `uiux_confidence: low` |
| S3 | Cross-reference existing UI markers | Project has bounded component or route files |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Note design-system token references | Project has established token SSOT |
| O2 | Suggest PB-decompose-issues | Large surface needing task breakdown before Implement |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Write or modify DISC | PB-discovery-research |
| N5 | Write or modify API or DB design | PB-draft-api / PB-draft-database |
| N6 | Write component code, JSX, CSS, or Storybook files | PB-implement-frontend |
| N7 | Approve H-PLAN or advance workflow | Human |
| N8 | Auto-invoke next playbook | Human after H-PLAN |
| N9 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N10 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N11 | Choose implementation tasks or sprint order | PB-decompose-issues |
| N12 | Modify OS repository files | OS maintainer |
| N13 | Store decisions only in chat | Must persist UIUX |
| N14 | Self-approve UI/UX plan | Human at H-PLAN |
| N15 | Skip CL-UIUX | Never |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| UI/UX design & UIUX draft | proposes | approves / revises / rejects at H-PLAN |
| PRD/ARCH/DISC alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Open questions resolution | lists | decides sufficient for Implement |
| Accessibility trade-offs | proposes WCAG targets | approves exceptions |
| Next playbook | recommends | approves after H-PLAN |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-draft-prd | skill (upstream) | PRD artifact |
| PRD | artifact | H-PLAN approved on PRD (or documented waiver) |
| ARCH | artifact (soft) | Component boundaries when present |
| DISC | artifact (soft) | User research grounding when present |
| TP-uiux | template | OUT-01 structure |
| CL-UIUX | checklist | Handoff blocker |
| STD-A11Y-001 | standard | Accessibility targets |
| STD-DOC-001 | standard | Document structure |