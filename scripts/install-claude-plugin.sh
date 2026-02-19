#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_PLUGIN_DIR="$REPO_ROOT/plugins/zig-development-playbook"
DEST_PLUGIN_DIR="${CLAUDE_PLUGIN_DIR:-$HOME/.claude/plugins/repos/zig-development-playbook}"

mkdir -p "$(dirname "$DEST_PLUGIN_DIR")"
rm -rf "$DEST_PLUGIN_DIR"
cp -R "$SRC_PLUGIN_DIR" "$DEST_PLUGIN_DIR"

echo "Installed Claude plugin to: $DEST_PLUGIN_DIR"
