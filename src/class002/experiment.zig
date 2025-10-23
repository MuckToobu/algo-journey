//! # Game Rules
//! 1. Initially there are 100 people, each people with 100 RMB.
//! 2. In every round, each people give 1 RMB to another people chosen randomly.
//! 3. A people with 0 RMB is exempt from giving, but can still receive.
//! 4. After many rounds, will the distribution of wealth among these 100 people be uniform?
//!
//! Methode for measuring the uniformity of weath: the Gini coefficient.

const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    print(
        \\> the Gini coefficient is a decimal number between 0 and 1
        \\> a Gini coefficient of 0 represents that everyone's wealth is perfectly equal
        \\> the Gini coefficient of 1 reprents that one individual possesses all of teh society's wealth
        \\> the smallar Gini coefficient, the more balanced the distribution of social wealth;
        \\  the larger it is, the more uneven the wealth distribution
        \\> in 2020, the average Gini coefficient across contries globally was 0.44
        \\> it is currently widely accepted that when the Gini coefficient reaches 0.5,
        \\  it signifies a very large gap between the rich and the poor, and the distribution is highly uneven
        \\> society may consequenly descend into crisis, such as wide spread crime or social unrest
        \\> TEST STARTS! <
        \\
    , .{});

    const n = 100;
    const t = 100000;
    print("> number of people: {d}\n", .{n});
    print("> number of turns: {d}\n", .{t});
    try experiment(n, t);
    print("> TEST ENDS <\n", .{});
}

fn experiment(n: usize, t: usize) !void {
    var dba: std.heap.DebugAllocator(.{}) = .init;
    const a = dba.allocator();
    const wealths = try a.alloc(i32, n);
    @memset(wealths, 100);

    const has_money = try a.alloc(bool, n);
    var rng: std.Random.DefaultPrng = .init(@intCast(std.time.timestamp()));
    for (0..t) |_| {
        // determin who will give out 1 RMB this turn
        for (wealths, 0..) |wealth, j| {
            if (wealth > 0) has_money[j] = true else has_money[j] = false;
        }
        // the give action
        for (wealths, 0..) |*wea, j| {
            if (has_money[j]) {
                var other = j;
                // if the random persion is himself, reroll
                while (other == j) other = rng.random().intRangeLessThan(u8, 0, 100);
                wea.* -= 1;
                wealths[other] += 1;
            }
        }
    }

    std.mem.sort(i32, wealths, {}, std.sort.asc(i32));

    print("> the wealth of every person(from poor to rich):\n", .{});
    for (wealths, 0..) |wealth, i| {
        print("  {d: >5}", .{wealth});
        if (i % 10 == 9) print("\n", .{});
    }
    print("> the Gini coefficient of the sociaty is: {d:.5}\n", .{calculateGini(wealths)});
}

fn calculateGini(wealths: []const i32) f64 {
    var sum_of_abs_diff: i32 = 0;
    var sum_of_wealth: i32 = 0;
    for (wealths) |wealth| {
        sum_of_wealth += wealth;
        for (wealths) |another| {
            sum_of_abs_diff += @intCast(@abs(wealth - another));
        }
    }
    return @as(f64, @floatFromInt(sum_of_abs_diff)) / @as(f64, @floatFromInt(2 * @as(i32, @intCast(wealths.len)) * sum_of_wealth));
}
