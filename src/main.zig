const std = @import("std");
const lua = @import("modules/lua.zig");
pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    var lvm = try lua.LUAVM.init(true);
    defer lvm.deinit();
    const script =
        \\-- script.lua
        \\-- Receives a table, returns the sum of its components.
        \\io.write("The table the script received has:\n");
        \\x = 0
        \\for i = 1, #foo do
        \\print(i, foo[i])
        \\x = x + foo[i]
        \\end
        \\io.write("Returning data back to C\n");
        \\return x
    ;
    lvm.loadScript(script, script.len);
    lvm.addTable(f64, "foo", &.{ 1, 2, 3, 4, 5 });

    lvm.run();
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
