const lottie = @import("library.zig");

pub extern fn lottie_animation_from_file(path: [*c]const u8) ?*lottie.Animation;
pub extern fn lottie_animation_from_data(data: [*c]const u8, key: [*c]const u8, resource_path: [*c]const u8) ?*lottie.Animation;
pub extern fn lottie_animation_destroy(animation: ?*lottie.Animation) void;
pub extern fn lottie_animation_get_size(animation: ?*const lottie.Animation, width: [*c]usize, height: [*c]usize) void;
pub extern fn lottie_animation_get_duration(animation: ?*const lottie.Animation) f64;
pub extern fn lottie_animation_get_totalframe(animation: ?*const lottie.Animation) usize;
pub extern fn lottie_animation_get_framerate(animation: ?*const lottie.Animation) f64;
pub extern fn lottie_animation_render_tree(animation: ?*lottie.Animation, frame_num: usize, width: usize, height: usize) [*c]const lottie.LayerNode;
pub extern fn lottie_animation_get_frame_at_pos(animation: ?*const lottie.Animation, pos: f32) usize;
pub extern fn lottie_animation_render(animation: ?*lottie.Animation, frame_num: usize, buffer: [*c]u32, width: usize, height: usize, bytes_per_line: usize) void;
pub extern fn lottie_animation_render_async(animation: ?*lottie.Animation, frame_num: usize, buffer: [*c]u32, width: usize, height: usize, bytes_per_line: usize) void;
pub extern fn lottie_animation_render_flush(animation: ?*lottie.Animation) [*c]u32;
pub extern fn lottie_animation_property_override(animation: ?*lottie.Animation, @"type": lottie.AnimationProperty, keypath: [*c]const u8, ...) void;
