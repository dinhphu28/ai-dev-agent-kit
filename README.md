# AI Dev Agent Kit

Reusable workflow package for Claude Code, Codex, and opencode.

The goal is not to make an AI agent magically remember everything. The goal is to give every project an external memory and a safe workflow:

```text
Jira / Confluence / unclear requirement
  -> Confluence sync when external docs exist
  -> requirement intake
  -> open questions or design
  -> task breakdown
  -> one small implementation task
  -> tests
  -> diff review
  -> production checklist
```

## What this installs

```text
AGENTS.md                         Universal project rules for AI agents
CLAUDE.md                         Claude Code entrypoint that points to AGENTS.md
.claude/skills/*/SKILL.md          Claude Code reusable workflows, including confluence-sync
.claude/agents/*.md                Claude Code role prompts
.agents/skills/*/SKILL.md          Codex-compatible Agent Skills
.opencode/opencode.jsonc           Lightweight opencode config
.opencode/agents/*.md              opencode lightweight agents
.opencode/prompts/*.md             opencode agent prompts
docs/ai-workflow/*.md              External memory templates
docs/ai-workflow/confluence/*.md   Jira/Confluence snapshots and publish templates
tasks/TASK-000-template.md         Small task template
bin/ai-dev                         Helper CLI
```

## Install globally

From this package directory:

```bash
./install.sh global
```

This copies reusable skills to:

```text
~/.claude/skills/
~/.agents/skills/
~/.config/opencode/skills/
```

It does not overwrite existing files unless you pass `--force`.

## Initialize a project

```bash
./install.sh project /path/to/project
```

or from inside a repo:

```bash
./install.sh project .
```

This installs project-local files. Commit them to the repository.

## opencode weak-resource mode

opencode can work well if you force it to use tiny vertical slices and lazy-loaded skills.

After project install, run opencode from the repo root and use:

```text
@ai-lite-plan inspect this task: tasks/TASK-001.md
@ai-lite-build implement only TASK-001. Max one vertical slice. Do not load unrelated docs.
@ai-lite-review review the current diff.
```

The opencode config limits steps and prevents broad subagent fan-out by default.

## Claude Code usage

From the repo root:

```text
/requirement-intake docs/00-project-brief.md
/task-split docs/ai-workflow/current-requirement.md
/implement-task tasks/TASK-001.md
/review-diff
/production-check
```

Claude Code can also use `.claude/agents/` role prompts.

## Codex usage

Codex reads `AGENTS.md`. Use skills explicitly:

```text
Use the requirement-intake skill on docs/00-project-brief.md.
Use the task-split skill to create small tasks.
Use the implement-task skill for tasks/TASK-001.md only.
Use the review-diff skill on the current diff.
```


## Jira / Confluence workflow

Install project files, then configure the Atlassian MCP for your agent. The default is a **local stdio MCP** (`atlassian-mcp`) under the server name `atlassian`. Configure it once, then register it with Claude Code:

```bash
atlassian-mcp setup    # site URL, email, API token
atlassian-mcp login    # verify credentials
claude mcp add --transport stdio atlassian -- ~/.local/bin/atlassian-mcp
```

Run `/mcp` in Claude Code to confirm the `atlassian` server is connected. To use Atlassian's hosted Rovo MCP instead of the local binary:

```bash
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

See `docs/ai-workflow/mcp-atlassian-setup.md` for full setup, tool list, and security rules.

Use this flow:

```text
/confluence-sync JIRA-123
/requirement-intake docs/ai-workflow/confluence/requirement-snapshot.md
/task-split docs/ai-workflow/current-requirement.md
/implement-task tasks/TASK-001.md
/review-diff
```

For Codex/opencode, ask explicitly:

```text
Use the confluence-sync skill for JIRA-123. Read only the Jira issue and linked Confluence pages. Update docs/ai-workflow/confluence/ snapshots. If blocking questions remain, stop.
```

For weak opencode models, do not let it browse/search Confluence broadly. First ask a stronger agent or yourself to produce `docs/ai-workflow/confluence/requirement-snapshot.md`, then let opencode implement one task from that snapshot.

## Important rule

Do not ask an agent to implement a large unclear requirement directly.

Instead, always create or update a task file first:

```text
tasks/TASK-001-short-name.md
```

One task should be small enough for one agent session.
