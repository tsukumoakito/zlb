// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    const args = try init.minimal.args.toSlice(allocator);

    var n: usize = 4000;
    if (args.len > 1) {
        n = try std.fmt.parseInt(usize, args[1], 10);
    }

    const max_iter: u32 = 1000;
    const x_min: f64 = -2.0;
    const x_max: f64 = 1.0;
    const y_min: f64 = -1.1;
    const y_max: f64 = 1.1;

    const dx = (x_max - x_min) / @as(f64, @floatFromInt(n));
    const dy = (y_max - y_min) / @as(f64, @floatFromInt(n));

    var checksum: u64 = 0;

    var row_buffer = std.ArrayList(u32).empty;
    try row_buffer.ensureTotalCapacity(allocator, n);
    row_buffer.items.len = n;

    for (0..n) |i| {
        const y = y_min + @as(f64, @floatFromInt(i)) * dy;

        for (0..n) |j| {
            const x = x_min + @as(f64, @floatFromInt(j)) * dx;
            var z_re: f64 = 0.0;
            var z_im: f64 = 0.0;
            var iter: u32 = 0;

            while (z_re * z_re + z_im * z_im <= 4.0 and iter < max_iter) : (iter += 1) {
                const next_re = z_re * z_re - z_im * z_im + x;
                z_im = 2.0 * z_re * z_im + y;
                z_re = next_re;
            }
            row_buffer.items[j] = iter;
        }

        for (row_buffer.items) |val| {
            checksum += val;
        }
    }

    const recovered_checksum = std.mem.bytesToValue(u64, std.mem.asBytes(&checksum));

    const stdout = Io.File.stdout();
    const stderr = Io.File.stderr();

    var out_buf: [128]u8 = undefined;
    var out_f = Io.Writer.fixed(&out_buf);
    try out_f.print("Checksum: {d}\n", .{recovered_checksum});
    try stdout.writeStreamingAll(init.io, out_f.buffered());

    var err_buf: [128]u8 = undefined;
    var err_f = Io.Writer.fixed(&err_buf);
    try err_f.print("Size: {d}x{d}, Max Iter: {d}\n", .{ n, n, max_iter });
    try stderr.writeStreamingAll(init.io, err_f.buffered());
}
