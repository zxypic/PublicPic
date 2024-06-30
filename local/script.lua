-- socket = require("socket")

-- srcpath = "/work/git_uu/engine3.0/mode"
-- local exc = dofile(string.format("%s/%s", srcpath, "luamap.lua"))
--~ require("socket")

local gclient = nil
local gserver = nil

function bind(host, port, backlog)
    local sock, err = socket.tcp()
    if not sock then return nil, err end
    sock:setoption("reuseaddr", true)
    local res, err = sock:bind(host, port)
    if not res then return nil, err end
    res, err = sock:listen(backlog)
    if not res then return nil, err end
    return sock
end

function sleep(n)
   if n > 0 then os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL") end
end

function wlog(DataLog)
	local debugfile = nil
	local filename
	filename = "debug.txt"
 	debugfile = io.open(filename, "a+")
	if debugfile ~= nil then
		DataLog = "[]"..DataLog.."\t\n"
		debugfile:write(DataLog)
		debugfile:close()
	end
end

function channel_start()
	wlog("1111111111111111111111111111111111111111111")
	host = host or "0.0.0.0";
	port = port or "10086";
	gserver, err = bind(host,port,10)
	wlog(tostring(gserver))
	print(gserver, err)
	gclient = gserver:accept()
end

function channel_send(data)
    gclient:send(data)
end


function channel_ends()
	if gclient ~= nil then
		gclient:close()
		gserver:close()
	end
	socket.select(nil,nil,5)
end

function uusenseMain()
	wlog("server: waiting for client connection...");
	channel_start()
	for i=1,1000 do
		channel_send("2223333");
		exc._sleep(2)
	end
	channel_ends()
	return 0
end


