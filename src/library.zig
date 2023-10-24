pub const common = @import("common.zig");
pub const c = @import("c.zig");

const LayerNode = common.LayerNode;

pub const AnimationProperty = enum(c_uint) {
    /// Color property of Fill object, value type is `f32` [0 ... 1]
    Fillcolor,
    /// Opacity property of Fill object, value type is `f32` [ 0 .. 100]
    Fillopacity,
    /// Color property of Stroke object, value type is `f32` [0 ... 1]
    Strokecolor,
    /// Opacity property of Stroke object, value type is `f32` [ 0 .. 100]
    Strokeopacity,
    /// stroke with property of Stroke object, value type is `f32`
    Strokewidth,
    /// Transform Anchor property of Layer and Group object, value type is
    /// `c_int`
    TrAnchor,
    /// Transform Position property of Layer and Group object, value type is
    /// `c_int`
    TrPosition,
    /// Transform Scale property of Layer and Group object, value type is `f32`
    /// range[0 ..100]
    TrScale,
    /// Transform Scale property of Layer and Group object, value type is
    /// `f32`. range[0 .. 360] in degrees
    TrRotation,
    /// Transform Opacity property of Layer and Group object, value type is
    /// `f32` [ 0 .. 100]
    TrOpacity,
};

pub const Animation = opaque {
    /// Constructs an animation object from file path.
    ///
    /// **Parameters**
    /// - `path`: Lottie resource file path
    ///
    /// **Returns**
    ///
    /// animation object that can build the contents of the Lottie resource
    /// represented by file path. Destroy with `lottie.Animation.destroy()`.
    pub fn fromFile(path: [:0]const u8) !*Animation {
        return c.lottie_animation_from_file(path) orelse error.NullPointer;
    }

    /// Constructs an animation object from JSON string data.
    ///
    /// **Parameters**
    /// - `data`: the JSON string data.
    /// - `key`: the string that will be used to cache the JSON string data.
    /// - `resource_path`: the path that will be used to load external resource
    /// needed by the JSON data.
    ///
    /// **Returns**
    ///
    /// animation object that can build the contents of the Lottie resource
    /// represented by JSON string data. Destroy with
    /// `lottie.Animation.destroy()`.
    pub fn fromData(data: [:0]const u8, key: [:0]const u8, resource_path: [:0]const u8) !*Animation {
        return c.lottie_animation_from_data(data, key, resource_path) orelse error.NullPointer;
    }

    /// Free given `lottie.Animation` object resource.
    pub fn destroy(self: *Animation) void {
        c.lottie_animation_destroy(self);
    }

    /// Returns default viewport size of the Lottie resource as tuple
    /// `{width, height}`.
    pub fn getSize(self: *const Animation) struct { usize, usize } {
        var width: usize, var height: usize = .{ 0, 0 };
        c.lottie_animation_get_size(self, &width, &height);
        return .{ width, height };
    }

    /// Returns total animation duration of Lottie resource in second. It uses
    /// `totalFrame()` and `frameRate()` to calculate the duration.
    /// ```
    /// duration = totalFrame() / frameRate()
    /// ```
    /// See `lottie.Animation.getTotalframe()` and
    /// `lottie.Animation.getFramerate()`.
    ///
    /// **Returns**
    ///
    /// total animation duration in second. `0` if the Lottie resource has no
    /// animation.
    pub fn getDuration(self: *const Animation) f64 {
        return c.lottie_animation_get_duration(self);
    }

    /// Returns total number of frames present in the Lottie resource.
    ///
    /// **NOTE**: frame number starts with 0.
    ///
    /// See `lottie.Animation.getDuration()` and
    /// `lottie.Animation.getFramerate()`.
    pub fn getTotalframe(self: *const Animation) usize {
        return c.lottie_animation_get_totalframe(self);
    }

    /// Returns default framerate of the Lottie resource.
    pub fn getFramerate(self: *const Animation) f64 {
        return c.lottie_animation_get_framerate(self);
    }

    /// Get the render tree which contains the snapshot of the animation object
    /// at frame = `frame_num`, the content of the animation in that frame
    /// number.
    ///
    /// **Parameters**
    /// - `frame_num`: content corresponds to the `frame_num` needs to be
    /// drawn.
    /// - `width`: requested snapshot viewport width.
    /// - `height`: requested snapshot viewport height.
    ///
    /// **Returns**
    ///
    /// animation snapshot tree.
    ///
    /// **NOTE**: user has to traverse the tree for rendering.
    pub fn renderTree(self: *Animation, frame_num: usize, width: usize, height: usize) [*c]const LayerNode {
        return c.lottie_animation_render_tree(self, frame_num, width, height);
    }

    /// Maps position to frame number and returns it.
    ///
    /// **Parameters**
    /// - `pos`: position in the range [ 0.0 .. 1.0 ].
    ///
    /// **Returns**
    ///
    /// mapped frame numbe in the range [ start_frame .. end_frame ]. `0` if
    /// the Lottie resource has no animation.
    pub fn getFrameAtPos(self: *const Animation, pos: f32) usize {
        return c.lottie_animation_get_frame_at_pos(self, pos);
    }

    /// Request to render the content of the frame `frame_num` to buffer
    /// `buffer`.
    ///
    /// **Parameters**
    /// - `frame_num`: the frame number needs to be rendered.
    /// - `buffer`: surface buffer use for rendering.
    /// - `width`: width of the surface
    /// - `height`: height of the surface
    /// - `bytes_per_line`: stride of the surface in bytes.
    pub fn render(self: *Animation, frame_num: usize, buffer: []u32, width: usize, height: usize, bytes_per_line: usize) void {
        c.lottie_animation_render(self, frame_num, buffer.ptr, width, height, bytes_per_line);
    }

    /// Request to render the content of the frame `frame_num` to buffer
    /// `buffer` asynchronously.
    ///
    /// **Parameters**
    /// - `frame_num`: the frame number needs to be rendered.
    /// - `buffer`: surface buffer use for rendering.
    /// - `width`: width of the surface
    /// - `height`: height of the surface
    /// - `bytes_per_line`: stride of the surface in bytes.
    ///
    /// **NOTE**: user must call `lottie.Animation.renderFlush()` to make sure
    /// render is finished.
    pub fn renderAsync(self: *Animation, frame_num: usize, buffer: []u32, width: usize, height: usize, bytes_per_line: usize) void {
        c.lottie_animation_render_async(self, frame_num, buffer.ptr, width, height, bytes_per_line);
    }

    /// Request to finish the current async renderer job for this animation
    /// object. If render is finished then this call returns immidiately. If
    /// not, it waits till render job finish and then return.
    ///
    /// **WARNING**: user must call `lottie.Animation.renderAsync()` and
    /// `lottie.Animation.renderFlush()` in pair to get the benefit of async
    /// rendering.
    ///
    /// **Returns**
    ///
    /// the pixel buffer it finished rendering.
    pub fn renderFlush(self: *Animation) ![*]u32 {
        return c.lottie_animation_render_flush(self) orelse error.NullPointer;
    }

    /// Request to change the properties of this animation object. Keypath
    /// should conatin object names separated by (.) and can handle globe(**)
    /// or wildchar(*).
    ///
    /// To change fillcolor property of fill1 object in the
    /// layer1->group1->fill1 hirarchy to RED color
    /// ```
    /// animation.propertyOverride(.Fillcolor, "layer1.group1.fill1", .{@as(f32, 1), @as(f32, 0), @as(f32, 0)});
    /// ```
    /// if all the color property inside group1 needs to be changed to GREEN color
    /// ```
    /// animation.propertyOverride(.Fillcolor, "**.group1.**", .{@as(f32, 1), @as(f32, 0), @as(f32, 0)});
    /// ```
    /// **Parameters**
    /// - `type`: property type.
    /// - `keypath`: specific content of target.
    /// - `values`: property values.
    pub fn propertyOverride(self: *Animation, @"type": AnimationProperty, keypath: [:0]const u8, values: anytype) void {
        @call(.auto, c.lottie_animation_property_override, .{ self, @"type", keypath } ++ values ++ .{@as(c_int, 0)});
    }
};
