const std = @import("std");
//const lua = @import("modules/lua.zig");
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
    while (true) {
        ren.clear();
        ren.renderCopy(tex, null, null);
        ren.present();
        sdl.Delay(100);
        while (sdl.pollEvent()) |ev| {
            switch (ev) {
                .quit => {
                    return;
                },
            }
        }
    }
}
