CC ?= gcc  
CFLAGS = -g -O2 -Wall -I$(LUA_INC)  
SHARED := -fPIC --shared  
TARGET = myLualib.so  
LUA_CLIB_PATH = clib  
# 引入lua头文件  
LUA_INC ?= /works/git_auto/engine3.0/local/zclua/src  
start: $(TARGET)  
$(TARGET) : mylib.c | $(LUA_CLIB_PATH)  
    $(CC) $(CFLAGS) $(SHARED) $^ -o $@  
clean:  
    rm -fr $(TARGET)  
$(LUA_CLIB_PATH) :  
    mkdir $(LUA_CLIB_PATH)  