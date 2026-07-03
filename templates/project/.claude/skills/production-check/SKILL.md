---
name: production-check
description: Run a production-readiness checklist before merge or deployment, covering build, tests, migration, config, secrets, observability, rollback, and smoke tests.
---

# Production Check Skill

Use this before merge, release, or deployment.

## Checklist

Check and report:

1. Build passes.
2. Unit tests pass.
3. Integration tests or smoke tests pass where available.
4. Database migrations are safe and reversible or rollback plan exists.
5. Config changes are documented.
6. Secrets are not committed.
7. Logs avoid sensitive data.
8. Metrics/health checks are sufficient.
9. Backward compatibility is considered.
10. Rollback steps are clear.
11. Manual acceptance test steps exist.

## Output format

```md
# Production Readiness Check

## Verdict

READY | NOT_READY

## Checks Run

## Blockers

## Warnings

## Smoke Test Plan

## Rollback Plan
```
