function _gmatch(str, pattern)
	local temp = {}
	for w in string.gmatch(str, pattern) do
		local ttt = string.gsub(w, "[%[%]]", "")
		table.insert(temp, ttt)
	end
	return temp
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
function InTable(str, tab)
	local i = 1
	local retval = nil
	while i <= table.getn(tab) do
		if tab[i] == str then
			retval = i
			break
		end
		i = i + 1
	end
	return retval
end
function writeLog(filename, filevalue, wtype)
	local valuefile
	valuefile = io.open(filename, wtype);
	valuefile:write(filevalue);
	valuefile:close();
end
function Device_CreateDir(Dir)
	local cret
	if EngineMode == "symbian" then
		cret = createdir(Dir)
	elseif EngineMode == "ios" then
		cret = CreateDir(Dir)
	else
		cret = _cfunc.CreateDir(Dir)
	end
	return cret
end;
function getAPIMobileNum()   --手机号码
	local retnum = _cfunc.DevMsim()
	if not retnum or retnum == "" then
		retnum = "nil"
	end
	return retnum;
end;

-- retimei=_cfunc.DevCode()   --设备编码 手机终端用IMEI号
-- retdtype=_cfunc.DevType()  --拨测设备型号
retdtype = "test"
retimei = "65278392740128204"

local NetInfo = {'中国移动GSM', '中国联通GSM', '中国移动TD', '中国电信CDMA', '中国测试网络', '中国电信CDMA', '中国联通WCDMA', '中国移动TD-S', '中国电信FDD-LTE'}
local NetNum = {46000, 46001, 46002, 46003, 46004, 46005, 46006, 46007, 46011}
-- local NInfo = _cfunc.GetNetworkOperator()
local NInfo = 46001
local info = InTable(NInfo, NetNum)
net = NetInfo[info]
retnet = net ~= "WIFI" and "LAN" or "WIFI"
-- retip = _cfunc.GetIp() or "127.0.0.1"
retip = "127.0.0.1"


Businesses = "引擎更新"
Edition = "1.0.0"
Title = "引擎更新成功率"
Clientversion = "2"
-- arg = ArguMentList[2].."|"..ArguMentList[3]
arg = "23442|3"
ValueStr = string.format("hzys\t%s\t%s\t0,0\t%s\t18500000000\t%s\t%s\t%s\tNA\t%s\t%s", retdtype, retimei, retip, arg, tostring(Businesses), Clientversion, retnet, Edition)
local Stime = os.date("%Y%m%d%H%M%S")	


local Etime = os.date("%Y%m%d%H%M%S")	

ret = 1
rst = "00"

tmpstr = string.format("auto\t%s\t%s\tINPHONE\t%s\t%s\t%s\t0\t%s\t1|1|NA|NA|NA\t%s\t0\t0", Edition, Title, Stime, Etime, ret, rst, retnet)

print(ValueStr)
print(tmpstr)
--[[ValueStr=string.sub(ValueStr,1,-2).."\n"..tmpstr
filename = SysDbgPath..G_OpSrver..".txt"
if cmtTotalNum>0 and Businesses then
    local valuefile = io.open(filename, "a")
    valuefile:write(ValueStr)
    valuefile:close()
    DebugLogId("测试结果记入成功："..filename)
end


hzys	Che1CL20	868227025302175	0,0	192.168.5.165	18500000000	669193|18	测试业务	UNKNOWN	NA	LAN	WIFI	1.0. 
auto	1.0.0	引擎更新成功率	INPHONE	20170610114003	20170610114003	1	0	00	1|1|NA|NA|NA|NA|NA|NA|NA|NA	WIFI	0	0	



[2017/06/10 11:40:03.077 测试日志] 测试指标入表:
auto	1.0.0	引擎更新成功率	INPHONE	20170610114003	20170610114003	1	0	00	1|1|NA|NA|NA|NA|NA|NA|NA|NA	WIFI	0	0		
--]]
