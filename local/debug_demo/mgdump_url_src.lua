


function TableInStr_sigle(tab,s)
	for i = 1,#tab do
		if string.find(s,tab[i])then
			return i
		end
	end
	return -1
end
function _xsplit(str,flag)
	table_tmp = {}
	if string.sub(str,-1,-1) ~= flag then
		str = str .. flag
	end
	for i in string.gmatch(str,'(.-)'..flag) do
		table.insert(table_tmp,i)
	end
	return table_tmp
end
function check_view(str)
	local tab_view_attribute = {"index='","text='","class='","package='","desc='","content%-desc='","id='","resource%-id='","editable='","checkable='","checked='","clickable='","enabled='","focusable='","focused='","scrollable='","long%-clickable='","password='","selected='","xpath='","bounds='","type='","name='","label='","value='"}
	local index = TableInStr_sigle(tab_view_attribute,str)
	if index > 0 then
		if string.find(str,tab_view_attribute[index].."(.-)'") then
			return true
		end
	end
	return false
end
print("---------------------------------------------")


-- 现在看接口信息至少包含以�?4个字段，{"videoName":"无双","downloadURL":"http://xxxxx","type":"m3u8/ts","resolution":"480"}�?

mg = {"[1],[MGDUMP],[{校验规则,是否符合规则(默认true)}],[{视频名称,类型,分辨率}],[从tcpdump中获取url值并上传]"}
mg = {"[1],[MGDUMP],[{regex:'m3u8',outflg:'true'}],[{name:'无双',type:'m3u8/ts',resolution:'480'}],[从tcpdump中获取url值并上传]"}

 
local send = coroutine.create( function()
    local hint = "testSend:"
    local file = io.open("/works/HelloWorks/pymodule/access.log", "rb")
    while true do
        local text = file:read()
        if nil == text then print("send break") break end
        coroutine.yield(text)
    end
    file:close()
end)

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
    print("socket sleep "..n)
end
function _gettime()   -- 获取时间戳，单位ms
	local socket = require("socket")
	if socket ~= nil then
		return socket.gettime()
	else
		print("gettime function unable!")
	end
end


local function loop_load_file(filename,n)
    local myfile = io.open(filename, "rb")
    local stime = _gettime()
    if nil == myfile then
        print(string.format("open file %s fail", filename))
        return 
    end
    local s1 = myfile:seek("end")
    n = n or 0
    if s1~=n then 
        myfile:seek("set",n) 
        local line = myfile:read(s1-n)
        upload_url(line)
        n = myfile:seek()
        myfile:close()
    else
        Sleep(2)
    end
    local etime = _gettime()
    print(string.format( "load time: %s",math.floor(etime-stime)))
    if math.floor(etime-stime)>10 then return end
    return loop_load_file(filename,n)
end

function upload_url(urls)
    print(string.format( "【upload�?: %s",urls))
end

filename = "/works/HelloWorks/pymodule/access.log"
-- loop_load_file(filename)
-- print(math.floor( 2.0013859272003 ))
-- print(tonumber(2.0013859272003))

function lua_cmd(urlexc)
    local restb = {}
    for v in io.popen(urlexc):lines() do
        -- print(v)
        table.insert(restb,v)
    end
    return restb
end
function process_url(allline)
    all_lines=[[	GET /000000001000/4810873738577663591/4810873738577663591_1500000_20190325_101000_31.ts?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1	MediaPlayerID: 26	Host: cache.ott.bestlive.itv.cmvideo.cn:80
    Accept: */*	Range: bytes=0-	Accept-language: zh-cn||||||||||
    GET /000000001000/4810873738577663591/4810873738577663591_1500000_20190325_101000_32.ts?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1	MediaPlayerID: 26	Host: cache.ott.bestlive.itv.cmvideo.cn:80
    Accept: */*	Range: bytes=0-	Accept-language: zh-cn||||||||||
    /4810873738577663591_1500000_20190325_101000_33.ts?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1	MediaPlayerID: 26	Host: cache.ott.bestlive.itv.cmvideo.cn:80
    Accept: */*	Range: bytes=0-	Accept-language: zh-cn||||||||||
    POST /000000001000/4810873738577663591/4810873738577663591_1500000_20190325_101000_34.ts?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1	MediaPlayerID: 26	Host: cache.ott.bestlive.itv.cmvideo.cn:80
    Accept: */*	Range: bytes=0-	Accept-language: zh-cn||||||||||]]
    local postLocation = {}
    local all_tb = _xsplit(all_lines,'||||||||||')
    for k,v in pairs(all_tb) do
        local uris = v:match("[GET%s][POST%s](/.-)HTTP") or v:match("(%g.-)HTTP")
        local hosts = v:match("Host:%s(.-)%c")
        if uris and hosts then 
            local v_url = string.format( "http://%s%s",hosts,uris)
            table.insert(postLocation,v_url)
        end
    end
    
    for k,v in pairs(postLocation) do
        -- print(k,v)
    end
    
end
----------------------------------------------------------------


all_lines=[[02:04:49.557884 IP (tos 0x0, ttl 64, id 10712, offset 0, flags [DF], proto TCP (6), length 757)
192.168.2.113.34104 > 110.184.124.45.80: Flags [P.], cksum 0x831a (correct), seq 117363465:117364182, ack 3944462267, win 229, length 717: HTTP, length: 717
GET /000000001000/4810873738577663591/index.m3u8?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1
MediaPlayerID: 26
Host: cache.ott.bestlive.itv.cmvideo.cn:80
Accept: */*
Range: bytes=0-
Accept-language: zh-cn
Accept-Encoding: identity
User-Agent: Mozilla/4.0 (compatible; MS IE 6.0; (ziva))
player: BesTVMediaPlayerJar
Connection: Keep-Alive

02:04:49.875483 IP (tos 0x0, ttl 64, id 9621, offset 0, flags [DF], proto TCP (6), length 766)
192.168.2.113.34105 > 110.184.124.45.80: Flags [P.], cksum 0x7643 (correct), seq 246929842:246930568, ack 993962170, win 229, length 726: HTTP, length: 726
GET /000000001000/4810873738577663591/4810873738577663591_1500000_20190325_100000_9.ts?channel-id=bestzb&Contentid=4810873738577663591&livemode=1&stbId=004003FF0003231000013C0CDBB30B98&usergroup=g28000000001&userToken=0e11169de048dc094f8a1ecf411ad89928vv&version=1.0&owaccmark=4810873738577663591&owchid=bestzb&owsid=1106497910032755402&AuthInfo=WABK7QFeEYVu3rw36qI0MwLxGxK6vPBOk%2bpVlSLe%2f36HxuS06en8IiXlb1CQSO%2fWOKt%2bAZy4W6NpWzGPx9d4llIJ61jFK4b%2fvLQER11w%2fwPP6S2SoSBYSyIzXvy%2bwjEK HTTP/1.1
MediaPlayerID: 26
Host: cache.ott.bestlive.itv.cmvideo.cn:80
Accept: */*
Range: bytes=0-
Accept-language: zh-cn
Accept-Encoding: identity
User-Agent: Mozilla/4.0 (compatible; MS IE 6.0; (ziva))
Connection: Keep-Alive]]

local function process_dumpurls(filename) --处理dumps源文件
    -- local myfile = io.open(filename, "rb")
    -- local all_lines = myfile:read("all")
    -- myfile:close()

    -- DebugLogId(string.format("cat file : \t%s", filename))
    -- local all_lines = _cfunc.Command(string.format("su -c 'cat %s'", filename))
    -- DebugLogId(string.format("opened file : \n%s", all_lines))

    local all_lines = lua_cmd(string.format("cat %s", filename))
    all_lines = table.concat( all_lines, "\n")
    -- local all_tb = _xsplit(all_lines,'\n\t\n')
    local all_tb = _xsplit(all_lines,'%.%d+%sIP%s')
    
    local tmp_dumps = {}
    for i,v in pairs(all_tb) do
        table.insert(tmp_dumps, v)
    end
    local all_dumps = {}
    for k,v in pairs(tmp_dumps) do
        -- local uris,host = v:match("GET%s(/%g+).*Host:%s(.-)%c")
        local uris,host = v:match("GET%s(/.-)%s.*Host:%s(.-)%c")
        if uris and host then 
            table.insert(all_dumps, host..uris)
        else
            -- print(v)    --异常或无效链接
        end
    end
    return all_dumps
end

local function regkey_or(all_dumps,regkey)
    local dumps_or = {}
    print(regkey)
    local regkey_fmt = _xsplit(regkey,'|')
    for k,v in pairs(all_dumps) do
        for s,t in pairs(regkey_fmt) do
            t = t:gsub('%.','%%.'):gsub('%?','%%?')
            if v:match(t) then 
                -- print(t,v)
                table.insert(dumps_or, v)
                break
            end
        end
    end
    return dumps_or
end

local function regkey_and(all_dumps,regkey)
    local dumps_and = {}
    local regkey_fmt = _xsplit(regkey,'&')
    for k,v in pairs(all_dumps) do
        local flg = true
        for s,t in pairs(regkey_fmt) do
            t = t:gsub('%.','%%.'):gsub('%?','%%?')
            if not v:match(t) then 
                flg = false
                break
            end
            -- if s==#regkey_fmt then print("匹配一次",s) break end
        end
        if flg then table.insert(dumps_and, v) end
    end
    return dumps_and
end

local function regkey_out(all_dumps,regkey)
    local dumps_and = {}
    local regkey_fmt = _xsplit(regkey,',')
    for k,v in pairs(all_dumps) do
        local flg = true
        for s,t in pairs(regkey_fmt) do
            t = t:gsub('%.','%%.'):gsub('%?','%%?')
            if v:match(t) then 
                flg = false
                break
            end
        end
        if flg then table.insert(dumps_and, v) end
    end
    return dumps_and
end

function new_proce_dumps(filename,regkey)
    local fname = filename or "/data/local/tmp/dump_tmp.txt "
    local all_dumps = process_dumpurls(filename)
    print(string.format("共发现%s条数据",#all_dumps))
    
    local dump_regkey 
    -- 包含的逻辑 1
    if regkey.regex and regkey.regex:match("|") then 
        print("process or ...")
        local regkey = regkey.regex 
        dump_regkey = regkey_or(all_dumps,regkey)
    elseif regkey.regex and regkey.regex:match("&") then 
        print("process and ...")
        local regkey = regkey.regex 
        dump_regkey = regkey_and(all_dumps,regkey)
    elseif regkey.regex then
        print("def process or ...")     --默认
        local regkey = regkey.regex 
        dump_regkey = regkey_or(all_dumps,regkey)
    end
    if regkey.regex then print(string.format("过滤[regex]后剩余数据：%s条",#dump_regkey)) end
    --包含的逻辑 2
    all_dumps = regkey.extra and dump_regkey or all_dumps   --是否再次处理
    if regkey.extra and regkey.extra:match("|") then 
        print("process or ...")
        local regkey = regkey.extra 
        dump_regkey = regkey_or(all_dumps,regkey)
    elseif regkey.extra and regkey.extra:match("&") then 
        print("process and ...")
        local regkey = regkey.extra 
        dump_regkey = regkey_and(all_dumps,regkey)
    elseif regkey.extra then
        print("def process or ...")     --默认
        local regkey = regkey.extra 
        dump_regkey = regkey_or(all_dumps,regkey)
    end
    if regkey.extra then print(string.format("过滤[extra]后剩余数据：%s条",#dump_regkey)) end
    --不包含的逻辑
    all_dumps = regkey.out_regex and dump_regkey or all_dumps   --是否再再次处理
    if regkey.out_regex then
        print("process out ...")
        local regkey = regkey.out_regex 
        dump_regkey = regkey_out(all_dumps,regkey)
        print(string.format("过滤[out_regex]后剩余数据：%s条",#dump_regkey))
    end
    print(string.format("过滤后剩余数据：%s条",#dump_regkey))
    local myfile,e = io.open("video_dump.txt", "wb")
	myfile:write(table.concat(dump_regkey, "\n"))
	myfile:close()
end

-----------------------------------------------
-- filename = "/works/xy_tmp/dump_tmp.txt"
filename = "/works/xy_tmp/test_dump.txt"
local jsonIni = "{regex:'.ts?|.flv?|.mp4?|.265ts?|.f4v?'}"
local jsonIni = "{regex:'.m3u8?&index&Contentid'}"
local jsonIni = "{regex:'.ts?|.mp4?'}"
jsonIni = jsonIni:match("%b{}") and jsonIni:match("%b{}"):sub(2,-2) or nil
-- 匹配字符串，(and: &	or: |) 可以为空，筛选条件
local regkey = {}
for k,v in jsonIni:gmatch(",?(.-):'(.-)'") do
    regkey[k] = v
end
-----------------------------------------------
for k,v in pairs(regkey) do
    print(k,v)
end


new_proce_dumps(filename,regkey)    --逻辑后的dump_file
local filename = "/works/git_auto/engine3.0/video_dump.txt"
local myfile,e = io.open(filename, "rb")
local all_lines = myfile:read("*all")
myfile:close()

local postLocation = {}
local all_tb = _xsplit(all_lines,'\n')
for k,v in pairs(all_tb) do
    local hosturi = v
    if hosturi or uris and hosts then 
        local v_url = string.format( "http://%s",hosts and uris and hosts..uris or hosturi)
        table.insert(postLocation,v_url)
    end
end
for k,v in pairs(postLocation) do
    print(k,v)
end
