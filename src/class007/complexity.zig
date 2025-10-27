//! there is no necessary correlation between time complexity and the number of loop structures.
//! a deep understanding of the algrithm's process is required to correctly determin the complexity.

const std = @import("std");
const t = @import("tools.zig");
const Allocator = std.mem.Allocator;

/// example of a single loop structure with a time complexity higher than O(n).
fn bubbleSort(arr: []i32) void {
    if (arr.len < 2) return;
    const n = arr.len;
    var end: usize, var i: usize = .{ n - 1, 0 };
    while (end > 0) {
        if (arr[i] > arr[i - 1]) t.swapa(arr, i, i + 1);

        if (i < end - 1)
            i += 1
        else {
            end -= 1;
            i = 0;
        }
    }
}

/// when the dynamic array's resizing factor is 2(or else), the cost of its expansion is O(n).
/// total cost is N + N/2 + N/3 + N/4 + ... = 2N
fn resize(gpa: Allocator, arr: []i32) []i32 {
    const len = if (arr.len == 0) 1 else arr.len * 2;
    return gpa.realloc(arr, len);
}

/// example of two nested for structure with a time complexity lower than O(n^2).
/// total cost is n/1 + n/2 + n/3 + ... + 1 = n*(1 + 1/2 + 1/3 + 1/4 + ...) = n*(ln(n)+gama) [Euler's constant].
fn forLoop() void {
    const n = 1000;
    for (0..n) |i| {
        for (0..n / i) |_| {
            // dosome
        }
    }
}
