#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

set -e

n=${1:-10000000}

awk -v n="$n" '
BEGIN {
    for (i = 0; i <= n; i++) is_prime[i] = 1;
    is_prime[0] = 0;
    is_prime[1] = 0;

    for (p = 2; p * p <= n; p++) {
        if (is_prime[p] == 1) {
            for (i = p * p; i <= n; i += p) {
                is_prime[i] = 0;
            }
        }
    }

    count = 0;
    for (i = 0; i <= n; i++) {
        if (is_prime[i] == 1) count++;
    }

    printf "Checksum: %d\n", count;
}
'

echo "Limit: $n" >&2
