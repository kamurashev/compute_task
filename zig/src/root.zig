const std = @import("std");

pub fn BatchIteratorByCount(comptime T: type) type {
    return struct {
        start: T,
        end: T,
        batch_count: T,
        current_batch: T,

        const Self = @This();

        pub const Batch = struct { start: T, end: T };

        pub fn init(start: T, end: T, batch_count: T) Self {
            return .{
                .start = start,
                .end = end,
                .batch_count = batch_count,
                .current_batch = 0,
            };
        }

        /// Returns the next batch as {start, end}, or null when finished
        pub fn next(self: *Self) ?Batch {
            if (self.current_batch >= self.batch_count or self.start >= self.end) return null;

            const remaining_batches = self.batch_count - self.current_batch;
            const total_remaining = self.end - self.start;

            // ceil division to evenly distribute remaining items
            const batch_size = (total_remaining + remaining_batches - 1) / remaining_batches;
            const batch_end = @min(self.start + batch_size, self.end);

            const result = Batch{
                .start = self.start,
                .end = batch_end,
            };

            self.start = batch_end;
            self.current_batch += 1;

            return result;
        }
    };
}