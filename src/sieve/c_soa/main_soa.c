// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  size_t n = 10000000;
  if (argc > 1) {
    n = atoll(argv[1]);
  }

  uint8_t *is_prime = (uint8_t *)malloc(n + 1);
  uint32_t *values = (uint32_t *)malloc((n + 1) * sizeof(uint32_t));

  if (!is_prime || !values) {
    return 1;
  }

  memset(is_prime, 1, n + 1);
  if (n >= 0)
    is_prime[0] = 0;
  if (n >= 1)
    is_prime[1] = 0;

  for (size_t i = 0; i <= n; i++) {
    values[i] = (uint32_t)i;
  }

  for (size_t p = 2; p * p <= n; p++) {
    if (is_prime[p]) {
      for (size_t i = p * p; i <= n; i += p) {
        is_prime[i] = 0;
      }
    }
  }

  uint64_t count = 0;
  for (size_t i = 0; i <= n; i++) {
    if (is_prime[i])
      count++;
  }

  printf("Checksum: %llu\n", (unsigned long long)count);
  fprintf(stderr, "Limit: %zu\n", n);

  free(is_prime);
  free(values);
  return 0;
}
