// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};
use std::time::{SystemTime, UNIX_EPOCH};

#[allow(dead_code)]
struct LogEntry {
    id: u64,
    level: String,
    msg: String,
    timestamp: u64,
}

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

        let mut entry = LogEntry {
            id: 0,
            level: String::new(),
            msg: String::new(),
            timestamp: 0,
        };

        let mut current_key = "";
        for part in line.split(|c| c == '"' || c == ':' || c == ',' || c == '{' || c == '}') {
            let trimmed = part.trim();
            if trimmed.is_empty() { continue; }

            match trimmed {
                "id" | "level" | "msg" | "timestamp" => current_key = trimmed,
                _ => {
                    match current_key {
                        "id" => entry.id = trimmed.parse().unwrap_or(0),
                        "level" => entry.level = trimmed.to_string(),
                        "msg" => entry.msg = trimmed.to_string(),
                        "timestamp" => entry.timestamp = trimmed.parse().unwrap_or(0),
                        _ => {}
                    }
                    current_key = "";
                }
            }
        }
        checksum += entry.id + entry.msg.len() as u64;
    }

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
