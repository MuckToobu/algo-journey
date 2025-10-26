//! test if an element is in an ascending ordered array.

const std = @import("std");
const t = @import("tools.zig");

pub fn main() !void {
    const dba = struct {
        var a: std.heap.DebugAllocator(.{}) = .init;
    }.a.allocator();
    const n = 100;
    const v = 1000;
    const test_times = 1000;
    for (0..test_times) |_| {
        const arr = t.randomArray(dba, n, v);
        defer dba.free(arr);
        t.bubbleSort(arr);
        std.debug.assert(ascOrdered(arr));
        std.debug.print("{any} exists {d}: ", .{ arr, 3 });
        std.debug.print("{}\n", .{binarySearch(arr, 3)});
    }
}

/// test if the array is in ascending order.
fn ascOrdered(arr: []i32) bool {
    if (arr.len < 2) return true;
    for (arr[0 .. arr.len - 1], arr[1..]) |ei, ej| {
        if (ei > ej) return false;
    }
    return true;
}
/// binary search, arr must in ascending order.
fn binarySearch(arr: []i32, elem: i32) bool {
    if (arr.len == 0) return false;
    var l: usize, var r: usize, var m: usize = .{ 0, arr.len, 0 };
    while (l < r) {
        m = l + (r - l) / 2;
        switch (std.math.order(arr[m], elem)) {
            .eq => return true,
            .gt => r = m,
            .lt => l = m + 1,
        }
    }
    return false;
}
