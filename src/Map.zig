const std = @import("std");
const sprite = @import("SpriteSheet.zig");

const Vec = struct {
    x: isize,
    y: isize,
};

const Rect = struct {
    pos: Vec,
    size: Vec,
};

const Surface = enum {
    Grass,
    Water,
    Dirt,
    Gravel,
    Sand,
};

const Section = struct {
    pos: Rect,
    surface: Surface,
};

pub fn getSprite(surface: Surface) sprite.Sprite {
    return switch (surface) {
        .Grass => .{ .x = 6, .y = 0, .sheet = 0 },
        .Water => .{ .x = 0, .y = 0, .sheet = 0 },
        .Dirt => .{ .x = 7, .y = 0, .sheet = 0 },
        .Gravel => .{ .x = 8, .y = 0, .sheet = 0 },
        .Sand => .{ .x = 9, .y = 0, .sheet = 0 },
    };
}

pub const Map = struct {
    size: Vec,
    defaultSurface: Surface,
    sections: []const Section,
    pub fn generate(self: Map, alloc: std.mem.Allocator) !std.ArrayList(sprite.Sprite) {
        var data = std.ArrayList(sprite.Sprite).init(alloc);
        errdefer data.deinit();
        try data.appendNTimes(getSprite(self.defaultSurface), @intCast(usize, self.size.x * self.size.y));
        for (self.sections) |s| {
            var x: isize = 0;
            while (x < s.pos.size.x) : (x += 1) {
                var y: isize = 0;
                while (y < s.pos.size.y) : (y += 1) {
                    const idx = @intCast(usize, (x + s.pos.pos.x) + (y + s.pos.pos.y) * self.size.x);
                    if (idx > data.items.len) return error.FuckedUpSomewhere;
                    data.items[idx] = getSprite(s.surface);
                }
            }
        }
        return data;
    }
};

pub const m = Map{
    .size = .{ .x = 50, .y = 50 },
    .defaultSurface = .Dirt,
    .sections = &.{
        .{
            .pos = .{ .pos = .{ .x = 0, .y = 0 }, .size = .{ .x = 4, .y = 4 } },
            .surface = .Water,
        },
        .{
            .pos = .{ .pos = .{ .x = 15, .y = 15 }, .size = .{ .x = 4, .y = 4 } },
            .surface = .Grass,
        },
    },
};
