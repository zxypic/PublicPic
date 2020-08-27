
login_version = "v1.0.2"

function SPLOG(pics,txts)
	pics = pics or "77"
	txts = txts or "88"
	DebugLogId(string.format("me  [%s] ret: %s", pics,txts ))
	return pics,txts
end

action_A = {
	{"[1],[TOUCH],[B,0.5,5],[],[<login_A>]"},	  
	{"[1],[SLEEP],[3],[],[]"},	  
	{"[1],[TOUCH],[home,0,2],[],[<异常指标6>]"},	  
}
action_B = {
	{"[1],[TOUCH],[B,0.5,5],[],[<logins_B>]"},	  
	{"[1],[SLEEP],[3],[],[]"},	  
	{"[1],[TOUCH],[home,0,2],[],[<异常指标6>]"},	  
}
