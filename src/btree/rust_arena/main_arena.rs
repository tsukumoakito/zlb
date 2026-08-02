// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};

struct Node {
    left: Option<usize>,
    right: Option<usize>,
}

struct Arena {
    nodes: Vec<Node>,
}

impl Arena {
    fn new(capacity: usize) -> Self {
        Arena {
            nodes: Vec::with_capacity(capacity),
        }
    }

    fn alloc_node(&mut self) -> usize {
        let idx = self.nodes.len();
        self.nodes.push(Node {
            left: None,
            right: None,
        });
        idx
    }

    fn create_tree(&mut self, depth: i32) -> usize {
        let node_idx = self.alloc_node();
        if depth > 0 {
            let left = self.create_tree(depth - 1);
            let right = self.create_tree(depth - 1);
            self.nodes[node_idx].left = Some(left);
            self.nodes[node_idx].right = Some(right);
        }
        node_idx
    }

    fn count_nodes(&self, node_idx: usize) -> u64 {
        let mut count = 1;
        let node = &self.nodes[node_idx];
        if let Some(l) = node.left {
            count += self.count_nodes(l);
        }
        if let Some(r) = node.right {
            count += self.count_nodes(r);
        }
        count
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let depth: i32 = if args.len() > 1 {
        args[1].parse().unwrap_or(20)
    } else {
        20
    };

    let total_nodes = (1usize << (depth + 1)) - 1;

    let mut arena = Arena::new(total_nodes);

    let root_idx = arena.create_tree(depth);
    let count = arena.count_nodes(root_idx);

    println!("Checksum: {}", count);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Depth: {}", depth);

}
