const std = @import("std");
const print = std.debug.print;

const Game = @import("engine.zig").Game;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    
    var game = try Game.init(allocator, "Zig Game");

    while (!game.quit) {
        game.pollEvents();
        game.update();
        game.render();
    }

    game.deinit();
}
