local srcpath = "/works/git_auto/engine/new_func_xy"
local exc = dofile(string.format("%s/%s", srcpath, "luamap.lua"))
srcpath = "/works/git_auto/engine3.0/mode"
local json = dofile(string.format("%s/%s", srcpath, "dkjson.lua"))
-- dofile(string.format("%s/%s", srcpath, "luatest.lua"))
function winCommand(cmds)   --执行命令行
	local logtb = io.popen(cmds)
	local logs = {}
	for i in logtb:lines() do
		table.insert(logs, i)
	end
	return table.concat(logs, "\n")
end
function url_overview(logdata, userurl,json)
	DebugLogId(string.format("packetdata[%s] to overview : %s", #logdata,userurl))
	local overview = exc._xsplit(logdata, '{"overview')
	for k, v in ipairs(overview) do
		overview[k] = '{"overview' .. v
	end
	local userhttptb = {}
	for k, v in pairs(overview) do
		if v:find(userurl) then
			local tmptb = json.decode(v)
			table.insert(userhttptb, tmptb)
		end
	end
	return userhttptb
end

function mgkv_HttpMain(cmddurl, scstr)
	local json = dofile(string.format("/works/git_auto/engine3.0/mode/%s", "dkjson.lua"))
	scstr = scstr:gsub(" ", "")
	local rules = scstr:match("regex:%'(.-)%',") or ""
	local tvalue = scstr:match("value:%'(%a+)%',?") or ""
	DebugLogId(string.format("get [%s] value to [%s]", rules, tvalue))
	local function getpkglog(pktf)
		local files = io.open(pktf, "rb")
		local fdata = files:read("*all")
		files:close()
		-- os.remove(pktf)  --删除文件
		-- local file = io.open("/sdcard/packet_log.txt", "a+") --备份
		-- file:write(fdata .. "\n")
		-- file:close()
		return fdata
	end
	local uncode_mgdata = function(hturl, urlpacket,type) --解密数据
		local curlp = "/data/local/tmp/curl-7.40.0/bin"
		DebugLogId(string.format("请求解密接口: %s", hturl))
		local urlexc = ""
		if type then
			local postdata = ""
			for k, v in pairs(urlpacket["postdata params"]) do
				postdata = string.format('%s"%s":"%s",', postdata, k, v)
			end
			DebugLogId(string.format("请求数据: {%s}", sendata))
			urlexc = string.format("%s/curl -X POST -d '{%s}' %s", curlp, postdata, hturl)
		else
			if not urlpacket["postdata params"]["data"] then return "nil" end
			local getdata = ""
			for k, v in pairs(urlpacket["postdata params"]) do
				getdata = string.format("%s%s=%s&", getdata, k, v)
			end
			DebugLogId(string.format("请求数据: {%s}", getdata:sub(1,-2)))
			-- urlexc = string.format('%s/curl -d "%s" %s', curlp, getdata:sub(1,-2),hturl)
			urlexc = string.format('curl -d "%s" %s', getdata:sub(1,-2),hturl)
		end
		local httpstr = winCommand(urlexc)
		-- local httpstr = _cfunc.Command(urlexc)
		if #httpstr<6 then DebugLogId(string.format("ret: \n%s", httpstr or "nil")) httpstr = httpstr or '{Command return nil}' end
		local retpram = httpstr:match("{.*}") or "nil"
		DebugLogId(string.format("解密返回值: \n%s", retpram))
		-- G_mgScriptFlg["RESPONSE"] = _cfunc.Utf8ToGbk(retpram)
		DebugLogId("保存解密返回值至参数<RESPONSE>")
		-- json中\t转为/t | 转为 $$$ ,更好的方法是 采用网页方式  ASCII 然后加网页格式 如 | => &#124;
		return retpram
	end
	local pktf = "/Users/xnder/Downloads/packet.log"
	local enurl = G_mgKVENURL or "nil" --解密地址
	local userurl = cmddurl or "nil" --捕获指定地址
	if not exc._file_exists(pktf) then
		local lslogtmp = _cfunc.Command("ls /sdcard/ -l |grep log")
		DebugLogId(string.format("未找到数据包文件 (请检查代理设置或抓包工具): \n%s", lslogtmp))
		return 1
	end
	-- local version = _cfunc.Command(string.format("dumpsys package %s |grep '%s'", "com.forys.network", "versionName"))
	-- local installTime = _cfunc.Command(string.format("dumpsys package %s |grep '%s'", "com.forys.network", "firstInstallTime"))
	-- DebugLogId(string.format("version: %s  installtime: %s", version, installTime))

	local function httpPKstr(urlpacket) --解析抓包json
		local httpstr = "nil"
		for i = #urlpacket, 1, -1 do
			if urlpacket[i]["postdata params"] then
				httpstr = uncode_mgdata(enurl, urlpacket[i]) or "nil" --解密
				httpstr = httpstr:match(rules) or "nil" --正则捕获的值
				DebugLogId(string.format("regex[%s]获取到的对应值: %s", i, httpstr))
				if httpstr ~= "nil" then break end
			else return "nil" end
		end
		return httpstr
	end 
	local httpstr = "nil"
	for i = 1, 3 do
		-- _cfunc.Sleep(3 * 1000)
		local logdata = getpkglog(pktf) --获取已捕获的包
		local urlpacket = url_overview(logdata, userurl, json) --获取url.view
		DebugLogId(string.format("当前packet,共找到 url.view: %s 个", #urlpacket))
		httpstr = httpPKstr(urlpacket)
		if httpstr == "nil" then
			local psnettmp = _cfunc.Command("ps |grep com.forys.network")
			DebugLogId(string.format("send postdata is null, 请检查: %s:%s", pktf, psnettmp))
		elseif httpstr ~= "nil" then
			break
		end
	end

	httpstr = httpstr:gsub('"', "") or "nil"
	if httpstr ~= "nil" and httpstr ~= "" then
		local kvstr = string.format('{"%s":"%s"}', tvalue, httpstr)
		local pram = json.decode(kvstr)
		for k, v in pairs(pram) do
			G_mgScriptFlg[k] = v
		end --放入全局表中
	else
		return 1
	end
	DebugLogId(string.format("save as [%s] done .", tvalue))
end


ArguMentList='[{"EID":"user_login","TDT":[{"EV":"0","EK":"result_code"},{"EV":"1","EK":"account_type"},{"EV":"15198033955","EK":"account"},{"EV":"192.168.253.6","EK":"client_ip"},{"EV":"15198033955","EK":"phone_number"}],"OCID":"70f7a9e5d3cd43ef86ff1fe3eb5baa50","ETM":1539055652041}]},"code":200}'
ArguMentList='{"msg":{"DevInfo":{"AC":"01474D60003","MO":"","SV":"7.0","DI":"351952084904678-null-1b4f489e580cd71b","APILevel":"24","DM":"SM-G9350","AK":"6c837308eb2349da90f8649ea2386794","AN":"鍜挄闊充箰","AVC":"6.5.0|238","SC":"2560x1440","SDKV":"2.3.1","SN":"Android","DB":"samsung","APN":"cmccwm.mobilemusic"},"Events":[{"EID":"et_00001","TDT":[{"EV":"0","EK":"logion_account_type"},{"EV":"15198033955","EK":"login_account"},{"EV":"OK","EK":"action_result_intro"},{"EV":"10000","EK":"login_type"},{"EV":"0","EK":"action_result_code"},{"EV":"1540537499976","EK":"action_start_time"},{"EV":"1540537500646","EK":"action_end_time"}],"OCID":"dd8be51bd5ac4b0085a877938d9cdfec","ETM":1540537500646}]},"code":200}'
-- print(string.find(a, "EID":"user_read"  "EK":"book_id","EV":"463062884"  "EK":"account_type","EV":"1" "account","EV":"18980595574"))
-- "Events":[{"EID":"user_read","ETM":1540520160333,"OCID":"51148f4beb4943f894eb03c37726e3bf","TDT":[{"EK":"book_author","EV":"【澳】泰瑞·海耶斯"},{"EK":"book_id","EV":"463062884"},{"EK":"chapter_length","EV":"113"},{"EK":"book_name","EV":"朝圣者"},{"EK":"account_type","EV":"1"},{"EK":"account","EV":"18980595574"},{"EK":"chapter_id","EV":"463062888"},{"EK":"book_type","EV":"ebook"},{"EK":"duration","EV":"8"},{"EK":"phone_number","EV":"18980595574"}]
retlog = json.decode(ArguMentList)
commdd =  "{regex:'EID:user_read,book_id:463062884,account_type:1,account:18980595574'}"  --可以考虑这样
commdd = commdd:gsub('%s','')
local EIDstr = commdd:match("EID%p(.-),")
local EKVstr = commdd:match(string.format( "%s,(.*)'", EIDstr))
print(EIDstr,EKVstr)

print(retlog['msg']['Events'])
print(retlog['msg']['Events'][1]['EID'])

-- print(kvlog['book_id'])
function getUKV(EKVstr)  --解用户KV值
    local i=0
    local EKVstrtb = {}
    for k,v in EKVstr:gmatch(',?(%w+[%p]?%w+):(%w+)') do
        EKVstrtb[k] = v
        i = i + 1
    end
    return EKVstrtb,i
end

function pairstb(k,usertb)
    for i,v in pairs(usertb) do
        if i==k then return v end
    end
    return nil
end



function CheckMGkv(retlog,UEKVstr)   --校验咪咕KV值，顺序不定
    local ret = -1
    local EKVstrtb,ui = getUKV(UEKVstr)
    if retlog['Events'][1]['EID']==EIDstr then 
        DebugLogId(string.format( "EID OK, 开始校验 EKV值: %s", UEKVstr))
        if retlog['Events'][1]['TDT'] then 
            local ki = 0
            for k,v in pairs(retlog['Events'][1]['TDT']) do
                if type(v)=='table' then 
                    local mgv = pairstb(v['EK'],EKVstrtb)
                    if mgv then 
                        local equal,eret = "≠","false"
                        if mgv==v['EV'] then 
                            ki = ki +1 
                            equal,eret = "==","OK"
                        end
                        DebugLogId(string.format("User check  [%s] ? [%s] --> result [UV:%s %s EV:%s]\t%s",v['EK'],mgv,mgv, equal, v['EV'], eret))
                    end
                    if ki==ui then break end
                end
            end
            if ki~=ui then DebugLogId("校验不通过") return 1 end
            if ki==ui then DebugLogId("校验通过OK") return 0  end
        else
            DebugLogId("返回结构有误，缺少[Events][1][TDT]")
        end
    else
        DebugLogId("返回结构有误，缺少[Events][1][EID]")
    end
    return ret
end

DebugLogId = print
-- CheckMGkv(retlog,EKVstr)

DebugLogId = print
G_mgScriptFlg = {}

G_mgKVRULE = "http://119.29.116.61:9091"
G_mgKVRULE = "http://10.148.128.1:18289/udcc/decodeAppSDKData.html"
G_mgKVENURL = "http://uem.uusense.com/getudcc"


cmddurl = "https://uem.migu.cn:18088/udcc/upload.html"


mgkv_HttpMain(cmddurl, "TDT.-(%d+).-result_code")

-- DebugLogId("你要的: " .. G_mgScriptFlg["vid"])
