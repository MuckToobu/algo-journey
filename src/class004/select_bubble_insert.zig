//! the select bubble and insert sort.
//! i32 is used as example, without using generic type.

const std = @import("std");

pub fn main() !void {
    const a = [_]i32{ 1, 32, 2, 46, -2, -5, 6, 7, 9, 0 };
    std.debug.print("{any}\n", .{a});
    // select sort
    var b = a;
    selectionSort(&b);
    std.debug.print("{any}\n", .{b});
    // bubble sort
    var c = a;
    bubbleSort(&c);
    std.debug.print("{any}\n", .{c});
    // select sort
    var d = a;
    bubbleSort(&d);
    std.debug.print("{any}\n", .{d});
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
