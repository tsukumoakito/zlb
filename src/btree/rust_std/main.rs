// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};

struct Node {
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

fn create_tree(depth: i32) -> Box<Node> {
    if depth > 0 {
        Box::new(Node {
            left: Some(create_tree(depth - 1)),
            right: Some(create_tree(depth - 1)),
        })
    } else {
        Box::new(Node { left: None, right: None })
    }
}

fn count_nodes(node: &Node) -> u64 {
    let mut count = 1;
    if let Some(ref l) = node.left { count += count_nodes(l); }
    if let Some(ref r) = node.right { count += count_nodes(r); }
    count
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let depth: i32 = if args.len() > 1 {
        args[1].parse().unwrap_or(20)
    } else {
        20
    };

    let root = create_tree(depth);
    let count = count_nodes(&root);

    println!("Checksum: {}", count);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Depth: {}", depth);
}
