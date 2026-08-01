<!--
SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
SPDX-License-Identifier: MIT
-->

# zlb (Zig Language Benchmark)

This project provides a quantitative evaluation of optimization capabilities and runtime overhead across a spectrum of programming languages—from low-level systems languages to high-level scripting languages. It specifically aims to demonstrate the performance and implementation idiomatics of **Zig 0.16.0** compared to established industry standards.

## 1. Measurement Environment

- **OS**: Linux 7.1.4-arch
- **Zig**: 0.16.0
- **C (gcc)**: 16.1.1 (Optimization: -O3)
- **C (clang)**: 22.1.8 (Optimization: -O3)
- **Rust**: 1.97.1 (Optimization: --release)
- **Go**: 1.26.5
- **Python**: 3.14.6
- **Bash**: 5.3.15

## 2. Benchmark Items

| Item | Content | Primary Objective |
| :--- | :--- | :--- |
| **mandel** | Mandelbrot Set calculation | Pure floating-point math, loop unrolling, and SIMD efficiency. |
| **sieve** | Sieve of Eratosthenes | Array access speed and the impact of Runtime Bounds Checking. |
| **btree** | Binary Tree generation/deletion | Allocator efficiency and Garbage Collection (GC) overhead. |

## 3. Zig 0.16.0 Implementation Strategy

Following the latest idiomatic patterns for Zig 0.16.0, this project applies the following strategies to verify its advantages over other languages:

- **Zero-Copy Philosophy**: Utilizing `std.mem.asBytes` for type-safe, non-copying binary casts.
- **Optimized Memory Management**: Leveraging `std.heap.ArenaAllocator` for high-speed batch deallocation (btree).
- **Modern Initialization Patterns**: Moving away from deprecated `init` functions to the `.empty` + `ensureTotalCapacity` pattern specific to v0.16.0.
- **Granular Safety Control**: Evaluating the performance trade-offs between `ReleaseSafe` (with runtime checks) and `ReleaseFast` (maximum optimization).

## 4. Repository Structure

Implementations for each algorithm are isolated into language-specific directories.

```text
src/
├── mandel/
│   ├── c/         # Common source for gcc/clang
│   ├── zig/       # Zig 0.16.0 implementation (including build.zig)
│   ├── rust/      # Rust implementation
│   ├── go/        # Go implementation
│   ├── python/    # Python implementation
│   └── bash/      # Bash implementation
├── sieve/         # (Same structure as above)
└── btree/         # (Same structure as above)
```

## 5. Methodology

- **Execution Time**: Statistical average calculation using `hyperfine` (including warm-up runs).
- **Resource Usage**: Measurement of Maximum Resident Set Size (RSS) via `/usr/bin/time -v`.
- **Fairness**: Each language uses its "Idiomatic" style while ensuring time complexity and iteration counts are strictly identical across all implementations.

## 6. Evaluation Results (Preview)

*Note: Initial architecture and placeholders established. Benchmarking results will be populated sequentially.*

| Pattern | gcc | clang | Rust | Zig (fast) | Zig (safe) | Go | Python | Bash |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **mandel** | 1.00 | | | | | | | |
| **sieve** | 1.00 | | | | | | | |
| **btree** | 1.00 | | | | | | | |

---

## License

This benchmark suite is released under the **MIT License**.
You are free to re-verify these implementations, measure in different environments, or cite the source code as a reference.
