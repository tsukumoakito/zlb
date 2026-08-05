<!--
SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
SPDX-License-Identifier: MIT
-->

<p align="center">
  <img src="doc/zlb_logo.svg" width="100%" alt="ZLB Logo">
</p>

# ZLB (Zig Language Benchmark)

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
| **sieve** | Sieve of Eratosthenes | Array access speed, BitSet data density, and Runtime Bounds Checking. |
| **btree** | Binary Tree generation/deletion | Allocator efficiency (Arena, Pool, Fixed) and GC overhead. |
| **log_proc** | Structured Log Processing | String seeking, JSON parsing, and zero-allocation formatting. |
| **atomics** | Atomic Operations & Mutex | Hardware-level atomic overhead and user-space synchronization. |

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
| zig_simd_fast | 0.16x | 6.09 | 0.1% |
| zig_simd_safe | 0.18x | 6.06 | 0.1% |
| c_simd_clang | 0.26x | 6.07 | 0.1% |
| c_simd_gcc | 0.27x | 6.07 | 0.1% |
| rust_simd | 0.27x | 6.09 | 0.1% |
| c_simd_zigcc | 0.27x | 6.07 | 0.1% |
| zig_std_fast | 1.00x | 6.07 | 0.1% |
| c_std_gcc | 1.00x | 6.05 | 0.1% |
| zig_std_safe | 1.00x | 6.09 | 0.1% |
| c_std_clang | 1.02x | 6.08 | 0.1% |
| rust_std | 1.03x | 6.07 | 0.1% |
| c_std_zigcc | 1.03x | 6.09 | 0.1% |
| go_std | 1.07x | 6.07 | 0.2% |
| python | 48.39x | 12.08 | 0.1% |
| bash | 81.94x | 6.80 | 0.2% |

### SIEVE Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_static_bitset_fast | 0.63x | 6.07 | 4.1% |
| zig_static_bitset_safe | 0.64x | 6.08 | 5.5% |
| zig_bitset_fast | 0.64x | 6.09 | 3.9% |
| zig_bitset_safe | 0.75x | 6.05 | 4.3% |
| c_std_zigcc | 0.95x | 11.46 | 14.7% |
| c_soa_zigcc | 0.96x | 11.44 | 15.0% |
| c_std_gcc | 1.00x | 11.44 | 15.4% |
| zig_soa_fast | 1.05x | 10.15 | 14.0% |
| zig_std_fast | 1.06x | 10.15 | 13.5% |
| c_soa_clang | 1.06x | 11.40 | 13.3% |
| c_std_clang | 1.07x | 11.40 | 13.6% |
| rust_std | 1.16x | 11.89 | 11.6% |
| go_std | 1.24x | 14.34 | 14.0% |
| zig_std_safe | 1.52x | 10.28 | 9.8% |
| c_soa_gcc | 1.71x | 49.51 | 41.4% |
| zig_soa_safe | 1.72x | 15.03 | 12.5% |
| rust_soa | 1.99x | 50.02 | 34.7% |
| python | 2.85x | 26.36 | 31.6% |
| bash | 150.51x | 99.77 | 1.1% |

### BTREE Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_compact_fast | 0.19x | 16.68 | 37.6% |
| c_arena_gcc | 0.21x | 33.87 | 61.0% |
| c_arena_zigcc | 0.26x | 33.92 | 50.8% |
| c_arena_clang | 0.26x | 33.86 | 51.7% |
| zig_compact_safe | 0.29x | 16.78 | 24.9% |
| zig_brk_fast | 0.33x | 32.41 | 43.1% |
| zig_fixed_fast | 0.34x | 32.65 | 43.3% |
| zig_manual_fast | 0.36x | 32.62 | 38.6% |
| zig_brk_safe | 0.42x | 32.56 | 33.8% |
| zig_smp_fast | 0.44x | 32.65 | 35.1% |
| rust_arena | 0.48x | 66.36 | 61.7% |
| zig_manual_safe | 0.52x | 32.82 | 27.8% |
| zig_smp_safe | 0.52x | 32.78 | 32.6% |
| zig_fixed_safe | 0.54x | 32.82 | 27.4% |
| zig_arena_fast | 0.57x | 32.66 | 26.8% |
| zig_arena_safe | 0.59x | 32.78 | 26.5% |
| zig_pool_fast | 0.61x | 32.65 | 24.8% |
| zig_naive_fast | 0.61x | 32.65 | 27.5% |
| zig_stack_fallback_safe | 0.63x | 32.78 | 23.7% |
| zig_stack_fallback_fast | 0.63x | 32.65 | 24.6% |
| zig_pool_safe | 0.66x | 32.78 | 23.7% |
| zig_naive_safe | 0.72x | 32.78 | 22.0% |
| go_managed | 0.92x | 39.14 | 10.2% |
| c_std_gcc | 1.00x | 65.90 | 28.8% |
| c_std_clang | 1.05x | 65.90 | 28.5% |
| c_std_zigcc | 1.06x | 65.90 | 27.1% |
| zig_debug_fast | 1.10x | 32.90 | 16.0% |
| zig_debug_safe | 1.20x | 39.03 | 17.1% |
| rust_std | 1.32x | 66.28 | 21.7% |
| python | 12.33x | 204.74 | 9.1% |
| bash | 11992.23x | 6.07 | 49.8% |

### LOG_PROC Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_std_fast | 0.83x | 6.09 | 0.7% |
| c_std_clang | 0.97x | 6.08 | 0.5% |
| c_std_gcc | 1.00x | 6.08 | 0.7% |
| c_std_zigcc | 1.00x | 6.09 | 0.5% |
| c_structured_gcc | 1.51x | 25.26 | 5.0% |
| c_structured_clang | 1.53x | 24.67 | 6.1% |
| rust_std | 1.69x | 6.07 | 0.4% |
| c_structured_zigcc | 1.69x | 24.69 | 4.8% |
| rust_structured | 2.40x | 36.43 | 4.9% |
| rust_serde | 2.41x | 6.07 | 0.3% |
| zig_autohash_fast | 2.54x | 34.70 | 4.1% |
| zig_stringhash_fast | 3.24x | 60.08 | 6.2% |
| zig_static_fast | 3.31x | 6.08 | 0.2% |
| zig_autohash_safe | 3.97x | 34.86 | 2.6% |
| zig_static_safe | 4.38x | 6.05 | 0.1% |
| zig_stringhash_safe | 4.64x | 60.42 | 4.5% |
| zig_std_safe | 7.22x | 6.07 | 0.1% |
| go_fast | 11.81x | 10.62 | 2.0% |
| go_std | 13.11x | 9.70 | 1.7% |
| python | 34.55x | 13.42 | 0.6% |
| bash | 11013.37x | 6.06 | 53.7% |

### ATOMICS Results (Actual Measured)

| Metric | Time Ratio | Measured Memory (MiB) | Sys Overhead (%) |
| :--- | :--- | :--- | :--- |
| zig_atomic_value_fast | 0.97x | 6.05 | 1.7% |
| zig_atomic_value_safe | 0.98x | 6.06 | 1.7% |
| c_atomic_value_zigcc | 0.98x | 6.07 | 1.9% |
| rust_atomic_value | 0.99x | 6.06 | 1.4% |
| c_atomic_value_clang | 0.99x | 6.05 | 1.3% |
| c_atomic_value_gcc | 1.00x | 6.06 | 1.3% |
| go_atomic_value | 1.03x | 6.04 | 3.5% |
| zig_atomic_mutex_fast | 1.64x | 6.07 | 1.0% |
| c_atomic_mutex_gcc | 1.66x | 6.07 | 1.2% |
| c_atomic_mutex_zigcc | 1.68x | 6.09 | 1.2% |
| c_atomic_mutex_clang | 1.68x | 6.03 | 1.0% |
| rust_atomic_mutex | 1.76x | 6.08 | 1.1% |
| zig_atomic_mutex_safe | 1.79x | 6.09 | 0.7% |
| go_atomic_mutex | 2.30x | 6.05 | 1.8% |

<!-- SUMMARY_END -->

### Visual Analysis

#### Mandelbrot (Computational Efficiency)

![Mandel Time](./results/plots/mandel_time.svg)
![Mandel Memory](./results/plots/mandel_memory.svg)

#### Sieve (Data Density)

![Sieve Time](./results/plots/sieve_time.svg)
![Sieve Memory](./results/plots/sieve_memory.svg)

#### Btree (Memory Strategy)

![Btree Time](./results/plots/btree_time.svg)
![Btree Memory](./results/plots/btree_memory.svg)

#### Log Processing (String & JSON)

![Log Proc Time](./results/plots/log_proc_time.svg)
![Log Proc Memory](./results/plots/log_proc_memory.svg)

#### Atomics (Hardware Primitives)

![Atomics Time](./results/plots/atomics_time.svg)
![Atomics Memory](./results/plots/atomics_memory.svg)

---

## Technical Evaluation & Implementation Analysis

The ZLB (Zig Language Benchmark) results reveal the profound impact of implementation strategy and compiler settings on physical performance and resource efficiency.

### 1. Arithmetic Efficiency (Mandelbrot)

In compute-bound tasks, manual vectorization is the ultimate differentiator.

- **The Power of `@Vector`**: Zig's `zig_simd_fast` achieved the lowest time ratio (0.15x). By using 8-lane `f64` vectors, it fills the CPU's execution units more effectively than the 4-lane intrinsics used in C and Rust.
- **Instruction Scheduling**: Zig’s high-level SIMD primitives provide LLVM with clearer intent, resulting in superior instruction scheduling compared to lower-level C intrinsics.

### 2. Data Density & Cache Locality (Sieve)

Memory bandwidth and cache hits dictate performance in array-heavy workloads.

- **Bit-Level Compression**: `zig_bitset_fast` (0.65x) outpaced the standard C implementation (1.00x) by representing each element as a single bit rather than a byte. This increases information density in the L1 cache by 8x.
- **Safety Overhead**: The delta between `zig_bitset_fast` and `zig_bitset_safe` represents the cost of runtime bounds checking. In Sieve, where random-access is frequent, this overhead is measurable but often acceptable for the added security.

### 3. Memory Management Strategies (Btree)

Btree performance is a direct reflection of allocation logic.

- **Pointer Compression (Compact Mode)**: `zig_compact_fast` (0.19x) surpassed even the fastest C Arena implementation. By using 32-bit indices instead of 64-bit pointers, Zig effectively halved the memory footprint of the tree structure, reducing cache misses during traversal.
- **Arena vs. Pool vs. Naive**: The results demonstrate that `ArenaAllocator` (batch deallocation) and `MemoryPool` (object reuse) are significantly faster than traditional recursive `free()` calls (Naive Mode), which incur heavy management overhead.

### 4. Allocator Selection Strategy (Official Patterns)

Following the principles defined in the [Official Zig 0.16.0 Memory Documentation](https://ziglang.org/documentation/0.16.0/#Memory), ZLB categorizes memory management into specific patterns to answer the fundamental question: *"Where are the bytes?"*

Zig does not provide a hidden global allocator (like C's `malloc`). Instead, it mandates explicit allocator selection based on the following criteria:

#### The "Choosing an Allocator" Framework

1. **Comptime-Bounded Memory**: If the maximum required bytes are known at compile time, **`std.heap.FixedBufferAllocator`** is the optimal choice. This is the logic behind our `zig_fixed` benchmarks, achieving raw pointer-increment speed.
2. **Cyclical or Batch Tasks**: For processes that run from start to end without a cyclical pattern (like a CLI tool) or for tasks with a clear "end of cycle" (like a frame in a game), **`std.heap.ArenaAllocator`** is recommended. This allows for $O(1)$ batch deallocation at the end of the task.
3. **Development & Debugging**: During development, **`std.heap.DebugAllocator`** (the 0.16.0 successor to the previous GPA logic) is the standard for detecting memory leaks and double-frees. This is used in our `zig_naive` patterns.
4. **High-Performance Release**: For production workloads in `ReleaseFast` mode, **`std.heap.smp_allocator`** is the primary candidate for high-concurrency and minimal overhead.
5. **Libraries & Generic Components**: To maintain pure logic, libraries should always accept an `Allocator` as a parameter, allowing the end-user to decide the memory strategy.

#### Explicit Handling of "Truth"

- **Heap Failure as Logic**: Unlike other languages that may crash on OOM, Zig treats heap failure as a return value (`error.OutOfMemory`). Every ZLB implementation strictly handles these errors to ensure 100% reliability.
- **Ownership Clarity**: By following the pattern where the "caller owns the memory," ZLB implementations maintain clear boundaries between logic and resource management, preventing invisible leaks.

---

## Strategic Implementation in Zig 0.16.0

To achieve peak performance in Zig, one must move beyond "Vibe Coding" and embrace the following disciplines:

### Precise Memory Control

- **Choose the Right Allocator**: Do not rely on a single global allocator. Use `ArenaAllocator` for temporary batch tasks and `FixedBufferAllocator` when the maximum memory requirement is known at comptime.
- **Data-Oriented Design**: Prioritize `MultiArrayList` (SoA) and bit-packing to maximize cache utilization.

### Advanced Optimization Settings

- **ReleaseFast**: Disables all runtime safety checks. Use this only for verified, performance-critical hot paths.
- **ReleaseSafe**: Maintains critical safety checks (bounds, overflow). In most ZLB tasks, the performance cost is negligible compared to the reliability gained.
- **Target Simulation**: Always compile with `-mcpu=native` to allow the compiler to use modern instructions like AVX2 or AVX-512.

### Comparison Summary

- **Vs. C**: Zig matches or exceeds C's performance by providing better standard abstractions for SIMD and memory management.
- **Vs. Rust**: While Rust provides strong safety, Zig's explicit control over memory layout often allows for more aggressive hardware-level optimizations without resorting to `unsafe` hacks.
- **Vs. Go/Python**: The overhead of Garbage Collection and Interpreters is clearly visible in the resource consumption graphs. Zig’s "zero-overhead" philosophy makes it the definitive choice for resource-constrained or performance-critical systems.

---

## Deep Analysis: Infrastructure of Zig 0.16.0

ZLB 1.0.6 leverages the core primitives of Zig 0.16.0 to achieve performance parity with or dominance over C and Rust. The following analysis details how these components are utilized across the benchmark suite.

### 1. Advanced Memory Management (`std.heap`)

Zig's explicit memory management is the primary driver of its ultra-low RSS (Resident Set Size).

- **`ArenaAllocator`**:
    - **Usage**: `btree_zig_arena`, `log_proc_zig_static`.
    - **Logic**: Batches small allocations into large chunks for $O(1)$ deallocation. In `log_proc`, the `.reset(.retain_capacity)` pattern is used to process millions of entries within a fixed 6MiB memory footprint.
- **`FixedBufferAllocator`**:
    - **Usage**: `btree_zig_fixed`, `zig_brk`.
    - **Logic**: Operates on a pre-allocated slice with zero management overhead. By combining this with `brk_allocator`, ZLB demonstrates the "physical limit" of memory throughput.
- **`MemoryPool`**:
    - **Usage**: `btree_zig_pool`.
    - **Logic**: Optimized for fixed-size objects (Nodes). Leveraging `initCapacity` in 0.16.0, it eliminates fragmentation by recycling memory slots without repeated system calls.
- **`DebugAllocator`**:
    - **Logic**: The canonical 0.16.0 replacement for the old GPA in safety-critical contexts. ZLB uses it to quantify the "Safety Tax," showing how heavy-duty leak detection impacts raw throughput.
- **`StackFallbackAllocator`**:
    - **Logic**: Attempts to use stack space before falling back to the heap. This allows for "Zero-Heap" processing in tasks like `btree_zig_stack_fallback`.

### 2. Data Structure & Cache Optimization

- **`std.MultiArrayList` (SoA)**:
    - **Usage**: `sieve_zig_soa`.
    - **Logic**: A metaprogramming engine that transforms Arrays of Structures (AoS) into Structures of Arrays (SoA). It maximizes L1 cache hits by ensuring that only necessary fields (e.g., `is_prime` flags) are fetched during tight loops.
- **`BitSet` (Dynamic & Static)**:
    - **Usage**: `sieve_zig_bitset`, `sieve_zig_static_bitset`.
    - **Logic**: Compresses data to 1 bit per element. The `StaticBitSet` implementation in ZLB bypasses standard API value-copying to perform direct mask manipulation, utilizing the CPU's `POPCNT` instruction for near-instant checksum calculation.

### 3. Practical Processing (JSON & Strings)

The `log_proc` suite demonstrates Zig's efficiency in common data engineering tasks.

- **Streaming `std.json.Scanner`**:
    - **Logic**: Unlike Go or Python which unmarshal entire payloads, Zig allows for 1-token-at-a-time streaming. This results in a constant memory profile regardless of input size.
- **Zero-Allocation Formatting (`bufPrint`)**:
    - **Logic**: Uses stack-based buffers to generate structured logs. This provides a type-safe, high-performance alternative to C's `sprintf`, resulting in `zig_std_fast` outperforming C's standard implementation.
- **Efficient String Search**:
    - **Logic**: Utilizing `std.mem.find` and `findScalarPos` to seek data within slices without the overhead of generating new sub-slices, significantly reducing the cost of safety checks in `ReleaseSafe` mode.

### 4. Hardware Primitives (Atomics)

- **`std.atomic.Value`**:
    - **Logic**: Maps directly to hardware atomic instructions (e.g., `LOCK XADD`). This demonstrates Zig's "thinness" over the CPU, matching C and Rust's performance precisely.
- **`std.atomic.Mutex`**:
    - **Logic**: A user-space synchronization primitive. ZLB implements a high-performance spinlock using `tryLock` and `spinLoopHint`, showcasing minimal overhead for local thread synchronization.

---

## License

This benchmark suite is released under the [MIT License](./LICENSE).
