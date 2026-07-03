# Claude Code Project Instructions

@AGENTS.md

Use the project-local skills in `.claude/skills/` when the user asks for requirement intake, Confluence sync, task split, implementation, diff review, session handoff, or production check.

Prefer this sequence:

```text
/confluence-sync -> /requirement-intake -> /task-split -> /design-review -> /implement-task -> /review-diff -> /production-check
```

Do not implement unclear requirements directly. If open questions affect security, data model, permissions, external side effects, or destructive behavior, ask questions and stop.


For Jira/Confluence work, first use `confluence-sync`. Create/update compact snapshots under `docs/ai-workflow/confluence/` before implementing.
