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
	ID        int    `json:"id"`
	Level     string `json:"level"`
	Msg       string `json:"msg"`
	Timestamp int64  `json:"timestamp"`
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
		entry := LogEntry{
			ID:        i,
			Level:     "info",
			Msg:       fmt.Sprintf("performance_test_log_entry_number_%d", i),
			Timestamp: time.Now().Unix(),
		}

		data, _ := json.Marshal(entry)

		var parsed LogEntry
		_ = json.Unmarshal(data, &parsed)

		checksum += uint64(parsed.ID)
		checksum += uint64(len(parsed.Msg))
	}

	fmt.Printf("Checksum: %d\n", checksum)
	fmt.Fprintf(os.Stderr, "Limit: %d\n", n)
}
