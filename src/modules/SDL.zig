const SDL2 = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
    @cInclude("SDL2/SDL_syswm.h");
});

const std = @import("std");

//pub const SDL = struct {};
pub const InitFlags = struct {
    timer: bool = false,
    audio: bool = false,
    video: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    gamecontroller: bool = false,
    events: bool = false,

    pub fn toInt(self: InitFlags) u32 {
        var val: u32 = 0;
        if (self.timer) {
            val |= SDL2.SDL_INIT_TIMER;
        }
        if (self.audio) {
            val |= SDL2.SDL_INIT_AUDIO;
        }
        if (self.video) {
            val |= SDL2.SDL_INIT_VIDEO;
        }
        if (self.joystick) {
            val |= SDL2.SDL_INIT_JOYSTICK;
        }
        if (self.haptic) {
            val |= SDL2.SDL_INIT_HAPTIC;
        }
        if (self.gamecontroller) {
            val |= SDL2.SDL_INIT_GAMECONTROLLER;
        }
        if (self.events) {
            val |= SDL2.SDL_INIT_EVENTS;
        }
        return val;
    }
    pub const everything = InitFlags{
        .timer = true,
        .audio = true,
        .video = true,
        .joystick = true,
        .haptic = true,
        .gamecontroller = true,
        .events = true,
    };
};

pub fn init(flags: InitFlags) !void {
    const val = SDL2.SDL_Init(flags.toInt());
    if (val != 0) {
        std.log.err("Failed to Init: {s}", .{SDL2.SDL_GetError()});
        return error.FailedToInit;
    }
}

pub const CreateFlags = struct {
    fullscreen: bool = false,
    fullscreen_desktop: bool = false,
    opengl: bool = false,
    vulkan: bool = false,
    metal: bool = false,
    hidden: bool = false,
    borderless: bool = false,
    minimized: bool = false,
    maximized: bool = false,
    input_grabbed: bool = false,
    allow_highdpi: bool = false,

    pub fn toInt(self: CreateFlags) u32 {
        var val: u32 = 0;
        if (self.fullscreen) {
            val |= SDL2.SDL_WINDOW_FULLSCREEN;
        }
        if (self.fullscreen_desktop) {
            val |= SDL2.SDL_WINDOW_FULLSCREEN_DESKTOP;
        }
        if (self.opengl) {
            val |= SDL2.SDL_WINDOW_OPENGL;
        }
        if (self.vulkan) {
            val |= SDL2.SDL_WINDOW_VULKAN;
        }
        if (self.metal) {
            val |= SDL2.SDL_WINDOW_METAL;
        }
        if (self.hidden) {
            val |= SDL2.SDL_WINDOW_HIDDEN;
        }
        if (self.borderless) {
            val |= SDL2.SDL_WINDOW_BORDERLESS;
        }
        if (self.minimized) {
            val |= SDL2.SDL_WINDOW_MINIMIZED;
        }
        if (self.maximized) {
            val |= SDL2.SDL_WINDOW_MAXIMIZED;
        }
        if (self.input_grabbed) {
            val |= SDL2.SDL_WINDOW_INPUT_GRABBED;
        }
        if (self.allow_highdpi) {
            val |= SDL2.SDL_WINDOW_ALLOW_HIGHDPI;
        }
        return val;
    }
};

pub const Rect = SDL2.SDL_Rect;

pub const Window = struct {
    pub const Renderer = struct {
        renderer: ?*SDL2.SDL_Renderer,
        pub fn deinit(self: Renderer) void {
            SDL2.SDL_DestroyRenderer(self.renderer);
        }
        pub fn clear(self: Renderer) void {
            _ = SDL2.SDL_RenderClear(self.renderer);
        }
        pub fn renderCopy(self: Renderer, tex: Texture, src: ?*const Rect, dest: ?*const Rect) void {
            _ = SDL2.SDL_RenderCopy(self.renderer, tex.texture, src, dest);
        }
        pub fn present(self: Renderer) void {
            SDL2.SDL_RenderPresent(self.renderer);
        }
        pub fn createTarget(self: Renderer, targetSize: Position) Texture {
            var tex = SDL2.SDL_CreateTexture(self.renderer, SDL2.SDL_PIXELFORMAT_RGBA8888, SDL2.SDL_TEXTUREACCESS_TARGET, targetSize.x, targetSize.y);
            return Texture{
                .texture = tex,
            };
        }
        pub fn setTarget(self: Renderer, tex: ?Texture) void {
            if (tex) |t| {
                _ = SDL2.SDL_SetRenderTarget(self.renderer, t.texture);
            } else {
                _ = SDL2.SDL_SetRenderTarget(self.renderer, null);
            }
        }
    };
    window: ?*SDL2.SDL_Window,

    pub fn createRenderer(self: *Window) !Renderer {
        const ren = SDL2.SDL_CreateRenderer(self.window, -1, SDL2.SDL_RENDERER_ACCELERATED | SDL2.SDL_RENDERER_PRESENTVSYNC);
        if (ren == null) {
            std.log.err("Failed to create renderer:[{s}]", .{SDL2.SDL_GetError()});
        }
        return Renderer{
            .renderer = ren,
        };
    }
    pub fn size(self: Window) Position {
        var pos = Position{ .x = 0, .y = 0 };
        SDL2.SDL_GetWindowSize(self.window, &pos.x, &pos.y);
        return pos;
    }

    pub fn deinit(self: Window) void {
        SDL2.SDL_DestroyWindow(self.window);
    }
};
pub fn createWindow(
    name: [*c]const u8,
    xPos: ?c_int,
    yPos: ?c_int,
    xSize: c_int,
    ySize: c_int,
    flags: CreateFlags,
) !Window {
    const res = SDL2.SDL_CreateWindow(
        name,
        if (xPos) |xp| xp else SDL2.SDL_WINDOWPOS_UNDEFINED,
        if (yPos) |yp| yp else SDL2.SDL_WINDOWPOS_UNDEFINED,
        xSize,
        ySize,
        flags.toInt(),
    );
    if (res == null) {
        std.log.err("Unable to Create Window:[{s}]", .{SDL2.SDL_GetError()});
        return error.FailedToInit;
    }
    var info: SDL2.SDL_SysWMinfo = undefined;
    _ = SDL2.SDL_GetWindowWMInfo(res, &info);
    std.log.err("Info:[{}]", .{info});
    return Window{
        .window = res,
    };
}
pub const Texture = struct {
    texture: ?*SDL2.SDL_Texture,
    pub fn deinit(self: Texture) void {
        SDL2.SDL_DestroyTexture(self.texture);
    }
};
pub const Surface = struct {
    surface: ?*SDL2.SDL_Surface,
    pub fn deinit(self: Surface) void {
        SDL2.SDL_FreeSurface(self.surface);
    }
    pub fn CreateTexture(self: Surface, ren: Window.Renderer) !Texture {
        var tex = SDL2.SDL_CreateTextureFromSurface(ren.renderer, self.surface);
        if (tex == null) {
            std.log.err("Unable to create texture:[{s}]", .{SDL2.SDL_GetError()});
            return error.FailedToInitTexture;
        }
        return Texture{
            .texture = tex,
        };
    }
};

pub fn createSurfaceFromMem(data: []const u8) Surface {
    var rw = SDL2.SDL_RWFromConstMem(data.ptr, @intCast(c_int, data.len));
    var image = SDL2.IMG_Load_RW(rw, 1);

    return Surface{
        .surface = image,
    };
}

pub fn quit() void {
    SDL2.SDL_Quit();
}

pub fn Delay(time_ms: u32) void {
    //std.log.info("Delay", .{});
    SDL2.SDL_Delay(time_ms);
}

pub const Position = struct {
    x: c_int,
    y: c_int,
};

pub const Event = union(enum) {
    quit: usize,
    mouseMotion: Position,
    windowResized: void,
};

var eventCount: usize = 0;
pub fn pollEvent() ?Event {
    //std.log.info("poll", .{});
    var event: SDL2.SDL_Event = undefined;
    if (SDL2.SDL_PollEvent(&event) == 0) {
        return null;
    }
    defer eventCount +%= 1;
    switch (event.type) {
        SDL2.SDL_AUDIODEVICEADDED => {
            std.log.err("SDL_AUDIODEVICEADDED", .{});
        },
        SDL2.SDL_AUDIODEVICEREMOVED => {
            std.log.err("SDL_AUDIODEVICEREMOVED", .{});
        },
        SDL2.SDL_CONTROLLERAXISMOTION => {
            std.log.err("SDL_CONTROLLERAXISMOTION", .{});
        },
        SDL2.SDL_CONTROLLERBUTTONDOWN => {
            std.log.err("SDL_CONTROLLERBUTTONDOWN", .{});
        },
        SDL2.SDL_CONTROLLERBUTTONUP => {
            std.log.err("SDL_CONTROLLERBUTTONUP", .{});
        },
        SDL2.SDL_CONTROLLERDEVICEADDED => {
            std.log.err("SDL_CONTROLLERDEVICEADDED", .{});
        },
        SDL2.SDL_CONTROLLERDEVICEREMOVED => {
            std.log.err("SDL_CONTROLLERDEVICEREMOVED", .{});
        },
        SDL2.SDL_CONTROLLERDEVICEREMAPPED => {
            std.log.err("SDL_CONTROLLERDEVICEREMAPPED", .{});
        },
        SDL2.SDL_DOLLARGESTURE => {
            std.log.err("SDL_DOLLARGESTURE", .{});
        },
        SDL2.SDL_DOLLARRECORD => {
            std.log.err("SDL_DOLLARRECORD", .{});
        },
        SDL2.SDL_DROPFILE => {
            std.log.err("SDL_DROPFILE", .{});
        },
        SDL2.SDL_DROPTEXT => {
            std.log.err("SDL_DROPTEXT", .{});
        },
        SDL2.SDL_DROPBEGIN => {
            std.log.err("SDL_DROPBEGIN", .{});
        },
        SDL2.SDL_DROPCOMPLETE => {
            std.log.err("SDL_DROPCOMPLETE", .{});
        },
        SDL2.SDL_FINGERMOTION => {
            std.log.err("SDL_FINGERMOTION", .{});
        },
        SDL2.SDL_FINGERDOWN => {
            std.log.err("SDL_FINGERDOWN", .{});
        },
        SDL2.SDL_FINGERUP => {
            std.log.err("SDL_FINGERUP", .{});
        },
        SDL2.SDL_KEYDOWN => {
            std.log.err("SDL_KEYDOWN", .{});
        },
        SDL2.SDL_KEYUP => {
            std.log.err("SDL_KEYUP", .{});
        },
        SDL2.SDL_JOYAXISMOTION => {
            std.log.err("SDL_JOYAXISMOTION", .{});
        },
        SDL2.SDL_JOYBALLMOTION => {
            std.log.err("SDL_JOYBALLMOTION", .{});
        },
        SDL2.SDL_JOYHATMOTION => {
            std.log.err("SDL_JOYHATMOTION", .{});
        },
        SDL2.SDL_JOYBUTTONDOWN => {
            std.log.err("SDL_JOYBUTTONDOWN", .{});
        },
        SDL2.SDL_JOYBUTTONUP => {
            std.log.err("SDL_JOYBUTTONUP", .{});
        },
        SDL2.SDL_JOYDEVICEADDED => {
            std.log.err("SDL_JOYDEVICEADDED", .{});
        },
        SDL2.SDL_JOYDEVICEREMOVED => {
            std.log.err("SDL_JOYDEVICEREMOVED", .{});
        },
        SDL2.SDL_MOUSEMOTION => {
            //std.log.err("SDL_MOUSEMOTION:[{}]", .{event.motion});
            return Event{
                .mouseMotion = .{
                    .x = event.motion.x,
                    .y = event.motion.y,
                },
            };
        },
        SDL2.SDL_MOUSEBUTTONDOWN => {
            std.log.err("SDL_MOUSEBUTTONDOWN", .{});
        },
        SDL2.SDL_MOUSEBUTTONUP => {
            std.log.err("SDL_MOUSEBUTTONUP", .{});
        },
        SDL2.SDL_MOUSEWHEEL => {
            std.log.err("SDL_MOUSEWHEEL", .{});
        },
        SDL2.SDL_MULTIGESTURE => {
            std.log.err("SDL_MULTIGESTURE", .{});
        },
        SDL2.SDL_QUIT => {
            return Event{ .quit = event.quit.timestamp };
        },
        SDL2.SDL_SYSWMEVENT => {
            std.log.err("SDL_SYSWMEVENT", .{});
        },
        SDL2.SDL_TEXTEDITING => {
            std.log.err("SDL_TEXTEDITING", .{});
        },
        SDL2.SDL_TEXTINPUT => {
            std.log.err("SDL_TEXTINPUT", .{});
        },
        SDL2.SDL_USEREVENT => {
            std.log.err("SDL_USEREVENT", .{});
        },
        SDL2.SDL_WINDOWEVENT => {
            const wev = event.window;
            std.log.err("window :[{}]", .{wev});
            switch (wev.event) {
                SDL2.SDL_WINDOWEVENT_NONE => {
                    std.log.err("WINDOWEVENT_NONE", .{});
                },
                SDL2.SDL_WINDOWEVENT_SHOWN => {
                    std.log.err("WINDOWEVENT_SHOWN", .{});
                },
                SDL2.SDL_WINDOWEVENT_HIDDEN => {
                    std.log.err("WINDOWEVENT_HIDDEN", .{});
                },
                SDL2.SDL_WINDOWEVENT_EXPOSED => {
                    std.log.err("WINDOWEVENT_EXPOSED", .{});
                },
                SDL2.SDL_WINDOWEVENT_MOVED => {
                    std.log.err("WINDOWEVENT_MOVED", .{});
                },
                SDL2.SDL_WINDOWEVENT_RESIZED => {
                    std.log.err("WINDOWEVENT_RESIZED", .{});
                    return Event.windowResized;
                },
                SDL2.SDL_WINDOWEVENT_SIZE_CHANGED => {
                    std.log.err("WINDOWEVENT_SIZE_CHANGED", .{});
                },
                SDL2.SDL_WINDOWEVENT_MINIMIZED => {
                    std.log.err("WINDOWEVENT_MINIMIZED", .{});
                },
                SDL2.SDL_WINDOWEVENT_MAXIMIZED => {
                    std.log.err("WINDOWEVENT_MAXIMIZED", .{});
                },
                SDL2.SDL_WINDOWEVENT_RESTORED => {
                    std.log.err("WINDOWEVENT_RESTORED", .{});
                },
                SDL2.SDL_WINDOWEVENT_ENTER => {
                    std.log.err("WINDOWEVENT_ENTER", .{});
                },
                SDL2.SDL_WINDOWEVENT_LEAVE => {
                    std.log.err("WINDOWEVENT_LEAVE", .{});
                },
                SDL2.SDL_WINDOWEVENT_FOCUS_GAINED => {
                    std.log.err("WINDOWEVENT_FOCUS_GAINED", .{});
                },
                SDL2.SDL_WINDOWEVENT_FOCUS_LOST => {
                    std.log.err("WINDOWEVENT_FOCUS_LOST", .{});
                },
                SDL2.SDL_WINDOWEVENT_CLOSE => {
                    std.log.err("WINDOWEVENT_CLOSE", .{});
                },
                SDL2.SDL_WINDOWEVENT_TAKE_FOCUS => {
                    std.log.err("WINDOWEVENT_TAKE_FOCUS", .{});
                },
                SDL2.SDL_WINDOWEVENT_HIT_TEST => {
                    std.log.err("WINDOWEVENT_HIT_TEST", .{});
                },
                else => {
                    std.log.err("Unknown event[{}]", .{wev.type});
                },
            }
            //return Event{
            //.window =
            //};

        },
        else => {
            std.log.err("SDL undefined event:[{}]", .{event.type});
        },
    }
    return null;
}

// pub fn main() !u8 {

//     // Initialize SDL2
//     if (SDL2.SDL_Init(sdl2.SDL_INIT_EVERYTHING) != 0) {
//         print("SDL_Init Error: {s}\n", .{sdl2.SDL_GetError()});
//         return 1;
//     }
//     defer sdl2.SDL_Quit();

//     // Create a SDL_Window
//     var win: ?*sdl2.SDL_Window = sdl2.SDL_CreateWindow("Hello World!", 100, 100, 620, 387, sdl2.SDL_WINDOW_SHOWN);
//     if (win == null) {
//         print("SDL_CreateWindow Error: {s}\n", .{sdl2.SDL_GetError()});
//         return 1;
//     }
//     defer sdl2.SDL_DestroyWindow(win);

//     // Create a SDL_Renderer
//     var ren: ?*sdl2.SDL_Renderer = sdl2.SDL_CreateRenderer(win, -1, sdl2.SDL_RENDERER_ACCELERATED | sdl2.SDL_RENDERER_PRESENTVSYNC);
//     if (ren == null) {
//         print("SDL_CreateRenderer Error: {s}\n", .{sdl2.SDL_GetError()});
//         return 1;
//     }
//     defer sdl2.SDL_DestroyRenderer(ren);

//     // Load the image as an SDL_Surface
//     var bmp: ?*sdl2.SDL_Surface = sdl2.SDL_LoadBMP("../img/grumpy-cat.bmp");
//     if (bmp == null) {
//         print("SDL_LoadBMP Error: {s}\n", .{sdl2.SDL_GetError()});
//         return 1;
//     }
//     defer sdl2.SDL_FreeSurface(bmp);

//     // Create a SDL_Texture from the SDL_Surface
//     var tex: ?*sdl2.SDL_Texture = sdl2.SDL_CreateTextureFromSurface(ren, bmp);
//     if (tex == null) {
//         print("SDL_CreateTextureFromSurface Error: {s}\n", .{sdl2.SDL_GetError()});
//         return 1;
//     }
//     defer sdl2.SDL_DestroyTexture(tex);

//     // Render the SDL_Texture to the SDL_Window, repeatedly
//     var i: usize = 0;
//     while (i < 20) : (i += 1) {
//         _ = sdl2.SDL_RenderClear(ren);
//         _ = sdl2.SDL_RenderCopy(ren, tex, null, null);
//         sdl2.SDL_RenderPresent(ren);
//         sdl2.SDL_Delay(100);
//     }

//     return 0;
// }
