// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"time"
)

type LogEntry struct {
	ID        uint64 `json:"id"`
	Level     string `json:"level"`
	Msg       string `json:"msg"`
	Timestamp uint64 `json:"timestamp"`
}

func main() {
	n := 10000
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			n = val
		}
	}

	var checksum uint64

	for i := 0; i < n; i++ {
		ts := time.Now().Unix()
		line := fmt.Sprintf(`{"id":%d,"level":"info","msg":"performance_test_log_entry_number_%d","timestamp":%d}`, i, i, ts)

		var entry LogEntry
		if err := json.Unmarshal([]byte(line), &entry); err == nil {
			checksum += entry.ID + uint64(len(entry.Msg))
		}
	}

	fmt.Printf("Checksum: %d\n", checksum)
	fmt.Fprintf(os.Stderr, "Limit: %d\n", n)
}
