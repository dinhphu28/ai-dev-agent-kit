---
name: opencode-lite
description: Run a resource-light opencode workflow for weak local/self-hosted models: small context, small task, few steps, no broad search, and mandatory handoff when stuck.
---

# opencode Lite Skill

Use this when the model or runtime is weak, slow, freezes, or retries too much.

## Core rule

One session = one tiny step.

## Workflow

1. Read `AGENTS.md`.
2. Read only one task file.
3. Read only files named in the task or found by one targeted search.
4. Produce a 5-bullet plan.
5. Edit at most 3 files per iteration.
6. Run only the narrowest test/build command.
7. If stuck after one failed attempt, create `docs/ai-workflow/session-handoff.md` and stop.

## Forbidden in lite mode

- Do not scan the whole repo.
- Do not load all docs.
- Do not run all tests unless the project is tiny.
- Do not refactor unrelated code.
- Do not create many subagents.
- Do not loop more than twice on the same error.

## Good prompts

```text
Use opencode-lite. Inspect tasks/TASK-001.md and propose a tiny plan only.
```

```text
Use opencode-lite. Implement only acceptance criterion #1 in tasks/TASK-001.md.
```

```text
Use opencode-lite. Create a handoff summary for the next agent.
```
