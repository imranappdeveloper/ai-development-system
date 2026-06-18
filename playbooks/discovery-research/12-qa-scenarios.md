# PB-discovery-research — QA Scenario Catalog

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| document | 12-qa-scenarios |
| author_role | QA Lead |
| scenario_count | 100 |
| spec_version | 1.0.0 |
| date | 2026-06-18 |

**Legend**

| Column | Meaning |
|--------|---------|
| **Behaviour** | Agent outcome before H-FRAME |
| **Documents** | Artifacts produced or updated |
| **Failures** | Expected CL-DISCOVERY / entry failures |
| **Recovery** | Agent or human recovery path |

**Standard success documents:** OUT-01 DISC, OUT-02 WR (`discovery_pending_review`), OUT-03 Validation (`pass`), OUT-04 Handoff (`decision: pending`).

---

## Category A — Simple Projects (DS-001–010)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-001 | Solo dev todo app — add dark mode | `feature`, INT approved, small CONTEXT | Research UI theming from README; `discovery_type: feature`; `confidence: high` | DISC + WR | None | H-FRAME approve → PB-draft-prd |
| DS-002 | Personal blog — migrate to static site | `new_project`, greenfield INT | Document current WP pain; `discovery_type: new_project` | DISC + WR | None | PB-draft-prd |
| DS-003 | CLI tool — add export to CSV | `enhancement`, approved INT | As-is CLI commands from CONTEXT; aligned | DISC + WR | None | PB-draft-prd |
| DS-004 | Weekend hackathon API — no CONTEXT | `new_project`, no project_root | Proceed INT-only; note `context_gap` | DISC + WR | None | Open questions for stack at H-FRAME |
| DS-005 | Forked open-source — adopt OS | `existing_project`, repo no CONTEXT.md | `discovery_type: existing_onboarding`; gap noted | DISC + WR | None | PB-onboard-project |
| DS-006 | Single-page landing — A/B headline test | `feature`, minimal docs | Problem = conversion hypothesis; no PRD in DISC | DISC + WR | CL-#7 if agent drafts PRD | DOC step remove PRD; re-VAL |
| DS-007 | Raspberry Pi sensor dashboard | `new_project` | Evidence from INT only; low external docs | DISC; `confidence: medium` | None | H-FRAME clarifies hardware constraints |
| DS-008 | Re-run discovery after approve | DISC H-FRAME approved | **Block** EC-ENT-02 | None new | Entry fail | Human `mode: revise` |
| DS-009 | INT pending H-INTAKE | INT `pending_review` | **Block** EC-ENT-01 | None | CL-#1 fail | PB-intake-classify / await H-INTAKE |
| DS-010 | Human waiver — discover before intake approve | `human_waiver` in WR | Proceed with waiver logged in DISC context | DISC + WR | None if waiver documented | H-FRAME notes waiver acceptance |

---

## Category B — Enterprise Projects (DS-011–020)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-011 | Fortune 500 CRM — enterprise SSO feature | `feature`, large CONTEXT, 40 modules | Digest CONTEXT; cite module map; `confidence: medium` | DISC + WR; OUT-06 optional digest log | EC-CTX-02 budget | Module-map digest; no full src dump |
| DS-012 | Multi-BU data warehouse initiative | `new_project`, INT approved | Stakeholder table redacted; `discovery_type: new_project` | DISC; PII `[REDACTED]` | EC-SEC-01 if PII leaked | Redact; re-DOC |
| DS-013 | SAP integration — enhancement | `enhancement`, legacy named in INT | As-is cites CONTEXT integrations section | DISC + WR | None | PB-draft-prd |
| DS-014 | Compliance audit prep — discovery only | `feature` misclassified? research shows docs | `alignment: partial_mismatch` if audit=documentation | DISC §6.2 | None | H-FRAME or re-intake |
| DS-015 | 12-team monorepo — shared auth service | `feature`, CONTEXT 8KB+ | Budget ≤35%; evidence table populated | DISC + WR | CL-#4 if uncited claims | RESEARCH add citations |
| DS-016 | Procurement 6-month RFP follow-up | `new_project`, incomplete INT | `confidence: low`; many open questions | DISC + WR | None | H-FRAME defers PRD until vendor pick |
| DS-017 | Enterprise onboarding 500 repos | `existing_project` | `existing_onboarding`; scope = OS adoption not feature | DISC + WR | None | PB-onboard-project |
| DS-018 | INT work_type bugfix — prod outage | `bugfix` INT approved by mistake | **Block** EC-ENT-03 | None | Entry block | PB-draft-issue redirect |
| DS-019 | Change board requires DISC before PRD | `feature`, approved | Standard handoff; recommend PB-draft-prd | DISC + WR | None | H-FRAME approve for Plan gate |
| DS-020 | Executive asks for ROI in DISC | `enhancement` | ROI as qualitative impact only — no financial model (out of scope) | DISC out-of-scope notes | CL-#7 if full PRD | Remove financial forecast section |

---

## Category C — SaaS (DS-021–030)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-021 | B2B SaaS — tenant-scoped admin roles | `feature`, multi-tenant CONTEXT | Cite tenancy model from CONTEXT; aligned | DISC + WR | None | PB-draft-prd |
| DS-022 | Usage-based billing meter addition | `enhancement` | Explore alternatives table; risks for billing accuracy | DISC + WR | None | H-FRAME |
| DS-023 | SOC2-driven audit log feature | `feature`, security signals in INT | Security risks section; no exploit detail | DISC + WR | None | PB-draft-prd |
| DS-024 | Free tier limit enforcement | `enhancement` | Partial mismatch if INT said `feature` | DISC §6.2 `partial_mismatch` | None | Human confirms enhancement |
| DS-025 | White-label customer subdomain | `feature`, incomplete tenant docs | `confidence: low`; blockers in open questions | DISC + WR | None | Revise loop after human clarifies DNS ownership |
| DS-026 | SaaS churn dashboard | `feature`, metrics in CONTEXT | Evidence from metrics section citations | DISC + WR | CL-#4 without refs | RESEARCH pass |
| DS-027 | API rate limit tier change | `enhancement` vs `feature` conflict in INT body | `alignment: aligned` if INT says enhancement | DISC + WR | EC-SCP-02 if agent reclassifies | CL-#8 fail → fix §6.2 |
| DS-028 | Marketplace third-party plugins | `new_project` INT for plugin platform | `discovery_type: new_project` | DISC + WR | None | PB-draft-prd |
| DS-029 | Customer data export (GDPR) | `feature` | PII handling in risks; redact sample emails | DISC + WR | EC-SEC-01 | Redact recovery |
| DS-030 | Concurrent edit conflict — realtime | `feature`, conflicting INT priority P0/P2 | Document conflict; do not resolve priority | DISC notes INT priority suggestion | None | Human sets priority at H-FRAME |

---

## Category D — Mobile Apps (DS-031–040)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-031 | iOS/Android fitness app — Apple Health sync | `feature`, mobile CONTEXT | Platform constraints in exploration; no code | DISC + WR | None | PB-draft-prd |
| DS-032 | React Native — offline mode | `feature`, incomplete offline spec | `confidence: low`; open questions on sync strategy | DISC + WR | None | H-FRAME |
| DS-033 | App Store rejection — privacy manifest | `enhancement` mislabeled as bugfix in research | If INT=enhancement stay aligned; if INT=bugfix block at entry | DISC or block | EC-ENT-03 if bugfix | Re-intake if wrong type |
| DS-034 | Push notification preferences | `feature` | As-is from mobile module markers only | DISC + WR | Reading full `src/**` | Scope violation → bounded markers |
| DS-035 | Tablet layout for existing phone app | `enhancement` | aligned; out-of-scope phone-only flows | DISC + WR | None | PB-draft-prd |
| DS-036 | Mobile game — IAP discovery | `feature` | Note store policy risks; no payment code | DISC + WR | None | H-FRAME |
| DS-037 | Legacy Xamarin migration assessment | `new_project` | Document migration as direction not architecture spec | DISC + WR | CL-#7 architecture detail | Trim to discovery level |
| DS-038 | Biometric login — no platform stated | `feature`, vague INT | `confidence: low` | DISC + WR | None | Revise after human specifies iOS/Android |
| DS-039 | Flutter app — adopt AI Dev OS | `existing_project` | `existing_onboarding` | DISC + WR | None | PB-onboard-project |
| DS-040 | Deep link universal links | `feature`, conflicting Android/iOS INT | Document conflict in open questions | DISC + WR | EC-MUL-01 | Split or human pick platform phase |

---

## Category E — Web Apps (DS-041–050)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-041 | Next.js e-commerce — checkout V2 | `feature`, web CONTEXT | Cite checkout module; alternatives table | DISC + WR | None | PB-draft-prd |
| DS-042 | SPA — accessibility WCAG AA | `enhancement` | Gaps table from docs survey | DISC + WR | None | H-FRAME |
| DS-043 | Server-rendered app — add PWA | `feature` | aligned | DISC + WR | None | PB-draft-prd |
| DS-044 | Web app — no README, INT only | `feature`, CONTEXT missing EC-CTX-01 | Proceed; note gap | DISC + WR | None | Open questions at H-FRAME |
| DS-045 | Micro-frontends discovery | `new_project` | `discovery_type: new_project`; boundaries in out-of-scope | DISC + WR | None | PB-draft-prd |
| DS-046 | SEO content tool — conflicting marketing vs tech INT | Marketing wants CMS; tech wants git-based | `partial_mismatch` or open questions | DISC + WR | None | H-FRAME picks direction |
| DS-047 | WebSocket chat feature | `feature` | Risks: scale, presence; no API spec | DISC + WR | CL-#7 if OpenAPI drafted | Remove API spec |
| DS-048 | Design system adoption | `enhancement` | Evidence from `docs/design` if present | DISC + WR | None | PB-draft-prd |
| DS-049 | Premature PRD in repo | `feature`, `docs/prd-draft.md` exists | EC-DOC-05: flag anomaly; classify from INT not stale PRD | DISC + WR | None | Note anomaly in DISC |
| DS-050 | Browser support IE11 in INT | `enhancement`, contradictory to CONTEXT modern-only | `requires_re_intake` or `partial_mismatch` | DISC §6.2 | None | PB-intake-classify or human waiver |

---

## Category F — APIs (DS-051–060)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-051 | REST v2 — breaking change policy | `enhancement`, API CONTEXT | Cite TP-api upstream ref in recommendations table only | DISC + WR | None | PB-draft-prd |
| DS-052 | GraphQL federation gateway | `new_project` | new_project discovery; no schema draft | DISC + WR | CL-#7 | Remove schema |
| DS-053 | Public API — OAuth2 for partners | `feature` | Security risks; aligned with INT | DISC + WR | None | PB-draft-prd |
| DS-054 | Webhook delivery retries | `enhancement` | As-is from API module markers | DISC + WR | None | H-FRAME |
| DS-055 | gRPC internal service — incomplete proto context | `feature` | `confidence: low` | DISC + WR | None | Human provides proto ownership |
| DS-056 | API versioning — INT says feature, research shows maintenance | Research contradicts INT | `requires_re_intake` EC-RES-02 | DISC + WR | None | PB-intake-classify |
| DS-057 | Rate limit headers only change | `enhancement` | aligned; KISS recommendation | DISC + WR | None | PB-draft-prd |
| DS-058 | OpenAPI import from third party | `feature` | Third-party cited in evidence | DISC + WR | CL-#4 | Add citation |
| DS-059 | API — chat-only agent session | `feature`, no file write | EC-CTX-03 full DISC in chat + `persist: pending` | OUT-04 full DISC | None | Human persists files |
| DS-060 | Dual REST + GraphQL same resource | `feature`, conflicting INT scope | EC-MUL-01 flag split | DISC + WR | None | Re-intake split |

---

## Category G — Existing Projects (DS-061–070)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-061 | Brownfield — add feature to 5yr codebase | `feature`, rich CONTEXT | Bounded src markers; digest CONTEXT | DISC + WR | Budget exceed | Digest recovery |
| DS-062 | Team fork — discover after acquisition | `existing_onboarding` | Onboarding scope not feature build | DISC + WR | None | PB-onboard-project |
| DS-063 | CONTEXT.md stale sha vs live file | `feature` | Regenerate digest; current `source_sha` | DISC + WR | Stale cite | RESEARCH reload |
| DS-064 | Work Record missing INT link | `feature` | **Block** EC-01 | None | CL-#1 | Fix WR artifacts[] |
| DS-065 | Revision 2 — third H-FRAME revise | `feature`, `revision: 2` | Increment to 3; preserve approvals[] | DISC rev 3 + WR | None | H-FRAME |
| DS-066 | Vague revise: "more detail" | H-FRAME revise EC-HUM-01 | Agent requests specificity before re-HAND | Handoff questions | None | Human adds targeted notes |
| DS-067 | DISC reject at H-FRAME | Human reject | WR `discovery_rejected` | WR update | None | New work_id or waive |
| DS-068 | Parallel feature INTs same repo | Two work_ids | Isolated DISC per work_id | Two DISC paths | Cross-contamination | Strict work_id scoping |
| DS-069 | Monorepo package boundary feature | `feature`, CONTEXT lists packages | Cite package ownership | DISC + WR | None | PB-draft-prd |
| DS-070 | Existing — workflow_id not in INDEX | INT typo `WF-FEAT` | **Block** CL-#3 / EC-04 | None | VAL fail | Escalate OUT-05 or human fix INT |

---

## Category H — Legacy Systems (DS-071–080)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-071 | COBOL mainframe — screen scrape integration | `feature`, legacy noted in INT | Risks: fragility; no COBOL code in DISC | DISC + WR | None | H-FRAME |
| DS-072 | VB6 desktop — cloud migration discovery | `new_project` | Direction recommendation only | DISC + WR | CL-#7 if migration arch | Trim scope |
| DS-073 | Oracle Forms — enhancement | `enhancement` | `confidence: low` without SME | DISC + WR | None | Open questions for SME |
| DS-074 | AS/400 module — API wrapper | `feature` | Evidence from legacy docs only | DISC + WR | None | PB-draft-prd |
| DS-075 | Perl CGI — security hardening INT as feature | Research shows `security` would fit | `requires_re_intake` | DISC §6.2 | None | PB-intake-classify |
| DS-076 | Legacy — no digital docs | `enhancement`, INT only | `confidence: low`; blockers | DISC + WR | None | Human SME interview (out of band) |
| DS-077 | Mainframe batch job — schedule change | INT `maintenance` wrongly routed to discovery | **Block** — not in discovery_type enum | None | CL-#2 / entry | Re-intake maintenance path |
| DS-078 | Strangler fig pattern — phased legacy | `new_project` | Phases in recommendations narrative not project plan | DISC + WR | CL-#7 | Remove implementation plan |
| DS-079 | Legacy charset encoding issues | `bugfix` INT | Block EC-ENT-03 | None | Entry | PB-draft-issue |
| DS-080 | 30-year ERP — customization discovery | `enhancement`, huge CONTEXT | Digest; `confidence: medium` | DISC + WR | Token budget | Digest |

---

## Category I — Incomplete Requirements (DS-081–090)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-081 | "Make it faster" — no metrics | `enhancement`, vague INT | `confidence: low`; blockers: no baseline metric | DISC + WR | None | H-FRAME or re-intake |
| DS-082 | "Add AI" — no use case | `feature` | Open questions: model, data, privacy | DISC + WR | None | Revise loop |
| DS-083 | Empty problem statement in INT | INT defective | Proceed if inferable; else block | Partial or block | CL-#5 | PB-intake-classify amend INT |
| DS-084 | Missing project_root for normal feature | INT `entry_mode: normal` | **Block** EC-05 | None | Entry | Human supplies path |
| DS-085 | No stakeholders listed | `new_project` | Table with `unknown` rows allowed | DISC + WR | None | H-FRAME fills names |
| DS-086 | Acceptance criteria absent | `feature` | Note in open questions — not PRD ACs | DISC + WR | CL-#7 if AC section like PRD | Remove PRD-style AC |
| DS-087 | Language barrier — mixed EN/ZH INT | `feature` | Process INT as-is; cite quotes | DISC + WR | None | i18n gap — human review |
| DS-088 | TBD timeline "ASAP" only | `feature` | Urgency noted; no schedule commitment | DISC + WR | None | H-FRAME |
| DS-089 | Missing repro — enhancement not bug | `enhancement` | Do not demand repro | DISC + WR | None | Standard path |
| DS-090 | Single sentence INT | `feature`, minimal | `confidence: low` minimum | DISC + WR | None | Discovery-first per intake design |

---

## Category J — Conflicting Requirements (DS-091–100)

| ID | Scenario | INT precondition | Expected behaviour | Expected documents | Expected failures | Expected recovery |
|----|----------|------------------|--------------------|--------------------|-------------------|-------------------|
| DS-091 | Build mobile + web + API in one INT | `feature`, EC-MUL-01 | Flag split; `confidence: low` | DISC + WR | None | Re-intake 3 work items |
| DS-092 | CTO wants microservices; lead wants monolith | `feature`, conflicting quotes in INT | Alternatives table; no winner picked | DISC + WR | None | H-FRAME decides |
| DS-093 | Security team block vs product ship date | `feature` | Risks section captures conflict | DISC + WR | None | H-FRAME |
| DS-094 | INT feature vs discovery finds pure docs change | `feature` | `requires_re_intake` EC-RES-02 | DISC §6.2 | None | PB-intake-classify |
| DS-095 | Enhancement vs feature — INT says enhancement, user text says "new module" | `enhancement` | `partial_mismatch` | DISC + WR | None | Human confirms |
| DS-096 | In-scope OAuth; out-of-scope SAML — INT contradicts | Self-contradictory INT | Note contradiction; cite INT quotes | DISC + WR | None | Re-intake or H-FRAME waiver |
| DS-097 | P0 priority vs "nice to have" in same INT | `feature` | Document conflict; don't assign priority | DISC + WR | None | Human priority |
| DS-098 | Legal says no PII; feature requires email | `feature` | Risk + open question; redact samples | DISC + WR | EC-SEC-01 if emails pasted | Redact |
| DS-099 | Revise notes contradict INT — human says "bugfix" | `feature` INT + revise | IN-50 authoritative → note alignment mismatch | DISC + WR | EC-SCP-02 if agent changes type | §6.2 `requires_re_intake` not new type |
| DS-100 | Discovery recommends kill initiative | `new_project`, negative research | Valid DISC: recommend not proceeding; still `decision: pending` | DISC + WR | None | H-FRAME reject or pivot |

---

## Cross-Cutting Weaknesses Identified

Findings from scenario analysis against spec v1.0.0:

### Spec gaps (skill cannot handle consistently)

| # | Weakness | Scenarios exposing it | Severity |
|---|----------|----------------------|----------|
| W1 | **No `maintenance` / `security` / `refactor` discovery path** — wrongly routed INTs only block at entry | DS-077, DS-075, DS-033 | P1 |
| W2 | **`human_waiver` format undefined** in 04-io-contract | DS-010 | P1 |
| W3 | **i18n non-English INT** — no guidance | DS-087 | P2 |
| W4 | **Regulatory frameworks** (HIPAA, PCI, FedRAMP) — no evidence taxonomy | DS-012, DS-023, DS-029 | P1 |
| W5 | **Multi-initiative INT** — flag only; no `split_request` machine output | DS-091, DS-060, DS-040 | P1 |
| W6 | **Kill/pivot recommendation** — no WR status for "discovery_no_go" | DS-100 | P2 |
| W7 | **SME / interview method** — excluded (N10) but required for legacy | DS-073, DS-076 | P1 |
| W8 | **Third-party / vendor dependency discovery** — no method enum | DS-016, DS-028, DS-058 | P2 |
| W9 | **Mobile + platform-specific** — no `discovery_type` variant | DS-031–040 | P2 |
| W10 | **Concurrent DISC per monorepo** — isolation rules underspecified | DS-068 | P2 |

### Operational gaps (QA execution)

| # | Weakness | Scenarios | Severity |
|---|----------|-----------|----------|
| W11 | **No fixtures** for 100 scenarios — manual cost prohibitive | All | P0 |
| W12 | **No automated CL-DISCOVERY validator** | DS-006, DS-027, DS-047 | P1 |
| W13 | **Promotion gate has 5 HT + 5 ET** — 90 scenarios uncovered | All | P1 |
| W14 | **No golden DISC snapshots** per category | All | P1 |
| W15 | **`17-examples.md` missing** — RT regression impossible | DS-008, DS-099 | P0 |

### Behavioural / prompt risks

| # | Weakness | Scenarios | Severity |
|---|----------|-----------|----------|
| W16 | **Agent drafts PRD** under pressure from enterprise completeness | DS-006, DS-020, DS-047 | P0 |
| W17 | **Agent reclassifies work_type** despite §6.2 | DS-027, DS-056, DS-099 | P0 |
| W18 | **Over-reads `src/**`** on brownfield | DS-034, DS-061 | P1 |
| W19 | **Resolves stakeholder conflict** instead of documenting | DS-092, DS-097 | P1 |
| W20 | **Chat-only `persist: pending`** — no idempotency protocol | DS-059 | P2 |

### Recommended QA priorities

1. **Automate** CL-#7, #8, #10 (forbidden content, alignment, pending) — catches W16, W17.
2. **Add fixtures** per category A–J (10 minimum) — addresses W11, W14.
3. **Extend 07-edge-cases** for maintenance/security mis-route and multi-initiative split — W1, W5.
4. **Define waiver schema** in 04-io-contract — W2.
5. **Add DS-091, DS-056, DS-018, DS-009** to P0 ET suite in `11-test-plan.md` when approved.

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Happy path (DISC + CL pass) | 62 |
| Entry block expected | 14 |
| CL-DISCOVERY fail then recovery | 12 |
| Human-heavy (H-FRAME / revise / waiver) | 48 |
| `requires_re_intake` expected | 8 |
| `confidence: low` expected | 18 |

**QA Lead verdict:** Skill spec is testable in principle but **not executable at scale** until fixtures, golden DISC files, and automated rubric exist. Run DS-001–010 as smoke; DS-091–100 as conflict stress; DS-071–080 as legacy honesty checks before promotion.