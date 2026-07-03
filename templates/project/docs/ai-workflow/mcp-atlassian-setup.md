# Atlassian MCP Setup

Use Atlassian Rovo MCP to let supported AI clients read/search Jira and Confluence, and create/update issues or pages when your organization allows it.

## Claude Code

Run:

```bash
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

Then inside Claude Code:

```text
/mcp
```

Authenticate with Atlassian in the browser.

## Codex / opencode

If your client supports MCP, configure an Atlassian MCP server named `atlassian` with this URL:

```text
https://mcp.atlassian.com/v1/mcp/authv2
```

If your client does not support remote MCP or your company blocks it, use a local custom MCP or CLI wrapper that exposes only these safe actions:

```text
jira_get_issue
jira_comment
confluence_search
confluence_get_page
confluence_create_or_update_page
```

## Security Rules

- Use least-privilege Atlassian access.
- Do not give AI write access to all spaces by default.
- Prefer creating/updating pages under a dedicated AI workspace/parent page.
- Do not allow the agent to overwrite human-authored pages without appending a clearly marked section.
- Require human approval before high-impact design or production changes.
