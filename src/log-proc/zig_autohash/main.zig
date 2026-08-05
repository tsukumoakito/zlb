// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var n: usize = 10000;
    if (args.len > 1) {
        n = try std.fmt.parseInt(usize, args[1], 10);
    }

    var checksum: u64 = 0;
    var map = std.AutoHashMap(usize, u64).init(allocator);
    try map.ensureTotalCapacity(@intCast(n));

    var scratch_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer scratch_arena.deinit();
    const scratch_allocator = scratch_arena.allocator();

    var line_buf: [512]u8 = undefined;

    for (0..n) |i| {
        const ts = std.Io.Clock.now(.real, init.io).toSeconds();
        const line = try std.fmt.bufPrint(&line_buf, "{{\"id\":{d},\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_{d}\",\"timestamp\":{d}}}", .{ i, i, ts });

        var stream = std.json.Scanner.initCompleteInput(scratch_allocator, line);
        defer stream.deinit();

        var id: ?u64 = null;
        var msg_len: ?u64 = null;

        while (true) {
            const token = try stream.next();
            if (token == .end_of_document) break;
            switch (token) {
                .string => |name| {
                    if (std.mem.eql(u8, name, "id")) {
                        const next_token = try stream.next();
                        id = std.fmt.parseInt(u64, next_token.number, 10) catch null;
                    } else if (std.mem.eql(u8, name, "msg")) {
                        const next_token = try stream.next();
                        msg_len = next_token.string.len;
                    }
                },
                else => {},
            }
        }

        if (id) |id_v| {
            if (msg_len) |m_len| {
                try map.put(i, id_v + m_len);
            }
        }
        _ = scratch_arena.reset(.retain_capacity);
    }

    var it = map.valueIterator();
    while (it.next()) |val| {
        checksum += val.*;
    }

    const stdout = Io.File.stdout();
    const stderr = Io.File.stderr();
    var out_buf: [128]u8 = undefined;
    var out_f = Io.Writer.fixed(&out_buf);
    try out_f.print("Checksum: {d}\n", .{checksum});
    try stdout.writeStreamingAll(init.io, out_f.buffered());

    var err_buf: [128]u8 = undefined;
    var err_f = Io.Writer.fixed(&err_buf);
    try err_f.print("Limit: {d}\n", .{n});
    try stderr.writeStreamingAll(init.io, err_f.buffered());
}
