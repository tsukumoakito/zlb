// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

package main

import (
	"fmt"
	"os"
	"strconv"
)

type Node struct {
	left  *Node
	right *Node
}

func createTree(depth int) *Node {
	if depth > 0 {
		return &Node{
			left:  createTree(depth - 1),
			right: createTree(depth - 1),
		}
	}
	return &Node{}
}

func countNodes(node *Node) uint64 {
	if node == nil {
		return 0
	}
	return 1 + countNodes(node.left) + countNodes(node.right)
}

func main() {
	depth := 20
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			depth = val
		}
	}

	root := createTree(depth)
	count := countNodes(root)

	fmt.Printf("Checksum: %d\n", count)
	fmt.Fprintf(os.Stderr, "Depth: %d\n", depth)
}
