dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --引入Android引擎
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Edition = "1.0.5"
Businesses = "ZXY"
DScreen = nil	

Action_Exp = {
	{"[1],[TOUCH],[B,0.5,5],[],[<异常指标5>]"},	  
	{"[1],[SLEEP],[3],[],[]"},	  
	{"[1],[TOUCH],[home,0,2],[],[<异常指标6>]"},	  
}
Action_mgPlay = {
	{"[1],[TOUCH],[text='腾讯视频'],[text='首页'|text='电视剧'],[<打开客户端#T>]"},	  
	{"[1],[TOUCH],[text='电视剧'],[],[进入电视剧]"},
	{"[1],[SLEEP],[5],[],[]"},	  
	{"[1],[TOUCH],[500,500],[],[随便看电视]"},	  
	{"[1],[MGDUMP],[{regex:'.ts?'}],[{client:'mg',name:'腾讯电视',type:'ts',resolution:'1080'},80],[从tcpdump中获取url值并上传]"},
	{"[1],[TOUCH],[B|B|B],[],[退出确认]"},
}

Action_title = {
	{"[1],[TOUCH],[B|B|B],[],[<退出确认>]"},
}

ScriptAction = {
	{"A", Action_mgPlay},  
}


DebugFlag="Android|3|1|1|INPHONE|200|"

