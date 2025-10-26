//! find the index of rightmost number in a sorted array that is less than or equal to a number.

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
        if (right(arr, num) != binaryFindRight(arr, num)) {
            t.prints("some error !!");
        }
    }

    t.prints("> TEST ENDS <");
}

fn right(arr: []const i32, num: i32) ?usize {
    var ans: ?usize = null;
    for (arr, 0..) |ei, i| {
        if (ei <= num)
            ans = i
        else
            break;
    }
    return ans;
}

fn binaryFindRight(arr: []i32, num: i32) ?usize {
    var l: usize, var r: usize, var m: usize = .{ 0, arr.len, 0 };
    var ans: ?usize = null;
    while (l < r) {
        m = l + (r - l) / 2;
        switch (std.math.order(arr[m], num)) {
            .lt, .eq => {
                ans = m;
                l = m + 1;
            },
            .gt => r = m,
        }
    }
    return ans;
}
