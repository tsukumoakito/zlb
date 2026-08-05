// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const NumberInfo = struct {
    is_prime: u8,
};

pub fn main(init: std.process.Init) !void {
    const args_allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(args_allocator);

    var n: usize = 10000000;
    if (args.len > 1) {
        n = std.fmt.parseInt(usize, args[1], 10) catch 10000000;
    }

    const allocator = std.heap.page_allocator;
    var list = std.MultiArrayList(NumberInfo).empty;
    try list.ensureTotalCapacity(allocator, n + 1);
    defer list.deinit(allocator);
    list.len = n + 1;

    const sieve = list.items(.is_prime);
    @memset(sieve, 1);

    if (n >= 0) sieve[0] = 0;
    if (n >= 1) sieve[1] = 0;

    var p: usize = 2;
    while (p * p <= n) : (p += 1) {
        if (sieve[p] == 1) {
            var i = p * p;
            while (i <= n) : (i += p) {
                sieve[i] = 0;
            }
        }
    }

    var count: u64 = 0;
    for (sieve) |val| {
        if (val == 1) count += 1;
    }

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
