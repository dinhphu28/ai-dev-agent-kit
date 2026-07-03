# AI Agent Index

Use this file to decide which project memory to load. Do not load all documents blindly.

## Core Files

- `AGENTS.md` — mandatory rules for all agents.
- `CLAUDE.md` — Claude Code entrypoint.
- `tasks/` — implementation task files.
- `docs/ai-workflow/current-requirement.md` — latest structured requirement.
- `docs/ai-workflow/open-questions.md` — unresolved questions.
- `docs/ai-workflow/assumptions.md` — assumptions that must not be silently treated as fact.
- `docs/ai-workflow/risks.md` — known delivery/security/technical risks.
- `docs/ai-workflow/session-handoff.md` — current handoff between AI sessions.

## When to Load What

- Requirement unclear: load requirement-intake skill and current requirement docs.
- Design/API/security question: load design docs and design-review skill.
- Implementation: load only one task file and referenced docs.
- Review: load current diff, task file, and `AGENTS.md`.
- opencode weak model: load opencode-lite skill and one task file only.

## Project-Specific Docs

Add your project docs here:

```text
docs/01-requirements.md
docs/02-business-rules.md
docs/03-architecture.md
docs/04-api-design.md
docs/05-domain-model.md
docs/06-database-design.md
docs/07-security-model.md
docs/08-validation-rules.md
docs/09-test-strategy.md
docs/10-task-breakdown.md
docs/11-open-questions.md
```
