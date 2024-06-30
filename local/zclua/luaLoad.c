//定义一个可供lua调用的模块

#include        "./src/lua.h"
#include        "./src/lualib.h"
#include        "./src/lauxlib.h"

static int add(lua_State *L) {
    double d1 = luaL_checknumber(L, 1);  
    double d2 = luaL_checknumber(L, 2);  
    lua_pushnumber(L, d1+d2);  
    return 1;  
}

int luaopen_luaLoad(lua_State *L) {
    luaL_Reg luaLoadFun[] = {
        {"add",add},
        {NULL,NULL}
    };
    luaL_newlib(L,luaLoadFun);
    return 1;
}