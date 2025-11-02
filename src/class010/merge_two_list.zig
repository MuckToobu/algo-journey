const std = @import("std");
const Allocator = std.mem.Allocator;
const Writer = std.Io.Writer;
const t = @import("tools.zig");

fn SingleLinkedList(T: type) type {
    return struct {
        const Self = @This();
        head: ?*Node = null,
        pub fn fromSlice(gpa: Allocator, src: []const T) Self {
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
            pub fn meargeAscOrderd(head1: *Node, head2: *Node) *Node {
                const head = if (head1.val <= head2.val) head1 else head2;
                var h1: ?*Node = head1.next;
                var h2: ?*Node = head2.next;
                var cur: ?*Node = head;
                while (h1 != null and h2 != null) {
                    if (h1.?.val <= h2.?.val) {
                        cur.?.next = h1;
                        h1 = h1.?.next;
                    } else {
                        cur.?.next = h2;
                        h2 = h2.?.next;
                    }

                    cur = cur.?.next;
                }
                cur.?.next = if (h1 != null) h1 else h2;
                return head;
            }
        };
    };
}
pub fn main() !void {
    const dba = struct {
        var d: std.heap.DebugAllocator(.{}) = .init;
    }.d.allocator();

    const a1 = t.randomArray(dba, 25, 100);
    defer dba.free(a1);
    t.bubbleSort(a1);
    const a2 = t.randomArray(dba, 25, 100);
    defer dba.free(a2);
    t.bubbleSort(a2);

    var l1 = SingleLinkedList(i32).fromSlice(dba, a1);
    std.debug.print("{f}", .{l1});
    const l2 = SingleLinkedList(i32).fromSlice(dba, a2);
    std.debug.print("{f}", .{l2});
    l1.head = SingleLinkedList(i32).Node.meargeAscOrderd(l1.head.?, l2.head.?);
    std.debug.print("{f}", .{l1});
}
