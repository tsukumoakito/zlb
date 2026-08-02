// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};
use std::arch::x86_64::*;

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

    unsafe {
        let v_four = _mm256_set1_pd(4.0);
        let v_two = _mm256_set1_pd(2.0);
        let v_zero = _mm256_set1_pd(0.0);
        let v_one_i = _mm256_set1_epi64x(1);

        for i in 0..n {
            let y_val = Y_MIN + (i as f64) * dy;
            let vy = _mm256_set1_pd(y_val);

            for j in (0..n).step_by(4) {
                let mut x_array = [0.0f64; 4];
                let mut mask_array = [0u64; 4];

                for v in 0..4 {
                    let current_j = j + v;
                    x_array[v] = X_MIN + (current_j as f64) * dx;
                    mask_array[v] = if current_j < n { !0u64 } else { 0 };
                }

                let vx = _mm256_loadu_pd(x_array.as_ptr());
                let mut vz_re = v_zero;
                let mut vz_im = v_zero;
                let mut v_iters = _mm256_setzero_si256();
                let mut v_active_mask = _mm256_loadu_si256(mask_array.as_ptr() as *const __m256i);

                for _ in 0..MAX_ITER {
                    let vz_re2 = _mm256_mul_pd(vz_re, vz_re);
                    let vz_im2 = _mm256_mul_pd(vz_im, vz_im);
                    let v_mag2 = _mm256_add_pd(vz_re2, vz_im2);

                    let v_cmp_mask = _mm256_cmp_pd(v_mag2, v_four, _CMP_LE_OQ);
                    v_active_mask = _mm256_and_si256(v_active_mask, _mm256_castpd_si256(v_cmp_mask));

                    if _mm256_movemask_pd(_mm256_castsi256_pd(v_active_mask)) == 0 {
                        break;
                    }

                    let v_inc = _mm256_and_si256(v_active_mask, v_one_i);
                    v_iters = _mm256_add_epi64(v_iters, v_inc);

                    let v_next_re = _mm256_add_pd(_mm256_sub_pd(vz_re2, vz_im2), vx);
                    vz_im = _mm256_add_pd(_mm256_mul_pd(_mm256_mul_pd(v_two, vz_re), vz_im), vy);
                    vz_re = v_next_re;
                }

                let mut res = [0u64; 4];
                _mm256_storeu_si256(res.as_mut_ptr() as *mut __m256i, v_iters);
                checksum += res[0] + res[1] + res[2] + res[3];
            }
        }
    }

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Size: {}x{}, Max Iter: {}", n, n, MAX_ITER);
}
