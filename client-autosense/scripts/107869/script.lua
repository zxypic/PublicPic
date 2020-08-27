require("LuaClient")


--��ȡ����׺�ļ���  
function getFileName(filename)  
    if string.find(filename,":") then  
        return string.match(filename, ".+\\([^\\]*%.%w+)")
    else  
        return string.match(filename, ".+/([^/]*%.%w+)$")  
    end  
end  

--����Ҫ�ϴ���̨���ļ�����·��
function uploadFile(filePath)
	if _file_exists(filePath) then
		local filename = getFileName(filePath)
		copy(filePath, string.format("%s\\%s", G_resultDirLog, filename))	
	else
		printLog("׼���ϴ����ļ�������: " .. filePath)	
	end
end

function runTest()
	----------------------------------------------------------------------
	printLog("ҵ�����ִ�ж�����ʼ-----")
	printLog("do something")
	--ִ��ҵ����ԣ� ִ�н�����ȱ����ļ��У� ִ�н�����ͨ��lua��ȡ�����Ȼ���ϴ�����̨�� Ҳ����ֱ��ͨ��uploadFile����������ϴ�����̨
	os.execute("python D:\\workspacecpp\\PyTest\\autosense\\pc.py")
	printLog("ҵ�����ִ�ж�������-----")
	--����ִ�н����ע������table��keyֵ�����޸�
	local retTestTable = {
		--[[ ���Խ������vtype��ѡ��ֵ��
			1=�ɹ���(%)		2=����(KB/s)		3=ʱ��(s)		4=����			5=ʱ��(s)	6=����			
			7=ҳ���С(KB)	8=ʱ��(ms)		9=ҳ���С(B)		10=�����С(MB)	11=�ź�ǿ��(dbm)
			12=Ƶ��(HZ)		13=Ƶ��			20 =��ֵ			21=�Զ���(20�ַ�)
	    --]]
		vtype = "4",			--���Խ�����ͣ� ���޸ģ�
		ret = "00",				--���Խ����00:�ɹ�     03:ҵ��ʧ�ܣ� ���޸�
		values = 5,				--���ֵ�� ���޸�
		title = "PC����",		--������ƣ� ���޸�
		stime = startTime,		--��ʼʱ�䣬 �����޸�
	}
	---�����޸Ľ��
	retTestTable.values = "30"
	retTestTable.ret = "00"
	local tmpstr = toContentResult(retTestTable, retTestTable.title) -- ƴ�ӽ���ַ���
	_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", tmpstr), "a+")    --д���
	
	--ʹ��uploadFile���������ϴ��κ��ļ�����̨
	uploadFile("D:\\uusense\\script_result\\206658_74_1\\�����Ż�����10��8��.docx")
	uploadFile("D:\\uusense\\script_result\\206658_74_1\\�Լ����.xlsx")
end


function uusenseMain(ParmSysParms)  --���
	startTime = os.date("%Y%m%d%H%M%S")
	ParmSysParms = ParmSysParms ~= "PC|" and ParmSysParms or "PC|1|51738|5|200|auto"
	dofile("mode/func/bscOpm.lua")
	dofile("mode/func/bscFun.lua")
	
	--G_resultDirLog ��־�ļ�Ŀ¼�����������ļ������Զ��ϴ�����̨ �����Խ�������Ҫ�ϴ����ļ���д�뵽���ļ���  C:\AutoSensePC\W9A13G31    W9A13G31\Result\147852_37_1\FILE\
	--�ͻ�����־·����D:\uusense\log
	--[2019/10/09 21:01:08 ������־] ParmSysParms:PC|206500|66|1|107867|	
	--[2019/10/09 21:01:08 ������־] G_resultDir��C:\AutoSensePC\W9A13G31    W9A13G31\Result\206500_66_1	
	--[2019/10/09 21:01:08 ������־] G_resultDirLog��C:\AutoSensePC\W9A13G31    W9A13G31\Result\206500_66_1\FILE\	
	--[2019/10/09 21:01:08 ������־] G_debugDir��D:\uusense\script_result\206500_66_1	
	--[2019/10/09 21:01:08 ������־] pathresult��D:\uusense	
	--[2019/10/09 21:01:08 ������־] scriptDir��C:\AutoSensePC\W9A13G31    W9A13G31	
	--[2019/10/09 21:01:08 ������־] scriptPath��C:\AutoSensePC\W9A13G31    W9A13G31\script\common\107867		
	G_ArguMentList, G_Id, G_resultDir, G_resultDirLog, G_debugDir,G_devicesId,scriptDir,pathresult = doSysPramPC(ParmSysParms)	--������Ŀ¼��ʼ��
	scriptPath = scriptDir .. "\\script\\common\\" .. G_ArguMentList[5]
	
	--printLog("scriptPath��==" .. scriptPath .. "\\util.lua")
	--dofile(scriptPath .. "\\util.lua") -- �ɼ����Զ����lua�ļ����ͽű�һ����
	
	Businesses = "����ҵ������"	--����ҵ�����ƣ������޸�
	local ValueStr = toHeaderResult(G_ArguMentList)
	_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", ValueStr), "a+") --д���ͷ�ļ��� �̶���ʽ����Ҫ��
	
	local status , msg = pcall(runTest) -- ִ�����涨��ķ������������쳣
	if status then
		--�ű�����ִ�н���
		printLog("�ű�����ִ�н���")
	else
		printLog("�ű�����" .. msg)
		local retTestTable = {
			vtype = "21",			
			ret = "01",				
			values = msg,			
			title = "�ű�����",		
			stime = startTime,		
		}
		local tmpstr = toContentResult(retTestTable, retTestTable.title)
		_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", tmpstr), "a+")    --д���ָ��
	end
	doSysResult()  --���ƽ���ļ������ϴ�Ŀ¼
	return 0
end


