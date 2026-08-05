// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const LogEntry = struct {
    id: u64,
    level: []const u8,
    msg: []const u8,
    timestamp: u64,
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var n: usize = 10000;
    if (args.len > 1) {
        n = try std.fmt.parseInt(usize, args[1], 10);
    }

    var checksum: u64 = 0;
    var line_buf: [512]u8 = undefined;

    var scratch_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer scratch_arena.deinit();
    const scratch_allocator = scratch_arena.allocator();

    for (0..n) |i| {
        const ts = @as(u64, @intCast(std.Io.Clock.now(.real, init.io).toSeconds()));
        const line = try std.fmt.bufPrint(&line_buf, "{{\"id\":{d},\"level\":\"info\",\"msg\":\"performance_test_log_entry_number_{d}\",\"timestamp\":{d}}}", .{ i, i, ts });

        const parsed = try std.json.parseFromSlice(LogEntry, scratch_allocator, line, .{ .ignore_unknown_fields = true });
        checksum += parsed.value.id + parsed.value.msg.len;

        _ = scratch_arena.reset(.retain_capacity);
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
