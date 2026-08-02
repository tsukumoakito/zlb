// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() > 1 {
        args[1].parse().unwrap_or(10_000_000)
    } else {
        10_000_000
    };

    let mut is_prime = vec![1u8; n + 1];

    if is_prime.len() > 0 { is_prime[0] = 0; }
    if is_prime.len() > 1 { is_prime[1] = 0; }

    let mut p = 2;
    while p * p <= n {
        if is_prime[p] == 1 {
            let mut i = p * p;
            while i <= n {
                is_prime[i] = 0;
                i += p;
            }
        }
        p += 1;
    }

    let mut count: u64 = 0;
    for &val in &is_prime {
        if val == 1 {
            count += 1;
        }
    }

    println!("Checksum: {}", count);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
