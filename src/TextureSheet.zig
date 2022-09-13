const std = @import("std");
const SDL = @import("modules/SDL.zig");
const sprite = @import("SpriteSheet.zig");

pub fn render(ren: SDL.Window.Renderer, img: SDL.Texture, target: SDL.Texture, sprites: []const sprite.Sprite, x: usize, y: usize) void {
    ren.setTarget(target);
    defer ren.setTarget(null);
    defer ren.present();
    ren.clear();

    for (sprites) |spr, idx| {
        const sheetRect = SDL.Rect{
            .x = @intCast(c_int, spr.x * 17),
            .y = @intCast(c_int, spr.y * 17),
            .w = 16,
            .h = 16,
        };

        const xPos = idx % x;
        const yPos = idx / x;
        _ = y;
        const targetRect = SDL.Rect{
            .x = @intCast(c_int, xPos * 16),
            .y = @intCast(c_int, yPos * 16),
            .w = 16,
            .h = 16,
        };
        ren.renderCopy(img, &sheetRect, &targetRect);
    }
}
