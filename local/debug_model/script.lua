
dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --引入Android引擎
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Edition = "1.0.6"
Businesses = "爱奇艺视频测试"
DScreen = nil
APP_PacketName = "com.uusense.speed"


-- require_script("login") 

prams={
    ["user"]="刘德华",
    ["login"]="12345",
}

require_model("login",prams)  
require_model("user",prams)  


ScriptAction = {
    {"A", action_login1},
    {"B", action_login2},
}

