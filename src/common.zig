pub const BrushType = enum(c_uint) {
    Solid = 0,
    Gradient,
};

pub const FillRule = enum(c_uint) {
    EvenOdd = 0,
    Winding,
};

pub const JoinStyle = enum(c_uint) {
    Miter = 0,
    Bevel,
    Round,
};

pub const CapStyle = enum(c_uint) {
    Flat = 0,
    Square,
    Round,
};

pub const GradientType = enum(c_uint) {
    Linear = 0,
    Radial,
};

pub const GradientStop = extern struct {
    pos: f32,
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

pub const MaskType = enum(c_uint) {
    Add = 0,
    Substract,
    Intersect,
    Difference,
};

pub const Mask = struct {
    mPath: extern struct {
        ptPtr: [*c]const f32,
        ptCount: usize,
        elmPtr: [*c]const u8,
        elmCount: usize,
    },
    mMode: MaskType,
    mAlpha: u8,
};

pub const MatteType = enum(c_uint) {
    None = 0,
    Alpha,
    AlphaInv,
    Luma,
    LumaInv,
};

pub const Node = extern struct {
    pub const ChangeFlagNone = 0x0000;
    pub const ChangeFlagPath = 0x0001;
    pub const ChangeFlagPaint = 0x0010;
    pub const ChangeFlagAll = (ChangeFlagPath & ChangeFlagPaint);

    mPath: extern struct {
        ptPtr: [*c]const f32,
        ptCount: usize,
        elmPtr: [*c]const u8,
        elmCount: usize,
    },

    mColor: extern struct { r: u8, g: u8, b: u8, a: u8 },

    mStroke: extern struct {
        enable: u8,
        width: f32,
        cap: CapStyle,
        join: JoinStyle,
        miterLimit: f32,
        dashArray: [*c]f32,
        dashArraySize: c_int,
    },

    mGradient: extern struct {
        type: GradientType,
        stopPtr: [*c]GradientStop,
        stopCount: usize,
        start: extern struct { x: f32, y: f32 },
        end: extern struct { x: f32, y: f32 },
        center: extern struct { x: f32, y: f32 },
        focal: extern struct { x: f32, y: f32 },
        cradius: f32,
        fradius: f32,
    },

    mImageInfo: extern struct {
        data: [*c]u8,
        width: usize,
        height: usize,
        mMatrix: extern struct {
            m11: f32,
            m12: f32,
            m13: f32,
            m21: f32,
            m22: f32,
            m23: f32,
            m31: f32,
            m32: f32,
            m33: f32,
        },
    },

    mFlag: c_int,
    mBrushType: BrushType,
    mFillRule: FillRule,
};

pub const LayerNode = extern struct {
    mMaskList: extern struct {
        ptr: [*c]Mask,
        size: usize,
    },

    mClipPath: extern struct {
        ptPtr: [*c]const f32,
        ptCount: usize,
        elmPtr: [*c]const u8,
        elmCount: usize,
    },

    mLayerList: extern struct {
        ptr: [*c][*c]LayerNode,
        size: usize,
    },

    mNodeList: extern struct {
        ptr: [*c][*c]Node,
        size: usize,
    },

    mMatte: MatteType,
    mVisible: c_int,
    mAlpha: u8,
    keypath: [*c]const u8,
};
