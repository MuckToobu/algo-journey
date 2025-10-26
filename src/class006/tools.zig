//! some useful tools in this exercise

const std = @import("std");
const Allocator = std.mem.Allocator;

/// return true and print a massage indicating that the fn is called.
pub fn returnTrue() bool {
    prints("entered <returnTrue> function");
    return true;
}

/// return false and print a massage indicating that the fn is called.
pub fn returnFalse() bool {
    prints("entered <returnFalse> function");
    return false;
}

/// print string and new line.
pub fn prints(s: []const u8) void {
    std.debug.print("{s}\n", .{s});
}

/// print a number and new line.
pub fn printd(number: anytype) void {
    std.debug.print("{}\n", .{number});
}

/// print a integer in it binary form.
pub fn printBinary(i: anytype) void {
    const T = @TypeOf(i);
    const St = std.math.Log2Int(T);
    var bit: St = std.math.maxInt(St);
    while (true) : (bit -= 1) {
        std.debug.print("{s}", .{if (i & (@as(T, 1) << bit) == 0) "0" else "1"});
        if (bit == 0) break;
    }
    std.debug.print("\n", .{});
}

/// sort an array of i32 in ascending order.
pub fn selectionSort(arr: []i32) void {
    if (arr.len < 2) return;
    for (0..arr.len) |i| {
        var min_index: usize = i;
        for (arr[i..], i..) |ej, j| {
            if (ej < arr[min_index]) min_index = j;
        }
        swapa(arr, i, min_index);
    }
}

/// sort an array of i32 in ascending order.
pub fn bubbleSort(arr: []i32) void {
    if (arr.len < 2) return;

    var unsort_end = arr.len;
    while (unsort_end > 0) : (unsort_end -= 1) {
        for (0..unsort_end - 1) |i| {
            if (arr[i] > arr[i + 1]) swapa(arr, i, i + 1);
        }
    }
}

/// sort an array of i32 in ascending order.
pub fn insertionSort(arr: []i32) void {
    if (arr.len < 2) return;
    for (1..arr.len) |i| {
        var j: usize = i;
        while (j > 0) : (j -= 1) {
            if (arr[j] < arr[j - 1]) swapa(arr, j, j - 1);
        }
    }
}

/// exchange the value at two positions.
pub fn swapp(ei: *i32, ej: *i32) void {
    const tmp = ei.*;
    ei.* = ej.*;
    ej.* = tmp;
}

/// exchange the value at two positions of an array.
pub fn swapa(arr: []i32, i: usize, j: usize) void {
    const tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

/// generate a array with len n and all data are in range 1..=v
/// the return array must be freed by the caller with gpa.
pub fn randomArray(gpa: Allocator, n: usize, v: i32) []i32 {
    var dprng: std.Random.DefaultPrng = .init(@intCast(std.time.milliTimestamp()));
    const prng = dprng.random();
    const size = prng.uintAtMost(usize, n);
    const array = gpa.alloc(i32, size) catch unreachable;
    for (array) |*e| {
        e.* = prng.intRangeAtMost(i32, 1, v);
    }
    return array;
}

/// random length array with data undefined
pub fn randomArrayUninited(gpa: Allocator, n: usize) []i32 {
    var dprng: std.Random.DefaultPrng = .init(@intCast(std.time.milliTimestamp()));
    const prng = dprng.random();
    const size = prng.uintAtMost(usize, n);
    return gpa.alloc(size, i32) catch unreachable;
}

/// fill an array with random i32 number in range at_least..=at_most.
pub fn randomlyFillArray(arr: []i32, at_least: i32, at_most: i32) void {
    for (arr) |*e| e.* = randomNumber(at_least, at_most);
}

/// fill an array with random i32 number in range at_least..=at_most.
pub fn randomNumber(at_least: i32, at_most: i32) i32 {
    var dprng: std.Random.DefaultPrng = .init(@intCast(std.time.milliTimestamp()));
    const prng = dprng.random();
    return prng.intRangeAtMost(i32, at_least, at_most);
}

/// copy a array useing gpa
/// the return array must be freed by the caller with gpa.
pub fn copyArray(gpa: Allocator, src: []const i32) []i32 {
    const dst = gpa.alloc(i32, src.len) catch unreachable;
    @memcpy(dst, src);
    return dst;
}

/// if the lenght and contents of two arrays are same, return true.
pub fn sameArray(a1: []const i32, a2: []const i32) bool {
    return std.mem.eql(i32, a1, a2);
}

/// test if the array is in ascending order.
pub fn ascOrdered(arr: []i32) bool {
    if (arr.len < 2) return true;
    for (arr[0 .. arr.len - 1], arr[1..]) |ei, ej| {
        if (ei > ej) return false;
    }
    return true;
}

/// binary search, arr must in ascending order.
pub fn binarySearch(arr: []i32, elem: i32) bool {
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
