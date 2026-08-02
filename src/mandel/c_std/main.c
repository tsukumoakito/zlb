// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int n = 4000;
  if (argc > 1) {
    n = atoi(argv[1]);
  }

  const int max_iter = 1000;

  const double x_min = -2.0;
  const double x_max = 1.0;
  const double y_min = -1.1;
  const double y_max = 1.1;

  const double dx = (x_max - x_min) / n;
  const double dy = (y_max - y_min) / n;

  uint64_t checksum = 0;

  for (int i = 0; i < n; i++) {
    double y = y_min + i * dy;
    for (int j = 0; j < n; j++) {
      double x = x_min + j * dx;

      double z_re = 0.0;
      double z_im = 0.0;
      int iter = 0;

      while (z_re * z_re + z_im * z_im <= 4.0 && iter < max_iter) {
        double next_re = z_re * z_re - z_im * z_im + x;
        z_im = 2.0 * z_re * z_im + y;
        z_re = next_re;
        iter++;
      }
      checksum += iter;
    }
  }

  printf("Checksum: %llu\n", (unsigned long long)checksum);

  fprintf(stderr, "Size: %dx%d, Max Iter: %d\n", n, n, max_iter);

  return 0;
}
