# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

| Label in canonical role | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

### Work-to-PR workflow labels

Used by `/work-to-pr-v2` during execution (not general triage):

| Label | Meaning |
|---|---|
| `in-progress` | Agent claimed issue; branch exists |
| `done` | Agent work complete — PR opened. Unblocks dependents. Human merges when ready. |
| `pr-open` | Legacy only — repair to `done` on state sync |

Create `done` on GitHub if missing: `gh label create "done" --description "Agent complete — PR opened"`.

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.
