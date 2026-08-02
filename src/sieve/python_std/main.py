#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

"""Benchmark implementation module for zlb."""

import sys


def main():
    """Execute the Sieve of Eratosthenes benchmark."""
    n = 10000000
    if len(sys.argv) > 1:
        try:
            n = int(sys.argv[1])
        except ValueError:
            pass

    is_prime = bytearray([1]) * (n + 1)
    if n >= 0:
        is_prime[0] = 0
    if n >= 1:
        is_prime[1] = 0

    p = 2
    while p * p <= n:
        if is_prime[p] == 1:
            is_prime[p * p : n + 1 : p] = bytearray([0]) * len(range(p * p, n + 1, p))
        p += 1

    count = is_prime.count(1)

    sys.stdout.write(f"Checksum: {count}\n")
    sys.stderr.write(f"Limit: {n}\n")


if __name__ == "__main__":
    main()
