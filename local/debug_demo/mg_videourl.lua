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


Action_txPlay = {
	{"[1],[TOUCH],[text='腾讯视频'],[text='首页'|text='电视剧'],[<打开客户端#T>]"},	  
	{"[1],[TOUCH],[text='电视剧'],[],[进入电视剧]"},
	{"[1],[MGDUMP],[{regex:'.ts?'}],[],[开启tcpdump中获取url服务]"},
	{"[1],[TOUCH],[500,500],[],[随便看电视]"},	  
	{"[1],[MGDUMP],[],[{client:'tx',name:'txds',type:'ts',resolution:'1080'},400],[监听tcpdump中获取url值并上传]"},
	{"[1],[TOUCH],[B|B|B],[],[退出确认]"},
}
Action_mgPlay = {
	{"[1],[TOUCH],[text='咪咕视频'],[text='热点'|text='电视剧'],[<打开客户端#T>]"},	  
	{"[1],[TOUCH],[text='电视剧'],[],[进入电视剧]"},
	{"[1],[click],[id='com.cmcc.cmvideo:id/searchIv'],[],[点击搜索]"},
	{"[1],[input],[小女花不弃],[],[输入]"},
	{"[1],[click],[id='com.cmcc.cmvideo:id/contentTv' text='小女花不弃'],[],[点击搜索结果]"},
	{"[1],[MGDUMP],[{regex:'.m3u8'}],[],[开启tcpdump中获取url服务]"},

	{"[1],[MGDUMP],[{regex:'.m3u8',extra:''}],[],[开启tcpdump中获取url服务]"},

	{"[1],[TOUCH],[id='com.cmcc.cmvideo:id/firstBtn' text='1'],[],[点击播放]"},	  
	{"[1],[MGDUMP],[],[{client:'mg',name:'mgds',type:'m3u8',resolution:'1080'},80],[监听tcpdump中获取url值并上传]"},
	{"[1],[TOUCH],[B|B|B],[],[退出确认]"},
}
ScriptAction = {
	{"A", Action_txPlay},  
	{"B", Action_mgPlay},  
}

