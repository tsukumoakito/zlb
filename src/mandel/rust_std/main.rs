// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() > 1 {
        args[1].parse().unwrap_or(4000)
    } else {
        4000
    };

    const MAX_ITER: u32 = 1000;
    const X_MIN: f64 = -2.0;
    const X_MAX: f64 = 1.0;
    const Y_MIN: f64 = -1.1;
    const Y_MAX: f64 = 1.1;

    let dx = (X_MAX - X_MIN) / (n as f64);
    let dy = (Y_MAX - Y_MIN) / (n as f64);

    let mut checksum: u64 = 0;
    let mut row_buffer = vec![0u32; n];

    for i in 0..n {
        let y = Y_MIN + (i as f64) * dy;
        for j in 0..n {
            let x = X_MIN + (j as f64) * dx;
            let mut z_re: f64 = 0.0;
            let mut z_im: f64 = 0.0;
            let mut iter: u32 = 0;

            while z_re * z_re + z_im * z_im <= 4.0 && iter < MAX_ITER {
                let next_re = z_re * z_re - z_im * z_im + x;
                z_im = 2.0 * z_re * z_im + y;
                z_re = next_re;
                iter += 1;
            }
            row_buffer[j] = iter;
        }

        for &val in &row_buffer {
            checksum += val as u64;
        }
    }

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Size: {}x{}, Max Iter: {}", n, n, MAX_ITER);
}
