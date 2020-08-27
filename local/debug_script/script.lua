dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --引入Android引擎
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Edition = "1.0.6"
Businesses = "爱奇艺视频测试"
DScreen = nil
APP_PacketName = "com.uusense.speed"
G_mgKVENURL = "http://10.124.2.27:18289/udcc/decodeAppSDKData.html"
G_UIAutoClick = nil
-- Clientversion="9.3.0"
SwitchCity = "1000|7550|2100" --北京|深圳|上海|杭州
SwitchTime = "||"

-- 有多个返回时， 需要单独处理 ，目前只有一个返回值是正常的
local srcpath = debug.getinfo(1).short_src:match("^.*/")
require_script("at_login")
-- action_a,action_b = require_script("login.lua",srcpath)
require_script("user.lua",srcpath)
require_script("process")

Action_Exp = {
    {"[1],[TOUCH],[B,0.5,5],[],[<异常指标5>]"},
    {"[1],[SLEEP],[3],[],[]"},
    {"[1],[TOUCH],[home,0,2],[],[<异常指标6>]"}
}

Action_input = {
    {"[1],[input],[zhengc],[],[正常输入_M]"}
}

ScriptAction = {
    {"A", action_A},
    {"B", action_B},
    
    -- {"O", Action_login},
    -- {"U", Action_user},
    {"P", Action_process},
    {"J", Action_ject},
    {"Z", Action_input}
    
}
DebugFlag = "Android|3|1|1|INPHONE|200|"
