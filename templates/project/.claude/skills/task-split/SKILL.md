---
name: task-split
description: Break approved requirements or designs into small implementation tasks with acceptance criteria, affected layers, tests, and do-not-do boundaries for coding agents.
---

# Task Split Skill

Use this skill after requirement intake and before implementation.

## Goal

Produce small task files that an AI coding agent can complete safely in one session.

## Process

1. Read only the requirement/design docs needed for the target feature.
2. Identify vertical slices.
3. Keep each task small: one API, one screen, one migration, one integration, or one domain behavior.
4. Define acceptance criteria and tests.
5. Add explicit do-not-do boundaries.
6. Put tasks under `tasks/`.

## Task size rule

A task is too large if it touches more than three major layers unless the change is mechanical.

Prefer:

```text
Task A: DB migration + entity
Task B: service behavior + tests
Task C: REST API + tests
Task D: frontend screen
```

instead of:

```text
Task A: implement the whole module
```

## Template

```md
# TASK-XXX: <short title>

## Goal

## Context

## Input Documents

## Affected Layers

- API:
- Domain/Application:
- Infrastructure/Persistence:
- Frontend:
- Tests:

## Acceptance Criteria

- [ ]

## Test Requirements

- [ ]

## Security / Authorization Requirements

## Validation Requirements

## Do Not Do

- Do not modify unrelated files.
- Do not introduce new dependencies unless justified.

## Done When

- [ ] Code compiles.
- [ ] Relevant tests pass.
- [ ] Diff is reviewed against `AGENTS.md`.
```
