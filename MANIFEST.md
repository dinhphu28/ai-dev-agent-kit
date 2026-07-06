# AI Dev Agent Kit Manifest

## Core

- `AGENTS.md` — universal project rules
- `CLAUDE.md` — Claude Code entrypoint
- `docs/ai-workflow/` — local external memory for AI agents
- `tasks/TASK-000-template.md` — reusable task template
- `bin/ai-dev` — helper CLI

## Skills

- `requirement-intake`
- `confluence-sync`
- `task-split`
- `design-review`
- `implement-task`
- `review-diff`
- `production-check`
- `session-handoff`
- `opencode-lite`

## Claude Code

- `.claude/skills/*/SKILL.md`
- `.claude/agents/planner.md`
- `.claude/agents/reviewer.md`
- `.claude/agents/test-fixer.md`

## Codex

- `.agents/skills/*/SKILL.md`
- `.codex/config.example.toml`

## opencode

- `.opencode/opencode.jsonc`
- `.opencode/agents/ai-lite-plan.md`
- `.opencode/agents/ai-lite-build.md`
- `.opencode/agents/ai-lite-review.md`
- `.opencode/skills/*/SKILL.md`
- `bin/ai-dev opencode-loop` for repeated small `ai-lite-build` slices

## Jira / Confluence

- `docs/ai-workflow/mcp-atlassian-setup.md`
- `docs/ai-workflow/confluence/source-index.md`
- `docs/ai-workflow/confluence/requirement-snapshot.md`
- `docs/ai-workflow/confluence/clarification-qna-template.md`
- `docs/ai-workflow/confluence/design-note-template.md`
- `docs/ai-workflow/confluence/implementation-summary-template.md`
- `confluence-sync` skill for reading Jira/Confluence and publishing Q&A/design notes safely
