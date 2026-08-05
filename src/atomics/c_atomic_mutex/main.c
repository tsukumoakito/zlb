// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdatomic.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  size_t n = 10000000;
  if (argc > 1) {
    n = (size_t)atoll(argv[1]);
  }

  atomic_bool lock = false;
  uint64_t counter = 0;

  for (size_t i = 0; i < n; i++) {
    while (atomic_exchange_explicit(&lock, true, memory_order_acquire)) {
#if defined(__i386__) || defined(__x86_64__)
      __asm__ volatile("pause");
#endif
    }
    counter += 1;
    atomic_store_explicit(&lock, false, memory_order_release);
  }

  printf("Checksum: %llu\n", (unsigned long long)counter);
  fprintf(stderr, "Limit: %zu\n", n);

  return 0;
}
