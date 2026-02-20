#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  install-claude-skill.sh [--skills-dir <path>]

Options:
  --skills-dir <path>  Claude skills root directory.
                       Priority: --skills-dir > CLAUDE_SKILLS_DIR > ~/.claude/skills
  -h, --help           Show this help.
USAGE
}

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_SKILL_DIR="$REPO_ROOT/skills/zig-development-playbook"
CLAUDE_SKILLS_ROOT="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

while [[ $# -gt 0 ]]; do
    case "$1" in
    --skills-dir)
        if [[ $# -lt 2 ]]; then
            echo "ERROR: --skills-dir requires a path argument." >&2
            usage
            exit 2
        fi
        CLAUDE_SKILLS_ROOT="$2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        echo "ERROR: Unknown option: $1" >&2
        usage
        exit 2
        ;;
    esac
done

DEST_SKILL_DIR="$CLAUDE_SKILLS_ROOT/ecosystem/signalridge/zig-development-playbook"

mkdir -p "$(dirname "$DEST_SKILL_DIR")"
rm -rf "$DEST_SKILL_DIR"
cp -R "$SRC_SKILL_DIR" "$DEST_SKILL_DIR"

echo "Installed Claude skill to: $DEST_SKILL_DIR"
