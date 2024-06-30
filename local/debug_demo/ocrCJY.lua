function fileread(FileName)
	local ReadContent
	pcall(
	function()
		io.input(FileName)
		ReadContent = io.read("*a")
		io.close()
	end)
	return ReadContent
end
-- ##############################################################################
function CJY_GetScore(aUser, aPass)
	local ret = - 1
	os.execute("curl -o GetScore.txt -F user=" .. aUser .. " -F pass=" .. aPass .. " http://code.chaojiying.net/Upload/GetScore.php")
	ret = fileread("GetScore.txt")
	return ret
end
--报错返分
--参数(用户账号,密码,图片ID,软件ID)
function CJY_ReportError(aUser, aPass, aPicid, aSoftid)
	os.execute("curl -o UpPic.txt -F username=" .. aUser .. " -F password=" .. aPass .. " -F id=" .. aPicid .. " -F softid=" .. aSoftid .. " http://code.chaojiying.net/Upload/ReportError.php")
	local ret = fileread("UpPic.txt")
	return ret
end
function CJY_UpPic(aUser, aPass, aCodetype, aSoftid, file_path)
	local curlParam = string.format("user=%s -F pass=%s -F codetype=%s -F softid=%s -F userfile=@%s http://upload.chaojiying.net/Upload/Processing.php", aUser, aPass, aCodetype, aSoftid, file_path)
	os.execute("curl -o UpPic.txt -F " .. curlParam)
	local ret = fileread("UpPic.txt")
	return ret
end

local aUser, aPass, aSoftid = "xdUU123", "uu@test", 893084  	--账号、密码、id
local aCodetype = 1006
file_path = "/Users/xnder/Downloads/Chaojiying_Python/a.jpg "
local tfstr = CJY_GetScore(aUser, aPass)
print("账户提分：", tfstr)
pic_str = CJY_UpPic(aUser, aPass, aCodetype, aSoftid, file_path)
print("识别结果：", pic_str)
-- errport = CJY_ReportError("xdUU123", "uu@test", "377023391406", 893084)
-- print("报错：", errport)
-- local tfstr = CJY_GetScore(aUser, aPass)
-- print("账户提分：", tfstr)

function cjy_ScorePic(pic_name)
	-- Method_CaptureOcr(posPram, ocrTflg)	
	-- {"[1],[PICOCR],[图片验证码],[21_23_23_18.bpm],[识别图片验证码]"},   --收费  2-5分  5min一次 一天 5.76元
	-- {"[1],[INPUT],[验证码],[21_23_23_18.bpm],[输入识别的验证码]"},
	local aUser, aPass, aSoftid = "xdUU123", "uu@test", 893084  	--账号、密码、id
	local aCodetype = 1006
	
	local function getScore(aUser, aPass)
		local ret = - 1
		os.execute("curl -o GetScore.txt -F user=" .. aUser .. " -F pass=" .. aPass .. " http://code.chaojiying.net/Upload/GetScore.php")
		ret = fileread("GetScore.txt")
		return ret
	end
	local function upPic(aUser, aPass, aCodetype, aSoftid, file_path)
		local curlParam = string.format("user=%s -F pass=%s -F codetype=%s -F softid=%s -F userfile=@%s http://upload.chaojiying.net/Upload/Processing.php", aUser, aPass, aCodetype, aSoftid, file_path)
		os.execute("curl -o UpPic.txt -F " .. curlParam)
		local ret = fileread("UpPic.txt")
		return ret
	end
	local tifen = getScore(aUser, aPass)	--查提分
	local pictxt = ""
	if tifen > 20 then
		local file_path = string.format("%s/%s", path, pic_name)	--图片路径
		pictxt = upPic(aUser, aPass, aCodetype, aSoftid, file_path)
	else
		print("账户余额不足，请联系管理员（张旭阳）进行充值！！")
	end
	
	return pictxt
end
