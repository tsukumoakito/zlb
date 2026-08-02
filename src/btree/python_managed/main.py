#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
# SPDX-License-Identifier: MIT

"""Benchmark implementation module for zlb."""

import sys


class Node:
    """A simple binary tree node."""

    def __init__(self, depth):
        """Initialize a node and recursively create children up to specified depth."""
        if depth > 0:
            self.left = Node(depth - 1)
            self.right = Node(depth - 1)
        else:
            self.left = None
            self.right = None


def count_nodes(node):
    """Recursively count nodes in the tree."""
    if node is None:
        return 0
    return 1 + count_nodes(node.left) + count_nodes(node.right)


def main():
    """Execute the Binary Tree benchmark."""
    depth = 20
    if len(sys.argv) > 1:
        try:
            depth = int(sys.argv[1])
        except ValueError:
            pass

    sys.setrecursionlimit(max(2000, 2**depth if depth < 10 else 2000))

    root = Node(depth)
    count = count_nodes(root)

    sys.stdout.write(f"Checksum: {count}\n")
    sys.stderr.write(f"Depth: {depth}\n")


if __name__ == "__main__":
    main()
