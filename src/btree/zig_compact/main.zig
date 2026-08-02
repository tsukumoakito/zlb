// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const Tree = struct {
    lefts: []u32,
    rights: []u32,
    next_idx: u32,

    const null_idx: u32 = std.math.maxInt(u32);

    fn init(allocator: std.mem.Allocator, total_nodes: usize) !Tree {
        return .{
            .lefts = try allocator.alloc(u32, total_nodes),
            .rights = try allocator.alloc(u32, total_nodes),
            .next_idx = 0,
        };
    }

    fn deinit(self: *Tree, allocator: std.mem.Allocator) void {
        allocator.free(self.lefts);
        allocator.free(self.rights);
    }

    fn createSubtree(self: *Tree, depth: i32) u32 {
        const current = self.next_idx;
        self.next_idx += 1;

        if (depth > 0) {
            self.lefts[current] = self.createSubtree(depth - 1);
            self.rights[current] = self.createSubtree(depth - 1);
        } else {
            self.lefts[current] = null_idx;
            self.rights[current] = null_idx;
        }
        return current;
    }

    fn countNodes(self: *const Tree, node_idx: u32) u64 {
        if (node_idx == null_idx) return 0;
        return 1 + self.countNodes(self.lefts[node_idx]) + self.countNodes(self.rights[node_idx]);
    }
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var depth: i32 = 20;
    if (args.len > 1) {
        depth = try std.fmt.parseInt(i32, args[1], 10);
    }

    const total_nodes = (@as(usize, 1) << @intCast(depth + 1)) - 1;

    var tree = try Tree.init(std.heap.page_allocator, total_nodes);
    defer tree.deinit(std.heap.page_allocator);

    const root = tree.createSubtree(depth);

    const count = tree.countNodes(root);

    const stdout = Io.File.stdout();
    const stderr = Io.File.stderr();

    var out_buf: [128]u8 = undefined;
    var out_f = Io.Writer.fixed(&out_buf);
    try out_f.print("Checksum: {d}\n", .{count});
    try stdout.writeStreamingAll(init.io, out_f.buffered());

    var err_buf: [128]u8 = undefined;
    var err_f = Io.Writer.fixed(&err_buf);
    try err_f.print("Depth: {d}\n", .{depth});
    try stderr.writeStreamingAll(init.io, err_f.buffered());
}
