#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  check-zig-version.sh [--strict-0-15]

Options:
  --strict-0-15   Require Zig 0.15.x exactly.
  -h, --help      Show this help.

Environment:
  ZIG_CMD         Zig executable to use (default: zig).
USAGE
}

strict_0_15=0

while [[ $# -gt 0 ]]; do
    case "$1" in
    --strict-0-15)
        strict_0_15=1
        shift
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

zig_cmd="${ZIG_CMD:-zig}"

if ! command -v "$zig_cmd" >/dev/null 2>&1; then
    echo "ERROR: '$zig_cmd' not found in PATH." >&2
    echo "Install Zig first: https://ziglang.org/learn/getting-started/" >&2
    exit 127
fi

version_raw="$("$zig_cmd" version)"

if [[ ! "$version_raw" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    echo "ERROR: Unable to parse Zig version: $version_raw" >&2
    exit 2
fi

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"

echo "Detected Zig version: $major.$minor.$patch (raw: $version_raw)"

if [[ "$strict_0_15" -eq 1 ]]; then
    if [[ "$major" -eq 0 && "$minor" -eq 15 ]]; then
        echo "OK: strict 0.15.x requirement satisfied."
        exit 0
    fi
    echo "ERROR: strict 0.15.x required, but found $version_raw." >&2
    exit 1
fi

if [[ "$major" -eq 0 && "$minor" -lt 15 ]]; then
    echo "ERROR: Zig $version_raw is too old for this skill. Need 0.15+." >&2
    exit 1
fi

if [[ "$major" -eq 0 && "$minor" -eq 15 ]]; then
    echo "OK: Zig 0.15.x detected (pinned compatibility target)."
    exit 0
fi

if [[ "$major" -eq 0 && "$minor" -ge 16 ]]; then
    echo "WARN: Zig $version_raw detected (newer than pinned 0.15.x)." >&2
    echo "      Continue, but verify API differences in failing areas." >&2
    exit 0
fi

echo "WARN: Zig $version_raw detected (1.x or newer)." >&2
echo "      Continue, but verify API differences in failing areas." >&2
exit 0
