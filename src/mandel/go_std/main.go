// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	n := 4000
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			n = val
		}
	}

	const maxIter = 1000
	const xMin = -2.0
	const xMax = 1.0
	const yMin = -1.1
	const yMax = 1.1

	dx := (xMax - xMin) / float64(n)
	dy := (yMax - yMin) / float64(n)

	var checksum uint64
	rowBuffer := make([]uint32, n)

	for i := 0; i < n; i++ {
		y := yMin + float64(i)*dy
		for j := 0; j < n; j++ {
			x := xMin + float64(j)*dx
			var zRe, zIm float64
			var iter uint32

			for zRe*zRe+zIm*zIm <= 4.0 && iter < maxIter {
				nextRe := zRe*zRe - zIm*zIm + x
				zIm = 2.0*zRe*zIm + y
				zRe = nextRe
				iter++
			}
			rowBuffer[j] = iter
		}

		for _, val := range rowBuffer {
			checksum += uint64(val)
		}
	}

	fmt.Printf("Checksum: %d\n", checksum)

	fmt.Fprintf(os.Stderr, "Size: %dx%d, Max Iter: %d\n", n, n, maxIter)
}
