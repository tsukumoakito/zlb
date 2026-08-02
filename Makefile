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

# --- sieve Targets (Standard vs SOA vs Bitset) ---
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
SIEVE_RUST_STD = $(BIN_DIR)/sieve_rust_std
SIEVE_RUST_SOA = $(BIN_DIR)/sieve_rust_soa
SIEVE_GO_STD = $(BIN_DIR)/sieve_go_std

SIEVE_BINS = $(SIEVE_C_STD_GCC) $(SIEVE_C_STD_CLANG) $(SIEVE_C_STD_ZIGCC) \
             $(SIEVE_C_SOA_GCC) $(SIEVE_C_SOA_CLANG) $(SIEVE_C_SOA_ZIGCC) \
             $(SIEVE_ZIG_STD_FAST) $(SIEVE_ZIG_STD_SAFE) \
             $(SIEVE_ZIG_SOA_FAST) $(SIEVE_ZIG_SOA_SAFE) $(SIEVE_ZIG_BITSET_FAST) \
             $(SIEVE_ZIG_BITSET_SAFE) $(SIEVE_RUST_STD) $(SIEVE_RUST_SOA) $(SIEVE_GO_STD)

# --- btree Targets (Naive vs Arena/Pool vs Managed) ---
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
             $(BTREE_RUST_STD) $(BTREE_RUST_ARENA) $(BTREE_GO_MANAGED)

ALL_BINS = $(MANDEL_BINS) $(SIEVE_BINS) $(BTREE_BINS)

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
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(MANDEL_ZIG_STD_SAFE): src/mandel/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(MANDEL_ZIG_SIMD_FAST): src/mandel/zig_simd/main_simd.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(MANDEL_ZIG_SIMD_SAFE): src/mandel/zig_simd/main_simd.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
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
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(SIEVE_ZIG_STD_SAFE): src/sieve/zig_std/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(SIEVE_ZIG_SOA_FAST): src/sieve/zig_soa/main_soa.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(SIEVE_ZIG_SOA_SAFE): src/sieve/zig_soa/main_soa.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(SIEVE_ZIG_BITSET_FAST): src/sieve/zig_bitset/main_bitset.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(SIEVE_ZIG_BITSET_SAFE): src/sieve/zig_bitset/main_bitset.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
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
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_NAIVE_SAFE): src/btree/zig_naive/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_ZIG_ARENA_FAST): src/btree/zig_arena/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_ARENA_SAFE): src/btree/zig_arena/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_ZIG_POOL_FAST): src/btree/zig_pool/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_POOL_SAFE): src/btree/zig_pool/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_ZIG_FIXED_FAST): src/btree/zig_fixed/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_FIXED_SAFE): src/btree/zig_fixed/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_ZIG_COMPACT_FAST): src/btree/zig_compact/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_COMPACT_SAFE): src/btree/zig_compact/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_ZIG_MANUAL_FAST): src/btree/zig_manual/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseFast --name $@
$(BTREE_ZIG_MANUAL_SAFE): src/btree/zig_manual/main.zig | $(BIN_DIR)
	$(ZIG) build-exe $< -O ReleaseSafe --name $@
$(BTREE_RUST_STD): src/btree/rust_std/main.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(BTREE_RUST_ARENA): src/btree/rust_arena/main_arena.rs | $(BIN_DIR)
	$(RUSTC) -C opt-level=3 $< -o $@
$(BTREE_GO_MANAGED): src/btree/go_managed/main.go | $(BIN_DIR)
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

clean:
	rm -rf $(BIN_DIR)
	rm -rf src/**/*.zig-cache/ src/**/.zig-cache/

.PHONY: all build test-all clean
