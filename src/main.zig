const std = @import("std");
const sprite = @import("SpriteSheet.zig");
const ts = @import("TextureSheet.zig");
const map = @import("Map.zig");
//const lua = @import("modules/lua.zig");
const spriteSheet = @import("SpriteSheet.zig");
const sdl = @import("modules/SDL.zig");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    try sdl.init(sdl.InitFlags.everything);
    defer sdl.quit();
    var window = try sdl.createWindow("Game", null, null, 1920, 1080, .{ .opengl = true, .resizable = true });
    defer window.deinit();
    var ren = try window.createRenderer();
    defer ren.deinit();

    var target = ren.createTarget(.{ .x = 16 * 64, .y = 16 * 64 });
    defer target.deinit();

    var img = sdl.createSurfaceFromMem(@embedFile("img.png"));
    defer img.deinit();

    var tex = try img.CreateTexture(ren);
    defer tex.deinit();

    var spriteImg = sdl.createSurfaceFromMem(sprite.sheets[0].data);
    defer spriteImg.deinit();

    var spriteTex = try spriteImg.CreateTexture(ren);
    defer spriteTex.deinit();

    var items = try map.m.generate(alloc);
    defer items.deinit();
    ts.render(ren, spriteTex, target, items.items, 50, 50);

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
    var windowSize = sdl.Rect{
        .x = 0,
        .y = 0,
        .w = 0,
        .h = 0,
    };
    {
        const p = window.size();
        windowSize.w = p.x;
        windowSize.h = p.y;
    }
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
                .windowResized => {
                    const p = window.size();
                    windowSize.w = p.x;
                    windowSize.h = p.y;
                },
            }
        }
        ren.clear();
        ren.renderCopy(
            target,
            null,
            &windowSize,
        );
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
