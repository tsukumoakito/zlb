#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

"""Benchmark implementation module for zlb."""

import sys


def main():
    """Execute the Mandelbrot set benchmark."""
    n = 4000
    if len(sys.argv) > 1:
        try:
            n = int(sys.argv[1])
        except ValueError:
            pass

    max_iter = 1000
    x_min, x_max = -2.0, 1.0
    y_min, y_max = -1.1, 1.1

    dx = (x_max - x_min) / n
    dy = (y_max - y_min) / n

    checksum = 0

    for i in range(n):
        y = y_min + i * dy
        for j in range(n):
            x = x_min + j * dx
            z_re = 0.0
            z_im = 0.0
            iteration = 0
            while z_re * z_re + z_im * z_im <= 4.0 and iteration < max_iter:
                next_re = z_re * z_re - z_im * z_im + x
                z_im = 2.0 * z_re * z_im + y
                z_re = next_re
                iteration += 1
            checksum += iteration

    sys.stdout.write(f"Checksum: {checksum}\n")
    sys.stderr.write(f"Size: {n}x{n}, Max Iter: {max_iter}\n")


if __name__ == "__main__":
    main()
