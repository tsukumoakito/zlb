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

## 4. Allocator Selection Strategy (Official Patterns)

Following the principles defined in the [Official Zig 0.16.0 Memory Documentation](https://ziglang.org/documentation/0.16.0/#Memory), ZLB categorizes memory management into specific patterns to answer the fundamental question: *"Where are the bytes?"*

Zig does not provide a hidden global allocator (like C's `malloc`). Instead, it mandates explicit allocator selection based on the following criteria:

### The "Choosing an Allocator" Framework

1. **Comptime-Bounded Memory**: If the maximum required bytes are known at compile time, **`std.heap.FixedBufferAllocator`** is the optimal choice. This is the logic behind our `zig_fixed` benchmarks, achieving raw pointer-increment speed.
2. **Cyclical or Batch Tasks**: For processes that run from start to end without a cyclical pattern (like a CLI tool) or for tasks with a clear "end of cycle" (like a frame in a game), **`std.heap.ArenaAllocator`** is recommended. This allows for $O(1)$ batch deallocation at the end of the task.
3. **Development & Debugging**: During development, **`std.heap.DebugAllocator`** (the 0.16.0 successor to the previous GPA logic) is the standard for detecting memory leaks and double-frees. This is used in our `zig_naive` patterns.
4. **High-Performance Release**: For production workloads in `ReleaseFast` mode, **`std.heap.smp_allocator`** is the primary candidate for high-concurrency and minimal overhead.
5. **Libraries & Generic Components**: To maintain pure logic, libraries should always accept an `Allocator` as a parameter, allowing the end-user to decide the memory strategy.

### Explicit Handling of "Truth"

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

## Deep Analysis: Memory Management in Zig 0.16.0

The following evaluation details the "Ground Truth" of Zig 0.16.0’s memory infrastructure and its current utilization in ZLB.

### 1. Proven Logic (Implemented in ZLB)

These APIs form the backbone of Zig's performance dominance in the current suite.

- **`std.heap.ArenaAllocator`**:
    - **Usage**: `btree_zig_arena`.
    - **Logic**: Aggregates small allocations into large chunks for $O(1)$ deallocation. While highly efficient, its internal chunk list overhead, making it slightly slower than the `Fixed` variant but more flexible for unknown workloads.
- **`std.heap.FixedBufferAllocator`**:
    - **Usage**: `btree_zig_fixed / manual`.
    - **Logic**: Operates on a pre-allocated slice with zero management overhead. It achieves parity with C's raw pointer-increment strategy while maintaining the safety of the `Allocator` interface.
- **`std.heap.MemoryPool`**:
    - **Usage**: `btree_zig_pool`.
    - **Logic**: Optimized for fixed-size types (Nodes). Leveraging the new `initCapacity` in 0.16.0, it eliminates fragmentation and allocation cycles by reusing memory slots.
- **`std.MultiArrayList`**:
    - **Usage**: `sieve_zig_soa`.
    - **Logic**: A metaprogramming masterpiece that transforms AoS to SoA at compile time. It maximizes cache throughput by ensuring that only the relevant fields (e.g., `is_prime` flags) occupy the L1 cache during hot loops.
- **`std.DynamicBitSet`**:
    - **Usage**: `sieve_zig_bitset`.
    - **Logic**: Compresses boolean arrays to 1 bit per element. ZLB implements the updated 0.16.0 `deinit()` signature, which internally handles its associated allocator.

### 2. Potential Optimizations (Roadmap)

Identified through Zig's source code analysis but not yet fully utilized in ZLB benchmarks.

- **`std.heap.DebugAllocator` (The GPA Alternative)**:
    - **Note on GPA**: *`std.heap.GeneralPurposeAllocator (GPA)` is absent in the 0.16.0 core.* Instead, **`DebugAllocator`** is the canonical implementation for safety and leak detection.
    - **Prospect**: Evaluating the performance cost of `DebugAllocator` in `ReleaseSafe` mode to quantify the "Safety Tax" in real-world scenarios.
- **`std.heap.StackFallbackAllocator`**:
    - **Prospect**: Ideal for the upcoming `log-proc` task. It allows for "Zero-Heap" string processing by using stack space first and only falling back to the heap if the buffer overflows.
- **`std.heap.BrkAllocator / SmpAllocator`**:
    - **Prospect**: Low-level primitives for direct system-call interaction. Useful for benchmarking the absolute overhead of the OS memory manager versus user-land allocators.
- **`std.StaticBitSet`**:
    - **Prospect**: For fixed-size workloads, this eliminates the need for an allocator entirely, potentially surpassing even `DynamicBitSet` in raw speed.
- **`std.hash_map (AutoHashMap / StringHashMap)`**:
    - **Logic**: 0.16.0 scan results show a significant shift toward the `.empty` + `getOrPut` pattern.
    - **Prospect**: Crucial for the `log-proc` task to demonstrate how Zig handles structured data mapping with minimal allocation.
- **`std.atomic (Atomic Value / Mutex)`**:
    - **Features**: Abstractions for hardware-level atomic operations and synchronization primitives.
    - **Current Status**: Not yet implemented because Zlb is currently focused on pure single-threaded algorithmic performance.
    - **Prospect**: Crucial for future **Multi-threaded Benchmarks**. This will demonstrate how Zig’s `atomic` can leverage parallel performance in lock-free data structures with minimal overhead.

---

## Future Roadmap: Practical Log Processing (`log-proc`)

While pure algorithmic benchmarks like Mandelbrot and Btree provide valuable insights into raw compute and memory management, the next phase of ZLB focuses on real-world data engineering through a new task: **`log-proc`**.

### The Strategic Importance of `log-proc`

For developers of high-frequency infrastructure, SaaS backends, and monitoring tools, the ability to process massive volumes of structured data with minimal overhead is far more critical than pure mathematical throughput. The `log-proc` task aims to quantify how different languages handle the ingestion, transformation, and generation of structured logs (JSON/Text).

### High-Efficiency Patterns in Zig 0.16.0

The implementation of `log-proc` will leverage specific architectural patterns in Zig 0.16.0 to demonstrate a physical advantage in data processing:

- **Streaming Ingestion with `std.json.Scanner`**: Unlike managed languages that often unmarshal entire payloads into memory, Zig allows for 1-token-at-a-time streaming. This ensures a constant, ultra-low memory footprint regardless of the log file size.
- **Zero-Copy Parsing**: Utilizing logic that references existing strings within the source buffer, physically eliminating unnecessary memory allocations and copying cycles.
- **Zero-Allocation Formatting with `std.fmt.bufPrintSentinel`**: By leveraging stack-based formatting, Zig can generate structured output without ever touching the heap, providing a type-safe alternative to C's `sprintf`.
- **Optimized Numerical Conversions**: Benchmarking Zig’s low-level integer and float rendering against the heavier string-processing runtimes of other environments.

### Comparative Vision

String and JSON processing are notoriously resource-intensive for scripting languages and can lead to significant memory spikes in managed-memory languages. By implementing these patterns, the `log-proc` suite will visualize the "Efficiency Gap"—proving that Zig is a precision tool for building sustainable, low-latency digital infrastructure.

---

## License

This benchmark suite is released under the [MIT License](./LICENSE).
