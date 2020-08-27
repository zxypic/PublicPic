#include "./src/lua.h"
#include "./src/lualib.h"
#include "./src/lauxlib.h"
#include <stdio.h>

static int log(lua_State *L){
    int num = luaL_checkinteger(L, 1);
    printf("log num :%d", num);
    return 0;
}

static int logEx(lua_State *L){
  size_t len = 0;
  const char* str = lua_checkstring(L, 1, &len);
  print("logEx %s %d", str, len);
  return 0
}

int luaopen_mylib(lua_State *L){
  luaL_Reg = libs[] = {
    {"log", log},
    {"logEx", log},
    {nullptr, nullptr}
  }
  luaL_newlib(L, 1);
  return 1;
}