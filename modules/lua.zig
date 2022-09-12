pub const files = [_][]const u8{
    "modules/lua-5.4.4/src/lapi.c",
    "modules/lua-5.4.4/src/lcode.c",
    "modules/lua-5.4.4/src/lctype.c",
    "modules/lua-5.4.4/src/ldebug.c",
    "modules/lua-5.4.4/src/ldo.c",
    "modules/lua-5.4.4/src/ldump.c",
    "modules/lua-5.4.4/src/lfunc.c",
    "modules/lua-5.4.4/src/lgc.c",
    "modules/lua-5.4.4/src/llex.c",
    "modules/lua-5.4.4/src/lmem.c",
    "modules/lua-5.4.4/src/lobject.c",
    "modules/lua-5.4.4/src/lopcodes.c",
    "modules/lua-5.4.4/src/lparser.c",
    "modules/lua-5.4.4/src/lstate.c",
    "modules/lua-5.4.4/src/lstring.c",
    "modules/lua-5.4.4/src/ltable.c",
    "modules/lua-5.4.4/src/ltm.c",
    "modules/lua-5.4.4/src/lundump.c",
    "modules/lua-5.4.4/src/lvm.c",
    "modules/lua-5.4.4/src/lzio.c",
    "modules/lua-5.4.4/src/lauxlib.c",
    "modules/lua-5.4.4/src/lbaselib.c",
    "modules/lua-5.4.4/src/lcorolib.c",
    "modules/lua-5.4.4/src/ldblib.c",
    "modules/lua-5.4.4/src/liolib.c",
    "modules/lua-5.4.4/src/lmathlib.c",
    "modules/lua-5.4.4/src/loadlib.c",
    "modules/lua-5.4.4/src/loslib.c",
    "modules/lua-5.4.4/src/lstrlib.c",
    "modules/lua-5.4.4/src/ltablib.c",
    "modules/lua-5.4.4/src/lutf8lib.c",
    "modules/lua-5.4.4/src/linit.c",
};

pub const flags = [_][]const u8{
    "-DLUA_COMPAT_5_3",
};

pub const searchDirs = [_][]const u8{
    "modules/lua-5.4.4/src",
};
