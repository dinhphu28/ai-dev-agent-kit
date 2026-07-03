# Atlassian MCP Setup

Give supported AI clients read/search access to Jira and Confluence, and scoped create/update on issues or pages when your organization allows it.

This kit uses a **local stdio MCP** (`atlassian-mcp`) as the default, so the agent talks to Atlassian through a binary you control instead of a remote endpoint. A remote Rovo MCP alternative is documented at the bottom.

## Claude Code (local stdio — default)

Install the `atlassian-mcp` binary (default location `~/.local/bin/atlassian-mcp`), then configure and authenticate it once:

```bash
atlassian-mcp setup    # enter site URL, Jira/Confluence, email, API token
atlassian-mcp login    # verify credentials
```

Register it with Claude Code under the server name `atlassian`:

```bash
claude mcp add --transport stdio atlassian -- ~/.local/bin/atlassian-mcp
```

Verify the tools are available:

```text
/mcp
```

You should see the `atlassian` server connected. Tools exposed by the local server (prefixed `mcp__atlassian__` when the agent calls them):

```text
# Jira
jira_get_issue            jira_search              jira_get_transitions
jira_create_issue         jira_update_issue        jira_transition_issue
jira_add_comment          jira_get_comments        jira_download_attachments
jira_get_issue_images

# Confluence
confluence_get_page       confluence_search        confluence_get_page_children
confluence_create_page    confluence_update_page   confluence_get_page_history
confluence_add_comment    confluence_get_comments  confluence_reply_to_comment
confluence_add_label      confluence_get_labels    confluence_move_page
confluence_get_attachments confluence_download_attachment confluence_upload_attachment
confluence_delete_page
```

Use `/mcp` to confirm the exact tool list, since it can change with the binary version.

## Codex / opencode (local stdio)

Point the client at the same binary. Configure an MCP server named `atlassian` with:

```text
command: ~/.local/bin/atlassian-mcp
transport: stdio
```

For Codex (`.codex/config.toml`):

```toml
[mcp_servers.atlassian]
command = "/home/YOU/.local/bin/atlassian-mcp"
args = []
```

If a client cannot launch a local stdio MCP, fall back to a CLI wrapper that exposes only these read-only actions:

```text
jira_get_issue
jira_search
confluence_get_page
confluence_search
```

## Remote Rovo MCP (alternative)

If you prefer Atlassian's hosted Rovo MCP instead of the local binary, register the remote URL:

```bash
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

Then run `/mcp` in Claude Code and authenticate with Atlassian in the browser. For Codex/opencode, configure an MCP server named `atlassian` with URL `https://mcp.atlassian.com/v1/mcp/authv2`.

## Security Rules

- Use least-privilege Atlassian access; scope the API token to only what the agent needs.
- Do not give AI write access to all spaces by default.
- Prefer creating/updating pages under a dedicated AI workspace/parent page.
- Do not allow the agent to overwrite human-authored pages without appending a clearly marked section.
- Require human approval before high-impact design or production changes.
- Keep the local `atlassian-mcp` config and API token out of the repository.
