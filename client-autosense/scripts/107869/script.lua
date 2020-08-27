require("LuaClient")


--获取带后缀文件名  
function getFileName(filename)  
    if string.find(filename,":") then  
        return string.match(filename, ".+\\([^\\]*%.%w+)")
    else  
        return string.match(filename, ".+/([^/]*%.%w+)$")  
    end  
end  

--传入要上传后台的文件绝对路径
function uploadFile(filePath)
	if _file_exists(filePath) then
		local filename = getFileName(filePath)
		copy(filePath, string.format("%s\\%s", G_resultDirLog, filename))	
	else
		printLog("准备上传的文件不存在: " .. filePath)	
	end
end

function runTest()
	----------------------------------------------------------------------
	printLog("业务测试执行动作开始-----")
	printLog("do something")
	--执行业务测试， 执行结果可先保存文件中， 执行结束后通过lua读取结果，然后上传到后台， 也可以直接通过uploadFile函数将结果上传到后台
	os.execute("python D:\\workspacecpp\\PyTest\\autosense\\pc.py")
	printLog("业务测试执行动作结束-----")
	--任务执行结果，注意下面table中key值不能修改
	local retTestTable = {
		--[[ 测试结果类型vtype可选的值：
			1=成功率(%)		2=速率(KB/s)		3=时长(s)		4=次数			5=时间(s)	6=方差			
			7=页面大小(KB)	8=时长(ms)		9=页面大小(B)		10=带宽大小(MB)	11=信号强度(dbm)
			12=频段(HZ)		13=频点			20 =数值			21=自定义(20字符)
	    --]]
		vtype = "4",			--测试结果类型， 可修改，
		ret = "00",				--测试结果，00:成功     03:业务失败， 可修改
		values = 5,				--结果值， 可修改
		title = "PC启动",		--结果名称， 可修改
		stime = startTime,		--开始时间， 不用修改
	}
	---可以修改结果
	retTestTable.values = "30"
	retTestTable.ret = "00"
	local tmpstr = toContentResult(retTestTable, retTestTable.title) -- 拼接结果字符串
	_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", tmpstr), "a+")    --写结果
	
	--使用uploadFile函数可以上传任何文件到后台
	uploadFile("D:\\uusense\\script_result\\206658_74_1\\功耗优化——10月8日.docx")
	uploadFile("D:\\uusense\\script_result\\206658_74_1\\自检测试.xlsx")
end


function uusenseMain(ParmSysParms)  --入口
	startTime = os.date("%Y%m%d%H%M%S")
	ParmSysParms = ParmSysParms ~= "PC|" and ParmSysParms or "PC|1|51738|5|200|auto"
	dofile("mode/func/bscOpm.lua")
	dofile("mode/func/bscFun.lua")
	
	--G_resultDirLog 日志文件目录，里面所有文件都会自动上传到后台 ，可以将所有需要上传的文件都写入到此文件夹  C:\AutoSensePC\W9A13G31    W9A13G31\Result\147852_37_1\FILE\
	--客户端日志路径：D:\uusense\log
	--[2019/10/09 21:01:08 测试日志] ParmSysParms:PC|206500|66|1|107867|	
	--[2019/10/09 21:01:08 测试日志] G_resultDir：C:\AutoSensePC\W9A13G31    W9A13G31\Result\206500_66_1	
	--[2019/10/09 21:01:08 测试日志] G_resultDirLog：C:\AutoSensePC\W9A13G31    W9A13G31\Result\206500_66_1\FILE\	
	--[2019/10/09 21:01:08 测试日志] G_debugDir：D:\uusense\script_result\206500_66_1	
	--[2019/10/09 21:01:08 测试日志] pathresult：D:\uusense	
	--[2019/10/09 21:01:08 测试日志] scriptDir：C:\AutoSensePC\W9A13G31    W9A13G31	
	--[2019/10/09 21:01:08 测试日志] scriptPath：C:\AutoSensePC\W9A13G31    W9A13G31\script\common\107867		
	G_ArguMentList, G_Id, G_resultDir, G_resultDirLog, G_debugDir,G_devicesId,scriptDir,pathresult = doSysPramPC(ParmSysParms)	--参数及目录初始化
	scriptPath = scriptDir .. "\\script\\common\\" .. G_ArguMentList[5]
	
	--printLog("scriptPath＝==" .. scriptPath .. "\\util.lua")
	--dofile(scriptPath .. "\\util.lua") -- 可加载自定义的lua文件，和脚本一起打包
	
	Businesses = "测试业务名称"	--测试业务名称，自行修改
	local ValueStr = toHeaderResult(G_ArguMentList)
	_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", ValueStr), "a+") --写结果头文件， 固定格式，不要改
	
	local status , msg = pcall(runTest) -- 执行上面定义的方法，并捕获异常
	if status then
		--脚本正常执行结束
		printLog("脚本正常执行结束")
	else
		printLog("脚本出错：" .. msg)
		local retTestTable = {
			vtype = "21",			
			ret = "01",				
			values = msg,			
			title = "脚本出错",		
			stime = startTime,		
		}
		local tmpstr = toContentResult(retTestTable, retTestTable.title)
		_writeLog(string.format("%s\\result.txt", G_debugDir), string.format("%s\n", tmpstr), "a+")    --写结果指标
	end
	doSysResult()  --复制结果文件夹至上传目录
	return 0
end


