

login_version = "v1.0.2"

function SPLOG(pics,txts)
	pics = pics or "77"
	txts = txts or "88"
	print(string.format("me  [%s] ret: %s", pics,txts ))
	return pics,txts
end

action_B = {
	{"[1],[TOUCH],[B,0.5,5],[],[<logins_B>]"},	  
	{"[1],[SLEEP],[3],[],[]"},	  
	{"[1],[TOUCH],[home,0,2],[],[<login-6>]"},	  
}

ScriptAction = {
    {"A", action_B},
}

