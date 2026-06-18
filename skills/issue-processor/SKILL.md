---
name: issue-processor
description: Process all issues in a project folder sequentially until no executable issue remains. Use when running a batch of tickets or processing issues.
---
# Issue Processor

## Goal

Process all issues in the designated issues folder (e.g., `.scratch/<feature-slug>/issues/`) until no executable issue remains.

## Quick start

```markdown
Run the issue processor workflow:
1. Locate the issues directory.
2. Select the next non-completed, non-blocked issue.
```

## Workflows

### Batch Issue Processing Loop

1. **Scan and Filter**: Scan the target issues folder (e.g., `.scratch/<feature-slug>/issues/`). 
2. **Determine Executability**: Pick the next available task that isn't blocked by any other tasks.
3. **Launch Subagent**:
   - Create a fresh subagent using the `Task` tool (Grok) or `invoke_subagent` (AntiGravity).
   - In the subagent prompt, instruct it to read and follow the `tdd` skill at `~/.gemini/config/skills/tdd/SKILL.md` using `Read` (Grok) or `view_file` with `IsSkillFile: true` (AntiGravity).
   - Provide the path of the issue file, and relevant project context (e.g., `CONTEXT.md`, `AGENTS.md`) in the prompt.
   - Skip UI tests.
   - Run automated feedback loops (like type checking and tests) when finished.
4. **Verify Resolution**:
   - Verify that acceptance criteria are satisfied, the project builds successfully, and tests pass.
5. **Mark Completed**:
   - Update the issue file frontmatter to `Status: completed`.
6. **Loop**: Repeat from step 1 until a stop condition is met.

## Rules

- **One Subagent Per Issue**: Use a separate, fresh subagent for each issue to keep context clean.
- **Transient Failures**: Automatically retry execution or fix failures without stopping unless a critical error is encountered.
- **Continuous Execution**: Keep running until all issues are processed or blocked.
- **AUTONOMOUS MODE**: Run the entire process fully autonomously. Do not prompt, ask questions (e.g. using `AskQuestion` or `ask_question`), or wait for user inputs, reviews, or confirmations on tasks, plans, or execution steps. Automatically execute commands, run verification tests, and handle errors without pausing for manual approval.


## Stop Conditions

- All issues are completed.
- All remaining issues are blocked by other uncompleted tasks.
- A critical project failure (e.g., build failure that can't be resolved) prevents further progress.
