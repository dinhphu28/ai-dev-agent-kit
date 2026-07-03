#!/usr/bin/env bash
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE=0

usage() {
  cat <<USAGE
AI Dev Agent Kit installer

Usage:
  ./install.sh global [--force]
  ./install.sh project <repo-path> [--force]
  ./install.sh opencode-lite <repo-path> [--force]
  ./install.sh help

Commands:
  global         Install reusable skills globally for Claude Code, Codex, and opencode.
  project        Initialize a repository with AGENTS.md, skills, docs, task template, and opencode lite config.
  opencode-lite  Install only opencode lightweight config into a repository.

Notes:
  - Existing files are not overwritten unless --force is provided.
  - When --force overwrites a file, a timestamped .bak file is created.
USAGE
}

parse_force() {
  for arg in "$@"; do
    if [[ "$arg" == "--force" ]]; then FORCE=1; fi
  done
}

copy_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      cp "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
      cp "$src" "$dst"
      echo "overwritten: $dst"
    else
      echo "skip existing: $dst"
    fi
  else
    cp "$src" "$dst"
    echo "installed: $dst"
  fi
}

copy_tree() {
  local src_root="$1"
  local dst_root="$2"
  find "$src_root" -type f | while read -r src; do
    rel="${src#$src_root/}"
    copy_file "$src" "$dst_root/$rel"
  done
}

install_global() {
  echo "Installing global AI Dev Agent Kit skills..."
  copy_tree "$KIT_DIR/skills" "$HOME/.claude/skills"
  copy_tree "$KIT_DIR/skills" "$HOME/.agents/skills"
  copy_tree "$KIT_DIR/skills" "$HOME/.config/opencode/skills"

  mkdir -p "$HOME/.local/bin"
  copy_file "$KIT_DIR/bin/ai-dev" "$HOME/.local/bin/ai-dev"
  chmod +x "$HOME/.local/bin/ai-dev"

  echo
  echo "Done. Ensure ~/.local/bin is in PATH if you want to use ai-dev globally."
}

install_project() {
  local repo="${1:-}"
  if [[ -z "$repo" ]]; then
    echo "repo path is required"
    usage
    exit 1
  fi
  mkdir -p "$repo"
  repo="$(cd "$repo" && pwd)"
  echo "Installing project files into $repo"
  copy_tree "$KIT_DIR/templates/project" "$repo"
  mkdir -p "$repo/bin"
  copy_file "$KIT_DIR/bin/ai-dev" "$repo/bin/ai-dev"
  chmod +x "$repo/bin/ai-dev"
  echo
  echo "Done. Commit AGENTS.md, CLAUDE.md, .claude/, .agents/, .opencode/, docs/ai-workflow/, and tasks/."
}

install_opencode_lite() {
  local repo="${1:-}"
  if [[ -z "$repo" ]]; then
    echo "repo path is required"
    usage
    exit 1
  fi
  mkdir -p "$repo"
  repo="$(cd "$repo" && pwd)"
  echo "Installing opencode lite files into $repo"
  copy_tree "$KIT_DIR/templates/project/.opencode" "$repo/.opencode"
  copy_file "$KIT_DIR/templates/project/AGENTS.md" "$repo/AGENTS.md"
  copy_file "$KIT_DIR/templates/project/docs/ai-workflow/agent-index.md" "$repo/docs/ai-workflow/agent-index.md"
  copy_file "$KIT_DIR/templates/project/docs/ai-workflow/session-handoff.md" "$repo/docs/ai-workflow/session-handoff.md"
  copy_file "$KIT_DIR/templates/project/tasks/TASK-000-template.md" "$repo/tasks/TASK-000-template.md"
  echo
  echo "Done. Use @ai-lite-plan, @ai-lite-build, and @ai-lite-review in opencode."
}

cmd="${1:-help}"
shift || true
parse_force "$@"

case "$cmd" in
  global)
    install_global
    ;;
  project)
    target="${1:-}"
    install_project "$target"
    ;;
  opencode-lite)
    target="${1:-}"
    install_opencode_lite "$target"
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "unknown command: $cmd"
    usage
    exit 1
    ;;
esac
