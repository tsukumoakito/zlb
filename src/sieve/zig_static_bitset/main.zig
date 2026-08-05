// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const MAX_LIMIT = 10000000;
const BitSet = std.StaticBitSet(MAX_LIMIT + 1);
var is_prime_global: BitSet = undefined;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var n: usize = MAX_LIMIT;
    if (args.len > 1) {
        n = std.fmt.parseInt(usize, args[1], 10) catch MAX_LIMIT;
    }
    if (n > MAX_LIMIT) n = MAX_LIMIT;

    const masks = &is_prime_global.masks;
    @memset(masks, ~@as(BitSet.MaskInt, 0));

    const mask_bits = @bitSizeOf(BitSet.MaskInt);
    masks[0] &= ~(@as(BitSet.MaskInt, 3));

    if (n < MAX_LIMIT) {
        var k: usize = n + 1;
        while (k <= MAX_LIMIT) : (k += 1) {
            masks[k / mask_bits] &= ~(@as(BitSet.MaskInt, 1) << @intCast(k % mask_bits));
        }
    }

    var p: usize = 2;
    while (p * p <= n) : (p += 1) {
        if ((masks[p / mask_bits] & (@as(BitSet.MaskInt, 1) << @intCast(p % mask_bits))) != 0) {
            var i = p * p;
            while (i <= n) : (i += p) {
                masks[i / mask_bits] &= ~(@as(BitSet.MaskInt, 1) << @intCast(i % mask_bits));
            }
        }
    }

    var count: u64 = 0;
    for (masks) |m| {
        count += @popCount(m);
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
