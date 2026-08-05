# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

# --- Compilers ---
CC = gcc
CLANG = clang
ZIG = zig
RUSTC = rustc
GO = go
PYTHON = python3
BASH = bash

# --- Directories ---
BIN_DIR = bin

# --- mandel Targets (Standard vs SIMD) ---
MANDEL_C_STD_GCC = $(BIN_DIR)/mandel_c_std_gcc
MANDEL_C_STD_CLANG = $(BIN_DIR)/mandel_c_std_clang
MANDEL_C_STD_ZIGCC = $(BIN_DIR)/mandel_c_std_zigcc
MANDEL_C_SIMD_GCC = $(BIN_DIR)/mandel_c_simd_gcc
MANDEL_C_SIMD_CLANG = $(BIN_DIR)/mandel_c_simd_clang
MANDEL_C_SIMD_ZIGCC = $(BIN_DIR)/mandel_c_simd_zigcc
MANDEL_ZIG_STD_FAST = $(BIN_DIR)/mandel_zig_std_fast
MANDEL_ZIG_STD_SAFE = $(BIN_DIR)/mandel_zig_std_safe
MANDEL_ZIG_SIMD_FAST = $(BIN_DIR)/mandel_zig_simd_fast
MANDEL_ZIG_SIMD_SAFE = $(BIN_DIR)/mandel_zig_simd_safe
MANDEL_RUST_STD = $(BIN_DIR)/mandel_rust_std
MANDEL_RUST_SIMD = $(BIN_DIR)/mandel_rust_simd
MANDEL_GO_STD = $(BIN_DIR)/mandel_go_std

MANDEL_BINS = $(MANDEL_C_STD_GCC) $(MANDEL_C_STD_CLANG) $(MANDEL_C_STD_ZIGCC) \
              $(MANDEL_C_SIMD_GCC) $(MANDEL_C_SIMD_CLANG) $(MANDEL_C_SIMD_ZIGCC) \
              $(MANDEL_ZIG_STD_FAST) $(MANDEL_ZIG_STD_SAFE) \
              $(MANDEL_ZIG_SIMD_FAST) $(MANDEL_ZIG_SIMD_SAFE) \
              $(MANDEL_RUST_STD) $(MANDEL_RUST_SIMD) $(MANDEL_GO_STD)

# --- sieve Targets ---
SIEVE_C_STD_GCC = $(BIN_DIR)/sieve_c_std_gcc
SIEVE_C_STD_CLANG = $(BIN_DIR)/sieve_c_std_clang
SIEVE_C_STD_ZIGCC = $(BIN_DIR)/sieve_c_std_zigcc
SIEVE_C_SOA_GCC = $(BIN_DIR)/sieve_c_soa_gcc
SIEVE_C_SOA_CLANG = $(BIN_DIR)/sieve_c_soa_clang
SIEVE_C_SOA_ZIGCC = $(BIN_DIR)/sieve_c_soa_zigcc
SIEVE_ZIG_STD_FAST = $(BIN_DIR)/sieve_zig_std_fast
SIEVE_ZIG_STD_SAFE = $(BIN_DIR)/sieve_zig_std_safe
SIEVE_ZIG_SOA_FAST = $(BIN_DIR)/sieve_zig_soa_fast
SIEVE_ZIG_SOA_SAFE = $(BIN_DIR)/sieve_zig_soa_safe
SIEVE_ZIG_BITSET_FAST = $(BIN_DIR)/sieve_zig_bitset_fast
SIEVE_ZIG_BITSET_SAFE = $(BIN_DIR)/sieve_zig_bitset_safe
SIEVE_ZIG_STATIC_BITSET_FAST = $(BIN_DIR)/sieve_zig_static_bitset_fast
SIEVE_ZIG_STATIC_BITSET_SAFE = $(BIN_DIR)/sieve_zig_static_bitset_safe
SIEVE_RUST_STD = $(BIN_DIR)/sieve_rust_std
SIEVE_RUST_SOA = $(BIN_DIR)/sieve_rust_soa
SIEVE_GO_STD = $(BIN_DIR)/sieve_go_std

SIEVE_BINS = $(SIEVE_C_STD_GCC) $(SIEVE_C_STD_CLANG) $(SIEVE_C_STD_ZIGCC) \
             $(SIEVE_C_SOA_GCC) $(SIEVE_C_SOA_CLANG) $(SIEVE_C_SOA_ZIGCC) \
             $(SIEVE_ZIG_STD_FAST) $(SIEVE_ZIG_STD_SAFE) \
             $(SIEVE_ZIG_SOA_FAST) $(SIEVE_ZIG_SOA_SAFE) \
             $(SIEVE_ZIG_BITSET_FAST) $(SIEVE_ZIG_BITSET_SAFE) \
             $(SIEVE_ZIG_STATIC_BITSET_FAST) $(SIEVE_ZIG_STATIC_BITSET_SAFE) \
             $(SIEVE_RUST_STD) $(SIEVE_RUST_SOA) $(SIEVE_GO_STD)

# --- btree Targets ---
BTREE_C_STD_GCC = $(BIN_DIR)/btree_c_std_gcc
BTREE_C_STD_CLANG = $(BIN_DIR)/btree_c_std_clang
BTREE_C_STD_ZIGCC = $(BIN_DIR)/btree_c_std_zigcc
BTREE_C_ARENA_GCC = $(BIN_DIR)/btree_c_arena_gcc
BTREE_C_ARENA_CLANG = $(BIN_DIR)/btree_c_arena_clang
BTREE_C_ARENA_ZIGCC = $(BIN_DIR)/btree_c_arena_zigcc
BTREE_ZIG_NAIVE_FAST = $(BIN_DIR)/btree_zig_naive_fast
BTREE_ZIG_NAIVE_SAFE = $(BIN_DIR)/btree_zig_naive_safe
BTREE_ZIG_ARENA_FAST = $(BIN_DIR)/btree_zig_arena_fast
BTREE_ZIG_ARENA_SAFE = $(BIN_DIR)/btree_zig_arena_safe
BTREE_ZIG_POOL_FAST = $(BIN_DIR)/btree_zig_pool_fast
BTREE_ZIG_POOL_SAFE = $(BIN_DIR)/btree_zig_pool_safe
BTREE_ZIG_FIXED_FAST = $(BIN_DIR)/btree_zig_fixed_fast
BTREE_ZIG_FIXED_SAFE = $(BIN_DIR)/btree_zig_fixed_safe
BTREE_ZIG_COMPACT_FAST = $(BIN_DIR)/btree_zig_compact_fast
BTREE_ZIG_COMPACT_SAFE = $(BIN_DIR)/btree_zig_compact_safe
BTREE_ZIG_MANUAL_FAST = $(BIN_DIR)/btree_zig_manual_fast
BTREE_ZIG_MANUAL_SAFE = $(BIN_DIR)/btree_zig_manual_safe
BTREE_ZIG_DEBUG_FAST = $(BIN_DIR)/btree_zig_debug_fast
BTREE_ZIG_DEBUG_SAFE = $(BIN_DIR)/btree_zig_debug_safe
BTREE_ZIG_STACK_FALLBACK_FAST = $(BIN_DIR)/btree_zig_stack_fallback_fast
BTREE_ZIG_STACK_FALLBACK_SAFE = $(BIN_DIR)/btree_zig_stack_fallback_safe
BTREE_ZIG_BRK_FAST = $(BIN_DIR)/btree_zig_brk_fast
BTREE_ZIG_BRK_SAFE = $(BIN_DIR)/btree_zig_brk_safe
BTREE_ZIG_SMP_FAST = $(BIN_DIR)/btree_zig_smp_fast
BTREE_ZIG_SMP_SAFE = $(BIN_DIR)/btree_zig_smp_safe
BTREE_RUST_STD = $(BIN_DIR)/btree_rust_std
BTREE_RUST_ARENA = $(BIN_DIR)/btree_rust_arena
BTREE_GO_MANAGED = $(BIN_DIR)/btree_go_managed

BTREE_BINS = $(BTREE_C_STD_GCC) $(BTREE_C_STD_CLANG) $(BTREE_C_STD_ZIGCC) \
             $(BTREE_C_ARENA_GCC) $(BTREE_C_ARENA_CLANG) $(BTREE_C_ARENA_ZIGCC) \
             $(BTREE_ZIG_NAIVE_FAST) $(BTREE_ZIG_NAIVE_SAFE) \
             $(BTREE_ZIG_ARENA_FAST) $(BTREE_ZIG_ARENA_SAFE) \
             $(BTREE_ZIG_POOL_FAST) $(BTREE_ZIG_POOL_SAFE) \
             $(BTREE_ZIG_FIXED_FAST) $(BTREE_ZIG_FIXED_SAFE) \
             $(BTREE_ZIG_COMPACT_FAST) $(BTREE_ZIG_COMPACT_SAFE) \
             $(BTREE_ZIG_MANUAL_FAST) $(BTREE_ZIG_MANUAL_SAFE) \
             $(BTREE_ZIG_DEBUG_FAST) $(BTREE_ZIG_DEBUG_SAFE) \
             $(BTREE_ZIG_STACK_FALLBACK_FAST) $(BTREE_ZIG_STACK_FALLBACK_SAFE) \
             $(BTREE_ZIG_BRK_FAST) $(BTREE_ZIG_BRK_SAFE) \
             $(BTREE_ZIG_SMP_FAST) $(BTREE_ZIG_SMP_SAFE) \
             $(BTREE_RUST_STD) $(BTREE_RUST_ARENA) $(BTREE_GO_MANAGED)

# --- log-proc Targets ---
LOGPROC_C_STD_GCC = $(BIN_DIR)/log_proc_c_std_gcc
LOGPROC_C_STD_CLANG = $(BIN_DIR)/log_proc_c_std_clang
LOGPROC_C_STD_ZIGCC = $(BIN_DIR)/log_proc_c_std_zigcc
LOGPROC_C_STRUCTURED_GCC = $(BIN_DIR)/log_proc_c_structured_gcc
LOGPROC_C_STRUCTURED_CLANG = $(BIN_DIR)/log_proc_c_structured_clang
LOGPROC_C_STRUCTURED_ZIGCC = $(BIN_DIR)/log_proc_c_structured_zigcc
LOGPROC_ZIG_STD_FAST = $(BIN_DIR)/log_proc_zig_std_fast
LOGPROC_ZIG_STD_SAFE = $(BIN_DIR)/log_proc_zig_std_safe
LOGPROC_ZIG_AUTOHASH_FAST = $(BIN_DIR)/log_proc_zig_autohash_fast
LOGPROC_ZIG_AUTOHASH_SAFE = $(BIN_DIR)/log_proc_zig_autohash_safe
LOGPROC_ZIG_STRINGHASH_FAST = $(BIN_DIR)/log_proc_zig_stringhash_fast
LOGPROC_ZIG_STRINGHASH_SAFE = $(BIN_DIR)/log_proc_zig_stringhash_safe
LOGPROC_ZIG_STATIC_FAST = $(BIN_DIR)/log_proc_zig_static_fast
LOGPROC_ZIG_STATIC_SAFE = $(BIN_DIR)/log_proc_zig_static_safe
LOGPROC_RUST_STD = $(BIN_DIR)/log_proc_rust_std
LOGPROC_RUST_STRUCTURED = $(BIN_DIR)/log_proc_rust_structured
LOGPROC_RUST_SERDE = $(BIN_DIR)/log_proc_rust_serde
LOGPROC_GO_STD = $(BIN_DIR)/log_proc_go_std
LOGPROC_GO_FAST = $(BIN_DIR)/log_proc_go_fast

LOGPROC_BINS = $(LOGPROC_C_STD_GCC) $(LOGPROC_C_STD_CLANG) $(LOGPROC_C_STD_ZIGCC) \
               $(LOGPROC_C_STRUCTURED_GCC) $(LOGPROC_C_STRUCTURED_CLANG) $(LOGPROC_C_STRUCTURED_ZIGCC) \
               $(LOGPROC_ZIG_STD_FAST) $(LOGPROC_ZIG_STD_SAFE) \
               $(LOGPROC_ZIG_AUTOHASH_FAST) $(LOGPROC_ZIG_AUTOHASH_SAFE) \
               $(LOGPROC_ZIG_STRINGHASH_FAST) $(LOGPROC_ZIG_STRINGHASH_SAFE) \
               $(LOGPROC_ZIG_STATIC_FAST) $(LOGPROC_ZIG_STATIC_SAFE) \
               $(LOGPROC_RUST_STD) $(LOGPROC_RUST_STRUCTURED) $(LOGPROC_RUST_SERDE) \
               $(LOGPROC_GO_STD) $(LOGPROC_GO_FAST)

# --- atomics Targets ---
ATOMICS_C_VALUE_GCC = $(BIN_DIR)/atomics_c_atomic_value_gcc
ATOMICS_C_VALUE_CLANG = $(BIN_DIR)/atomics_c_atomic_value_clang
ATOMICS_C_VALUE_ZIGCC = $(BIN_DIR)/atomics_c_atomic_value_zigcc
ATOMICS_C_MUTEX_GCC = $(BIN_DIR)/atomics_c_atomic_mutex_gcc
ATOMICS_C_MUTEX_CLANG = $(BIN_DIR)/atomics_c_atomic_mutex_clang
ATOMICS_C_MUTEX_ZIGCC = $(BIN_DIR)/atomics_c_atomic_mutex_zigcc
ATOMICS_ZIG_VALUE_FAST = $(BIN_DIR)/atomics_zig_atomic_value_fast
ATOMICS_ZIG_VALUE_SAFE = $(BIN_DIR)/atomics_zig_atomic_value_safe
ATOMICS_ZIG_MUTEX_FAST = $(BIN_DIR)/atomics_zig_atomic_mutex_fast
ATOMICS_ZIG_MUTEX_SAFE = $(BIN_DIR)/atomics_zig_atomic_mutex_safe
ATOMICS_RUST_VALUE = $(BIN_DIR)/atomics_rust_atomic_value
ATOMICS_RUST_MUTEX = $(BIN_DIR)/atomics_rust_atomic_mutex
ATOMICS_GO_VALUE = $(BIN_DIR)/atomics_go_atomic_value
ATOMICS_GO_MUTEX = $(BIN_DIR)/atomics_go_atomic_mutex

ATOMICS_BINS = $(ATOMICS_C_VALUE_GCC) $(ATOMICS_C_VALUE_CLANG) $(ATOMICS_C_VALUE_ZIGCC) \
               $(ATOMICS_C_MUTEX_GCC) $(ATOMICS_C_MUTEX_CLANG) $(ATOMICS_C_MUTEX_ZIGCC) \
               $(ATOMICS_ZIG_VALUE_FAST) $(ATOMICS_ZIG_VALUE_SAFE) \
               $(ATOMICS_ZIG_MUTEX_FAST) $(ATOMICS_ZIG_MUTEX_SAFE) \
               $(ATOMICS_RUST_VALUE) $(ATOMICS_RUST_MUTEX) \
               $(ATOMICS_GO_VALUE) $(ATOMICS_GO_MUTEX)

ALL_BINS = $(MANDEL_BINS) $(SIEVE_BINS) $(BTREE_BINS) $(LOGPROC_BINS) $(ATOMICS_BINS)

all: build

build: $(BIN_DIR) $(ALL_BINS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# --- Mandel Build Rules ---
$(MANDEL_C_STD_GCC): src/mandel/c_std/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(MANDEL_C_STD_CLANG): src/mandel/c_std/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(MANDEL_C_STD_ZIGCC): src/mandel/c_std/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 -ffp-contract=off $< -o $@
$(MANDEL_C_SIMD_GCC): src/mandel/c_simd/main_simd.c | $(BIN_DIR)
	$(CC) -O3 -march=native -ffp-contract=off $< -o $@
$(MANDEL_C_SIMD_CLANG): src/mandel/c_simd/main_simd.c | $(BIN_DIR)
	$(CLANG) -O3 -march=native -ffp-contract=off $< -o $@
$(MANDEL_C_SIMD_ZIGCC): src/mandel/c_simd/main_simd.c | $(BIN_DIR)
	$(ZIG) cc -O3 -ffp-contract=off -march=native $< -o $@
$(MANDEL_ZIG_STD_FAST): src/mandel/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(MANDEL_ZIG_STD_SAFE): src/mandel/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(MANDEL_ZIG_SIMD_FAST): src/mandel/zig_simd/main_simd.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(MANDEL_ZIG_SIMD_SAFE): src/mandel/zig_simd/main_simd.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(MANDEL_RUST_STD): src/mandel/rust_std/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 -C lto=yes $< -o $@
$(MANDEL_RUST_SIMD): src/mandel/rust_simd/main_simd.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 -C target-cpu=native $< -o $@
$(MANDEL_GO_STD): src/mandel/go_std/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<

# --- Sieve Build Rules ---
$(SIEVE_C_STD_GCC): src/sieve/c_std/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(SIEVE_C_STD_CLANG): src/sieve/c_std/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(SIEVE_C_STD_ZIGCC): src/sieve/c_std/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(SIEVE_C_SOA_GCC): src/sieve/c_soa/main_soa.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(SIEVE_C_SOA_CLANG): src/sieve/c_soa/main_soa.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(SIEVE_C_SOA_ZIGCC): src/sieve/c_soa/main_soa.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(SIEVE_ZIG_STD_FAST): src/sieve/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(SIEVE_ZIG_STD_SAFE): src/sieve/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(SIEVE_ZIG_SOA_FAST): src/sieve/zig_soa/main_soa.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(SIEVE_ZIG_SOA_SAFE): src/sieve/zig_soa/main_soa.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(SIEVE_ZIG_BITSET_FAST): src/sieve/zig_bitset/main_bitset.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(SIEVE_ZIG_BITSET_SAFE): src/sieve/zig_bitset/main_bitset.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(SIEVE_ZIG_STATIC_BITSET_FAST): src/sieve/zig_static_bitset/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(SIEVE_ZIG_STATIC_BITSET_SAFE): src/sieve/zig_static_bitset/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(SIEVE_RUST_STD): src/sieve/rust_std/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(SIEVE_RUST_SOA): src/sieve/rust_soa/main_soa.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(SIEVE_GO_STD): src/sieve/go_std/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<

# --- Btree Build Rules ---
$(BTREE_C_STD_GCC): src/btree/c_std/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(BTREE_C_STD_CLANG): src/btree/c_std/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(BTREE_C_STD_ZIGCC): src/btree/c_std/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(BTREE_C_ARENA_GCC): src/btree/c_arena/main_arena.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(BTREE_C_ARENA_CLANG): src/btree/c_arena/main_arena.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(BTREE_C_ARENA_ZIGCC): src/btree/c_arena/main_arena.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(BTREE_ZIG_NAIVE_FAST): src/btree/zig_naive/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_NAIVE_SAFE): src/btree/zig_naive/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_ARENA_FAST): src/btree/zig_arena/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_ARENA_SAFE): src/btree/zig_arena/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_POOL_FAST): src/btree/zig_pool/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_POOL_SAFE): src/btree/zig_pool/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_FIXED_FAST): src/btree/zig_fixed/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_FIXED_SAFE): src/btree/zig_fixed/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_COMPACT_FAST): src/btree/zig_compact/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_COMPACT_SAFE): src/btree/zig_compact/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_MANUAL_FAST): src/btree/zig_manual/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_MANUAL_SAFE): src/btree/zig_manual/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_DEBUG_FAST): src/btree/zig_debug/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_DEBUG_SAFE): src/btree/zig_debug/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_STACK_FALLBACK_FAST): src/btree/zig_stack_fallback/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_STACK_FALLBACK_SAFE): src/btree/zig_stack_fallback/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_ZIG_BRK_FAST): src/btree/zig_brk/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -fsingle-threaded -femit-bin=$@
$(BTREE_ZIG_BRK_SAFE): src/btree/zig_brk/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -fsingle-threaded -femit-bin=$@
$(BTREE_ZIG_SMP_FAST): src/btree/zig_smp/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(BTREE_ZIG_SMP_SAFE): src/btree/zig_smp/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(BTREE_RUST_STD): src/btree/rust_std/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(BTREE_RUST_ARENA): src/btree/rust_arena/main_arena.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(BTREE_GO_MANAGED): src/btree/go_managed/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<

# --- Log-proc Build Rules ---
$(LOGPROC_C_STD_GCC): src/log-proc/c_std/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(LOGPROC_C_STD_CLANG): src/log-proc/c_std/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(LOGPROC_C_STD_ZIGCC): src/log-proc/c_std/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(LOGPROC_C_STRUCTURED_GCC): src/log-proc/c_structured/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(LOGPROC_C_STRUCTURED_CLANG): src/log-proc/c_structured/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(LOGPROC_C_STRUCTURED_ZIGCC): src/log-proc/c_structured/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(LOGPROC_ZIG_STD_FAST): src/log-proc/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(LOGPROC_ZIG_STD_SAFE): src/log-proc/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(LOGPROC_ZIG_AUTOHASH_FAST): src/log-proc/zig_autohash/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(LOGPROC_ZIG_AUTOHASH_SAFE): src/log-proc/zig_autohash/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(LOGPROC_ZIG_STRINGHASH_FAST): src/log-proc/zig_stringhash/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(LOGPROC_ZIG_STRINGHASH_SAFE): src/log-proc/zig_stringhash/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(LOGPROC_ZIG_STATIC_FAST): src/log-proc/zig_static/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(LOGPROC_ZIG_STATIC_SAFE): src/log-proc/zig_static/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(LOGPROC_RUST_STD): src/log-proc/rust_std/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(LOGPROC_RUST_STRUCTURED): src/log-proc/rust_structured/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(LOGPROC_RUST_SERDE): src/log-proc/rust_serde/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(LOGPROC_GO_STD): src/log-proc/go_std/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<
$(LOGPROC_GO_FAST): src/log-proc/go_fast/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<

# --- Atomics Build Rules ---
$(ATOMICS_C_VALUE_GCC): src/atomics/c_atomic_value/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(ATOMICS_C_VALUE_CLANG): src/atomics/c_atomic_value/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(ATOMICS_C_VALUE_ZIGCC): src/atomics/c_atomic_value/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(ATOMICS_C_MUTEX_GCC): src/atomics/c_atomic_mutex/main.c | $(BIN_DIR)
	$(CC) -O3 $< -o $@
$(ATOMICS_C_MUTEX_CLANG): src/atomics/c_atomic_mutex/main.c | $(BIN_DIR)
	$(CLANG) -O3 $< -o $@
$(ATOMICS_C_MUTEX_ZIGCC): src/atomics/c_atomic_mutex/main.c | $(BIN_DIR)
	$(ZIG) cc -O3 $< -o $@
$(ATOMICS_ZIG_VALUE_FAST): src/atomics/zig_atomic_value/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(ATOMICS_ZIG_VALUE_SAFE): src/atomics/zig_atomic_value/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(ATOMICS_ZIG_MUTEX_FAST): src/atomics/zig_atomic_mutex/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast -femit-bin=$@
$(ATOMICS_ZIG_MUTEX_SAFE): src/atomics/zig_atomic_mutex/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe -femit-bin=$@
$(ATOMICS_RUST_VALUE): src/atomics/rust_atomic_value/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(ATOMICS_RUST_MUTEX): src/atomics/rust_atomic_mutex/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(ATOMICS_GO_VALUE): src/atomics/go_atomic_value/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<
$(ATOMICS_GO_MUTEX): src/atomics/go_atomic_mutex/main.go | $(BIN_DIR)
	$(GO) build -o $@ $<

# --- Verification ---
test-all: build
	@printf "\n=== mandel: Checking Checksums ===\n"
	@for bin in $(MANDEL_BINS); do ./$$bin 100; done
	@$(PYTHON) src/mandel/python_std/main.py 100
	@$(BASH) src/mandel/bash_std/main.sh 100
	@printf "\n=== sieve: Checking Checksums ===\n"
	@for bin in $(SIEVE_BINS); do ./$$bin 100; done
	@$(PYTHON) src/sieve/python_std/main.py 100
	@$(BASH) src/sieve/bash_std/main.sh 100
	@printf "\n=== btree: Checking Checksums ===\n"
	@for bin in $(BTREE_BINS); do ./$$bin 10; done
	@$(PYTHON) src/btree/python_managed/main.py 10
	@$(BASH) src/btree/bash_naive/main.sh 10
	@printf "\n=== log-proc: Checking Checksums ===\n"
	@for bin in $(LOGPROC_BINS); do ./$$bin 100; done
	@$(PYTHON) src/log-proc/python_std/main.py 100
	@$(BASH) src/log-proc/bash_std/main.sh 100
	@printf "\n=== atomics: Checking Checksums ===\n"
	@for bin in $(ATOMICS_BINS); do ./$$bin 10000; done

clean:
	rm -rf $(BIN_DIR)
	rm -rf src/**/*.zig-cache/ src/**/.zig-cache/

.PHONY: all build test-all clean
