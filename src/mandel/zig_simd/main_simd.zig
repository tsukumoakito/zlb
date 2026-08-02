// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    @setFloatMode(.strict);

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

    const vec_len = 8;
    const Vec = @Vector(vec_len, f64);
    const VecU32 = @Vector(vec_len, u32);

    for (0..n) |i| {
        const y_val = y_min + @as(f64, @floatFromInt(i)) * dy;
        const y = @as(Vec, @splat(y_val));

        var j: usize = 0;
        while (j < n) : (j += vec_len) {
            var x_vals: [vec_len]f64 = undefined;
            var initial_mask_vals: [vec_len]u32 = undefined;

            comptime var v_idx = 0;
            inline while (v_idx < vec_len) : (v_idx += 1) {
                const current_j = j + v_idx;
                x_vals[v_idx] = x_min + @as(f64, @floatFromInt(current_j)) * dx;
                initial_mask_vals[v_idx] = if (current_j < n) 1 else 0;
            }

            const x = @as(Vec, x_vals);
            var z_re = @as(Vec, @splat(0.0));
            var z_im = @as(Vec, @splat(0.0));
            var iters = @as(VecU32, @splat(0));
            var active_mask = @as(VecU32, initial_mask_vals);

            var iter: u32 = 0;
            while (iter < max_iter) : (iter += 1) {
                const z_re_sq = z_re * z_re;
                const z_im_sq = z_im * z_im;
                const mag_sq = z_re_sq + z_im_sq;

                const mask = mag_sq <= @as(Vec, @splat(4.0));
                const mask_u32 = @select(u32, mask, @as(VecU32, @splat(1)), @as(VecU32, @splat(0)));

                active_mask &= mask_u32;

                if (@reduce(.Or, active_mask) == 0) break;

                iters += active_mask;

                const next_re = z_re_sq - z_im_sq + x;
                z_im = @as(Vec, @splat(2.0)) * z_re * z_im + y;
                z_re = next_re;
            }
            checksum += @reduce(.Add, iters);
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
    try err_f.print("Size: {d}x{d}, Max Iter: {d}\n", .{ n, n, max_iter });
    try stderr.writeStreamingAll(init.io, err_f.buffered());
}
