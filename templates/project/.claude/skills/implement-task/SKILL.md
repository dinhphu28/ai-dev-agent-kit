---
name: implement-task
description: Implement exactly one prepared task file, preserving architecture, minimizing context, editing only relevant files, adding tests, and reporting changed files and verification results.
---

# Implement Task Skill

Use this only when a task file exists.

## Mandatory workflow

1. Read `AGENTS.md`.
2. Read the task file.
3. Read only the input documents listed in the task file.
4. Inspect existing code before editing.
5. Summarize impacted layers.
6. Implement the smallest correct change.
7. Add/update tests for behavior changes.
8. Run the most relevant checks available.
9. Review the diff against the task and `AGENTS.md`.
10. Report changed files, tests run, and remaining risks.

## Context budget rule

Do not load the whole repository. Use targeted search and read only files directly related to the task.

## Do-not-do rules

- Do not modify unrelated files.
- Do not redesign architecture unless the task explicitly requires it.
- Do not add dependencies without explicit justification.
- Do not skip authorization/validation/error handling.
- Do not delete tests to make the build pass.

## Final report format

```md
## Summary

## Changed Files

## Tests / Checks Run

## Acceptance Criteria Mapping

## Risks / Follow-up
```
