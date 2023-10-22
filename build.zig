const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_lottie_module = b.addModule("zig-rlottie", .{ .source_file = .{ .path = "src/library.zig" }, .dependencies = &.{} });
    _ = zig_lottie_module;

    const lib = b.addStaticLibrary(.{
        .name = "rlottie",
        .root_source_file = b.addWriteFiles().add("empty.c", ""),
        .target = target,
        .optimize = optimize,
    });
    link(b, lib);
    b.installArtifact(lib);
}

pub fn link(b: *std.Build, step: *std.build.CompileStep) void {
    const librlottie_dep = b.dependency("librlottie", .{
        .target = step.target,
        .optimize = step.optimize,
    });
    step.linkLibrary(librlottie_dep.artifact("rlottie"));
}
