#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  zig_quality_gate.sh [project_dir] [--release-mode <mode>] [--targets <csv>] [--skip-fmt] [--skip-version-check] [--strict-0-15]

Options:
  project_dir             Project root path. Default: current directory.
  --release-mode <mode>   Debug | ReleaseSafe | ReleaseFast | ReleaseSmall (default: ReleaseSafe)
  --targets <csv>         Optional cross-target list, comma separated.
  --skip-fmt              Skip 'zig fmt --check .'.
  --skip-version-check    Skip running Zig toolchain compatibility check.
  --strict-0-15           Require Zig 0.15.x in toolchain compatibility check.
  -h, --help              Show this help.
USAGE
}

project_dir="."
release_mode="ReleaseSafe"
targets_csv=""
skip_fmt=0
skip_version_check=0
strict_0_15=0
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
check_version_script="$script_dir/check-zig-version.sh"

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    --release-mode)
        [[ $# -ge 2 ]] || {
            echo "ERROR: --release-mode requires a value" >&2
            exit 2
        }
        release_mode="$2"
        shift 2
        ;;
    --targets)
        [[ $# -ge 2 ]] || {
            echo "ERROR: --targets requires a CSV value" >&2
            exit 2
        }
        targets_csv="$2"
        shift 2
        ;;
    --skip-fmt)
        skip_fmt=1
        shift
        ;;
    --skip-version-check)
        skip_version_check=1
        shift
        ;;
    --strict-0-15)
        strict_0_15=1
        shift
        ;;
    -*)
        echo "ERROR: Unknown option: $1" >&2
        usage
        exit 2
        ;;
    *)
        project_dir="$1"
        shift
        ;;
    esac
done

case "$release_mode" in
Debug | ReleaseSafe | ReleaseFast | ReleaseSmall) ;;
*)
    echo "ERROR: Invalid --release-mode '$release_mode'" >&2
    exit 2
    ;;
esac

if ! command -v zig >/dev/null 2>&1; then
    echo "ERROR: 'zig' not found in PATH." >&2
    echo "Install Zig first: https://ziglang.org/learn/getting-started/" >&2
    exit 127
fi

[[ -d "$project_dir" ]] || {
    echo "ERROR: project directory not found: $project_dir" >&2
    exit 2
}
cd "$project_dir"
[[ -f "build.zig" ]] || {
    echo "ERROR: build.zig not found in: $(pwd)" >&2
    exit 2
}

run_step() {
    local label="$1"
    shift
    echo "==> $label"
    "$@"
}

if [[ "$skip_version_check" -eq 0 ]]; then
    if [[ -x "$check_version_script" ]]; then
        if [[ "$strict_0_15" -eq 1 ]]; then
            run_step "Toolchain version check (strict 0.15.x)" "$check_version_script" --strict-0-15
        else
            run_step "Toolchain version check" "$check_version_script"
        fi
    else
        run_step "Toolchain version check" zig version
    fi
fi

if [[ "$skip_fmt" -eq 0 ]]; then
    run_step "Formatting check" zig fmt --check .
fi

run_step "Test suite" zig build test
run_step "Primary build" zig build -Doptimize="$release_mode"

if [[ -n "$targets_csv" ]]; then
    IFS=',' read -r -a targets <<<"$targets_csv"
    for raw in "${targets[@]}"; do
        target="${raw//[[:space:]]/}"
        [[ -n "$target" ]] || continue
        run_step "Cross build ($target)" zig build -Dtarget="$target" -Doptimize="$release_mode"
    done
fi

echo "==> Zig quality gate passed"
