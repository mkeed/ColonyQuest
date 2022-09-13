const std = @import("std");
const sprite = @import("SpriteSheet.zig");
//const lua = @import("modules/lua.zig");
const spriteSheet = @import("SpriteSheet.zig");
const sdl = @import("modules/SDL.zig");
pub fn main() !void {
    try sdl.init(sdl.InitFlags.everything);
    defer sdl.quit();
    var window = try sdl.createWindow("Game", null, null, 640, 480, .{ .opengl = true });
    defer window.deinit();
    var ren = try window.createRenderer();
    defer ren.deinit();

    var img = sdl.createSurfaceFromMem(@embedFile("img.png"));
    defer img.deinit();

    var tex = try img.CreateTexture(ren);
    defer tex.deinit();

    var spriteImg = sdl.createSurfaceFromMem(sprite.sheets[0].data);
    defer spriteImg.deinit();

    var spriteTex = try spriteImg.CreateTexture(ren);
    defer spriteTex.deinit();

    var spritePos = sdl.Rect{
        .x = 13 * 17,
        .y = 10 * 17,
        .w = 16,
        .h = 16,
    };
    var drawPos = sdl.Rect{
        .x = 0,
        .y = 0,
        .w = 32,
        .h = 32,
    };
    var targetPos = sdl.Position{
        .x = 100,
        .y = 100,
    };
    ren.present();
    while (true) {
        if (sdl.pollEvent()) |ev| {
            switch (ev) {
                .quit => {
                    return;
                },
                .mouseMotion => |m| {
                    targetPos = m;
                },
            }
        }
        ren.clear();
        ren.renderCopy(tex, null, null);
        if (drawPos.x > targetPos.x) {
            drawPos.x -= 1;
        }
        if (drawPos.x < targetPos.x) {
            drawPos.x += 1;
        }
        if (drawPos.y > targetPos.y) {
            drawPos.y -= 1;
        }
        if (drawPos.y < targetPos.y) {
            drawPos.y += 1;
        }
        ren.renderCopy(spriteTex, &spritePos, &drawPos);
        ren.present();
        sdl.Delay(10);
    }
}
