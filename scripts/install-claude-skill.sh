#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_SKILL_DIR="$REPO_ROOT/skills/zig-development-playbook"
CLAUDE_SKILLS_ROOT="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DEST_SKILL_DIR="$CLAUDE_SKILLS_ROOT/local/zig-development-playbook"

mkdir -p "$(dirname "$DEST_SKILL_DIR")"
rm -rf "$DEST_SKILL_DIR"
cp -R "$SRC_SKILL_DIR" "$DEST_SKILL_DIR"

echo "Installed Claude skill to: $DEST_SKILL_DIR"
