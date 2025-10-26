//! find the index of leftmost number in a sorted array that is greater than or equal to a number.

const std = @import("std");
const t = @import("tools.zig");

pub fn main() !void {
    const dba = struct {
        var d: std.heap.DebugAllocator(.{}) = .init;
        const a = d.allocator();
    }.a;
    const n = 100;
    const v = 1000;
    const test_times = 1000;
    t.prints("> TEST STARTS <");
    for (0..test_times) |_| {
        const arr = t.randomArray(dba, n, v);
        t.bubbleSort(arr);
        std.debug.assert(t.ascOrdered(arr));
        const num = t.randomNumber(0, v);
        if (right(arr, num) != binaryFindLeft(arr, num)) {
            t.prints("some error !!");
        }
    }

    t.prints("> TEST ENDS <");
}

fn right(arr: []const i32, num: i32) ?usize {
    for (arr, 0..) |ei, i| {
        if (ei >= num) {
            return i;
        }
    }
    return null;
}

fn binaryFindLeft(arr: []i32, num: i32) ?usize {
    var l: usize, var r: usize, var m: usize = .{ 0, arr.len, 0 };
    var ans: ?usize = null;
    while (l < r) {
        m = l + (r - l) / 2;
        switch (std.math.order(arr[m], num)) {
            .gt, .eq => {
                ans = m;
                r = m;
            },
            .lt => l = m + 1,
        }
    }
    return ans;
}
