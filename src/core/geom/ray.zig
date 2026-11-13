// src/core/geom/ray.zig
// standard imports

// external imports

// project imports
const Point = @import("../math/point.zig").Point;
const Vec3d = @import("../math/vec3d.zig").Vec3d;

pub const Ray = struct {
    origin: Point,
    direction: Vec3d,

    pub fn init(origin: Point, direction: Vec3d) Ray {
        return .{
            .origin = origin,
            .direction = direction.normalize(),
        };
    }

    pub fn pointAt(self: Ray, t: f64) Point {
        return self.origin.add(self.direction.scale(t));
    }
};
