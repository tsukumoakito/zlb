// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  size_t n = 10000000;
  if (argc > 1) {
    n = (size_t)atoll(argv[1]);
  }

  atomic_uint_fast64_t counter = 0;

  for (size_t i = 0; i < n; i++) {
    atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
  }

  uint64_t checksum = atomic_load_explicit(&counter, memory_order_seq_cst);

  printf("Checksum: %llu\n", (unsigned long long)checksum);
  fprintf(stderr, "Limit: %zu\n", n);

  return 0;
}
