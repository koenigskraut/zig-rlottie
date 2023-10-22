const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("zig-rlottie", .{ .source_file = .{ .path = "src/library.zig" } });
}
