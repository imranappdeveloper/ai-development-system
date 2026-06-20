---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## On lock (after user confirms `yes`)

Write or update `work/requirement-lock.md` with `status: approved`. That lock doc is the execution SSOT for AFK — agents do not read grill snapshots.

**Do not** run `usage-feedback.sh snapshot` for grill sessions. **Do not** show snapshot paths or summaries to the user.
