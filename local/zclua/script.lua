
-- print(package.path)
-- print(package.cpath)
local function _getFileLen(filename)
	local fh = assert(io.open(filename, "rb"))
	local len = assert(fh:seek("end"))
	fh:close()
	return len
end
function lualoads( a,b )
    -- package.cpath = "/works/git_auto/engine3.0/local/zclua/?.so;"..package.cpath

    -- local luaLoad = dofile("luaLoad")
    local luaLoad = require("luaLoad")
    _cfunc.Print(luaLoad.add(a,b))
    return luaLoad.add(a,b)
end

function uusenseMain(ParmSysParms)  --0910
	_cfunc.Print(package.path)
    _cfunc.Print(package.cpath)
	_cfunc.Print("bbbbbbbbbbbbbbbbbbbbbbbbbbbb")
    package.cpath = "/data/local/tmp/c/?.so;"..package.cpath
    _cfunc.Print("package.cpath:"..package.cpath)
	_cfunc.Print(package.path)
    _cfunc.Print(package.cpath)
    solen = _getFileLen("/data/local/tmp/c/luaload.so")
    _cfunc.Print("package.solen:"..solen)
    _cfunc.Print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    local path = "/data/local/tmp/c/luaload.so"
    local f = assert(package.loadlib(path, "add"))
    f()  -- 真正打开库

    lualoads(1,4)
    _cfunc.Print("\n\n")
    return 0
end

-- local path = "/works/git_auto/engine3.0/local/zclua/luaload.so"
-- local f = assert(package.loadlib(path, "add"))
-- f()  -- 真正打开库