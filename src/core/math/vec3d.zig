// src/core/math/vec3d

pub const Vec3d = struct {
    x: f64,
    y: f64,
    z: f64,

    pub const zero = Vec3d{ .x = 0, .y = 0, .z = 0 };
    pub const unit_x = Vec3d{ .x = 1, .y = 0, .z = 0 };
    pub const unit_y = Vec3d{ .x = 0, .y = 1, .z = 0 };
    pub const unit_z = Vec3d{ .x = 0, .y = 0, .z = 1 };

    pub fn init(x: f64, y: f64, z: f64) Vec3d {
        return .{ .x = x, .y = y, .z = z };
    }

    pub fn add(self: Vec3d, other: Vec3d) Vec3d {
        return .{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
        };
    }

    pub fn sub(self: Vec3d, other: Vec3d) Vec3d {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
            .z = self.z - other.z,
        };
    }

    pub fn scale(self: Vec3d, scalar: f64) Vec3d {
        return .{
            .x = self.x * scalar,
            .y = self.y * scalar,
            .z = self.z * scalar,
        };
    }

    // Produto Escalar: Mede o alinhamento (cosseno do ângulo)
    pub fn dot(self: Vec3d, other: Vec3d) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    // Produto Vetorial: Gera um vetor ortogonal (perpendicular) aos dois
    pub fn cross(self: Vec3d, other: Vec3d) Vec3d {
        return .{
            .x = self.y * other.z - self.z * other.y,
            .y = self.z * other.x - self.x * other.z,
            .z = self.x * other.y - self.y * other.x,
        };
    }

    pub fn lengthSquared(self: Vec3d) f64 {
        return self.dot(self);
    }

    pub fn length(self: Vec3d) f64 {
        return @sqrt(lengthSquared(self));
    }

    pub fn normalize(self: Vec3d) Vec3d {
        const len = self.length();
        if (len == 0) return zero;
        return self.scale(1.0 / len);
    }
};
