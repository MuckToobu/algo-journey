//! this file introduces the binary form of integer and operation on it;

const std = @import("std");

pub fn main() !void {
    // binary form of integer
    const a: i32 = 78;
    printd(a);
    printBinary(a);
    prints("===a===");
    const b: i32 = -6;
    printd(b);
    printBinary(b);
    prints("===b===");
    const c: i32 = 0b1001110;
    printd(c);
    printBinary(c);
    prints("===c===");
    const d: i32 = 0x4E;
    printd(d);
    printBinary(d);
    prints("===d===");
    // ~. the opposite number
    printBinary(a);
    printBinary(~a);
    const e: i32 = ~a + 1;
    printd(e);
    printBinary(e);
    prints("===e===");
    // the opposite value and the absolute value of min value of int type are themeselves
    // to reproduce this in zig , must use wrapping operator -%
    const f: i32 = std.math.minInt(i32);
    printd(f);
    printBinary(f);
    printd(-%f);
    printBinary(-%f);
    printd(~f);
    printBinary(~f);
    printd(~f +% 1);
    printBinary(~f +% 1);
    prints("===f===");
    // bitwise or and xor
    const g: i32 = 0b0001010;
    const h: i32 = 0b0001100;
    printBinary(g | h);
    printBinary(g & h);
    printBinary(g ^ h);
    prints("===g h===");
    // logic add or
    prints("> TEST1 BEGINS < ");
    const test1 = returnTrue() | returnFalse();
    std.debug.print("> TEST1 RESULT: {}\n", .{test1});
    prints("> TEST2 BEGINS < ");
    const test2 = returnTrue() or returnFalse();
    std.debug.print("> TEST2 RESULT: {}\n", .{test2});
    prints("> TEST3 BEGINS < ");
    const test3 = returnFalse() & returnTrue();
    std.debug.print("> TEST3 RESULT: {}\n", .{test3});
    prints("> TEST4 BEGINS < ");
    const test4 = returnFalse() and returnTrue();
    std.debug.print("> TEST4 RESULT: {}\n", .{test4});
    prints("===| or & and===");
    // left right shift
    const i: i32 = 0b0011010;
    printBinary(i);
    printd(i);
    printBinary(i << 1);
    printd(i << 1);
    printBinary(i << 2);
    printd(i << 2);
    printBinary(i << 3);
    printd(i << 3);
    prints("===i <<===");
    printBinary(i >> 1);
    printd(i >> 1);
    printBinary(i >> 2);
    printd(i >> 2);
    printBinary(i >> 3);
    printd(i >> 3);
    prints("===i >>===");
    const j: i32 = ~@as(i32, 0b00001111111111111111111111111111);
    printBinary(j);
    printd(j);
    printBinary(j << 1);
    printd(j << 1);
    printBinary(j << 2);
    printd(j << 2);
    printBinary(j << 3);
    printd(j << 3);
    prints("===j <<===");
    printBinary(j >> 1);
    printd(j >> 1);
    printBinary(j >> 2);
    printd(j >> 2);
    printBinary(j >> 3);
    printd(j >> 3);
    prints("===j >>===");
    const k: u32 = ~@as(u32, 0b00001111111111111111111111111111);
    printBinary(k);
    printd(k);
    printBinary(k << 1);
    printd(k << 1);
    printBinary(k << 2);
    printd(k << 2);
    printBinary(k << 3);
    printd(k << 3);
    prints("===k <<===");
    printBinary(k >> 1);
    printd(k >> 1);
    printBinary(k >> 2);
    printd(k >> 2);
    printBinary(k >> 3);
    printd(k >> 3);
    prints("===k >>===");
}

fn returnTrue() bool {
    prints("entered <returnTrue> function");
    return true;
}

fn returnFalse() bool {
    prints("entered <returnFalse> function");
    return false;
}

fn prints(s: []const u8) void {
    std.debug.print("{s}\n", .{s});
}
fn printd(number: anytype) void {
    std.debug.print("{}\n", .{number});
}

/// this function is interesting
fn printBinary(i: anytype) void {
    const T = @TypeOf(i);
    const St = std.math.Log2Int(T);
    var bit: St = std.math.maxInt(St);
    while (true) : (bit -= 1) {
        std.debug.print("{s}", .{if (i & (@as(T, 1) << bit) == 0) "0" else "1"});
        if (bit == 0) break;
    }
    std.debug.print("\n", .{});
}
