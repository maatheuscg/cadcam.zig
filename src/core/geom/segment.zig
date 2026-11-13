// src/core/geom/segment.zig
// standard imports

// external imports

// project imports
const Point = @import("../math/point.zig").Point;
const Vec3d = @import("../math/vec3d.zig").Vec3d;

pub const Segment = struct {
    start: Point,
    end: Point,

    pub fn init(start: Point, end: Point) Segment {
        return .{
            .start = start,
            .end = end,
        };
    }

    pub fn vector(self: Segment) Vec3d {
        return self.end.sub(self.start);
    }

    pub fn length(self: Segment) f64 {
        return self.vector().length();
    }

    // Interpolaçao Linear: t varia de (x) para (x + t)
    pub fn pointAt(self: Segment, t: f64) Point {
        const v = self.vector().scale(t);
        return self.start.add(v);
    }
};
