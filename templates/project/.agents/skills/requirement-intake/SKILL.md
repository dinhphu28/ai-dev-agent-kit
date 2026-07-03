---
name: requirement-intake
description: Convert unclear software requirements, Jira issues, client notes, or rough ideas into structured scope, business rules, open questions, risks, and a ready/not-ready decision before coding.
---

# Requirement Intake Skill

Use this skill before implementation when the requirement is vague, large, or only partly understood.

## Goal

Create external memory for the project before code is written.

## Inputs

Prefer these inputs, but continue with what is available:

- Rough client request, Jira issue, chat note, PDF summary, or project brief.
- Existing `docs/` files.
- Existing source code only if needed to understand constraints.

## Process

1. Identify the business goal.
2. Identify actors and permissions.
3. Extract explicit requirements.
4. Infer likely implicit requirements, but mark them as assumptions.
5. Separate business rules from implementation ideas.
6. Identify open questions.
7. Decide whether the task is ready for design or implementation.
8. Write/update the docs listed below.

## Output files

Write or update:

```text
docs/ai-workflow/current-requirement.md
docs/ai-workflow/open-questions.md
docs/ai-workflow/assumptions.md
docs/ai-workflow/risks.md
```

## Required output format

```md
# Requirement Intake

## Business Goal

## Scope

## Out of Scope

## Actors

## Functional Requirements

## Business Rules

## Assumptions

## Open Questions

## Risks

## Ready / Not Ready Decision

Decision: READY | NOT_READY
Reason:
```

## Stop rule

If open questions affect security, data model, API contract, billing, permissions, or destructive behavior, do not continue to implementation. Produce questions and stop.
