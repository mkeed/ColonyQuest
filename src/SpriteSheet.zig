const std = @import("std");

pub const Sprite = struct {
    x: usize,
    y: usize,
    sheet: usize,
};

pub const TileSheet = struct {
    data: []const u8,
    numX: usize,
    numY: usize,
    sizeX: usize,
    sizeY: usize,
    paddingX: usize,
    paddingY: usize,
};

pub const SpriteSheet = union(enum) {
    tileSheet: TileSheet,
};

pub const sheets = [_]TileSheet{
    .{
        .data = @embedFile("../assets/roguelikeSheet_transparent.png"),
        .numX = 57,
        .numY = 31,
        .sizeX = 16,
        .sizeY = 16,
        .paddingX = 1,
        .paddingY = 1,
    },
};
