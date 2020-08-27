#include        <stdio.h>
#include        <string.h>
#include        "./src/lua.h"
#include        "./src/lualib.h"
#include        "./src/lauxlib.h"

lua_State* L;
int
luaadd(int x, int y)
{
    int sum;
    /*函数名*/
    lua_getglobal(L,"add");
    /*参数入栈*/
    lua_pushnumber(L, x);
    /*参数入栈*/
    lua_pushnumber(L, y);
    /*开始调用函数，有2个参数，1个返回值*/
    lua_call(L, 2, 1);
    /*取出返回值*/
    sum = (int)lua_tonumber(L, -1);
    /*清除返回值的栈*/
    lua_pop(L,1);
    return sum;
}


static int l_SayHello(lua_State *L)
{
    const char *d = luaL_checkstring(L, 1);//获取参数，字符串类型
    int len = strlen(d);
    char str[100] = "hello ";
    strcat(str, d);
    lua_pushstring(L, str);  /* 返回给lua的值压栈 */
    return 1;
}

int
main(int argc, char *argv[])
{
    int sum;
    L = luaL_newstate();  /* 创建lua状态机 */
    luaL_openlibs(L);   /* 打开Lua状态机中所有Lua标准库 */
    lua_register(L, "SayHello", l_SayHello);//注册C函数到lua

    const char* testfunc = "print(SayHello('lijia'))";//lua中调用c函数
    if(luaL_dostring(L, testfunc))    // 执行Lua命令。
        printf("Failed to invoke.\n");

    /*加载lua脚本*/
    luaL_dofile(L, "add.lua");
    /*调用C函数，这个里面会调用lua函数*/
    sum = luaadd(99, 10);
    printf("The sum is %d \n",sum);

    /*清除Lua*/
    lua_close(L);
    return 0;
}


// gcc -o hello add.c -llua