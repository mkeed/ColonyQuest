const lua = @cImport({
    @cInclude("lua.h");
    @cInclude("lualib.h");
    @cInclude("lauxlib.h");
});
const std = @import("std");
pub const LUAVM = struct {
    state: *lua.lua_State,
    pub fn init(loadLibs: bool) !LUAVM {
        const L = lua.luaL_newstate();
        if (L == null) {
            return error.FailedToInit;
        }
        if (loadLibs) {
            lua.luaL_openlibs(L);
        }
        return LUAVM{
            .state = L.?,
        };
    }
    pub fn loadScript(self: LUAVM, script: [*c]const u8, len: usize) void {
        _ = lua.luaL_loadbufferx(self.state, script, len, "test", null);
    }
    pub fn addTable(self: LUAVM, comptime T: type, name: [*c]const u8, vals: []const T) void {
        lua.lua_newtable(self.state);
        for (vals) |val, idx| {
            lua.lua_pushnumber(self.state, @intToFloat(f64, idx));
            lua.lua_pushnumber(self.state, val);
            lua.lua_rawset(self.state, -3);
        }
        lua.lua_setglobal(self.state, name);
    }
    pub fn run(self: LUAVM) void {
        const res = lua.lua_pcallk(self.state, 0, lua.LUA_MULTRET, 0, 0, null);
        if (res != 0) {
            std.log.err("failed to run", .{});
        }
        const sum = lua.lua_tonumberx(self.state, -1, null);
        std.log.info("sum:[{}]", .{sum});
    }
    pub fn deinit(self: LUAVM) void {
        lua.lua_close(self.state);
    }
};
