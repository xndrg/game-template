const std = @import("std");
const Allocator = std.mem.Allocator;

const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub const Game = struct {
    pub const window_width  = 800;
    pub const window_height = 600;
    pub const fps           = 144;
    pub const dtime         = 1.0/fps;
    
    allocator: Allocator,
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    quit: bool,

    pub fn init(allocator: Allocator, title: [*]const u8) !Game {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
            c.SDL_Log("Could not initialize SDL: %s", c.SDL_GetError());
            return error.SDLInitError;
        }

        const window = c.SDL_CreateWindow(title, 0, 0, window_width, window_height, 0) orelse {
            c.SDL_Log("Could not create window: %s", c.SDL_GetError());
            return error.SDLInitError;
        };

        const renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) orelse {
            c.SDL_Log("Could not create renderer: %s", c.SDL_GetError());
            return error.SDLInitError;
        };
        
        return .{
            .allocator = allocator,
            .window = window,
            .renderer = renderer,
            .quit = false,
        };
    }

    pub fn pollEvents(self: *Game) void {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0){
            switch (event.type) {
                c.SDL_QUIT => {
                    self.quit = true;
                },
                else => {},
            }
        }
    }

    pub fn update(self: *Game) void {
        _ = self;
    }

    pub fn render(self: *Game) void {
        _ = c.SDL_SetRenderDrawColor(self.renderer, 0x18, 0x18, 0x18, 0xFF);
        _ = c.SDL_RenderClear(self.renderer);

        c.SDL_RenderPresent(self.renderer);
        c.SDL_Delay(1000/fps);
    }

    pub fn deinit(self: *Game) void {
        c.SDL_DestroyRenderer(self.renderer);
        c.SDL_DestroyWindow(self.window);
        c.SDL_Quit();
    }
};
