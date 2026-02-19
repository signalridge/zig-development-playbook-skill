#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_SKILL_DIR="$REPO_ROOT/skills/zig-development-playbook"
CODEX_SKILLS_ROOT="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
DEST_SKILL_DIR="$CODEX_SKILLS_ROOT/local/zig-development-playbook"

mkdir -p "$(dirname "$DEST_SKILL_DIR")"
rm -rf "$DEST_SKILL_DIR"
cp -R "$SRC_SKILL_DIR" "$DEST_SKILL_DIR"

echo "Installed Codex skill to: $DEST_SKILL_DIR"
