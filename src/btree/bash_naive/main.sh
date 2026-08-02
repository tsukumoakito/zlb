#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

set -euo pipefail

depth=${1:-20}

count_nodes_recursive() {
    local d=$1
    if ((d <= 0)); then
        echo 1
        return
    fi

    local left
    local right
    left=$(count_nodes_recursive $((d - 1)))
    right=$(count_nodes_recursive $((d - 1)))

    echo $((1 + left + right))
}

checksum=$(count_nodes_recursive "$depth")

echo "Checksum: $checksum"
echo "Depth: $depth" >&2
