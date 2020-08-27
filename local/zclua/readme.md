#### 编译设置
// gcc -o hello add.c -llua

#### .o 编译

// gcc -c -o hello.o add.c -llua

#### .so 文件
gcc luaLoad.c -fPIC -shared -o luaLoad.so -I /usr/local/lua53/src/lua-5.3.5/src
-I 后面是lua的安装路径，里面包含了上面include的那几个头文件

-DLUA_USE_DLOPEN
gcc -c sumc.cpp ; gcc -O2 -bundle -undefined dynamic_lookup -o sumc.so sumc.o 
gcc -c main.cpp ; gcc -O2 -bundle -undefined dynamic_lookup -o mylualib.so main.o 
gcc -c luaload.c ; gcc -O2 -bundle -undefined dynamic_lookup -o luaload.so luaload.o 
gcc -c luaload.c ; gcc -O2 -bundle -DLUA_USE_DLOPEN -undefined dynamic_lookup -o luaload.so luaload.o 


#### 参考链接

https://blog.csdn.net/themagickeyjianan/article/details/78506979

编译选项 https://www.cnblogs.com/cdyboke/p/7750015.html