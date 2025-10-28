const std = @import("std");
const Allocator = std.mem.Allocator;
const Writer = std.Io.Writer;

fn SingleLinkedList(T: type) type {
    return struct {
        const Self = @This();
        head: ?*Node = null,
        pub fn from_slice(gpa: Allocator, src: []const T) Self {
            var list: Self = .{};
            var cur = &list.head;
            for (src) |ei| {
                const node = Node.new(gpa, ei);
                cur.* = node;
                cur = &node.*.next;
            }
            return list;
        }
        pub fn format(self: *const Self, writer: *Writer) Writer.Error!void {
            try writer.print("{{ ", .{});
            var cur = self.*.head;
            while (cur) |cn| : (cur = cn.next) {
                try writer.print("{any} -> ", .{cn.val});
            }
            try writer.print("null }}\n", .{});
            try writer.flush();
        }
        const Node = struct {
            val: T,
            next: ?*Node,
            pub fn new(gpa: Allocator, elem: T) *Node {
                const node = gpa.create(Node) catch unreachable;
                node.*.val = elem;
                node.*.next = null;
                return node;
            }
            pub fn reverse(this: *?*Node) void {
                if (this.* == null) return;
                const current: *Node = this.*.?;
                while (current.next) |next| {
                    current.*.next = next.next;
                    next.*.next = this.*;
                    this.* = next;
                }
            }
        };
    };
}

fn DoubleLinkedList(T: type) type {
    return struct {
        const Self = @This();
        head: ?*Node = null,
        pub fn from_slice(gpa: Allocator, src: []const T) Self {
            var list: Self = .{};
            var cur = &list.head;

            var pre: ?*Node = null;
            for (src) |ei| {
                const node = Node.new(gpa, ei);
                cur.* = node;
                cur.*.?.prev = pre;
                pre = node;

                cur = &node.*.next;
            }
            return list;
        }
        pub fn format(self: *const Self, writer: *Writer) Writer.Error!void {
            try writer.print("{{ ", .{});
            var cur = self.*.head;
            while (cur) |cn| : (cur = cn.next) {
                try writer.print("{any} -> ", .{cn.val});
            }
            try writer.print("null }}\n", .{});
            try writer.flush();
        }
        const Node = struct {
            val: T,
            next: ?*Node = null,
            prev: ?*Node = null,
            pub fn new(gpa: Allocator, elem: T) *Node {
                const node = gpa.create(Node) catch unreachable;
                node.*.val = elem;
                node.*.next = null;
                node.*.prev = null;
                return node;
            }
            pub fn reverse(this: *?*Node) void {
                if (this.* == null) return;
                var cur = this.*.?;
                std.mem.swap(?*Node, &cur.next, &cur.prev);
                while (cur.prev) |c| {
                    std.mem.swap(?*Node, &c.*.prev, &c.*.next);
                    cur = cur.prev.?;
                }
                // all swaped, now deal with the edge.
                cur.prev = this.*.?.next;
                this.*.?.next = null;
                if (cur.prev) |n| n.next = cur;

                // cur.*.prev = this.*.?.next;
                // this.*.?.next = null;
                this.* = cur;
            }
        };
    };
}
pub fn main() !void {
    const dba = struct {
        var d: std.heap.DebugAllocator(.{}) = .init;
    }.d.allocator();

    const arr = [_]i32{ 1, 3423, 43, -1, -48, 2, 9, 0, 9, 10 };
    var list = SingleLinkedList(i32).from_slice(dba, &arr);
    std.debug.print("{s}\n", .{@typeName(@TypeOf(list))});
    std.debug.print("{f}", .{list});
    SingleLinkedList(i32).Node.reverse(&list.head);
    std.debug.print("{f}", .{list});

    var list2 = DoubleLinkedList(i32).from_slice(dba, &arr);
    std.debug.print("{s}\n", .{@typeName(@TypeOf(list2))});
    std.debug.print("{f}", .{list2});
    DoubleLinkedList(i32).Node.reverse(&list2.head);
    std.debug.print("{f}", .{list2});
}
