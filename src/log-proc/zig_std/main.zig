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
    var line_buf: [512]u8 = undefined;

    const id_key = "\"id\":";
    const msg_key = "\"msg\":\"";

    for (0..n) |i| {
        const ts = std.Io.Clock.now(.real, init.io).toSeconds();
        const line = try std.fmt.bufPrint(&line_buf, "{{\"id\":{d},\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_{d}\",\"timestamp\":{d}}}", .{ i, i, ts });

        if (std.mem.find(u8, line, id_key)) |id_pos| {
            const val_start = id_pos + id_key.len;
            if (std.mem.findScalarPos(u8, line, val_start, ',')) |comma_pos| {
                checksum += std.fmt.parseUnsigned(u64, line[val_start..comma_pos], 10) catch 0;
            }
        }

        if (std.mem.find(u8, line, msg_key)) |msg_pos| {
            const msg_start = msg_pos + msg_key.len;
            if (std.mem.findScalarPos(u8, line, msg_start, '\"')) |quote_pos| {
                checksum += (quote_pos - msg_start);
            }
        }
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
