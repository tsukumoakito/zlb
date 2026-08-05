// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const MAX_LIMIT = 10000000;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var n: usize = MAX_LIMIT;
    if (args.len > 1) {
        n = std.fmt.parseInt(usize, args[1], 10) catch MAX_LIMIT;
    }

    var is_prime = try std.DynamicBitSet.initFull(std.heap.page_allocator, n + 1);
    defer is_prime.deinit();

    if (n >= 0) is_prime.unset(0);
    if (n >= 1) is_prime.unset(1);

    var p: usize = 2;
    while (p * p <= n) : (p += 1) {
        if (is_prime.isSet(p)) {
            var i = p * p;
            while (i <= n) : (i += p) {
                is_prime.unset(i);
            }
        }
    }

    const count = is_prime.count();

    const stdout = Io.File.stdout();
    const stderr = Io.File.stderr();

    var out_buf: [128]u8 = undefined;
    var out_f = Io.Writer.fixed(&out_buf);
    try out_f.print("Checksum: {d}\n", .{count});
    try stdout.writeStreamingAll(init.io, out_f.buffered());

    var err_buf: [128]u8 = undefined;
    var err_f = Io.Writer.fixed(&err_buf);
    try err_f.print("Limit: {d}\n", .{n});
    try stderr.writeStreamingAll(init.io, err_f.buffered());
}
