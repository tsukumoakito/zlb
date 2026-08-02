<!--
SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
SPDX-License-Identifier: MIT
-->

# zlb (Zig Language Benchmark)

[English](./README.md)

低レイヤからスクリプト言語まで、異なる設計哲学を持つ言語群を同一条件で比較し、最新の **Zig 0.16.0** の最適化能力と実力、および各言語のランタイム・オーバーヘッドを定量的に評価するプロジェクトです。

## 1. 測定環境 (Environment)

- **OS**: Linux 7.1.4-arch
- **Zig**: 0.16.0
- **C (gcc)**: 16.1.1 (最適化: -O3)
- **C (clang)**: 22.1.8 (最適化: -O3)
- **Rust**: 1.97.1 (最適化: --release)
- **Go**: 1.26.5
- **Python**: 3.14.6
- **Bash**: 5.3.15

## 2. ベンチマーク項目

| 項目名 | 内容 | 主な測定意図 |
| :--- | :--- | :--- |
| **mandel** | マンデルブロ集合の演算 | 浮動小数点演算とループ展開、SIMD化の効率 |
| **sieve** | エラトステネスの篩 | 配列アクセス速度と境界チェック (Bounds Check) の影響 |
| **btree** | 二分木の動的生成・破棄 | アロケータの効率とガベージコレクション (GC) のコスト |

## 3. Zig 0.16.0 実装戦略

本プロジェクトでは、最新の Zig 作法に基づき、以下の論理を適用して他言語に対する優位性を検証します。

- **ゼロコピー思想**: `std.mem.asBytes` による型安全なノーコピー・キャスト。
- **メモリ管理の最適化**: `std.heap.ArenaAllocator` による一括破棄戦略。
- **最新の初期化作法**: 非推奨となった古い `init` を避け、`.empty` と `ensureTotalCapacity` を組み合わせた 0.16.0 準拠の記述。
- **安全性の制御**: `ReleaseSafe`（安全検査あり）と `ReleaseFast`（最高速）の両面評価。

## 4. 計測手法

- **実行時間**: `hyperfine` による統計的な平均実行時間の算出。
- **公平性**: 全ての言語・環境において全く同一のパラメータ（N, Depth）を適用。

## 5. 評価結果

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

### 視覚的解析 (Visual Analysis)

#### Mandelbrot (演算効率)

![Mandel Time](./results/plots/mandel_time.png)
![Mandel Memory](./results/plots/mandel_memory.png)

#### Sieve (データ密度)

![Sieve Time](./results/plots/sieve_time.png)
![Sieve Memory](./results/plots/sieve_memory.png)

#### Btree (メモリ戦略)

![Btree Time](./results/plots/btree_time.png)
![Btree Memory](./results/plots/btree_memory.png)

---

## ライセンス

本ベンチマークスイートは **MIT License** の下で公開されています。
