const std = @import("std");

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

pub fn createBackground(alloc: std.mem.Allocator) CompileTexture {
    var ct = compileTexture{
        .x = 16,
        .y = 16,
        .items = std.ArrayList(Sprite).init(alloc),
    };
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
