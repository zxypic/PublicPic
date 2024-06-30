
DEBUG = {gclient, gserver}
socket = require("socket")
function DEBUG:build(host, port, backlog)
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

function DEBUG:wlog(DataLog)
	local debugfile, filename
	filename = "debug.txt"
	debugfile = io.open(filename, "a+")
	if debugfile ~= nil then
		DataLog = "[]" .. DataLog .. "\t\n"
		debugfile:write(DataLog)
		debugfile:close()
	end
end

function DEBUG:channel_init()
	-- os.remove(debug.getinfo(1, "S").source:sub(2))
	host = host or "127.0.0.1"
	port = port or "6666"
	gserver, err = DEBUG:bind(host, port, 10)
	DEBUG:wlog(tostring(gserver))
	print(gserver, err)
	gclient = gserver:accept()
end

function DEBUG:channel_send(data)
	gclient:send(data)
end

function DEBUG:channel_ends()
	if gclient ~= nil then
		gclient:close()
		gserver:close()
	end
end

print(debug.getinfo(1, "S").source:sub(2))
print(debug.getinfo(1).short_src)   -- :match("^.*/")

DEBUG:channel_init()
DEBUG:channel_send("data")
DEBUG:channel_ends()