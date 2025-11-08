const std = @import("std");
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

    var chunks: usize = 1;
    if (mcore) {
        chunks = std.Thread.getCpuCount() catch 1;
    }

    const total_numbers = end_number - 2;
    const chunk_size = (total_numbers + chunks - 1) / chunks;

    // Create combined results array
    var results: ArrayList(usize) = try ArrayList(usize).initCapacity(allocator, end_number);
    defer results.deinit(allocator);

    // Use atomic counter for dynamic scheduling
    var next_number = std.atomic.Value(usize).init(2);

    if (mcore) {
        // Multi-core path with dynamic work distribution
        // Create chunk result arrays (one per thread)
        var chunk_results = try allocator.alloc(ArrayList(usize), chunks);
        defer {
            for (chunk_results) |*chunk| {
                chunk.deinit(allocator);
            }
            allocator.free(chunk_results);
        }

        // Initialize each chunk result with estimated capacity
        for (chunk_results) |*chunk| {
            chunk.* = try ArrayList(usize).initCapacity(allocator, chunk_size);
        }

        var threads = try ArrayList(std.Thread).initCapacity(allocator, chunks);
        defer threads.deinit(allocator);

        for (0..chunks) |i| {
            const thread = try std.Thread.spawn(.{}, process, .{ &next_number, end_number, &chunk_results[i] });
            threads.appendAssumeCapacity(thread);
        }

        // Wait for all threads to complete
        for (threads.items) |thread| {
            thread.join();
        }

        // Combine all chunk results into results array
        for (chunk_results) |chunk| {
            results.appendSliceAssumeCapacity(chunk.items);
        }
    } else {
        // Single-core path
        process(&next_number, end_number, &results);
    }

    print("Processed {} numbers, found {} prime numbers\n", .{ end_number, results.items.len });
}

fn process(next_number: *std.atomic.Value(usize), end_number: usize, chunk_result: *ArrayList(usize)) void {
    while (true) {
        // Atomically get the next number to check
        const number = next_number.fetchAdd(1, .monotonic);

        if (number >= end_number) {
            break;
        }

        if (isPrime(number)) {
            chunk_result.appendAssumeCapacity(number);
        }
    }
}

fn isPrime(number: usize) bool {
    for (2..number) |div| {
        if (number % div == 0) {
            return false;
        }
    }
    return true;
}