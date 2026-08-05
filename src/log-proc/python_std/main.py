#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

"""Benchmark for log processing performance in Python."""

import json
import sys
import time


def main():
    """Execute log generation and parsing benchmark."""
    try:
        n = int(sys.argv[1]) if len(sys.argv) > 1 else 10000
    except ValueError:
        n = 10000

    checksum = 0

    for i in range(n):
        log_data = {
            "id": i,
            "level": "info",
            "msg": f"performance_test_log_entry_number_{i}",
            "timestamp": int(time.time()),
        }
        line = json.dumps(log_data)

        parsed = json.loads(line)
        checksum += parsed["id"]
        checksum += len(parsed["msg"])

    print(f"Checksum: {checksum}")
    sys.stderr.write(f"Limit: {n}\n")


if __name__ == "__main__":
    main()
