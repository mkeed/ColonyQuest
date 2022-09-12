const SDL2 = @cImport({
    @cInclude("SDL.h");
});

pub fn init() void {
    _ = SDL2.SDL_Init(SDL2.SDL_INIT_VIDEO);
}
