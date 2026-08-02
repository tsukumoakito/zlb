// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

const std = @import("std");
const Io = std.Io;

const Node = struct {
    left: ?*Node,
    right: ?*Node,
};

fn createTree(allocator: std.mem.Allocator, depth: i32) !*Node {
    const node = try allocator.create(Node);
    if (depth > 0) {
        node.left = try createTree(allocator, depth - 1);
        node.right = try createTree(allocator, depth - 1);
    } else {
        node.left = null;
        node.right = null;
    }
    return node;
}

fn countNodes(node: *Node) u64 {
    var count: u64 = 1;
    if (node.left) |l| count += countNodes(l);
    if (node.right) |r| count += countNodes(r);
    return count;
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var depth: i32 = 20;
    if (args.len > 1) {
        depth = try std.fmt.parseInt(i32, args[1], 10);
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const root = try createTree(allocator, depth);
    const count = countNodes(root);

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
