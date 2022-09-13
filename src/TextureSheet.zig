const std = @import("std");
const SDL = @import("modules/SDL.zig");

pub const Sprite = struct {
    sheet: usize,
    x: usize,
    y: usize,
};

pub const CompileTexture = struct {
    x: usize,
    y: usize,
    items: std.ArrayList(Sprite),
};

pub fn render(ren: SDL.Window.Renderer, img: SDL.Texture, target: SDL.Texture) void {
    ren.setTarget(target);
    defer ren.setTarget(null);
    defer ren.present();
    ren.clear();
    var x: usize = 0;
    const pos = [_]SDL.Rect{
        .{
            .x = 0 * 17,
            .y = 0 * 17,
            .w = 16,
            .h = 16,
        },
        .{
            .x = 5 * 17,
            .y = 0 * 17,
            .w = 16,
            .h = 16,
        },
        .{
            .x = 0 * 17,
            .y = 6 * 17,
            .w = 16,
            .h = 16,
        },
    };
    while (x < 64) : (x += 1) {
        var y: usize = 0;
        while (y < 64) : (y += 1) {
            const p = SDL.Rect{
                .x = 16 * @intCast(c_int, x),
                .y = 16 * @intCast(c_int, y),
                .w = 16,
                .h = 16,
            };
            const idx = switch (@truncate(u2, y)) {
                0 => @as(usize, 0),
                1 => @as(usize, 1),
                2 => @as(usize, 2),
                3 => @as(usize, 0),
            };
            ren.renderCopy(img, &pos[idx], &p);
            std.log.err("Render[{}] at [{}]", .{ pos[idx], p });
        }
    }
}

pub fn createBackground(alloc: std.mem.Allocator) CompileTexture {
    var ct = CompileTexture{
        .x = 16,
        .y = 16,
        .items = std.ArrayList(Sprite).init(alloc),
    };
    _ = ct;
    var x: usize = 0;
    while (x < 16) : (x += 1) {
        var y: usize = 0;
        while (y < 16) : (y += 1) {
            if (x == 6) {
                try ct.item.append(.{
                    .sheet = 0,
                    .x = 3,
                    .y = 1,
                });
            } else {
                try ct.item.append(.{
                    .sheet = 0,
                    .x = 5,
                    .y = 0,
                });
            }
        }
    }
}
