#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

set -e

n=${1:-4000}
max_iter=1000

awk -v n="$n" -v max_iter="$max_iter" '
BEGIN {
    x_min = -2.0; x_max = 1.0;
    y_min = -1.1; y_max = 1.1;

    dx = (x_max - x_min) / n;
    dy = (y_max - y_min) / n;

    checksum = 0;

    for (i = 0; i < n; i++) {
        y = y_min + i * dy;
        for (j = 0; j < n; j++) {
            x = x_min + j * dx;
            z_re = 0.0;
            z_im = 0.0;
            iteration = 0;

            while (z_re * z_re + z_im * z_im <= 4.0 && iteration < max_iter) {
                next_re = z_re * z_re - z_im * z_im + x;
                z_im = 2.0 * z_re * z_im + y;
                z_re = next_re;
                iteration++;
            }
            checksum += iteration;
        }
    }
    printf "Checksum: %d\n", checksum;
}
'

echo "Size: ${n}x${n}, Max Iter: $max_iter" >&2
