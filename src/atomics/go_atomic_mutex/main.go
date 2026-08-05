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

	var lock uint32
	var counter uint64

	for i := 0; i < n; i++ {
		for !atomic.CompareAndSwapUint32(&lock, 0, 1) {
		}
		counter++
		atomic.StoreUint32(&lock, 0)
	}

	fmt.Printf("Checksum: %d\n", counter)
	fmt.Fprintf(os.Stderr, "Limit: %d\n", n)
}
