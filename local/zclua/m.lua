-- 文件名为 m.lua
-- 定义一个名为 m 的模块
module = {}
 
-- 定义一个常量
module.constant = "这是一个常量"
module.table = {key1="val1","val2"}
 
-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end
 
local function func2()
    print("这是一个私有函数！")
end

 
function module.func3()
    func2()
end

module.func4 = func2;

module.func5 = function()
    print("func5!!!")
end
 
return module