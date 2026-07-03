---
name: design-review
description: Review a feature design before implementation, checking architecture boundaries, REST/API shape, security, validation, data model, transactions, tests, and production risk.
---

# Design Review Skill

Use this before implementation when a feature has API, database, security, or architecture impact.

## Review checklist

Check:

1. Business goal matches the requirement.
2. API design uses resources and proper HTTP methods.
3. Authn/authz is explicit.
4. Validation rules are explicit.
5. Data model has constraints, not only application checks.
6. Transactions are clear.
7. Error handling is consistent.
8. Observability is sufficient.
9. Backward compatibility is considered.
10. Tests cover happy path, validation, authorization, and important edge cases.

## Output format

```md
# Design Review

## Verdict

APPROVED | NEEDS_CHANGES | BLOCKED

## Critical Issues

## Missing Decisions

## Suggested Changes

## Implementation Notes

## Test Plan
```

## Stop rule

If security, data ownership, external side effects, or destructive operations are unclear, mark `BLOCKED` and ask questions.
