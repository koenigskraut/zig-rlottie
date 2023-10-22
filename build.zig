const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep = b.dependency("librlottie", .{
        .target = target,
        .optimize = optimize,
    });

    const zig_lottie_module = b.addModule("zig-rlottie", .{ .source_file = .{ .path = "src/library.zig" }, .dependencies = &.{} });
    _ = zig_lottie_module;
    const rlottie_lib = dep.artifact("rlottie");
    _ = rlottie_lib;
}
