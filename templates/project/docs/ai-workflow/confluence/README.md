# Confluence Workflow

This folder stores compact local snapshots of Jira/Confluence context. It prevents AI agents from repeatedly loading large pages and losing important details.

Recommended flow:

```text
Jira issue / Confluence pages
  -> source-index.md
  -> requirement-snapshot.md
  -> clarification-qna.md
  -> design-note.md
  -> task files
  -> implementation-summary.md
  -> GitLab MR
```

Rules:

- Do not copy huge Confluence pages here.
- Summarize facts, constraints, decisions, and unresolved questions.
- Keep source links/page titles in `source-index.md`.
- Treat these files as the repo-local memory for AI agents.
