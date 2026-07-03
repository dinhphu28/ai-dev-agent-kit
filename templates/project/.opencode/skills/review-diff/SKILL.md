---
name: review-diff
description: Review the current git diff for correctness, architecture violations, security issues, missing validation, missing tests, and production risks without making changes unless asked.
---

# Review Diff Skill

Use this after implementation and before merge request.

## Process

1. Inspect `git status`.
2. Inspect `git diff --stat` and targeted diffs.
3. Compare changes against the task file if provided.
4. Check architecture, security, validation, persistence, tests, and edge cases.
5. Do not edit files unless the user explicitly asks to fix issues.

## Review checklist

- Requirement match.
- No unrelated changes.
- API design is consistent.
- Authorization is enforced server-side.
- Validation happens at boundaries.
- Database constraints match business uniqueness.
- Error responses are consistent.
- Tests cover happy path and negative paths.
- No secrets or PII logging.
- Migration/backward compatibility risks are clear.

## Output format

```md
# Diff Review

## Verdict

APPROVED | NEEDS_CHANGES | BLOCKED

## Critical Issues

## Important Suggestions

## Minor Suggestions

## Missing Tests

## Security Notes

## Production Risk
```
