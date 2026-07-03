---
name: confluence-sync
description: Use when a task needs Jira/Confluence requirement intake, clarification Q&A, design-note publishing, or syncing AI workflow docs back to Confluence.
---

# Confluence Sync Skill

Use this skill when the user asks to work from Jira/Confluence or to publish clarification, requirement, design, or implementation notes to Confluence.

## Principle

Confluence is an external memory source, not a full context dump. Never load an entire space unless the user explicitly asks. Fetch the Jira issue, linked pages, and the smallest set of related pages needed for the current task.

## Required Flow

1. Identify the Jira issue key or Confluence page URL/title.
2. Read the Jira issue and only directly linked Confluence pages first.
3. Create/update local snapshots under `docs/ai-workflow/confluence/`:
   - `source-index.md`
   - `requirement-snapshot.md`
   - `clarification-qna.md`
   - `design-note.md`
4. If requirement is unclear, write clarification questions and stop implementation.
5. If requirement is clear, write a design note and ask for/require approval before implementation when the change is high impact.
6. After implementation, publish/update the implementation summary and MR link.

## Context Budget Rules

- Prefer page summaries over full pages.
- Extract business rules, constraints, actors, acceptance criteria, APIs, security notes, and open questions.
- Do not paste full Confluence pages into prompts.
- Use `docs/ai-workflow/confluence/source-index.md` to track what was read.
- If the agent is weak or context grows too large, write `docs/ai-workflow/session-handoff.md` and stop.

## Clarification Gate

Stop and ask questions if any of these are unknown:

- Who can perform the action?
- What data is required?
- What validation rules apply?
- What authorization/ownership rule applies?
- What happens on duplicate/conflict/cancel/delete?
- What compatibility requirement exists?
- What is out of scope?

## Publish Back to Confluence

When publishing to Confluence, use the project templates in:

- `docs/ai-workflow/confluence/clarification-qna-template.md`
- `docs/ai-workflow/confluence/design-note-template.md`
- `docs/ai-workflow/confluence/implementation-summary-template.md`

Do not overwrite human-authored Confluence content without preserving existing content or appending a clearly marked AI section.

## Suggested Confluence Page Structure

```text
AI Workspace
  ├─ <JIRA-KEY> Requirement Snapshot
  ├─ <JIRA-KEY> Clarification Q&A
  ├─ <JIRA-KEY> Design Note
  └─ <JIRA-KEY> Implementation Summary
```

## Output Required

Always report:

- Source pages read
- Requirement summary
- Open questions
- Assumptions
- Decision needed from human
- Whether implementation is allowed to start
