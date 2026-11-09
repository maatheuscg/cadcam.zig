// src/core/math/point
const Vec3d = @import("vec3d.zig").Vec3d;

pub const Point = struct {
    x: f64,
    y: f64,
    z: f64,

    pub const origin = Point{ .x = 0, .y = 0, .z = 0 };

    pub fn init(x: f64, y: f64, z: f64) Point {
        return .{ .x = x, .y = y, .z = z };
    }

    pub fn add(self: Point, vec: Vec3d) Point {
        return .{
            .x = self.x + vec.x,
            .y = self.y + vec.y,
            .z = self.z + vec.z,
        };
    }

    pub fn sub(self: Point, other: Point) Vec3d {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
            .z = self.z - other.z,
        };
    }

    pub fn distanceSquared(self: Point, other: Point) f64 {
        const dx = self.x - other.x;
        const dy = self.y - other.y;
        const dz = self.z - other.z;

        return dx * dx + dy * dy + dz * dz;
    }

    pub fn distance(self: Point, other: Point) f64 {
        return @sqrt(self.distanceSquared(other));
    }
};
