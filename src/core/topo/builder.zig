// src/core/topo/builder.zig
// standard imports
const std = @import("std");

// external imports

// project imports
const Point = @import("../math/point.zig").Point;
const Vec3d = @import("../math/vec3d.zig").Vec3d;
const Topology = @import("./topology.zig");

const BRepBody = Topology.BRepBody;

pub const BRepBuilder = struct {
    pub fn extrudePolygon(
        allocator: std.mem.Allocator,
        profile: []const Point,
        extrusion_vector: Vec3d
    ) !BRepBody {
        var body = BRepBody.init(allocator);
        errdefer body.deinit();

        const n = profile.len;
        if (n < 3) return error.InvalidPolygon;

        var bottom_vertices = try allocator.alloc(Topology.VertexHandle, n);
        defer allocator.free(bottom_vertices);

        var top_vertices = try allocator.alloc(Topology.VertexHandle, n);
        defer allocator.free(top_vertices);

        for (profile, 0..) |pt, i| {
            bottom_vertices[i] = try body.addVertex(pt, 0);

            const top_pt = pt.add(extrusion_vector);
            top_vertices[i] = try body.addVertex(top_pt, 0);
        }

        return body;
    }

    pub fn createBox(allocator: std.mem.Allocator, dx: f64, dy: f64, dz: f64) !BRepBody {
        var body = BRepBody.init(allocator);
        errdefer body.deinit();

        const v0 = try body.addVertex(Point.init(0, 0, 0), 0);
        const v1 = try body.addVertex(Point.init(dx, 0, 0), 0);
        const v2 = try body.addVertex(Point.init(dx, dy, 0), 0);
        const v3 = try body.addVertex(Point.init(0, dy, 0), 0);

        const v4 = try body.addVertex(Point.init(0, 0, dz), 0);
        const v5 = try body.addVertex(Point.init(dx, 0, dz), 0);
        const v6 = try body.addVertex(Point.init(dx, dy, dz), 0);
        const v7 = try body.addVertex(Point.init(0, dy, dz), 0);

        _ = v1; _ = v2; _ = v3; _ = v4;
        _ = v5; _ = v6; _ = v7;

        try body.half_edge.append(.{
            .origin = v0,
            .twin = 12,
            .next = 1,
            .prev = 3,
            .face = 0,
        });

        return body;
    }
};
