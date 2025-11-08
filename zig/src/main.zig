const std = @import("std");
const zig = @import("zig");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

pub fn main() !void {

    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var end_number: usize = 100000;
    if (std.posix.getenv("endnum")) |end_number_env| {
        if (std.fmt.parseInt(usize, end_number_env, 10)) |end_number_env_int| {
            end_number = end_number_env_int;
        } else |_| {
            print("endnum env value is invalid: {s}, using default: {}\n", .{end_number_env, end_number});
        }
    }

    var mcore = false;
    if (std.posix.getenv("mcore")) |mcore_env| {
        if (std.mem.eql(u8, std.mem.trim(u8, mcore_env, " \t\r\n"), "true")) {
            mcore = true;
        } else {
            print("mcore env value is invalid: {s}, using default: {}\n", .{mcore_env, mcore});
        }
    }

    var batches :usize = 1;
    if (mcore) {
        batches = std.Thread.getCpuCount() catch 1;
    }
    var it = zig.BatchIteratorByCount(usize).init(2, end_number, batches);
    while (it.next()) |batch| {
        std.debug.print("batch: {}..{}\n", .{ batch.start, batch.end });
    }

    var list = try std.ArrayList(usize).initCapacity(allocator, end_number);
    defer list.deinit(allocator);

    for (2..end_number) |number| {
        if (isPrime(number)) {
            list.appendAssumeCapacity(number);
        }
    }
    print("Processed {} numbers, found {} prime numbers", .{end_number, list.items.len});
}

fn isPrime(number: usize) bool {
    for (2..number) |div| {
        if (number % div == 0) {
            return false;
        }
    }
    return true;
}