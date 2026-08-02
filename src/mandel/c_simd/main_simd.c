// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <immintrin.h>
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

  __m256d v_four = _mm256_set1_pd(4.0);
  __m256d v_two = _mm256_set1_pd(2.0);
  __m256d v_zero = _mm256_set1_pd(0.0);

  for (int i = 0; i < n; i++) {
    double y_val = y_min + i * dy;
    __m256d vy = _mm256_set1_pd(y_val);

    for (int j = 0; j < n; j += 4) {
      double x_vals[4];
      uint64_t initial_mask_array[4];
      for (int v = 0; v < 4; v++) {
        x_vals[v] = x_min + (j + v) * dx;
        initial_mask_array[v] = (j + v < n) ? 0xFFFFFFFFFFFFFFFFULL : 0;
      }

      __m256d vx = _mm256_loadu_pd(x_vals);
      __m256d vz_re = v_zero;
      __m256d vz_im = v_zero;

      __m256i v_iters = _mm256_setzero_si256();
      __m256d v_active_mask = _mm256_castsi256_pd(
          _mm256_loadu_si256((__m256i *)initial_mask_array));

      for (int iter = 0; iter < max_iter; iter++) {
        __m256d vz_re2 = _mm256_mul_pd(vz_re, vz_re);
        __m256d vz_im2 = _mm256_mul_pd(vz_im, vz_im);
        __m256d v_mag2 = _mm256_add_pd(vz_re2, vz_im2);

        __m256d v_cmp_mask = _mm256_cmp_pd(v_mag2, v_four, _CMP_LE_OQ);

        v_active_mask = _mm256_and_pd(v_active_mask, v_cmp_mask);

        if (_mm256_movemask_pd(v_active_mask) == 0)
          break;

        __m256i v_inc = _mm256_and_si256(_mm256_castpd_si256(v_active_mask),
                                         _mm256_set1_epi64x(1));
        v_iters = _mm256_add_epi64(v_iters, v_inc);

        __m256d v_next_re = _mm256_add_pd(_mm256_sub_pd(vz_re2, vz_im2), vx);
        vz_im = _mm256_add_pd(_mm256_mul_pd(_mm256_mul_pd(v_two, vz_re), vz_im),
                              vy);
        vz_re = v_next_re;
      }

      uint64_t res[4];
      _mm256_storeu_si256((__m256i *)res, v_iters);
      checksum += res[0] + res[1] + res[2] + res[3];
    }
  }

  printf("Checksum: %llu\n", (unsigned long long)checksum);
  fprintf(stderr, "Size: %dx%d, Max Iter: %d\n", n, n, max_iter);

  return 0;
}
