// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const args_allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(args_allocator);

    var n: usize = 10000000;
    if (args.len > 1) {
        n = try std.fmt.parseInt(usize, args[1], 10);
    }

    const allocator = std.heap.page_allocator;

    var is_prime = try std.DynamicBitSet.initFull(allocator, n + 1);
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
