// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};
use std::sync::atomic::{AtomicU64, Ordering};

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() > 1 {
        args[1].parse().unwrap_or(10000000)
    } else {
        10000000
    };

    let counter = AtomicU64::new(0);

    for _ in 0..n {
        counter.fetch_add(1, Ordering::Relaxed);
    }

    let checksum = counter.load(Ordering::SeqCst);

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
