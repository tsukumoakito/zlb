// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	n := 10000000
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			n = val
		}
	}

	isPrime := make([]byte, n+1)
	for i := range isPrime {
		isPrime[i] = 1
	}
	if n >= 0 { isPrime[0] = 0 }
	if n >= 1 { isPrime[1] = 0 }

	for p := 2; p*p <= n; p++ {
		if isPrime[p] == 1 {
			for i := p * p; i <= n; i += p {
				isPrime[i] = 0
			}
		}
	}

	var count uint64
	for _, val := range isPrime {
		if val == 1 {
			count++
		}
	}

	fmt.Printf("Checksum: %d\n", count)
	fmt.Fprintf(os.Stderr, "Limit: %d\n", n)
}
