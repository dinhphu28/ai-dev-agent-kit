# AGENTS.md

This project uses document-driven AI development. Treat repository files as external memory. Do not rely on chat memory.

## Prime Directive

Do not implement vague requirements directly. First clarify, document, split into small tasks, then implement exactly one task.

## Required Workflow

For any non-trivial change:

1. Read this file.
2. Read `docs/ai-workflow/agent-index.md`.
3. Read the specific task file under `tasks/`.
4. Read only docs and code relevant to that task.
5. Explain impacted layers before editing.
6. Make a small patch.
7. Add/update tests when behavior changes.
8. Run relevant checks.
9. Review the diff.
10. Report changed files, checks run, and remaining risks.

## Context Budget

Use lazy loading.

- Do not load all docs at once.
- Do not scan the whole repository unless the task is explicitly a repository-wide refactor.
- Prefer targeted search by domain term, class name, endpoint, or file path.
- If context grows too large, write `docs/ai-workflow/session-handoff.md` and stop.

## Tooling & Search

Prefer faster, modern CLI tools when they are installed; fall back to POSIX tools when they are not. Never fail a task just because a preferred tool is missing.

- Content search: prefer `rg` (ripgrep) over `grep` / `grep -r`. Scope by path and use type filters, e.g. `rg -t ts "pattern" src/`.
- File search: prefer `fd` over `find`, e.g. `fd -e ts config src/`.
- Fallback: if `rg` or `fd` is not on `PATH`, use `grep` / `find` instead.
- Do not run interactive tools non-interactively. `fzf`, `less`, `vim`, `top`, and similar block waiting for input and will hang the agent. For fuzzy matching, pipe `rg`/`fd` output through a non-interactive filter — never launch bare `fzf`.
- Keep searches targeted (see Context Budget); do not scan the whole repository unless the task requires it.
- Claude Code note: the built-in Grep and Glob tools already use ripgrep — prefer them over shelling out to `grep`/`find`.

## Jira / Confluence Rules

- Treat Jira and Confluence as external source-of-truth systems.
- For Jira/Confluence tasks, first use the `confluence-sync` workflow.
- Read the Jira issue and directly linked Confluence pages before searching broadly.
- Store compact local snapshots under `docs/ai-workflow/confluence/`.
- If blocking questions remain open, write clarification questions and stop.
- Do not implement from vague or contradictory Confluence content.
- When publishing back to Confluence, append or create clearly marked AI sections/pages; do not silently overwrite human content.

## Architecture Rules

- Preserve existing architecture and package/module boundaries.
- Do not put business logic directly in controllers/handlers.
- Do not let infrastructure code leak into domain/application logic.
- Do not introduce circular dependencies.
- Prefer small vertical slices over broad rewrites.
- Do not introduce new dependencies without explaining why existing tools are insufficient.

## API Rules

- REST endpoints should use resources/nouns and correct HTTP methods.
- Validate request DTOs at the boundary.
- Do not expose internal entities directly if DTOs exist.
- Return consistent error responses.
- Keep backward compatibility unless the task explicitly allows breaking changes.

## Security Rules

- Default deny.
- Every modifying endpoint must have explicit authorization.
- Never trust user identity, tenant ID, role, or ownership from request body if authenticated context exists.
- Do not log secrets, tokens, passwords, or sensitive personal data.
- Validate and sanitize external inputs.

## Database Rules

- Use migrations for schema changes.
- Enforce business uniqueness with database constraints where possible.
- Consider transaction boundaries.
- Do not rely only on application validation for critical invariants.

## Testing Rules

- Add tests for behavior changes.
- Cover happy path, validation failure, authorization failure, and important edge cases.
- Do not delete or weaken tests just to pass.
- Run the narrowest relevant tests first, then broader checks if needed.

## Done Definition

A task is done only when:

- Acceptance criteria are satisfied.
- Code compiles.
- Relevant tests/checks pass or failures are clearly reported.
- Diff contains no unrelated changes.
- Security/validation/error handling were reviewed.
- Remaining risks are documented.
