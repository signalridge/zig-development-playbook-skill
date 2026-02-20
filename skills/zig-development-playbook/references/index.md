# Zig Reference Index

Use this page as the default entry point when you are not sure which reference to load first.
This file is the canonical routing map; keep task-to-reference tables here only.

## Fast Route by Task

| Task Category | Start Here | Then Load |
| --- | --- | --- |
| `build` | `references/development-standards.md` | `references/quick-fixes.md` |
| `allocator` | `references/development-standards.md` | `references/quick-fixes.md` |
| `interop` | `references/zig-c-interop-deep-template.md` | `references/development-standards.md` |
| `toolchain` | `references/official-learning-path.md` | `scripts/check-zig-version.sh` |
| `release/cross-target` | `scripts/zig_quality_gate.sh` | `references/quick-fixes.md` |
| `ecosystem/examples` | `references/zig-ecosystem-projects.md` | `references/development-standards.md` |

## Decision Flow

1. If there is a compiler/build error, start with `references/quick-fixes.md`.
2. If the task is structural or workflow-oriented, start with `references/development-standards.md`.
3. If C ABI or headers are involved, start with `references/zig-c-interop-deep-template.md`.
4. If Zig installation/version mismatch is suspected, run `scripts/check-zig-version.sh`.
5. If preparing final verification or release artifacts, run `scripts/zig_quality_gate.sh`.
