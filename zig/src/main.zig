const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

pub fn main() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const start_number: usize = 2;
    var end_number: usize = 100000;

    if (std.posix.getenv("endnum")) |end_number_env| {
        if (std.fmt.parseInt(usize, end_number_env, 10)) |end_number_env_int| {
            end_number = end_number_env_int;
        } else |_| {
            print("endnum env value is invalid: {s}, using default: {}\n", .{ end_number_env, end_number });
        }
    }

    var mcore = false;
    if (std.posix.getenv("mcore")) |mcore_env| {
        if (std.mem.eql(u8, std.mem.trim(u8, mcore_env, " \t\r\n"), "true")) {
            mcore = true;
        } else {
            print("mcore env value is invalid: {s}, using default: {}\n", .{ mcore_env, mcore });
        }
    }

    var results = try ArrayList(usize).initCapacity(allocator, end_number - start_number);
    defer results.deinit(allocator);

    if (mcore) {
        try getPrimesMultiCore(allocator, start_number, end_number, &results);
    } else {
        getPrimesSingleCore(start_number, end_number, &results);
    }

    print("Processed {} numbers, found {} prime numbers\n", .{ end_number, results.items.len });
}

fn getPrimesSingleCore(start_number: usize, end_number: usize, results: *ArrayList(usize)) void {
    for (start_number..end_number) |number| {
        if (isPrime(number)) {
            results.appendAssumeCapacity(number);
        }
    }
}

fn getPrimesMultiCore(allocator: Allocator, start_number: usize, end_number: usize, results: *ArrayList(usize)) !void {
    const num_threads = std.Thread.getCpuCount() catch 1;
    const chunk_size = (end_number - start_number) / num_threads;

    var next_number = std.atomic.Value(usize).init(start_number);

    var chunk_results = try allocator.alloc(ArrayList(usize), num_threads);
    defer {
        for (chunk_results) |*chunk| {
            chunk.deinit(allocator);
        }
        allocator.free(chunk_results);
    }

    for (chunk_results) |*chunk| {
        chunk.* = try ArrayList(usize).initCapacity(allocator, chunk_size);
    }

    var threads = try ArrayList(std.Thread).initCapacity(allocator, num_threads);
    defer threads.deinit(allocator);

    for (0..num_threads) |i| {
        const thread = try std.Thread.spawn(.{}, process, .{ &next_number, end_number, &chunk_results[i] });
        threads.appendAssumeCapacity(thread);
    }

    for (threads.items) |thread| {
        thread.join();
    }

    for (chunk_results) |chunk| {
        results.appendSliceAssumeCapacity(chunk.items);
    }
}

fn process(next_number: *std.atomic.Value(usize), end_number: usize, chunk_result: *ArrayList(usize)) void {
    while (true) {
        const number = next_number.fetchAdd(1, .monotonic);
        if (number >= end_number) break;
        if (isPrime(number)) {
            chunk_result.appendAssumeCapacity(number);
        }
    }
}

fn isPrime(number: usize) bool {
    if (number == 1) return false;
    for (2..number) |div| {
        if (number % div == 0) {
            return false;
        }
    }
    return true;
}