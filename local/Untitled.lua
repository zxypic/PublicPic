
function _new(tb)
    -- tb = tb or {}
    local proxy = {}
	local mt = {__index = tb}
	setmetatable(proxy, mt)
    return proxy

	-- o = o or {}
	-- setmetatable(o,self)
	-- self.__index = self
	-- return o
end
function sendPacket(package)
    local socket = require("socket")

    local host = "127.0.0.1"
    local port = 32145
    local sock = assert(socket.connect(host, port))
    sock:settimeout(0)
      
    print("Press enter after input something:")
     
    local input, recvt, sendt, status
    input = package or io.read()
    if #input > 0 then
        assert(sock:send(input .. "\n"))
    end
        
    recvt, sendt, status = socket.select({sock}, nil, 1)
    while #recvt > 0 do
        local response, receive_status = sock:receive()
        if receive_status ~= "closed" then
            if response then
                print(response)
                recvt, sendt, status = socket.select({sock}, nil, 1)
            end
        else
            break
        end
    end
    
end

    
flg="0x7F"
sms="00100010"  --"10000100100001" or 
bsize = "0000"
-- local pack = string.format("%s%s%s%s", flg,"1111", sms,bsize)
-- package = string.pack("<s2",pack)
-- print(string.unpack("<s2",package))	--,string.packsize("<BxI2I4")

-- package = string.pack("<I1<I1<I2<I4",flg,"", sms,bsize)

-- print(string.unpack("<I1<I1<I2<I4",package))	

-- adb shell uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e port 32145 -e output true
-- function adtv()
--     error("sdjf")
-- end

retpram = [[{
    "status": 1,
    "message": "",
    "data": {
        "mobileNumber": ""
    },
    "timestamp": 1545279171
}]]
local function luacmdd(cmdd)
    local logstb = {}
    for v in io.popen(cmdd):lines() do
        table.insert( logstb,v)
    end
    return table.concat( logstb, "\n")
end

retpram='{"status":1,"message":"","data":{"mobileNumber":""},"timestamp":1545357594}'

local imeiNum =  retpram:match("mobileNumber%p+.-(%d+).*timestamp") or "ini null" 
print(imeiNum)
-----------------------------------------------------
local http=require("socket.http");  -- https://www.jianshu.com/p/059ed697a6ef
local ltn12 = require("ltn12")

function lua_socket_post(url,body)
    local port = "8102"
	local devimei = "0021d4bb1720ec2d99eaa427e902da022a1788de"
	local sessionId = self._sessionId()
    local request_body = [[login=user&password=123]]
    -- '{"url":http://localhost:%s/session/%s/element}'
    local response_body = {}
     
    local res, code, response_headers = http.request{
            url = url or "http://httpbin.org/post",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json";
                ["Content-Length"] = #request_body;
            },
            source = ltn12.source.string(request_body),
            sink = ltn12.sink.table(response_body),
    }
    return res, code, response_headers,response_body
end

res, code, res_headers,res_body = lua_socket_post()

print(res)
print(code)
print("----------------------------------------------")
if type(res_headers) == "table" then
    for k, v in pairs(res_headers) do
      print(k, v)
    end
end
print("----------------------------------------------")

print("Response body:")
if type(res_body) == "table" then
    print(table.concat(res_body))
else
    print("Not a table:", type(res_body))
end



