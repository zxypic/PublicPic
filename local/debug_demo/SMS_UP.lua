dofile("/data/local/tmp/c/engine/BasicEngine.lua")

Edition="1.0.x"
Businesses="深圳ZXY"


SMS_UP={

-- {"[1]","[MONITOR],[][]","[飞信登录成功率]"},
{"[1],[*RECVSMS_SIG_UP],[],[10086-码,300],[<上传验证码成功率>]"},
-- {"[1],[*RECVSMS_SIG],[],[10086123-动态密码,300],[<接收验证码成功率>]"},

}

ScriptAction={
{"1",SMS_UP},
}


DebugFlag="Android|2|1|1|INPHONE|200|"