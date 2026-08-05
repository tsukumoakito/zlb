// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

package main

import (
	"fmt"
	"os"
	"strconv"
	"sync/atomic"
)

func main() {
	n := 10000000
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			n = val
		}
	}

	var counter uint64

	for i := 0; i < n; i++ {
		atomic.AddUint64(&counter, 1)
	}

	checksum := atomic.LoadUint64(&counter)

	fmt.Printf("Checksum: %d\n", checksum)
	fmt.Fprintf(os.Stderr, "Limit: %d\n", n)
}
