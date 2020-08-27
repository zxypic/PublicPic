-- dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --引入Android引擎
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

function AT_SELF(pics,txts)
	pics = pics or "77"
	txts = txts or "88"
	DebugLogId(string.format("me  [%s] ret: %s", pics,txts ))
	return pics,txts
end

Action_self={
	{"[1],[TOUCH],[B|B|B],[],[exit_S]"},
	{"[1],[AT_SELF],[CC],[AA],[npnoexcit]"},
	{"[1],[title],[Y],[EE],[out]"},
	{"[1],[title],[Y],[DD],[<excite>]"},
}

ScriptAction = {
    {"A", Action_self},
}

