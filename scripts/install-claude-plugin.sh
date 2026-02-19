#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_PLUGIN_DIR="${CLAUDE_PLUGIN_DIR:-$HOME/.claude/plugins/repos/zig-development-playbook}"

mkdir -p "$(dirname "$DEST_PLUGIN_DIR")"
rm -rf "$DEST_PLUGIN_DIR"
mkdir -p "$DEST_PLUGIN_DIR"

cp -R "$REPO_ROOT/.claude-plugin" "$DEST_PLUGIN_DIR/.claude-plugin"
cp -R "$REPO_ROOT/skills" "$DEST_PLUGIN_DIR/skills"

if [[ -f "$REPO_ROOT/README.md" ]]; then
  cp "$REPO_ROOT/README.md" "$DEST_PLUGIN_DIR/README.md"
fi

echo "Installed Claude plugin to: $DEST_PLUGIN_DIR"
