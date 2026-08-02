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

fn countNodesManual(root: *Node, max_depth: i32) u64 {
    var count: u64 = 0;

    var stack: [64]*Node = undefined;
    const required_capacity = @as(usize, @intCast(max_depth)) + 1;
    std.debug.assert(required_capacity <= stack.len);

    var stack_ptr: usize = 0;
    stack[stack_ptr] = root;
    stack_ptr += 1;

    while (stack_ptr > 0) {
        stack_ptr -= 1;
        const current = stack[stack_ptr];
        count += 1;

        if (current.right) |r| {
            stack[stack_ptr] = r;
            stack_ptr += 1;
        }
        if (current.left) |l| {
            stack[stack_ptr] = l;
            stack_ptr += 1;
        }
    }
    return count;
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var depth: i32 = 20;
    if (args.len > 1) {
        depth = try std.fmt.parseInt(i32, args[1], 10);
    }

    const total_nodes = (@as(usize, 1) << @intCast(depth + 1)) - 1;

    const buffer = try std.heap.page_allocator.alloc(Node, total_nodes);
    defer std.heap.page_allocator.free(buffer);
    var fba = std.heap.FixedBufferAllocator.init(std.mem.sliceAsBytes(buffer));
    const fba_allocator = fba.allocator();

    const root = try createTree(fba_allocator, depth);

    const count = countNodesManual(root, depth);

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
