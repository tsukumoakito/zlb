// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

use std::collections::HashMap;
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

    let mut map: HashMap<usize, u64> = HashMap::with_capacity(n);

    for i in 0..n {
        let ts = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();

        let line = format!(
            "{{\"id\":{},\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_{}\",\"timestamp\":{}}}",
            i, i, ts
        );

        let mut id_v: Option<u64> = None;
        let mut m_len: Option<u64> = None;

        let mut tokens = line.split(|c| c == '"' || c == ':' || c == ',');
        while let Some(token) = tokens.next() {
            match token {
                "id" => {
                    while let Some(t) = tokens.next() {
                        if let Ok(val) = t.trim().parse::<u64>() {
                            id_v = Some(val);
                            break;
                        }
                    }
                }
                "msg" => {
                    while let Some(t) = tokens.next() {
                        if !t.trim().is_empty() {
                            m_len = Some(t.len() as u64);
                            break;
                        }
                    }
                }
                _ => {}
            }
        }

        if let (Some(id), Some(msg)) = (id_v, m_len) {
            map.insert(i, id + msg);
        }
    }

    let mut checksum: u64 = 0;
    for val in map.values() {
        checksum += val;
    }

    println!("Checksum: {}", checksum);
    let mut stderr = io::stderr();
    let _ = writeln!(stderr, "Limit: {}", n);
}
