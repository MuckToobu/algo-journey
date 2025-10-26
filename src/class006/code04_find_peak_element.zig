//! peak element is value that is strictly greater than is neighbors.
//! given an integer array `nums` where no two adjacent elements are equal.
//! find a peak element and return its value.
//! the array may contains multiple peaks; in that case return the index of one of them.
//! you may imagin that nums[-1] = num[len] = negative infinity.
//! you must inplement an algorithm that runs in O(logn) time.

const std = @import("std");
const t = @import("tools.zig");
pub fn main() !void {
    const a1 = [_]i32{ 1, 2, 3, 4, 5, 6 };
    const a2 = [_]i32{ 1, 0, 4 };
    const a3 = [_]i32{ 0, 5, 4, 7, 8, 6 };
    const a4 = [_]i32{ 0, 2, 1 };
    std.debug.print("array: {any}, peak_index:{?d}\n", .{ a1, findPeakElement(&a1) });
    std.debug.print("array: {any}, peak_index:{?d}\n", .{ a2, findPeakElement(&a2) });
    std.debug.print("array: {any}, peak_index:{?d}\n", .{ a3, findPeakElement(&a3) });
    std.debug.print("array: {any}, peak_index:{?d}\n", .{ a4, findPeakElement(&a4) });
}

fn findPeakElement(arr: []const i32) ?usize {
    if (arr.len == 0) return null;
    if (arr.len == 1) return 0; // cause arr[-1] == arr[len] is negative infinity, arr[0] is peak
    if (arr[0] > arr[1]) return 0; // whather arr[0] is peak
    if (arr[arr.len - 1] > arr[arr.len - 2]) return arr.len - 1; // whather arr[len-1] is peak

    // binary search
    // the profile is _^...^_
    var l: usize, var r: usize, var m: usize = .{ 1, arr.len, undefined };
    while (l < r) {
        m = l + (r - l) / 2;
        if (arr[m - 1] < arr[m] and arr[m + 1] < arr[m])
            return m;
        if (arr[m - 1] > arr[m]) r = m else l = m + 1;
    }
    unreachable;
}
