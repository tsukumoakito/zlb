#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

set -euo pipefail

n=${1:-10000}

generate_log_entry() {
    local id=$1
    echo "{\"id\":$id,\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_$id\",\"timestamp\":$(date +%s)}"
}

process_logs() {
    local limit=$1
    local checksum=0

    for ((i = 0; i < limit; i++)); do
        local line
        line=$(generate_log_entry "$i")

        if [[ "$line" =~ \"id\":([0-9]+) ]]; then
            id_val=${BASH_REMATCH[1]}
            checksum=$((checksum + id_val))
        fi

        if [[ "$line" =~ \"msg\":\"([^\"]+)\" ]]; then
            msg_val=${BASH_REMATCH[1]}
            msg_len=${#msg_val}
            checksum=$((checksum + msg_len))
        fi
    done
    echo "$checksum"
}

checksum=$(process_logs "$n")

echo "Checksum: $checksum"
echo "Limit: $n" >&2
