function TableInStr_sigle(tab, s)
	for i = 1, #tab do
		if string.find(s, tab[i]) then
			return i
		end
	end
	return -1
end
function _xsplit(str, flag)
	table_tmp = {}
	if string.sub(str, -1, -1) ~= flag then
		str = str .. flag
	end
	for i in string.gmatch(str, "(.-)" .. flag) do
		table.insert(table_tmp, i)
	end
	return table_tmp
end
local function _getFileLen(filename)
	local fh = assert(io.open(filename, "rb"))
	local len = assert(fh:seek("end"))
	fh:close()
	return len
end
local function _file_exists(path, kib) --file_exists 好看
	local file = io.open(path, "rb")
	if file then
		kib = kib or 1
		file:close()
		file = _getFileLen(path) > kib and file or nil
	end
	return file ~= nil
end

function check_view(str)
	local tab_view_attribute = {
		"index='",
		"text='",
		"class='",
		"package='",
		"desc='",
		"content%-desc='",
		"id='",
		"resource%-id='",
		"editable='",
		"checkable='",
		"checked='",
		"clickable='",
		"enabled='",
		"focusable='",
		"focused='",
		"scrollable='",
		"long%-clickable='",
		"password='",
		"selected='",
		"xpath='",
		"bounds='",
		"type='",
		"name='",
		"label='",
		"value='"
	}
	local index = TableInStr_sigle(tab_view_attribute, str)
	if index > 0 then
		if string.find(str, tab_view_attribute[index] .. "(.-)'") then
			return true
		end
	end
	return false
end
print("---------------------------------------------")

-- 现在看接口信息至少包含以�?4个字段，{"videoName":"无双","downloadURL":"http://xxxxx","type":"m3u8/ts","resolution":"480"}�?

mg = {"[1],[MGDUMP],[{校验规则,是否符合规则(默认true)}],[{视频名称,类型,分辨率}],[从tcpdump中获取url值并上传]"}
mg = {"[1],[MGDUMP],[{regex:'m3u8',outflg:'true'}],[{name:'无双',type:'m3u8/ts',resolution:'480'}],[从tcpdump中获取url值并上传]"}

local send =
	coroutine.create(
	function()
		local hint = "testSend:"
		local file = io.open("/works/HelloWorks/pymodule/access.log", "rb")
		while true do
			local text = file:read()
			if nil == text then
				print("send break")
				break
			end
			coroutine.yield(text)
		end
		file:close()
	end
)

-- print(coroutine.status(send))

-- while true do
--     local status, text = coroutine.resume(send)
--     local s            = coroutine.status(send)
--     print("s = ", s, ", status = ", status, ", text = ", text)
--     if not status then Sleep(1) end
-- end

function Sleep(n)
	local socket = require("socket")
	if socket ~= nil then
		n = n or 1
		socket.select(nil, nil, n)
	end
	print("socket sleep " .. n)
end
function _gettime() -- 获取时间戳，单位ms
	local socket = require("socket")
	if socket ~= nil then
		return socket.gettime()
	else
		print("gettime function unable!")
	end
end

local function loop_load_file(filename, n)
	local myfile = io.open(filename, "rb")
	local stime = _gettime()
	if nil == myfile then
		print(string.format("open file %s fail", filename))
		return
	end
	local s1 = myfile:seek("end")
	n = n or 0
	if s1 ~= n then
		myfile:seek("set", n)
		local line = myfile:read(s1 - n)
		upload_url(line)
		n = myfile:seek()
		myfile:close()
	else
		Sleep(2)
	end
	local etime = _gettime()
	print(string.format("load time: %s", math.floor(etime - stime)))
	if math.floor(etime - stime) > 10 then
		return
	end
	return loop_load_file(filename, n)
end

function upload_url(urls)
	print(string.format("【upload�?: %s", urls))
end

function lua_cmd(urlexc)
	local restb = {}
	for v in io.popen(urlexc):lines() do
		-- print(v)
		table.insert(restb, v)
	end
	return restb
end
function _gmatch(str, pattern)
	local temp = {}
	for w in string.gmatch(str, pattern) do
		local ttt = string.gsub(w, "[%[%]]", "")
		table.insert(temp, ttt)
	end
	return temp
end
function get_bounds(bounds)
	if bounds and bounds:find("%d+,%d+") then
		local boundTb = _gmatch(bounds, "%d+")
		local touchx = tostring(math.ceil((tonumber(boundTb[1]) + tonumber(boundTb[3])) / 2))
		local touchy = tostring(math.ceil((tonumber(boundTb[2]) + tonumber(boundTb[4])) / 2))
		return string.format("%s,%s", touchx, touchy)
	end
end
local modepath = "/Users/works/git_auto/engine3.0/"
local exc = dofile(string.format("%smode/luamap.lua", modepath)) --基础函数扩展lua
local json = dofile(string.format("%smode/json.lua", modepath)) --具体功能执行实现
--------------------------------------------------------------
--------------------------------------------------------------
local cmd_exists = function(cmdd)
	local vlog = _cfunc.Command(string.format("%s shell %s", ATdevice, cmdd))
	return not vlog:match("not")
end

function in_array(b, list)
	if not list then
		return false
	end
	if list then
		for k, v in pairs(list) do
			if v.tableName == b then
				return true
			end
		end
	end
end

function json.write(jsonfile, jsondata)
	exc._writeLog(jsonfile, json.encode(jsondata), "w+")
	return jsondata
end

touchxy = get_bounds("[688,514][936,762]")
print(touchxy)
debugMsg = print

pdpRefresh = 60
-- cga_freq({['freq']=math.ceil( pdpRefresh/60 )})
function init_fre(ffreq)
	local cagtime = ffreq:match("_(%d+).txt")
	local freq = ffreq:match("%d") -- 频次
	print(freq, cagtime)
	return {["freq"] = freq, ["cagtime"] = cagtime, ["ffreq"] = ffreq}
end

function fqds()
	return "CGA_2_263235554.txt"
end

function init_header(upflg)
	-- 有文件就不再更新 ，逻辑错误 需要修正
	-- 绑卡后就需要更新 ，否则第一次需要生产

	jsonf = "header.json"
	if not exc._file_exists(jsonf) then
		upflg = true
	end
	if upflg then
		datatb = init_fre(fqds())
		json.write(jsonf, datatb)
	else
		local header = json.decode(exc.readfile(jsonf))
		for k, v in pairs(header) do
			print(k, v)
		end
		return header
	end
end
debugMsg = print

function exResHeader(datatb)
	for k, v in pairs(datatb) do
		print(k, v)
	end
	json.write("jsonf.apn", datatb)
end
function AT_send(at, simflg)
	return "aaaa77tttt"
end
simflg = 1

local _apncode = function(_apn)
	if exc._file_exists(_apn, -1) then
		local apns = json.decode(exc.readfile(_apn))
		return apns["apncode"]
	else
		print("\tnot found")
	end
end

apncode = 'cmiot'
_apn = 'jsonf.apn'
exResHeader({simflg=simflg, apncode = 'cmiot', csq = AT_send('AT+CSQ', simflg):match('%d+') or ""}, "Simflg CSQ")
if exc._file_exists(_apn, -1) then
	local jsf = json.decode(exc.readfile(_apn))
	for k,v in pairs(jsf) do
		print(k,v)
	end
end

if not exc._file_exists(_apn, -1) or _apncode(_apn) ~= apncode then
	print("rm apn files")
	print("init at for devices ")
else
	print("------")
end
os.execute("rm -r *.apn")