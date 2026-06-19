# Requirement Lock — <feature name>

| Field | Value |
|-------|-------|
| document_id | REQ-LOCK-<NNN> |
| feature | <short name> |
| status | draft \| approved |
| approved_at | <ISO-8601 UTC when user confirms> |
| grill_session | <date or WR reference> |

**SSOT for AFK execution.** Issues are mechanical slices of this doc. AFK agents spot-check named files — they do not re-discover requirements.

---

## Problem statement

<2–4 sentences — precise, not vague>

## Out of scope

- <bullet>
- <bullet>

## Testing approach

- Seams: <where to test>
- Prior art: <similar tests in repo, if any>

---

## Screen / journey entries

Repeat one block per screen or journey slice. Use the user's words in **Your request** — do not paraphrase away intent.

### <Screen or journey name>

| Field | Content |
|-------|---------|
| **Current behavior** | What exists today in the codebase (from exploration) |
| **Your request** | Verbatim or near-verbatim from user chat |
| **Agreed change** | What will be built — product language, not implementation guesses |
| **Files / components** | Paths or component names to spot-check at execution |
| **Confirmed forks** | A/B/C choices made during grill (misalignment only); `none` if N/A |

<!-- Example:
### Settings — notification toggle

| Field | Content |
|-------|---------|
| **Current behavior** | Settings screen has email field only; no notification prefs |
| **Your request** | Add a way to turn email alerts on/off on settings |
| **Agreed change** | Toggle on Settings screen; OFF by default; saves immediately on change |
| **Files / components** | `lib/screens/settings_screen.dart`, `lib/providers/notification_prefs.dart` |
| **Confirmed forks** | Save timing: A) immediate on toggle (chosen) |
-->

---

## Issue sizing notes

Internal — used by `/plan-synthesis` hybrid rule:

- **Combine:** same screen + same files + small scope
- **Split:** >~3 days effort OR mixes unrelated journeys

## CONTEXT.md updates

<List terms/decisions written to CONTEXT.md during grill, or `none`>