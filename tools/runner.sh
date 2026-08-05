#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

set -euo pipefail

mkdir -p results

# フラグ解析
case "${1:-}" in
    "--clean")
        # コンパイル成果物と、スクリプト（python/bash）以外の計測結果を削除
        make clean
        find results/ -type f ! -name "*_python.*" ! -name "*_bash.*" -delete
        ;;
    "--purge")
        # 全ての計測結果を含めて完全に初期化
        make clean
        rm -f results/*.json results/*.hash
        ;;
esac

make build

get_hash() {
    sha256sum "$1" | cut -d' ' -f1
}

run_bench() {
    local task=$1
    local n=$2

    local targets=()
    case "$task" in
        "mandel")
            targets=(
                "c_std_gcc" "c_std_clang" "c_std_zigcc"
                "c_simd_gcc" "c_simd_clang" "c_simd_zigcc"
                "zig_std_fast" "zig_std_safe"
                "zig_simd_fast" "zig_simd_safe"
                "rust_std" "rust_simd" "go_std"
            )
            ;;
        "sieve")
            targets=(
                "c_std_gcc" "c_std_clang" "c_std_zigcc"
                "c_soa_gcc" "c_soa_clang" "c_soa_zigcc"
                "zig_std_fast" "zig_std_safe"
                "zig_soa_fast" "zig_soa_safe"
                "zig_bitset_fast" "zig_bitset_safe"
                "zig_static_bitset_fast" "zig_static_bitset_safe"
                "rust_std" "rust_soa" "go_std"
            )
            ;;
        "btree")
            targets=(
                "c_std_gcc" "c_std_clang" "c_std_zigcc"
                "c_arena_gcc" "c_arena_clang" "c_arena_zigcc"
                "zig_naive_fast" "zig_naive_safe"
                "zig_arena_fast" "zig_arena_safe"
                "zig_pool_fast" "zig_pool_safe"
                "zig_fixed_fast" "zig_fixed_safe"
                "zig_compact_fast" "zig_compact_safe"
                "zig_manual_fast" "zig_manual_safe"
                "zig_debug_fast" "zig_debug_safe"
                "zig_stack_fallback_fast" "zig_stack_fallback_safe"
                "zig_brk_fast" "zig_brk_safe"
                "zig_smp_fast" "zig_smp_safe"
                "rust_std" "rust_arena" "go_managed"
            )
            ;;
        "log_proc")
            targets=(
                "c_std_gcc" "c_std_clang" "c_std_zigcc"
                "c_structured_gcc" "c_structured_clang" "c_structured_zigcc"
                "zig_std_fast" "zig_std_safe"
                "zig_autohash_fast" "zig_autohash_safe"
                "zig_stringhash_fast" "zig_stringhash_safe"
                "zig_static_fast" "zig_static_safe"
                "rust_std" "rust_structured" "rust_serde"
                "go_std" "go_fast"
            )
            ;;
        "atomics")
            targets=(
                "c_atomic_value_gcc" "c_atomic_value_clang" "c_atomic_value_zigcc"
                "c_atomic_mutex_gcc" "c_atomic_mutex_clang" "c_atomic_mutex_zigcc"
                "zig_atomic_value_fast" "zig_atomic_value_safe"
                "zig_atomic_mutex_fast" "zig_atomic_mutex_safe"
                "rust_atomic_value" "rust_atomic_mutex"
                "go_atomic_value" "go_atomic_mutex"
            )
            ;;
    esac

    for t in "${targets[@]}"; do
        local bin_name="${task}_${t}"
        local bin_path="bin/${bin_name}"
        local out="results/${bin_name}.json"
        local hfile="results/${bin_name}.hash"
        local cur_h
        cur_h=$(get_hash "$bin_path")

        if [[ -f "$out" && -f "$hfile" && "$(cat "$hfile")" == "$cur_h" ]]; then
            continue
        fi

        hyperfine --warmup 1 --min-runs 20 --output=null --export-json "$out" -n "$bin_name" "./$bin_path $n"
        echo "$cur_h" >"$hfile"
    done

    if [[ "$task" == "atomics" ]]; then return 0; fi

    local scripts=("python" "bash")
    for s in "${scripts[@]}"; do
        local ext="py"
        [[ "$s" == "bash" ]] && ext="sh"
        local spath="src/${task//_/-}/${s}_std/main.${ext}"
        [[ "$task" == "btree" && "$s" == "python" ]] && spath="src/btree/python_managed/main.py"
        [[ "$task" == "btree" && "$s" == "bash" ]] && spath="src/btree/bash_naive/main.sh"
        [[ "$task" == "log_proc" && "$s" == "python" ]] && spath="src/log-proc/python_std/main.py"
        [[ "$task" == "log_proc" && "$s" == "bash" ]] && spath="src/log-proc/bash_std/main.sh"

        local label="${task}_${s}"
        local out="results/${label}.json"
        local hfile="results/${label}.hash"
        local cur_h
        cur_h=$(get_hash "$spath")

        if [[ -f "$out" && -f "$hfile" && "$(cat "$hfile")" == "$cur_h" ]]; then
            continue
        fi

        local cmd="python3 $spath $n"
        [[ "$s" == "bash" ]] && cmd="bash $spath $n"

        hyperfine --runs 1 --output=null --export-json "$out" -n "$s" "$cmd"
        echo "$cur_h" >"$hfile"
    done
}

run_bench "mandel" 4000
run_bench "sieve" 10000000
run_bench "btree" 20
run_bench "log_proc" 1000000
run_bench "atomics" 10000000

python3 tools/aggregate.py
