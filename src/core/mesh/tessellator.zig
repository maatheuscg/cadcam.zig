// src/core/mesh/tessellator.zig
// standard imports
const std = @import("std");

// external imports

// project imports
const Point = @import("../math/point.zig").Point;
const Topology = @import("../topo/topology.zig");

// Representa um malha de triangulos para GPU
pub const TriangleMesh = struct {
    allocator: std.mem.Allocator,
    vertices: std.ArrayList(f64),
    indices: std.ArrayList(u64),

    pub fn init(allocator: std.mem.Allocator) TriangleMesh {
        return .{
            .allocator = allocator,
            .vertices = std.ArrayList(f64).init(allocator),
            .indices = std.ArrayList(u64).init(allocator),
        };
    }

    pub fn deinit(self: *TriangleMesh) void {
        self.vertices.deinit();
        self.indices.deinit();
    }
};

pub const Tessellator = struct {
    pub fn tessellatorBody(body: *const Topology.BRepBody, allocator: std.mem.Allocator) !TriangleMesh {
        var mesh = TriangleMesh.init(allocator);
        errdefer mesh.deinit();

        for (body.faces.items, 0..) |_, face_idx| {
            const face_handle = @as(Topology.FaceHandle, @intCast(face_idx));
            const face = body.faces.items[face_handle];

            var face_points = std.ArrayList(Point).init(allocator);
            defer face_points.deinit();

            const start_he = face.outer_edge;
            var current_he = start_he;

            while (true) {
                const he = body.half_edge.items[current_he];
                const vertex = body.vertices.items[he.origin];
                try face_points.append(vertex.point);

                current_he = he.next;
                if (current_he == start_he) break;
            }

            if (face_points.items.len < 3) continue;

            const base_vertex_idx = @as(u32, @intCast(mesh.vertices.items.len / 3));

            for (face_points.items) |pt| {
                try mesh.vertices.append(@floatCast(pt.x));
                try mesh.vertices.append(@floatCast(pt.y));
                try mesh.vertices.append(@floatCast(pt.z));
            }

            const num_pts = @as(u32, @intCast(face_points.items.len));

            var i: u32 = 1;
            while (i < num_pts - 1) : (i += 1) {
                try.mesh.append(base_vertex_idx);
                try.mesh.append(base_vertex_idx + i);
                try mesh.append(base_vertex_idx + i + 1);
            }
        }

        return mesh;
    }
};