
local gclient, gserver
function bind(host, port, backlog)
	local sock, err = socket.tcp()
	if not sock then
		return nil, err
	end
	sock:setoption("reuseaddr", true)
	local res, err = sock:bind(host, port)
	if not res then
		return nil, err
	end
	res, err = sock:listen(backlog)
	if not res then
		return nil, err
	end
	return sock
end
function wlog(DataLog)
	local debugfile, filename
	filename = "/data/local/tmp/debug.txt"
	debugfile = io.open(filename, "a+")
	if debugfile ~= nil then
		DataLog = "[]" .. DataLog .. "\t\n"
		debugfile:write(DataLog)
		debugfile:close()
	end
end
function channel_init()
	os.remove(debug.getinfo(1, "S").source:sub(2))
	host = host or "127.0.0.1"
	port = port or "6666"
	gserver, err = bind(host, port, 10)
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
end
function uusenseMain(ParmSysParms)
	os.remove("/data/local/tmp/.fna00956")
	channel_init()
	print("......")
	channel_ends()
	return 0
end

function DebugLogId(DataLog, ddate)
	local time
	if not DataLog then
		DataLog = "DebugLogId传入参数为空..."
	elseif type(DataLog) == "table" then
		DataLog = table.concat(DataLog, "\n")
	end
	local debugfile, filename
	if G_EngineMode ~= "MacIOS" then
		filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "debug.txt"
	elseif DebugFlag then
		filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "debug.txt"
	else
		filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg .. "debug.txt"
	end
	ddate = ddate or "Debug" or "测试日志" or "UULog"
	time = GetAPI_OsClock()
	if G_EngineMode == "MacIOS" then
		DataLog =
			"[" .. os.date("%Y-%m-%d %H:%M:%S") .. "." .. string.sub(time, -5, -3) .. " " .. ddate .. "]" .. DataLog .. "\t\n"
	else
		DataLog =
			"[" ..
			os.date("%Y-%m-%d %H:%M:%S", string.sub(time, 1, -4)) ..
				"." .. string.sub(time, -3, -1) .. " " .. ddate .. "]" .. DataLog .. "\t\n"
	end
	if G_EngineMode == "MacIOS" then
		WriteFile(filename, DataLog, "a")
	else
		while true do
			debugfile = io.open(filename, "a")
			if not debugfile then
				GetAPI_Sleep(5)
			else
				break
			end
		end
		debugfile:write(DataLog)
		debugfile:close()
		channel_send(DataLog)
	end
end
