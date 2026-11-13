// src/core/topo/topology.zig
// standard imports
const std = @import("std");

// external imports

// project imports
const Point = @import("../math/point.zig").Point;

// Handles
pub const VertexHandle = u32;
pub const HalfEdgeHandle = u32;
pub const FaceHandle = u32;

pub const Vertex = struct {
    point: Point,
    // Aponta para um half-edge que começa neste vertice
    outgoing_edge: HalfEdgeHandle,
};

pub const HalfEdge = struct {
    origin: VertexHandle,
    // A meia-aresta gemea na face vizinha (direçao oposta)
    twin: HalfEdgeHandle,
    // A proxima meia-aresta contornando a mesma face
    next: HalfEdgeHandle,
    // A meia-aresta anterior na mesma face
    prev: HalfEdgeHandle,
    // A face a qual está meia-aresta pertence
    face: FaceHandle,
};

pub const Face = struct {
    // Aponta para qualquer uma das half-edges que compõe o contorno desta face
    outer_edge: HalfEdgeHandle,
};

pub const BRepBody = struct {
    allocator: std.mem.Allocator,
    vertices: std.ArrayList(Vertex),
    half_edge: std.ArrayList(HalfEdge),
    faces: std.ArrayList(Face),

    pub fn init(allocator: std.mem.Allocator) BRepBody {
        return .{
            .allocator = allocator,
            .vertices = std.ArrayList(Vertex).init(allocator),
            .half_edge = std.ArrayList(HalfEdge).init(allocator),
            .faces = std.ArrayList(Face).init(allocator),
        };
    }

    pub fn deinit(self: *BRepBody) void {
        self.vertices.deinit();
        self.half_edge.deinit();
        self.faces.deinit();
    }

    pub fn addVertex(self: *BRepBody, point: Point, outgoing_edge: HalfEdgeHandle) !VertexHandle {
        const id = @as(VertexHandle, @intCast(self.vertices.items.len));
        try self.vertices.append(.{
            .point = point,
            .outgoing_edge = outgoing_edge,
        });
        return id;
    }

    pub fn addFace(self: *BRepBody, outer_edge: HalfEdgeHandle) !FaceHandle {
        const id = @as(FaceHandle, @intCast(self.faces.items.len));
        try self.faces.append(.{
            .outer_edge = outer_edge,
        });
        return id;
    }
};
