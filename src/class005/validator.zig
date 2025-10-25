//! data validator, using known simple methods to generate some data for testing new effecient approch.

const std = @import("std");
const Allocator = std.mem.Allocator;

const dba = blk: {
    const d = struct {
        var d: std.heap.DebugAllocator(.{}) = .init;
        const a = d.allocator();
    };
    break :blk d.a;
};

pub fn main() !void {
    // the length of random array
    const n = 100;
    // the element value of random array are in range 1..=v
    const v = 1000;
    // the number of test
    const test_times = 1000;
    std.debug.print("> TEST STARTS! < \n", .{});
    for (0..test_times) |_| {
        const arr = randomArray(dba, n, v);
        defer dba.free(arr);
        const arr1 = copyArray(dba, arr);
        defer dba.free(arr1);
        const arr2 = copyArray(dba, arr);
        defer dba.free(arr2);
        const arr3 = copyArray(dba, arr);
        defer dba.free(arr3);
        selectionSort(arr1);
        bubbleSort(arr2);
        insertionSort(arr3);
        if (!sameArray(arr1, arr2) or !sameArray(arr2, arr3)) {
            std.debug.print("  error sample: {any}", .{arr});
        }
    }
    std.debug.print("> TEST ENDS! < \n", .{});
}
/// generate a array with len n and all data are in range 1..=v
/// the return array must be freed by the caller with gpa.
fn randomArray(gpa: Allocator, n: usize, v: i32) []const i32 {
    var dprng: std.Random.DefaultPrng = .init(@intCast(std.time.milliTimestamp()));
    const prng = dprng.random();
    const size = prng.uintAtMost(usize, n);
    const array = gpa.alloc(i32, size) catch unreachable;
    for (array) |*e| {
        e.* = prng.intRangeAtMost(i32, 1, v);
    }
    return array;
}

/// copy a array useing gpa
/// the return array must be freed by the caller with gpa.
fn copyArray(gpa: Allocator, src: []const i32) []i32 {
    const dst = gpa.alloc(i32, src.len) catch unreachable;
    @memcpy(dst, src);
    return dst;
}

fn sameArray(a1: []const i32, a2: []const i32) bool {
    return std.mem.eql(i32, a1, a2);
}

fn selectionSort(arr: []i32) void {
    if (arr.len < 2) return;
    for (0..arr.len) |i| {
        var min_index: usize = i;
        for (arr[i..], i..) |ej, j| {
            if (ej < arr[min_index]) min_index = j;
        }
        swapa(arr, i, min_index);
    }
}

fn bubbleSort(arr: []i32) void {
    if (arr.len < 2) return;

    var unsort_end = arr.len;
    while (unsort_end > 0) : (unsort_end -= 1) {
        for (0..unsort_end - 1) |i| {
            if (arr[i] > arr[i + 1]) swapa(arr, i, i + 1);
        }
    }
}

fn insertionSort(arr: []i32) void {
    if (arr.len < 2) return;
    for (1..arr.len) |i| {
        var j: usize = i;
        while (j > 0) : (j -= 1) {
            if (arr[j] < arr[j - 1]) swapa(arr, j, j - 1);
        }
    }
}

fn swapp(ei: *i32, ej: *i32) void {
    const tmp = ei.*;
    ei.* = ej.*;
    ej.* = tmp;
}

fn swapa(arr: []i32, i: usize, j: usize) void {
    const tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
