<!--
SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
SPDX-License-Identifier: MIT
-->

# zlb (Zig Language Benchmark)

[日本語 (Japanese)](./README_ja.md)

This project provides a quantitative evaluation of optimization capabilities and runtime overhead across a spectrum of programming languages. It specifically aims to demonstrate the performance and implementation idiomatics of **Zig 0.16.0** compared to established industry standards.

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

## 3. Benchmark Variants & Implementation Levels

To ensure a fair "Ground Truth" comparison, implementations are categorized into several levels:

### C Language (Compiler Comparison)

We compare three major compilers using the same source code to observe differences in optimization logic:

- **gcc**: The industry standard GNU compiler.
- **clang**: LLVM-based compiler known for aggressive optimization.
- **zig cc**: Zig's built-in C compiler (Clang-based), configured with `-ffp-contract=off` to ensure floating-point consistency across SIMD implementations.

### Zig 0.16.0 (Safety & Strategy)

Zig implementations are evaluated in two build modes and various memory/compute strategies:

- **ReleaseFast**: Maximum optimization, all runtime safety checks disabled.
- **ReleaseSafe**: High optimization, but critical safety checks (bounds, overflow) remain active.
- **Optimized Strategies**:
    - `simd`: Manual vectorization using Zig's `@Vector` primitives.
    - `soa / bitset`: Memory layout optimization using `MultiArrayList` and high-density bit-packing.
    - `fixed / compact / manual`: Custom memory management using `FixedBufferAllocator` and 32-bit index-based pointers to minimize cache misses.

### Rust & Go (Modern Standards)

- **Rust**: Compiled with `opt-level=3` and `LTO` enabled. We include both idiomatic `Box` pointers and optimized `Arena` (Vec-based) implementations.
- **Go**: Evaluates the efficiency of the modern tracing Garbage Collector and standard heap management.

### Scripting Languages (Reference)

- **Python & Bash**: Included as high-level baselines.
- **Measurement Policy**: Due to the extreme performance gap (often several thousand times slower), these are measured with a single sample per task (`--runs 1`) to remain within reasonable execution time.

## 4. Methodology

- **Execution Time**: Statistical average calculation using `hyperfine` with 1 warmup run and 20 measurement runs (except for scripts).
- **Resource Usage**: Measurement of Maximum Resident Set Size (RSS) and System Overhead (%) using real-time process monitoring.
- **Fairness**: All implementations use strictly identical parameters (N, Depth) to ensure a direct comparison of the computational cost.

## 5. Evaluation Results

<!-- SUMMARY_START -->

### MANDEL Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_simd_fast | 0.15x | 6.05 | 0.3% |
| zig_simd_safe | 0.17x | 6.07 | 0.3% |
| c_simd_gcc | 0.26x | 6.07 | 0.3% |
| c_simd_clang | 0.26x | 6.07 | 0.1% |
| rust_simd | 0.26x | 6.05 | 0.3% |
| c_simd_zigcc | 0.27x | 6.06 | 0.5% |
| zig_std_safe | 0.99x | 6.05 | 0.2% |
| zig_std_fast | 1.00x | 6.05 | 0.3% |
| c_std_gcc | 1.00x | 6.07 | 0.2% |
| c_std_clang | 1.01x | 6.08 | 0.2% |
| rust_std | 1.01x | 6.07 | 0.2% |
| c_std_zigcc | 1.02x | 6.05 | 0.2% |
| go_std | 1.06x | 6.06 | 0.3% |
| python | 46.77x | 12.08 | 0.1% |
| bash | 79.20x | 6.80 | 0.2% |

### SIEVE Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_bitset_fast | 0.65x | 6.09 | 5.6% |
| zig_bitset_safe | 0.90x | 6.06 | 4.4% |
| c_std_zigcc | 0.96x | 11.43 | 15.1% |
| c_soa_zigcc | 0.97x | 11.46 | 14.7% |
| c_std_gcc | 1.00x | 11.41 | 14.9% |
| c_soa_clang | 1.06x | 11.45 | 14.1% |
| c_std_clang | 1.08x | 11.41 | 13.8% |
| zig_std_fast | 1.14x | 10.15 | 12.3% |
| rust_std | 1.20x | 11.85 | 12.1% |
| go_std | 1.28x | 13.68 | 14.7% |
| zig_std_safe | 1.44x | 10.28 | 11.2% |
| c_soa_gcc | 1.60x | 49.58 | 42.5% |
| zig_soa_fast | 1.82x | 50.18 | 39.2% |
| rust_soa | 1.99x | 50.01 | 33.9% |
| python | 2.78x | 26.36 | 31.6% |
| zig_soa_safe | 3.51x | 72.25 | 29.9% |
| bash | 146.50x | 99.77 | 1.1% |

### BTREE Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_compact_fast | 0.19x | 16.67 | 37.6% |
| c_arena_gcc | 0.21x | 33.87 | 62.6% |
| c_arena_clang | 0.26x | 33.87 | 49.6% |
| c_arena_zigcc | 0.27x | 33.89 | 52.7% |
| zig_compact_safe | 0.29x | 16.78 | 23.5% |
| zig_fixed_fast | 0.34x | 32.65 | 42.1% |
| zig_manual_fast | 0.34x | 32.61 | 37.5% |
| rust_arena | 0.48x | 66.36 | 59.5% |
| zig_manual_safe | 0.49x | 32.82 | 28.2% |
| zig_fixed_safe | 0.50x | 32.82 | 29.6% |
| zig_arena_fast | 0.57x | 32.65 | 26.0% |
| zig_arena_safe | 0.59x | 33.83 | 24.0% |
| zig_pool_fast | 0.60x | 32.65 | 24.1% |
| zig_pool_safe | 0.65x | 32.79 | 23.0% |
| go_managed | 0.93x | 38.80 | 10.3% |
| c_std_gcc | 1.00x | 65.90 | 29.2% |
| c_std_clang | 1.05x | 65.90 | 28.5% |
| zig_naive_fast | 1.06x | 32.90 | 16.3% |
| c_std_zigcc | 1.06x | 65.90 | 27.4% |
| zig_naive_safe | 1.16x | 39.03 | 17.1% |
| rust_std | 1.34x | 66.35 | 21.2% |
| python | 11.58x | 204.74 | 9.1% |
| bash | 11254.84x | 6.07 | 49.8% |

<!-- SUMMARY_END -->

### Visual Analysis

#### Mandelbrot (Computational Efficiency)

![Mandel Time](./results/plots/mandel_time.png)
![Mandel Memory](./results/plots/mandel_memory.png)

#### Sieve (Data Density)

![Sieve Time](./results/plots/sieve_time.png)
![Sieve Memory](./results/plots/sieve_memory.png)

#### Btree (Memory Strategy)

![Btree Time](./results/plots/btree_time.png)
![Btree Memory](./results/plots/btree_memory.png)

---

## License

This benchmark suite is released under the [MIT License](./LICENSE).
