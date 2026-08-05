// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};
use std::time::{SystemTime, UNIX_EPOCH};

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() > 1 {
        args[1].parse().unwrap_or(10000)
    } else {
        10000
    };

    let mut checksum: u64 = 0;

    for i in 0..n {
        let ts = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();

        let line = format!(
            "{{\"id\":{},\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_{}\",\"timestamp\":{}}}",
            i, i, ts
        );

        if let Some(id_pos) = line.find("\"id\":") {
            let rest = &line[id_pos + 5..];
            let end = rest.find(',').unwrap_or(rest.len());
            if let Ok(val) = rest[..end].parse::<u64>() {
                checksum += val;
            }
        }

        if let Some(msg_pos) = line.find("\"msg\":\"") {
            let rest = &line[msg_pos + 7..];
            if let Some(end) = rest.find('\"') {
                checksum += rest[..end].len() as u64;
            }
        }
    }

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
