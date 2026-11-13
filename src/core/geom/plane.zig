// src/core/geom/plane.zig
// standard imports

// external imports

// project imports
const Point = @import("../math/point.zig").Point;
const Vec3d = @import("../math/vec3d.zig").Vec3d;

pub const Plane = struct {
    point: Point,
    normal: Vec3d,

    pub fn init(point: Point, normal: Vec3d) Plane {
        return .{
            .point = point,
            .normal = normal,
        };
    }

    // Retorna a distancia assinada de um ponto ao plano
    // (> 0 se estiver do lado normal, < 0 se estiver no oposto, 0 se estiver no plano)
    pub fn signedDistance(self: Plane, pt: Point) f64 {
        const v = pt.sub(self.point);
        return v.dot(self.normal);
    }
};
