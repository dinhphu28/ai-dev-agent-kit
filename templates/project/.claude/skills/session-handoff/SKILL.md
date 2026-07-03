---
name: session-handoff
description: Create a compact handoff summary for continuing work in another AI agent session, especially after context grows large or opencode reaches step limits.
---

# Session Handoff Skill

Use this when context is large, an agent is running out of budget, or work should continue in another session.

## Goal

Compress state without losing important decisions.

## Output file

Write/update:

```text
docs/ai-workflow/session-handoff.md
```

## Format

```md
# Session Handoff

## Current Task

## Goal

## Decisions Made

## Files Changed

## Tests Run

## Current Failure / Blocker

## Next Best Step

## Do Not Forget

## Commands Useful Next
```

## Rule

Prefer concrete file paths, exact command outputs, and explicit next steps. Avoid long narrative.
