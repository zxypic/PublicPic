
function UIdumpFile()	--界面
	local xpathFile	
	local duwn = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e output true -e isDumper true"
	local uiReturn = _cfunc.Command(duwn)
	if string.find(uiReturn, "longMsg") then
		_cfunc.Print("error！error！error！\n" .. string.match(uiReturn, "longMsg=(.-)\n"))
		error("UUBootstrap 服务异常！")
	else
		local Version = string.match(uiReturn, "%sUUBootstrap%s(.-)%[")
		local status = string.match(uiReturn, '"status":(%d+)')
		status = tonumber(status)
		if status == 0 then
			local Source = string.match(uiReturn, 'Dump Source At:(.-")')
			xpathFile = string.format("%s/dump.xml", string.sub(string.gsub(Source, "\\", ""), 0, - 2))
		else
			local statusLog = string.match(uiReturn, '"value":%b""')
			statusLog = string.format("Dump Source status:%s   %s", status, statusLog)
			_cfunc.Print(_cfunc.Utf8ToGbk(statusLog))
		end
	end	
	_cfunc.Print("#xpathFile")
	return xpathFile
end
function readFile(xpathFile, dmfg)	--一次性读取文件-->字符串
	local file
	while true do
		local f = assert(io.open(xpathFile, 'rb'))
		if f then
			file = f:read("*all")
			f:close()
			break
		else
			_cfunc.Sleep(100)
		end
	end
	if dmfg and #file > 10 then
		local s = string.find(file, '<node')
		local e = string.find(file, '</hierarchy>')
		file = string.sub(file, s, e - 1)
		file = string.gsub(file, "</node>", "")
		_cfunc.Print("readDumpFile : " .. #file)		
	else
		_cfunc.Print("readFile : " .. #file)
	end
	return file
end
function GetAPI_SubTime(e, s)				--时间计算函数
	local ArguMentList
	local rettime, rettimestr, retval
	local ostime, osstr, idx, tale
	retval =(e - s) / 1000
	return retval
end
function uiautomator_app(...)
	local appActivity = 'com.qq.reader/.activity.GuideActivity'
	local tmpstr = _cfunc.Command("su")
	DebugLogId(string.format('app start su:%s。', tmpstr))
	local amstart
	if tmpstr ~= "" then
		amstart = string.format("am start -n %s", appActivity)
	else
		amstart = string.format("su\n am start -n %s", appActivity)
	end
	local amcfunc = '/data/data/com.autosense/files/ser/commandd /system/bin/am'
	local tmpstr = string.format("%s %s", amcfunc, amstart)
	_cfunc.Command(amstart)
	
	local duwn = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e output true -e isDumper true"
	local uiReturn = _cfunc.Command(duwn)
	
end
function _xsplit(str, delimiter)	
	if str == nil or str == '' or delimiter == nil then
		return nil
	end
	local result = {}
	for match in(str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end
function _gmatch(str, pattern)
	local temp = {}
	for w in string.gmatch(str, pattern) do
		local ttt = string.gsub(w, "[%[%]]", "")
		table.insert(temp, ttt)
	end
	return temp
end

function file_exists(path)	
	local file = io.open(path, "rb")
	if file then file:close() file = length_of_file(path) > 1 and file or nil end
	return file ~= nil
end
function cmd_exists(cmdd)
	local vlog = _cfunc.Command(cmdd)
	_cfunc.Print("log :" .. vlog)
	vlog = string.find(vlog, 'not') and 1 or 0
	_cfunc.Print("log :" .. vlog)
	return vlog
end

function HttpClient2()
	local header, host, url, port
	_cfunc.Print("bbbbbbbbbbbbbbbbbbbbbbbbb")
	header = 'User-Agent:Mozilla/5.0(Linux;U;Android 5.1.1, GT-I9108) Mobile\r\nAccpt: */*\r\nContent-Length: 0\r\nConnection: Close\r\n\r\n'
	
	DownUrl = 'http://192.168.1.144//data/apps/201703/58bbd9fac2751338.apk'
	
	host = string.match(DownUrl, '(%d+.%d+.%d+.%d+)')
	-- host = 'dlsc.hcs.cmvideo.cn'
	-- port= "80"
	-- url = '/depository/asset/zhengshi/1000/147/138/1000147138/media/1000147138_5000485333_55.mp4?msisdn=300116_23000003-99000-2003001501&mdspid=&spid=800033&netType=0&sid=1500146601&pid=2028597139&timestamp=20170509161800&Channel_ID=0116_03000000-99000-100300010010001&ProgramID=622912990&ParentNodeID=-99&client_ip=10.200.21.77&assertID=1500146601&SecurityKey=20170509161800&encrypt=1a4c8004e7e08583c4f97bcd14fc7764'
	url = string.match(DownUrl, '%d+.%d+.%d+.%d+(.*)')
	
	local httpStr = string.format('GET %s HTTP/1.1\r\nHost: %s\r\n%s', url, host, header)
	local hosturl = port and string.format("%s:%s", host, port) or host
	_cfunc.Print("httpStr\n" .. httpStr)
	_cfunc.Print("hosturl\t" .. hosturl)
	local Doret, r2, r3, r4, r5, r6, ret, r8, r9, r10, connect, r12 = _cfunc.HttpClient2(hosturl, httpStr, 30);
	_cfunc.Print('r1 = ' .. Doret);
	_cfunc.Print('r2 = ' .. r2);
	_cfunc.Print('r3 = ' .. r3);
	_cfunc.Print('r4 = ' .. r4);
	_cfunc.Print('r5 = ' .. r5);
	_cfunc.Print('r6 = ' .. r6);
	_cfunc.Print('r7 = ' .. ret);
	_cfunc.Print('r8 = ' .. r8);
	_cfunc.Print('r9 = ' .. r9);
	_cfunc.Print('r10 = ' .. r10);
	_cfunc.Print('r11 = ' .. connect);
	_cfunc.Print('r12 = ' .. r12);
	if ret > 0 then
		local DLName = os.date("%Y%m%d%H%M%S")
		local lfile = io.open(DLName .. ".apk", "a")
		lfile:write(connect)
		lfile:close()
		_cfunc.Print("HTTP下载app成功: " .. DLName)
	else
		local elog = {"开始", "Dns", "连接", "发送", "首包", "下载", "完成"}
		log = 'HTPP-->' .. elog[Doret + 1]
		_cfunc.Print("HTTP下载app失败:" .. log)
	end
	-- if string.find(url,"//") then
	-- 	k=string.find(url,"//")
	-- 	url=string.sub(url,k+2,-1)
	-- end
	-- local i=string.find(url,"/")
	-- if i then
	-- 	HUrl=string.sub(url,1,i-1)
	-- 	DUrl=string.format("GET /%s HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n",string.sub(url,i+1,-1),string.sub(url,1,i-1))
	-- else
	-- 	HUrl=url
	-- 	DUrl=string.format("GET / HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n",url)
	-- end
	-- _cfunc.Print("本次测试网址:"..url)
end
local UI_AutoClickOpen = function()	
	-- uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e output true 
	local shell = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap " --开启自动点击
	local backRun = '/data/data/com.autosense/files/ser/commandd /system/bin/uiautomator'
	local tmpstr = string.format("%s %s", backRun, shell)
	_cfunc.Command(tmpstr)
	_cfunc.Print("App AutoClick opend ")
end
local getpid = function()
	local tmpstr = string.format("ps|grep uiauto")
	local pids = _cfunc.Command(tmpstr)
	_cfunc.Print("uiautomator pid： " .. pids)
end
local install_app = function(pkgpath)
	local tmpstr = string.format("pm install %s", pkgpath)
	local log = _cfunc.Command(tmpstr)
	return log
end
local am_monitor = function()
	local amcfunc = '/data/data/com.autosense/files/ser/commandd /system/bin/am'
	local tmpstr = string.format("%s am monitor > %s/activity.txt", amcfunc, G_SysDbgPath)
	_cfunc.Print("app activity monitor：" .. tmpstr)
	_cfunc.Command(tmpstr)
end


function pidGrepPS( pkgname,sclock )	--检查进程
	local tmpstr  = string.format("ps|grep %s$",pkgname)
	local ret,pid = -1,-1
	local starttime
	_cfunc.Print("Monitor permission box on the interface")
	while true do
		local pids = _cfunc.Command(tmpstr)	--通过pid检查是否启动完成
		if string.find(pids," %d+") then 
			ret = 0 
			pid = string.match(pids," %d+")
			_cfunc.Print("app start pids :"..pids..pid)
		end
		if ret == 0 then break end
	end			
	return ret,pid,starttime
end


function uusenseMain(ParmSysParms)  --0910
	_cfunc.Print("bbbbbbbbbbbbbbbbbbbbbbbbbbbb")
	_cfunc.Print(package.path)
	_cfunc.Print(package.cpath)
	_cfunc.Print("bbbbbbbbbbbbbbbbbbbbbbbbbbbb")
	local sucmd = "su -c '/data/local/tmp/tcpdump -i any -vvv tcp[20:2]=0x4745 or tcp[20:2]=0x504f >> /sdcard/test_dump.txt &'"
	-- local sucmd = "su -c '/data/local/tmp/c/program/commandd /data/local/tmp/tcpdump -i any -vvv tcp[20:2]=0x4745 or tcp[20:2]=0x504f >> /data/local/tmp/test_dump.txt &'"
	-- _cfunc.Print(sucmd)
	-- _cfunc.Command(sucmd,20)
	-- _cfunc.Print("eeeeeeeeeeeeeeeeeeeeeeeeeeee")
	-- _cfunc.Sleep(5*1000)
	-- _cfunc.Print("eeeeeeeeeeeeeeeeeeeeeeeeeeee 9aa5acb01a77e9a8a219b3843fedec19")
	-- local tcpdps = _cfunc.Command("ps|grep tcpdump")
	-- _cfunc.Print(tcpdps)

	-- local files = io.open("/sdcard/test_dump.txt", "rb")
	-- local fdata = files:read("*all")
	-- files:close()
	-- _cfunc.Print(fdata)
	-- _cfunc.Sleep(500)
	-- img = "/data/local/tmp/c/186_248_315_383_Android_hui1.bmp"
	-- _cfunc.CaptureRectangle(img)
	-- local tcpdps = _cfunc.Command("ps|grep tcpdump")
	-- _cfunc.Print(tcpdps)
	-- _cfunc.Print(" 9aa5acb01a77e9a8a219b3843fedec19")
	-- local killsu = string.format("su -c 'kill %s'", tcpdps:match('%d+'))
	-- _cfunc.Print(killsu)
	-- _cfunc.Command(killsu)
	-- local tcpdps = _cfunc.Command("ps|grep tcpdump")
	-- _cfunc.Print(tcpdps)
	-- local zipname = "/data/local/tmp/c/1560415648.zip"
	-- local zuhestr = "/data/local/tmp/c/model/at_login"
	-- local zipret=_cfunc.Unzip(zipname,zuhestr)
	-- _cfunc.Print(zipret)
	local net = _cfunc.DevNetType()
	local netype = {"2G","3G","WIFI","4G","LAN","5G"}
	netype = netype[tonumber(net)] or "UNKNOWN"
	_cfunc.Print("netype : "..netype)
	
	return 0
end

