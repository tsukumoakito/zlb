// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};
use std::sync::atomic::{AtomicBool, Ordering};
use std::hint;

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() > 1 {
        args[1].parse().unwrap_or(10000000)
    } else {
        10000000
    };

    let lock = AtomicBool::new(false);
    let mut counter: u64 = 0;

    for _ in 0..n {
        while lock.swap(true, Ordering::Acquire) {
            hint::spin_loop();
        }
        counter += 1;
        lock.store(false, Ordering::Release);
    }

    println!("Checksum: {}", counter);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
