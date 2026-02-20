# Zig Quick Fixes

Use this file when `zig build` or `zig build test` fails and you need high-confidence fixes first.

## Workflow

1. Run `zig build`.
2. Match the error text with the table below.
3. Apply the smallest fix.
4. Re-run `zig build test`.
5. Run `scripts/zig_quality_gate.sh` before final sign-off.

## High-Frequency Fix Table

| Compiler/Error Symptom | Likely Cause | Minimal Fix |
| --- | --- | --- |
| `no field named 'root_source_file'` in `addExecutable` | Old build API pattern | Use `.root_module = b.createModule(.{ .root_source_file = ..., .target = ..., .optimize = ... })` |

### `build.zig` API Migration

**WRONG (old API):**
```zig
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = b.path("src/main.zig"),  // ERROR: no field named 'root_source_file'
        .target = target,
        .optimize = optimize,
    });
}
```

**CORRECT (current API):**
```zig
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(exe);
}
```
| `no field or member function named 'addSharedLibrary'` | Old build API call | Use `b.addLibrary(.{ .linkage = .dynamic, ... })` |
| `expected 2 arguments, found 1` on `ArrayList.append` | Missing allocator argument in 0.15+ APIs | Use `list.append(allocator, value)` |
| `expected 1 argument, found 0` on `ArrayList.deinit` | Missing allocator argument | Use `list.deinit(allocator)` |

### `ArrayList` API Changes

**WRONG (old API):**
```zig
const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var list = std.ArrayList(u8).init(allocator);
list.append('a');      // ERROR: expected 2 arguments
list.deinit();         // ERROR: expected 1 argument
```

**CORRECT (current API):**
```zig
const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var list = std.ArrayList(u8).init(allocator);
defer list.deinit(allocator);

try list.append(allocator, 'a');
try list.append(allocator, 'b');
```

**Alternative: Use `ArrayListUnmanaged` for explicit allocator control:**
```zig
var list: std.ArrayListUnmanaged(u8) = .empty;
defer list.deinit(allocator);

try list.append(allocator, 'a');
```
| `no field named 'Struct'` in `@typeInfo` checks | Old enum tags | Use lowercase tags such as `.@"struct"`, `.int`, `.slice`, `.pointer` |

### `@typeInfo` Field Name Changes

**WRONG (0.13 and earlier):**
```zig
const info = @typeInfo(T);
if (info == .Struct) { ... }
const fields = info.Struct.fields;
```

**CORRECT (0.14+):**
```zig
const info = @typeInfo(T);
if (info == .@"struct") { ... }
const fields = info.@"struct".fields;
```

Full mapping: `.Struct` → `.@"struct"`, `.Int` → `.int`, `.Pointer` → `.pointer`, `.Fn` → `.@"fn"`
| `GenericWriter`/`GenericReader` deprecation or missing APIs | Using pre-`std.io` patterns | Switch to `std.io.Writer`/`std.io.Reader` with explicit buffering |

### `std.io` Migration (Writergate)

**WRONG (pre-Writergate):**
```zig
const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

// Old pattern using GenericWriter
var arr = std.ArrayList(u8).init(allocator);
const writer = arr.writer();
try writer.print("hello {s}", .{"world"});
```

**CORRECT (current):**
```zig
const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var arr = std.ArrayList(u8).init(allocator);
defer arr.deinit();

// Use std.io.getStdOut().writer() or create a buffered writer
var stdout = std.io.getStdOut().writer();
try stdout.print("hello {s}\n", .{"world"});

// For ArrayList, write then convert to slice
var buffer = std.ArrayList(u8).init(allocator);
defer buffer.deinit();
try buffer.writer().print("hello {s}", .{"world"});
const result = buffer.items;
```
| Output not visible after `print` | Missing flush | Call `try writer.flush()` after buffered writes |
| `use of undefined value` in arithmetic path | Undefined value used before init | Initialize value explicitly before arithmetic or loops |
| `no member named 'open'` on HTTP client | Old request API | Use `client.request(...)` or `client.fetch(...)` for current Zig API |
| `ambiguous format string` for custom formatter | Wrong format placeholder for formatter types | Use `{f}` for formatter-backed values |
| `usingnamespace` compile failure | Feature removed | Replace with explicit imports and re-exports |
| `async`/`await` keyword failure | Feature removed | Rewrite with synchronous flow or explicit threading/event loop strategy |
| Leak reports in tests | Missing cleanup paths | Add `defer`/`errdefer`; pair every alloc/create with free/destroy |
| Cross-target build fails only on one target | Target-specific assumptions in code/build | Build each target separately, then branch on `builtin.os.tag`/`builtin.cpu.arch` where required |

## Targeted Follow-Ups

- Build-system errors: also read `references/development-standards.md`.
- C interop errors: also read `references/zig-c-interop-deep-template.md`.
- Toolchain mismatch errors: run `scripts/check-zig-version.sh`.
