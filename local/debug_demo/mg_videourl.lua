dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --����Android����
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Edition = "1.0.5"
Businesses = "ZXY"
DScreen = nil	


Action_Exp = {
	{"[1],[TOUCH],[B,0.5,5],[],[<�쳣ָ��5>]"},	  
	{"[1],[SLEEP],[3],[],[]"},	  
	{"[1],[TOUCH],[home,0,2],[],[<�쳣ָ��6>]"},	  
}


Action_txPlay = {
	{"[1],[TOUCH],[text='��Ѷ��Ƶ'],[text='��ҳ'|text='���Ӿ�'],[<�򿪿ͻ���#T>]"},	  
	{"[1],[TOUCH],[text='���Ӿ�'],[],[������Ӿ�]"},
	{"[1],[MGDUMP],[{regex:'.ts?'}],[],[����tcpdump�л�ȡurl����]"},
	{"[1],[TOUCH],[500,500],[],[��㿴����]"},	  
	{"[1],[MGDUMP],[],[{client:'tx',name:'txds',type:'ts',resolution:'1080'},400],[����tcpdump�л�ȡurlֵ���ϴ�]"},
	{"[1],[TOUCH],[B|B|B],[],[�˳�ȷ��]"},
}
Action_mgPlay = {
	{"[1],[TOUCH],[text='�乾��Ƶ'],[text='�ȵ�'|text='���Ӿ�'],[<�򿪿ͻ���#T>]"},	  
	{"[1],[TOUCH],[text='���Ӿ�'],[],[������Ӿ�]"},
	{"[1],[click],[id='com.cmcc.cmvideo:id/searchIv'],[],[�������]"},
	{"[1],[input],[СŮ������],[],[����]"},
	{"[1],[click],[id='com.cmcc.cmvideo:id/contentTv' text='СŮ������'],[],[����������]"},
	{"[1],[MGDUMP],[{regex:'.m3u8'}],[],[����tcpdump�л�ȡurl����]"},

	{"[1],[MGDUMP],[{regex:'.m3u8',extra:''}],[],[����tcpdump�л�ȡurl����]"},

	{"[1],[TOUCH],[id='com.cmcc.cmvideo:id/firstBtn' text='1'],[],[�������]"},	  
	{"[1],[MGDUMP],[],[{client:'mg',name:'mgds',type:'m3u8',resolution:'1080'},80],[����tcpdump�л�ȡurlֵ���ϴ�]"},
	{"[1],[TOUCH],[B|B|B],[],[�˳�ȷ��]"},
}
ScriptAction = {
	{"A", Action_txPlay},  
	{"B", Action_mgPlay},  
}

