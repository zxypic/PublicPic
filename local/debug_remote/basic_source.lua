MGBscEdt = "2.7.9"
UUBscEdt = "5.06.13"
G_EngineMode = nil
G_Id = nil
G_SysParms = nil
G_DeviceName = nil
G_RelDeviceName = nil
G_DeviceImei = nil
G_SysRstPath = nil
G_SysDbgPath = nil
G_SysEngPath = nil
G_SysScpPath = nil
G_Pflg = "/"
G_RecvNumber = nil
G_recvcontent = nil
G_FuzzyFlag = nil
G_FTouchFlag = nil
G_res_x = nil
G_res_y = nil
G_CycUrl = nil
G_Captcha = nil
G_Turnnumber = nil
G_ScriptStart = nil
G_ScriptEnd = nil
G_OpSrver = "result"
G_GlbVocMsg = ""
G_CMValueTable = {}
G_CaptureTab = {}
G_CMVouc = ""
G_CMPNVouc = ""
G_CMDNSVouc = ""
G_NETSENSE = ""
G_INIContList = nil
G_INIFalse = nil
G_TestTimeTab = {}
G_img2 = nil
G_Imgtime = nil
G_first_time = nil
G_ScriptPic = ""
G_ScriptList = {}
G_AutoUPload = false
G_ScriptID = ""
G_actionID = 0
G_scriptactionID = 0
G_ExactionID = false
G_ReActionID = false
G_scriptflag = false
G_Oderflag = 0
G_scriptimg = {}
G_packet = {}
G_packetflag = false
G_vm2time = nil
G_vm2flag = nil
G_vm2flag_new = nil
G_vm2timeflag = false
G_sig = nil
G_PNVouc = {}
G_DNSVouc = {}
G_videoUrl_table = {}
G_videoUrl_band_table = {}
G_videoUrl_flag = false
G_VideoUrl_cnt = 1
G_VideoUrl_input_cnt = 1
G_startenergy = nil
G_fail_dump_tab = {}
G_fail_flag = false
G_loop = nil
G_loop_flag = 0
G_rate_url = nil
G_rateTime_url = nil
G_WRITE_FILE = {}
G_flag_ = 1
G_now_width = nil
G_now_height = nil
G_APPscript = nil
G_WEBscreen = nil
G_JRResultXml = {}
G_FrameRate = nil
G_BitRate = nil
G_TmpValue = nil
G_ATCID = nil
G_mgScriptFlg = {RESPONSE = "nil"}
SCRIPT_VIEW_VALUE = nil
Businesses = nil
G_Replace_Turnnumber = false
UnInit = nil
TestMode = nil
PortFlag = nil
G_timeOut = 60
G_ClickTimeOut = 30
G_Reboot = nil
G_failflag = false
G_Fuzzy_flag = false
DScreen = nil
G_Fuzzy_Offset = 100
G_pkgName = nil
G_logcat_flag = false
G_video_buf = false
SwitchCity = nil
SwitchTime = nil
G_PackageName = nil
G_http_keyword = nil
G_mgAppTest = nil
G_UIAutoClick = true
G_mgKVENURL = nil
G_OnecTime = nil
G_view = nil
DebugSCPath = DebugSCPath or "/data/local/tmp/c"
MacIOSF, IOSCALE, IOSPTYPE, WDATYPE, IOSPOINT = {}, nil, nil, nil, nil
G_WebTurl = nil
G_MonitorSignal = nil
G_USERID = ""
G_cnt = 0
function MainFunction()
  local ret = 0
  local sig, FileName, scriptcontent
  if ScriptAction then
    Serv_Action(G_DeviceName, ScriptAction)
  elseif CycAction then
    Serv_Action(G_DeviceName, CycAction, "Y")
  elseif BusinessActionA and not BusinessActionB then
    Serv_ALL_OneAction(G_DeviceName, BusinessActionA)
  elseif BusinessActionA and BusinessActionB then
    Serv_OrderAndCancel(G_DeviceName, BusinessActionA, BusinessActionB)
  end
  if G_FileName then
    DebugLogId("??????????¶ƒ???,???????!", "???????")
    GetAPI_perf_monitor(nil, nil, 1)
  end
  GetAPI_stop_signal_monitor()
  if G_MonitorSignal then
    GetAPI_MonitorSignal("stop")
  end
  DebugLogId("?????????????...")
  return ret
end
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
  local status, err, devcount
  local UsrParms = ""
  if DebugFlag then
    ParmSysParms = DebugFlag
  elseif ParmSysParms == "" or ParmSysParms == "android|" then
    DebugFlag = "Android|1|1|1|200|"
    ParmSysParms = DebugFlag
  end
  G_SysParms = ParmSysParms
  local ArguMentList = splittable(G_SysParms, "|")
  GetOSFlag(ParmSysParms)
  localToGlobal(ArguMentList)
  G_DeviceName = GetDeviceNameConfig()
  local EngineName = G_DeviceName .. "Engine"
  if G_EngineMode == "Android" then
    AndroidFunction(EngineName)
    DebugLogId(string.format("[WebAdress]: %s", G_WebTurl or "18565607913"))
  elseif G_EngineMode == "IOS" then
    IOSFunction(EngineName)
  elseif G_EngineMode == "MacIOS" then
    MacIOSF:Function(EngineName)
  end
  DebugLogId(string.format("[SysParms]: %s", ParmSysParms or "no prams !!!"))
  scriptDeal()
  DebugLogId(string.format("??????:%s--(????Id_???Id_??????)", G_Id))
  DebugLogId("???????:" .. ArguMentList[5])
  DebugLogId("?????°§??:" .. G_SysScpPath)
  DebugLogId(string.format("UU????∑⁄:Bsc%s-Mob%s", UUBscEdt, MobEdt))
  DebugLogId("????∑⁄:" .. tostring(Edition))
  GetAPI_GetDevicesInfo()
  DebugLogId("Test Start..............")
  local sig = GetAPI_signalPath()
  G_sig = sig .. "signal.txt"
  DebugLogId(string.format("????????????: %s", G_sig))
  GetAPI_start_signal_monitor(G_sig, 5)
  if G_USERID and G_USERID ~= "" then
    if File_Exists(G_USERID) then
      ReadTxtToTable(G_USERID, G_mgScriptFlg)
      DebugLogId(string.format("???G_USERID??????%s\t???????????????????G_mgScriptFlg\t", G_USERID))
    else
      DebugLogId(string.format("???G_USERID??????%s\t?????????????????????", G_USERID))
    end
  end
  if G_MonitorSignal and G_EngineMode == "Android" then
    GetAPI_MonitorSignal("start")
  end
  GetAPI_start_signal_monitor(G_sig, 5)
  if ArguMentList[16] and ArguMentList[16] ~= 1 then
    local taskPram = _xsplit(ArguMentList[16], "##")
    DebugLogId(string.format("????????????%s\t(1:????0:?????)\t????????????%s\t(0:????????????:????)", taskPram[12] or "", taskPram[20] or "¶ƒ????"))
    if taskPram[12] and tonumber(taskPram[12]) == 1 then
      if G_EngineMode ~= "Android" then
        error("?????,????????????????")
      end
      local rlog = _cfunc.Command("getprop ro.build.version.release")
      if 5 <= tonumber(string.sub(rlog, 1, 1)) then
        G_RSflag = true
        G_FrameRate = taskPram[13]
        G_BitRate = taskPram[14] or 1
        GetAPI_RecordScreenManager("start", G_FrameRate, G_BitRate, nil, RecordMode)
      else
        DebugLogId(string.format("????ıÙ?????∑⁄(%s)????5.0,?????????????", rlog))
      end
    end
    if taskPram[20] and tonumber(taskPram[20]) ~= 0 then
      if G_EngineMode ~= "Android" then
        error("?????,?????????????????")
      end
      if not File_Exists(string.format("/data/local/tmp/c/mode/%s", "dkjson.lua")) then
        error("?????, /data/local/tmp/c/mode?????json??????Óï")
      end
      local atcId = taskPram[20]
      local rate, loss, delay = ATC_SetIni(atcId)
      DebugLogId(string.format("???????????, {\"atcId\": %s}", atcId))
    end
  end
  if UnInit then
    devcount = Device_SimpleInit()
  else
    devcount = Device_Init(G_Id, G_DeviceName, G_SysParms, UsrParms)
  end
  DebugLogId("devcount=" .. devcount)
  if devcount == 0 then
    if G_EngineMode == "IOS" then
      End()
    end
    return -1
  end
  if SwitchCity then
    Device_SwitchNetwork(G_DeviceName)
  end
  timeOutSet()
  if DebugFlag and G_WebTurl and not G_WebTurl:match("auto") then
    G_timeOut = 30
  end
  TestMode = TestMode or ""
  if G_mgAppTest then
    MgAppTest()
  end
  if ArguMentList[6] == "mob" then
    G_APPscript = 1
    status, err = pcall(APPtestMain, ArguMentList)
  else
    status, err = pcall(MainFunction)
  end
  if status == true then
    DebugLogId("script execute ok")
  else
    DebugLogId("script execute error:" .. err)
    GetSurplusResultTitle()
  end
  if G_EngineMode == "Android" then
    AndroidEnd()
  elseif G_EngineMode == "IOS" then
    End()
  elseif G_EngineMode == "MacIOS" then
    OverIt()
  end
  if not UnInit then
    Device_UnInit(G_Id, G_DeviceName, G_SysParms, UsrParms)
    GetAPI_OpenAutosense()
  end
  GetAPI_CreateDir(G_SysRstPath)
  GetAPI_CreateDir(string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg)
  if G_APPscript ~= 1 then
    GetAPI_logcat("auto_start", APP_PacketName)
    DebugLogId("ß’??????..." .. G_SysRstPath)
    WriteCMValueTable()
  else
    GetAPI_CreateDir(string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg .. "images" .. G_Pflg)
    if G_APPJRscript then
      WriteJRVakueTable(DebugFlag)
    elseif G_APPBLscript then
      WriteBLValueTable("ripper")
    elseif G_APPMonkey then
      WriteBLValueTable("monkey")
    end
  end
  if not DebugFlag then
    Complete(G_SysDbgPath)
  else
    DebugLogId("???????????????...")
  end
  channel_ends()
  return 0
end
local ZXYXDSZ = {ftxtname = nil}
function ZXYXDSZ:_new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function _xnew(tb)
  local proxy = {}
  local mt = {__index = tb}
  setmetatable(proxy, mt)
  return proxy
end
function MacIOSF:key(keyvalue)
  return Key(string.lower(keyvalue))
end
function MacIOSF:init()
  local IOSCALE, IOSPTYPE, IOSPOINT = {}, {}, {}
  IOSCALE = {
    ["iPhone1,1"] = 1,
    ["iPhone1,2"] = 1,
    ["iPhone2,1"] = 1,
    ["iPhone3,1"] = 1,
    ["iPhone6,2"] = 1,
    ["iPhone3,3"] = 2,
    ["iPhone4,1"] = 2,
    ["iPhone5,1"] = 2,
    ["iPhone5,2"] = 2,
    ["iPhone5,3"] = 2,
    ["iPhone5,4"] = 2,
    ["iPhone6,1"] = 2,
    ["iPhone7,2"] = 2,
    ["iPhone8,1"] = 2,
    ["iPhone8,3"] = 2,
    ["iPhone8,4"] = 2,
    ["iPhone9,1"] = 2,
    ["iPhone7,1"] = 3,
    ["iPhone8,2"] = 3,
    ["iPhone9,2"] = 3,
    ["iPhone10,3"] = 3,
    ["iPhone10,6"] = 3,
    ["iPhone10,1"] = 2,
    ["iPhone10,4"] = 2,
    ["iPhone10,2"] = 2.6,
    ["iPhone10,5"] = 2.6
  }
  IOSPTYPE = {
    ["iPhone1,1"] = "iPhone2G",
    ["iPhone1,2"] = "iPhone3G",
    ["iPhone2,1"] = "iPhone3GS",
    ["iPhone3,1"] = "iPhone4",
    ["iPhone3,2"] = "iPhone4",
    ["iPhone3,3"] = "iPhone4",
    ["iPhone4,1"] = "iPhone4S",
    ["iPhone5,1"] = "iPhone5",
    ["iPhone5,2"] = "iPhone5",
    ["iPhone5,3"] = "iPhone5c",
    ["iPhone5,4"] = "iPhone5c",
    ["iPhone6,1"] = "iPhone5s",
    ["iPhone6,2"] = "iPhone5s",
    ["iPhone7,2"] = "iPhone6",
    ["iPhone8,1"] = "iPhone6s",
    ["iPhone8,3"] = "iPhoneSE",
    ["iPhone8,4"] = "iPhoneSE",
    ["iPhone9,1"] = "iPhone7",
    ["iPhone10,4"] = "iPhone8",
    ["iPhone7,1"] = "iPhone6Plus",
    ["iPhone8,2"] = "iPhone6sPlus",
    ["iPhone9,2"] = "iPhone7Plus",
    ["iPhone10,1"] = "iPhone8",
    ["iPhone10,2"] = "iPhone8Plus",
    ["iPhone10,5"] = "iPhone8Plus",
    ["iPhone10,3"] = "iPhoneX",
    ["iPhone10,6"] = "iPhoneX"
  }
  IOSPOINT = {
    ["iPhone1,1"] = 1,
    ["iPhone1,2"] = 1,
    ["iPhone2,1"] = 1,
    ["iPhone3,1"] = 1,
    ["iPhone3,3"] = 2,
    ["iPhone4,1"] = 2,
    ["iPhone8,3"] = 2,
    ["iPhone5,1"] = "320*568",
    ["iPhone5,2"] = "320*568",
    ["iPhone5,3"] = "320*568",
    ["iPhone5,4"] = "320*568",
    ["iPhone6,1"] = "320*568",
    ["iPhone6,2"] = "320*568",
    ["iPhone8,4"] = "320*568",
    ["iPhone7,1"] = "414*736",
    ["iPhone8,2"] = "414*736",
    ["iPhone9,2"] = "414*736",
    ["iPhone10,2"] = "414*736",
    ["iPhone10,5"] = "414*736",
    ["iPhone7,2"] = "375*667",
    ["iPhone8,1"] = "375*667",
    ["iPhone9,1"] = "375*667",
    ["iPhone10,4"] = "375*667",
    ["iPhone10,1"] = "375*667",
    ["iPhone10,3"] = "375*812",
    ["iPhone10,6"] = "375*812",
    ["iPad7,3"] = "834*1112"
  }
  local WDATYPE = DevType()
  self.iScale = IOSCALE[WDATYPE] or 1
  self.iPoint = IOSPOINT[WDATYPE]
  self.WDATYPE = WDATYPE
  self.IOSPOINT = IOSPOINT
  self.IOSPTYPE = IOSPTYPE
  self.IOSCALE = IOSCALE
  self.IMEI = DevCode()
  self.PORT = GetServicePort()
end
function MacIOSF:decodexy(...)
  local scale = self.iScale or 1
  local tmpxy = {}
  for i, v in pairs({
    ...
  }) do
    v = math.ceil(v / scale)
    table.insert(tmpxy, v)
  end
  return table.unpack(tmpxy)
end
function MacIOSF:decodeimg(imgFile, Fcale)
  local Scale = Fcale or self.iScale or 1
  local s1, _, t1, t2, t3, t4 = string.find(imgFile, "(%d+)_(%d+)_(%d+)_(%d+)")
  t1, t2, t3, t4 = math.modf(t1 / Scale), math.modf(t2 / Scale), math.modf(t3 / Scale), math.modf(t4 / Scale)
  return t1, t2, t3 + t1, t4 + t2
end
function MacIOSF:DScreen(touchx, touchy, touchbx, touchby)
  if DScreen then
    local lDScreen = self.IOSPOINT[DScreen]
    local now_iPoint = self.iPoint
    if now_iPoint ~= lDScreen then
      local G_now_width, G_now_height = now_iPoint:match("%d+"), now_iPoint:match("%*(%d+)")
      local temptable = splittable(lDScreen, "*")
      local ntouchx = touchx and math.ceil(touchx * G_now_width / tonumber(temptable[1]))
      local ntouchy = touchy and math.ceil(touchy * G_now_height / tonumber(temptable[2]))
      local ntouchbx = touchbx and math.ceil(touchbx * G_now_height / tonumber(temptable[2]))
      local ntouchby = touchby and math.ceil(touchby * G_now_height / tonumber(temptable[2]))
      DebugLogId(string.format(" %s,%s --> %s,%s\t(nowPoint:%s*%s)", touchx, touchy, ntouchx, ntouchy, G_now_width, G_now_height))
      touchx, touchy, touchbx, touchby = ntouchx, ntouchy, ntouchbx, ntouchby
    else
      DebugLogId(string.format("uniformity of the REC not decode\t%s\t%s", string.format("vim screen : %s", lDScreen), string.format("now screen : %s", now_iPoint)))
    end
  end
  return touchx, touchy, touchbx, touchby
end
function MacIOSF:TouchPIO(touchx, touchy, touchtype, touchdelay)
  touchdelay = touchdelay or 2
  touchtype = (touchtype == 1 or touchtype == 2) and 2 or touchtype == 3 and 1 or touchtype or 1
  touchx, touchy = self:decodexy(touchx, touchy)
  touchx, touchy = self:DScreen(touchx, touchy)
  DebugLogId(string.format("MacIOS.Touch.%s = %s,%s,%s", touchtype, touchx, touchy, touchdelay))
  Touch(touchx, touchy, touchtype, touchdelay)
end
function MacIOSF:MovePIO(touchax, touchay, touchbx, touchby, movtime)
  touchax, touchay, touchbx, touchby = self:decodexy(touchax, touchay, touchbx, touchby)
  touchax, touchay = self:DScreen(touchax, touchay)
  touchbx, touchby = self:DScreen(touchbx, touchby)
  movtime = movtime or 0.1
  DebugLogId(string.format("MacIOS.MOVE (%s,%s)-->(%s,%s)\t%s", touchax, touchay, touchbx, touchby, movtime))
  Move(touchax, touchay, touchbx, touchby, movtime)
end
function MacIOSF:JPEG_fuzzily(imgFile)
  local _, _, m1, m2, m3, m4 = string.find(imgFile, "(%d+)_(%d+)_(%d+)_(%d+)")
  local ax, ay, bx, by = self:DScreen(m1, m2, m3, m4)
  local FimgFile = imgFile:gsub("(%d+)_(%d+)_(%d+)_(%d+)", string.format("%s_%s_%s_%s", ax, ay, bx, by))
  local t1, t2, t3, t4 = self:decodeimg(FimgFile, self.IOSCALE[DScreen])
  local img = string.format("%sFILE/%s_%s_%s_%s_%s.jpeg", G_SysDbgPath, t1, t2, t3, t4, self.WDATYPE:gsub(",", "_"))
  local ret = CaptureRectangle(img)
  DebugLogId(string.format(" fuzzy img: MacRoot%s", img:match(string.format("%s(.*)", dvimei)) or img:match(".*(/.*)")))
  if ret ~= 0 then
    DebugLogId("CaptureRectangle false " .. ret)
    return -1
  end
  local imgret = MatchJPEGFuzzily(imgFile, img)
  DebugLogId(string.format("Capture ret: %s\t%s\tJPEGFuzzily ret: %s", ret or "nil", ret == 0, imgret))
  imgret = math.floor(imgret)
  if imgret >= 0.9 then
    DeleteFile(img)
  end
  return imgret * 100
end
function MacIOSF:JPEG_match(imgFile)
  local dvimei = DebugFlag and "recordDebugPath" or G_DeviceImei
  DebugLogId(string.format("script img: MacRoot%s\t  %s", imgFile:match(string.format("%s(.*)", dvimei)) or imgFile:match(".*(/.*)"), self.iScale or "error ¶ƒ??? IOSCALE ????"))
  local t1, t2, t3, t4 = self:decodeimg(imgFile)
  local img = string.format("%sFILE/%s_%s_%s_%s_%s.jpeg", G_SysDbgPath, t1, t2, t3, t4, self.WDATYPE:gsub(",", "_"))
  local ret = CaptureRectangle(img)
  DebugLogId(string.format(" match img: MacRoot%s", img:match(string.format("%s(.*)", dvimei)) or img:match(".*(/.*)")))
  if ret ~= 0 then
    DebugLogId("CaptureRectangle false " .. ret)
    return -1
  end
  local imgret = MatchJPEG(imgFile, img)
  DebugLogId(string.format("Capture ret: %s\t%s\tMatchJPEG ret: %s", ret or "nil", ret == 0, imgret))
  imgret = math.floor(imgret)
  if imgret == 0 then
    DeleteFile(img)
  end
  return imgret
end
function MacIOSF:MobileNum()
  local devimei, urls = self.IMEI or G_DeviceImei, G_WebTurl
  local bodytb = {
    data = {serial = devimei}
  }
  local NUMurl = "http://autoapi.uusense.com/uapi/agent/getDeviceMobileNumber"
  local retpram = SyncPost(NUMurl, bodytb, 10)
  retpram = retpram or ""
  return retpram:match("mobileNumber%p+.-(%d+).*timestamp") or "null"
end
function MacIOSF:PublicIP(pipurl)
  local port = self.PORT
  local localhost = string.format("http://localhost:%s/wda/uuGet", port)
  local pipurl = pipurl or "http://autoapi.uusense.com/uapi/agent/getip"
  local bodytb = {url = pipurl}
  local retpram = SyncPost(localhost, bodytb, 10)
  local publicIp = retpram:match("ip.-(%d+%.%d+.%d+.%d+)") or retpram or "nil"
  DebugLogId(string.format("PublicIp : %s", retpram:match("response.-(%b{})") or publicIp))
  return publicIp:match("(%d+%.%d+.%d+.%d+)")
end
function MacIOSF:element_process(elmprams)
  local names, values, types, labels, xpaths
  types = elmprams.type ~= "" and elmprams.type
  names = elmprams.name ~= "" and elmprams.name
  values = elmprams.value ~= "" and elmprams.value
  labels = elmprams.label ~= "" and elmprams.label
  xpaths = elmprams.xpath ~= "" and elmprams.xpath
  if not xpaths then
    local xpathStr = string.format("//%s", types)
    xpathStr = names and string.format("%s[@name='%s']", xpathStr, names) or xpathStr
    xpathStr = values and string.format("%s[@value='%s']", xpathStr, values) or xpathStr
    xpathStr = labels and string.format("%s[@label='%s']", xpathStr, labels) or xpathStr
    return xpathStr
  else
    return xpaths
  end
end
function MacIOSF:GetRect(uuid)
  if not uuid then
    return -1
  end
  local rect = GetElementRect(uuid)
  DebugLogId(string.format("MacIOS.Rect\tx:%s y:%s [%s,%s]", rect.x, rect.y, rect.width, rect.height))
  if not rect.x or rect.x < 0 or rect.y < 0 then
    return -1, -1
  end
  local x, y = rect.x + rect.width / 2, rect.y + rect.height / 2
  return x, y
end
function MacIOSF:FindElementX(xpathStr, flg)
  local udid = FindElement("xpath", xpathStr)
  local rect = 1
  if type(udid) == "string" then
    local x, y = self:GetRect(udid)
    if x ~= -1 then
      rect = 0
      if flg then
        DebugLogId(string.format("MacIOS.Element??touch??: %s,%s", x, y))
        Touch(x, y, 1)
      end
    end
  else
    DebugLogId(string.format("error --> FindElement.return: %s", udid))
  end
  return math.floor(rect)
end
function MacIOSF:ActionElements(elmprams, flg)
  if not elmprams.type and not elmprams.xpath then
    return -1
  end
  local rets = -1
  local xpathStr = self:element_process(elmprams)
  DebugLogId(string.format("%s -> %s", xpathStr, flg and "click" or "find"))
  if flg then
    if elmprams.type and elmprams.type:match("Button") then
      rets = FindElementAndClick("xpath", xpathStr)
      DebugLogId(string.format("MacIOS.Element??Click??: %s", rets))
    else
      rets = self:FindElementX(xpathStr, 1)
    end
  else
    rets = self:FindElementX(xpathStr)
    DebugLogId(string.format("MacIOS.Element??Find??: %s", rets))
  end
  return math.floor(rets)
end
function MacIOSF:process_element(elemstr)
  if not elemstr:match("=") then
    return -1
  end
  elemstr = GBKtoUTF(elemstr)
  local emprams = {}
  for k, v in elemstr:gmatch("(.-)=(%b''),?") do
    emprams[k] = v:gsub("'", "")
  end
  return emprams
end
function MacIOSF:Method_ActionEx(strCommand, flg, timeout)
  local view_tab = splittable(strCommand, "|")
  local start_time = GetAPI_OsClock()
  local time_first, touch_time_first, indexi = 0, 0, -1
  local ret = -1
  while true do
    for i = 1, #view_tab do
      local viewi = MacIOSF:process_element(view_tab[i])
      if viewi == -1 then
        ret = 1
        break
      end
      ret, touch_time_first = MacIOSF:ActionElements(viewi, flg)
      local end_time = GetAPI_OsClock()
      time_first = GetAPI_SubTime(end_time, start_time)
      DebugLogId(string.format("???????%s:%s\t???:%s\t%s", timeout and string.format("(%s)", timeout) or "", ret, time_first, ret == 0))
      if not flg then
        indexi = i
      end
      if ret == 0 then
        break
      end
    end
    if flg then
      return ret, time_first
    end
    if ret == 0 then
      if not flg then
        time_first = indexi
      end
      return ret, time_first
    end
    if timeout and time_first >= tonumber(timeout) then
      return 1, timeout
    end
  end
end
function GetOSFlag(str)
  if string.find(string.lower(str), "android") then
    G_EngineMode = "Android"
  elseif string.find(string.lower(str), "mac") then
    G_EngineMode = "MacIOS"
    MacIOSF:init()
    IOSCALE, IOSPTYPE, WDATYPE, IOSPOINT = MacIOSF.iScale, MacIOSF.IOSPTYPE, MacIOSF.WDATYPE, MacIOSF.iPoint
  elseif string.find(string.lower(str), "ios") then
    G_EngineMode = "IOS"
    require("devctl")
    require("ping")
    require("web")
    Start("127.0.0.1")
  else
    error("??????????????")
  end
end
function localToGlobal(tab)
  G_Id = tab[2] .. "_" .. tab[3] .. "_" .. tab[4]
  G_Turnnumber = tab[4]
  G_ScriptID = tab[5]
  G_SysDbgPath = GetAPI_DebugPath()
  G_SysRstPath = GetAPI_ResultPath()
  G_SysEngPath = GetAPI_EnginePicPath()
  G_SysScpPath = GetAPI_ScriptRoot()
  if G_EngineMode == "MacIOS" then
    G_SysDbgPath = G_SysRstPath
    GetAPI_DeleteDir(G_SysDbgPath)
    GetAPI_CreateDir(G_SysRstPath)
    GetAPI_CreateDir(G_SysRstPath .. "/FILE")
    DebugLogId("G_SysRstPath:" .. G_SysRstPath)
  else
    GetAPI_DeleteDir(G_SysDbgPath)
    GetAPI_CreateDir(G_SysDbgPath)
  end
end
function GetDeviceNameConfig()
  local FileDeviceName, DeviceName
  FileDeviceName = GetAPI_DevType()
  G_FileDeviceName = FileDeviceName
  DebugLogId("FileDeviceName: " .. FileDeviceName)
  if G_EngineMode == "Android" then
    DeviceName = "COMMON"
    getVersion()
    if SrcModel.log_file then
      DebugLogId(string.format("now main path: %s", SrcModel.folder))
      local inp = assert(io.open(SrcModel.log_file, "rb"))
      local data = inp:read("*all")
      DebugLogId(string.format([[
X require path: %s
%s]], SrcModel.log_file, data), "require")
      os.remove(SrcModel.log_file)
      DebugLogId(string.format("now cp imgs: %s ", SrcModel.folder))
      for k, v in pairs(SrcModel.model) do
        DebugLogId(string.format("include model %s : %s >>> %s", k, v, G_SysScpPath))
        DebugLogId(string.format("cp %s/%s/*.bmp %s", SrcModel.folder, v, G_SysScpPath))
        os.execute(string.format("cp %s/%s/*.bmp %s", SrcModel.folder, v, G_SysScpPath))
      end
    end
  elseif G_EngineMode == "MacIOS" then
    DeviceName = "MAC"
  elseif G_EngineMode == "IOS" then
    DeviceName = "IPHONE6"
  else
    DebugLogId("??????????????????????ûD??????????????")
  end
  G_RelDeviceName = DeviceName
  return DeviceName
end
function AndroidFunction(tmpEngine)
  local keyword
  AndroidEngineDofile(tmpEngine)
  if G_Reboot then
    Method_Reboot()
  end
  AndroidInit()
  if G_PackageName then
    if G_http_keyword then
      keyword = G_http_keyword
    else
      keyword = ""
    end
    Method_get_http_info(keyword, G_PackageName, 1)
  end
end
function AndroidEngineDofile(tmpEngine)
  local dofileret, err = pcall(function()
    dofile("/data/local/tmp/c/engine/" .. tmpEngine .. ".lua")
  end)
  if dofileret == false then
    DebugLogId("¶ƒ???" .. G_DeviceName .. "????,???®¥???????...")
    DebugLogId("?????????" .. err)
    G_DeviceName = "COMMON"
    dofile("/data/local/tmp/c/engine/COMMONEngine.lua")
  end
end
function GetCfgUrl()
  local filename = "/data/data/com.autosense/files/cfg/setting.cfg"
  local adress = "auto.uusense.com"
  if File_Exists(filename) then
    local file = io.open(filename, "r")
    local Content = file:read("*all")
    file:close()
    adress = Content:match("address=(.-)%c") or adress
  end
  adress = adress:find("autoapi.uusense.com") and "auto.uusense.com" or adress
  return string.format("http://%s", adress:gsub("\n", ""))
end
function AndroidInit()
  if DScreen == nil then
    DScreen = tostring(_cfunc.GetDisplayWidth()) .. "*" .. tostring(_cfunc.GetDisplayHeight())
  end
  local check_address = function(addrestb, address)
    for k, v in pairs(addrestb) do
      if address:match(v) then
        return true
      end
    end
    return false
  end
  local mg_address = {
    "39.156.1.13:9091",
    "39.156.1.70:81",
    "117.174.130.183:9001"
  }
  local sh_address = {
    "183.192.162.187:9091",
    "183.192.162.204:9091"
  }
  G_WebTurl = GetCfgUrl()
  local mg_ret = check_address(mg_address, G_WebTurl)
  local sh_ret = check_address(sh_address, G_WebTurl)
  local ret_flg = mg_ret and "migu.culture" or sh_ret and "migu.video_shanghai" or "auto.uusense"
  DebugLogId(string.format("now project: %s", ret_flg))
  if mg_ret then
    DebugLogId(string.format("MG????∑⁄:Bsc%s-Mob%s", MGBscEdt, MobEdt))
  end
  GetAPI_KillProcess("uiautomator")
  GetAPI_KillProcess("com.uusense.uiautomator2.server")
  GetAPI_KillProcess("tcpdump")
  GetAPI_KillProcess("logcat")
  GetAPI_KillProcess("monkey")
  GetAPI_KillProcess("com.forys.network")
  _cfunc.Command("logcat -c")
  _cfunc.Command("echo > data/anr/traces.txt")
  GetAPI_Switch_input(true)
  GetAPI_DeleteDir("/mnt/sdcard/mobileSense")
  local ret, res = pcall(function()
    local file = io.open("/mnt/sdcard/watchlog.log", "w")
    file:close()
  end)
  if res then
    DebugLogId("watchlog: " .. res)
  end
  local ret, res = pcall(function()
    local file = io.open("/mnt/sdcard/watchlog.txt", "w")
    file:close()
  end)
  if res then
    DebugLogId("watchtxt: " .. res)
  end
  DebugLogId(string.format("UIAutoClick: %s", G_UIAutoClick and "true" or "false"))
  GetAPI_DeleteDir("/mnt/sdcard/AutoManager/")
  GetAPI_DeleteDir("/mnt/sdcard/RecordScreenManager/")
  GetAPI_DeleteDir("/mnt/sdcard/RecordPerformanceInfo/")
  GetAPI_DeleteDir("/storage/emulated/0/richinfodata/")
  _cfunc.Command("rm -rf /mnt/sdcard/AutoManager/")
  _cfunc.Command("rm -rf /mnt/sdcard/RecordScreenManager/")
  _cfunc.Command("rm -rf /mnt/sdcard/RecordPerformanceInfo/")
  _cfunc.Command("rm -rf /storage/emulated/0/richinfodata/")
  local rmMangerf = function()
    local lpath = "/mnt/sdcard/RecordPerformanceInfo/"
    local tmpFiles = getPathFiles(lpath)
    for k, v in ipairs(tmpFiles) do
      if v ~= "" then
        local sourcefile = lpath .. v
        local value = GetAPI_Command(string.format("ls %s -l", sourcefile))
        DebugLogId("ls -l:\t" .. value:gsub("\n", ""))
      end
    end
  end
  _cfunc.Command("rm -rf /mnt/sdcard/packet.log")
  _cfunc.Command("rm -rf /mnt/sdcard/anrlog.txt")
  _cfunc.Command("rm -rf /mnt/sdcard/crashlog.txt")
  _cfunc.Command("rm -rf /mnt/sdcard/packet_log.txt")
  _cfunc.Command("rm -rf /data/local/tmp/.fna*")
end
function IOSFunction(tmpEngine)
  IOSEngineRequire(tmpEngine)
end
function MacIOSF:Function(tmpEngine)
  if self.WDATYPE then
    DebugLogId(string.format("MacIOS???????ßﬂ????%s\tWDATYPE: %s\tfcale:%s\tpoint:%s\tport:%s", tmpEngine, self.WDATYPE, self.iScale or 1, self.iPoint, self.PORT or "nil"))
  else
    error("?????????????¶ƒ???????????????????")
  end
  G_DeviceName = "COMMON"
  require("COMMONEngine")
  G_DeviceImei = GetAPI_DevCode()
  if G_Reboot then
    DebugLogId("MacIOS.RestartDevice()\t?????????????????")
  end
end
function IOSEngineRequire(tmpEngine)
  local dofileret = pcall(function()
    require(tmpEngine)
  end)
  pcall(UnlockScreen)
  if dofileret == false then
    DebugLogId("¶ƒ???" .. G_DeviceName .. "????,???®¥???????...")
    G_DeviceName = "COMMON"
    require(G_DeviceName .. "Engine")
  end
end
function getVersion()
  local version = _cfunc.Command(string.format("dumpsys package com.autosense |grep '%s'", "versionName"))
  local installTime = _cfunc.Command(string.format("dumpsys package com.autosense |grep '%s'", "firstInstallTime"))
  local id = _cfunc.Command(string.format("dumpsys package com.autosense |grep '%s'", "userId"))
  local buildV = _cfunc.Command("getprop ro.build.version.release")
  version = string.match(version, "=(.*)") or ""
  installTime = string.match(installTime, "=(.*)") or "00:00"
  version = string.gsub(version, "\n", "")
  installTime = string.gsub(installTime, "\n", "")
  id = string.gsub(id, "    ", "") or ""
  DebugLogId(string.format("??AutoSense?? version: %s  installtime: %s", version, installTime))
  local uptime = _cfunc.Command(string.format("uptime"))
  DebugLogId(string.format(" %s", uptime:gsub("\n", "") or ""))
  G_Id = string.format("%s_%s", G_Id, buildV:gsub("\n", "") or "")
  DebugLogId(string.format(" %s\t  ver: %s", id:gsub("\n", ""), buildV:gsub("\n", "") or ""))
end
function timeOutSet()
  if Time_Wait_2G ~= nil and Time_Wait_2G ~= 0 then
    if GetAPI_NetFlag() == "2G" then
      G_timeOut = Time_Wait_2G
    end
  elseif Time_Wait_3G ~= nil and Time_Wait_3G ~= 0 then
    if GetAPI_NetFlag() == "3G" then
      G_timeOut = Time_Wait_3G
    end
  elseif Time_Wait_4G ~= nil and Time_Wait_4G ~= 0 then
    if GetAPI_NetFlag() == "4G" then
      G_timeOut = Time_Wait_4G
    end
  elseif Time_Wait_Wifi ~= nil and Time_Wait_Wifi ~= 0 and (GetAPI_NetFlag() == "WIFI" or GetAPI_NetFlag() == "LAN") then
    G_timeOut = Time_Wait_Wifi
  end
end
function AndroidEnd()
  local keyword
  local vocpath = string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg
  if G_RSflag then
    GetAPI_RecordScreenManager()
    cpdir(string.format("%s%sscreen%s", string.sub(G_SysDbgPath, 1, -2), G_Pflg, G_Pflg), string.format("%sscreen%s", vocpath, G_Pflg))
  end
  if G_Perfsflag then
    Method_PerformanceManager()
    cpdir(string.format("%s%sperfs%s", string.sub(G_SysDbgPath, 1, -2), G_Pflg, G_Pflg), string.format("%sperfs%s", vocpath, G_Pflg))
  end
  if G_PackageName or G_mgKVURl then
    keyword = G_http_keyword or ""
    pcall(CopyFile, "/mnt/sdcard/packet_log.txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "packet_log.txt")
  end
  if G_TraceRoute then
    pcall(CopyFile, "/mnt/sdcard/traceroute.txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "traceroute.txt")
  end
  if G_fail_flag == true then
    _cfunc.Command("logcat -d -v time -f " .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "logcat.txt")
    _cfunc.Command("dmesg > " .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "kernel_log.txt")
    pcall(CopyFile, "/data/anr/traces.txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "traces.txt")
  end
  if G_logcat_flag == true then
    _cfunc.Command("logcat -d -v time -f " .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "logcat.txt")
  end
  DebugLogId(string.format("??????????????"))
  DebugLogId("????????????...")
  if G_packetflag == true then
    GetAPI_KillProcess("tcpdump")
    GetAPI_KillProcess("com.forys.network")
    GetAPI_Switch_input()
  end
  local lsfs = _cfunc.Command(string.format("ls %s -l", G_SysDbgPath))
  DebugLogId(string.format([[
result files(%s):
%s]], G_SysDbgPath, lsfs))
  GetAPI_KillProcess("logcat")
  _cfunc.Command("rm /data/data/com.autosense/files/vm2*.log")
  GetAPI_KillProcess("uiautomator")
  GetAPI_KillProcess_byPID("uiautomator")
  G_click_view = false
  G_check_view = false
end
function OverIt()
  DebugLogId("????????????...")
end
function cpdir(spath, epath)
  local tmpfiles = getPathFiles(spath)
  if #tmpfiles > 0 then
    _cfunc.Command(string.format("mkdir -p %s", epath))
    for k, v in pairs(tmpfiles) do
      if string.find(v, "mp4") or string.find(v, "csv") or string.find(v, "txt") then
        if string.find(v, "mp4") then
          DebugLogId(string.format("?????: CP %s  >>>  %s", v, epath))
        else
          DebugLogId(string.format("??????: CP %s  >>>  %s", v, epath))
        end
        _cfunc.Command(string.format("cp %s%s %s%s", spath, v, epath, v))
      end
    end
  end
end
function MgAppTest()
  local mgPath = "/data/local/tmp/mgapp"
  local mgfile = "/data/local/tmp/mgapp.txt"
  if tonumber(G_Turnnumber) == 1 then
    pcall(GetAPI_Deletefile(mgfile))
    local cmd = string.format("ls %s/*.apk > %s", mgPath, mgfile)
    _cfunc.Command(cmd)
    DebugLogId(string.format("mgApp Testing file save :%s", mgfile))
  end
  if File_Exists(mgfile) then
    local apkName = getFileFirst(mgfile)
    G_TmpValue = apkName:match("^.*/(.*)")
    local pkgname = G_mgAppTest
    local ret = CheckPKG(pkgname)
    if ret == 0 then
      DebugLogId(string.format("app -> %s ????,???ßÿ?? ", pkgname))
      local ret, status = AppUnInstall(pkgname)
      if ret ~= 0 then
        DebugLogId(string.format("App uninstall FAILED !!!!!!! %s", pkgname))
      end
    else
      DebugLogId(string.format("APP %s ¶ƒ???,???????ßÿ???", pkgname))
    end
    local sclock = GetAPI_OsClock()
    local pkgpath = string.format("%s", apkName)
    DebugLogId(string.format("App install start??%s ", pkgpath))
    local ret, log = AppInstall(pkgpath, pkgname)
    if ret == 0 then
      local installtime = GetAPI_SubTime(GetAPI_OsClock(), sclock)
      DebugLogId(string.format("App install time :%s ret:%s.", installtime, ret))
    else
      DebugLogId("App install failed exit test !")
    end
  else
    DebugLogId(string.format("??????app?ß“?????????????????????????%s", mgfile))
  end
end
function getFileFirst(file)
  local t = {}
  for line in io.lines(file) do
    table.insert(t, line)
    DebugLogId("????????????" .. line)
  end
  local list = table.remove(t, 1)
  local debu = io.open(file, "w")
  debu:write(table.concat(t, "\n"))
  debu:close()
  return list
end
function Complete(file)
  if G_EngineMode ~= "MacIOS" then
    GetAPI_DeleteDir(file)
  end
  pcall(GetAPI_Deletefile, "/mnt/sdcard/watchlog.log")
  pcall(GetAPI_Deletefile, "/mnt/sdcard/watchlog.txt")
  pcall(GetAPI_Deletefile, "/mnt/sdcard/anrlog.txt")
  pcall(GetAPI_Deletefile, "/mnt/sdcard/crashlog.txt")
end
function scriptDeal()
  local scriptcontent = GetAPI_ScriptContent()
  local ScriptList = splittable(scriptcontent, "\n")
  for i = 1, #ScriptList do
    local ret1, ret2, ret3, ret4, TempRet
    ScriptList[i] = string.gsub(ScriptList[i], "\n", "")
    ScriptList[i] = string.gsub(ScriptList[i], "\r", "")
    ScriptList[i] = string.gsub(ScriptList[i], "CycAction", "ScriptAction")
    ret1, ret2 = string.find(ScriptList[i], "%-%-")
    if ret2 then
      local ret5
      if string.sub(ScriptList[i], ret2 + 1, ret2 + 2) == "[[" then
        for j = i, #ScriptList do
          if j == i then
            _, ret4, _ = string.find(ScriptList[j], "]]")
            if ret4 then
              ScriptList[j] = string.sub(ScriptList[j], 1, ret1 - 1) .. string.sub(ScriptList[j], ret4 + 1, -1)
              break
            else
              ScriptList[j] = string.sub(ScriptList[j], 1, ret1 - 1)
            end
          elseif findword(ScriptList[j], "]]") then
            _, ret3, _ = string.find(ScriptList[j], "]]")
            ScriptList[j] = string.sub(ScriptList[j], ret3 + 1, -1)
            break
          else
            ScriptList[j] = ""
          end
        end
      end
      ret5, _, _ = string.find(ScriptList[i], "%-%-")
      if ret5 and string.sub(ScriptList[i], ret2 + 1, ret2 + 2) ~= "[[" then
        ScriptList[i] = string.sub(ScriptList[i], 1, ret5 - 1)
      end
    end
    TempRet = string.find(ScriptList[i], "}")
    if TempRet then
      ScriptList[i] = string.sub(ScriptList[i], 1, TempRet)
    end
  end
  G_ScriptList = ScriptList
end
function Serv_ALL_OneAction(G_DeviceName, OneActionList, step)
  local Titletab, RelTitletab, NewOneTagList, NewOneActionList, DoAffActionList, AffActionList, TestTime, StaSetp
  local DlLcTb = {}
  local tempflag = false
  local vm2time
  G_FuzzyFlag = false
  G_area = 0
  G_CMVouc = ""
  G_NETSENSE = ""
  G_CMDNSVouc = ""
  G_CMPNVouc = ""
  for i = 1, #OneActionList do
    if string.match(OneActionList[i][1], "VIDEO],") then
      Vid_Test = true
      DebugLogId("?????????????")
      vm2time = os.time()
      GetAPI_VM2_Start()
      G_vm2time = os.time()
      break
    end
  end
  if os.date("%Y%m%d%H%M%S", vm2time) ~= os.date("%Y%m%d%H%M%S", G_vm2time) then
    G_vm2timeflag = true
  end
  Titletab, RelTitletab, NewOneTagList, NewOneActionList, AffActionList, TestTime, StaSetp = PrevAction(OneActionList)
  local oneastart = GetAPI_OsClock()
  DebugLogId("##############################################################################################")
  local x = 1
  while x <= #Titletab do
    DebugLogId("???????" .. x .. ":" .. Titletab[x])
    x = x + 1
  end
  DebugLogId("##############################################################################################")
  local ResultTable, picidx, retsetp, LastResultTable, failpos, retlen
  local ret = 0
  local Jumptimes, nowtimes = 3, 0
  local jumpstep, falseflag, allflag, jumpflag
  local templist, temptable = {}, {}
  local scriptaction = {}
  local tempconcent, reta
  local retc = 0
  if G_scriptflag then
    templist = ReBuiltList(G_ScriptList, "ScriptAction")
    for i = 1, #templist do
      if templist[i] ~= "" then
        table.insert(scriptaction, templist[i])
      end
    end
    tempconcent = scriptaction[G_scriptactionID]
    temptable = splittable(tempconcent, ",")
    for i = 1, #temptable do
      temptable[i] = string.gsub(temptable[i], "{", "")
      temptable[i] = string.gsub(temptable[i], "}", "")
      temptable[i] = Strip(temptable[i])
    end
    if G_ExactionID then
      templist, reta = ReBuiltList(G_ScriptList, temptable[3])
    elseif G_ReActionID then
      templist, reta = ReBuiltList(G_ScriptList, temptable[4])
    else
      templist, reta = ReBuiltList(G_ScriptList, temptable[2])
    end
  elseif G_Oderflag == 1 then
    templist, reta = ReBuiltList(G_ScriptList, "BusinessActionA")
  elseif G_Oderflag == 2 then
    templist, reta = ReBuiltList(G_ScriptList, "BusinessActionB")
  else
    templist, reta = ReBuiltList(G_ScriptList, "BusinessActionA")
  end
  local i = 1
  while i <= #NewOneActionList do
    local scriptcontent = ""
    local jumpflag, BackFlag
    local retb = 0
    DebugLogId("##############################################################################################")
    DebugLogId("--------------------------------------??????????--------------------------------------------")
    DebugLogId(string.format("????????idx:%s\ttag:%s\t%s\t%s\t%s", i, NewOneTagList[i], NewOneActionList[i][1], NewOneActionList[i][2], NewOneActionList[i][3]))
    BackFlag = NewOneActionList[i][3]
    for j = 1, #NewOneActionList[i] do
      scriptcontent = scriptcontent .. ",[" .. NewOneActionList[i][j] .. "]"
    end
    scriptcontent = "{\"[" .. NewOneTagList[i] .. "]" .. scriptcontent .. "\"}"
    failpos, retlen, NewOneActionList[i][3] = CheckPicLine(NewOneActionList[i][3])
    local commantitle = NewOneActionList[i][4]
    if G_mgAppTest and G_TmpValue and string.find(commantitle, "%b<>") then
      local AppTitle = string.gsub(G_TmpValue, ".apk", "")
      local endtitle = string.format("<%s%s>", commantitle:sub(2, -2), AppTitle)
      NewOneActionList[i][4] = endtitle
    end
    if G_coordinate and string.find(NewOneActionList[i][1], "TRAVERSE") then
      DebugLogId("???????????" .. #G_coordinate)
      ret, ResultTable, picidx = cycRunOneCommand(i, G_coordinate, NewOneActionList[i], failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
    else
      ret, ResultTable, picidx = RunTestOneCommand(i, NewOneActionList[i], failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
    end
    if G_loop_flag == 1 and G_loop then
      G_i = i
    elseif G_loop_flag == 2 and G_loop then
      i = G_i
    end
    G_loop_flag = 0
    i = FindNextIdx(i, NewOneTagList, picidx)
    if NewOneActionList[i] and NewOneActionList[i][1] == "JUMPTO" then
      if tonumber(NewOneActionList[i][3]) then
        Jumptimes = tonumber(NewOneActionList[i][3])
      end
      if tonumber(NewOneActionList[i][2]) then
        jumpstep = tonumber(NewOneActionList[i][2])
      elseif string.sub(NewOneActionList[i][2], 1, 1) == "Y" then
        jumpstep = tonumber(string.sub(NewOneActionList[i][2], 2, -1))
      elseif string.sub(NewOneActionList[i][2], 1, 1) == "N" then
        jumpstep = tonumber(string.sub(NewOneActionList[i][2], 2, -1))
        falseflag = true
      elseif string.sub(NewOneActionList[i][2], 1, 1) == "A" then
        jumpstep = tonumber(string.sub(NewOneActionList[i][2], 2, -1))
        allflag = true
      end
      if allflag then
        ret = 0
        jumpflag = true
      elseif falseflag then
        if ret ~= 0 then
          ret = 0
          jumpflag = true
        end
      elseif ret == 0 then
        jumpflag = true
      end
      if jumpflag then
        if nowtimes < Jumptimes then
          i = jumpstep
          nowtimes = nowtimes + 1
          DebugLogId("?????????:" .. jumpstep)
        else
          i = FindNextIdx(i, NewOneTagList, 0)
        end
      end
    end
    if not i or ret ~= 0 then
      break
    end
    DebugLogId("##############################################################################################")
  end
  local oneaend = GetAPI_OsClock()
  local needwait
  if TestTime > GetAPI_SubTime(oneaend, oneastart) then
    needwait = TestTime - (oneaend - oneastart)
    DebugLogId("???????" .. TestTime .. "?????????" .. oneaend - oneastart .. "????????" .. needwait .. "??")
    GetAPI_Sleep(needwait)
  end
  if tempflag then
    OneActionList[1][1] = tempflag
  end
  if Vid_Test then
    GetAPI_VM2_Stop()
    Vid_Test = false
  end
  return ret, retsetp
end
function cycRunOneCommand(i, table, NewOneActionList, failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
  local ret = 0
  local ResultTable = {}
  local picidx = 0
  G_cyc_traverse = true
  for xx = 1, #table do
    if type(table[xx][1]) == "table" then
      G_flag_traverse = false
      cycRunOneCommand(i, table[xx], NewOneActionList, failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
    elseif not G_flag_traverse then
      G_CMVouc = ""
      NewOneActionList[2] = string.format(NewOneActionList[2], table[xx][1])
      NewOneActionList[4] = string.format(NewOneActionList[4], table[xx][2])
      ret, ResultTable, picidx = RunTestOneCommand(i, NewOneActionList, failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
      NewOneActionList[2] = string.gsub(NewOneActionList[2], table[xx][1], "%%s")
      NewOneActionList[4] = string.gsub(NewOneActionList[4], table[xx][2], "%%s")
      if G_flag_traverse then
        break
      end
    end
  end
  G_cyc_traverse = false
  return ret, ResultTable, picidx
end
function RunTestOneCommand(i, NewOneActionList, failpos, retlen, BackFlag, AffActionList, RelTitletab, scriptcontent, templist, retc, retb, reta)
  G_position1 = nil
  G_position2 = nil
  G_ActionElement = nil
  ret, ResultTable, picidx = DealOneCommand(NewOneActionList)
  picidx = picidx or 0
  if failpos == "1" then
    if ret == 0 and picidx ~= 0 then
      picidx = picidx + 1
    else
      picidx = 1
    end
    ret = 0
  elseif failpos == "2" then
    if ret ~= 0 then
      picidx = retlen
    end
    ret = 0
  end
  NewOneActionList[3] = BackFlag
  ResultTable[2] = ret
  picidx = tostring(picidx)
  DebugLogId("???????ret:" .. ret .. "\t(0=???,????=???)\tpicidx:" .. picidx)
  DebugLogId("--------------------------------------???????????--------------------------------------------")
  if ret == 0 and G_failflag == false then
    DoAffActionList, AffActionList = GetAffAction(i, AffActionList)
    if #DoAffActionList ~= 0 then
      DebugLogId("--------------------------------------??????????????--------------------------------------------")
      x = 1
      while x <= #DoAffActionList do
        DebugLogId("????????idx:" .. i .. "\taffidx:" .. x)
        ret = DealOneCommand(DoAffActionList[x])
        DebugLogId("??????????????ret:" .. ret)
        if ret ~= 0 then
          break
        end
        x = x + 1
      end
      if ret ~= 0 then
        ret = 5
        DebugLogId("??????????????,??ß’??????ret:" .. ret)
      else
        DebugLogId("??????????ß‘??,?????ß’??????ret:" .. ret)
      end
      DebugLogId("--------------------------------------???????????????--------------------------------------------")
      ResultTable[2] = ret
    end
  elseif ret ~= 0 and G_failflag == true then
    DoAffActionList, AffActionList = GetAffAction(i, AffActionList)
    if #DoAffActionList ~= 0 then
      DebugLogId("--------------------------------------??????????????--------------------------------------------")
      x = 1
      while x <= #DoAffActionList do
        DebugLogId("????????idx:" .. i .. "\taffidx:" .. x)
        ret = DealOneCommand(DoAffActionList[x])
        DebugLogId("??????????????ret:" .. ret)
        if ret ~= 0 then
          break
        end
        x = x + 1
      end
      if ret == 0 then
        ret = 5
        DebugLogId("??????????ß‘??,??ß’???ret:" .. ret)
      else
        DebugLogId("??????????????,????ß’??????ret:" .. ret)
      end
      DebugLogId("--------------------------------------???????????????--------------------------------------------")
      ResultTable[2] = ret
    end
  end
  DebugLogId("--------------------------------------??????????--------------------------------------------")
  if G_INIFalse then
    if ret == 0 then
      DebugLogId("????????,?????ini????...")
    elseif G_INIContList then
      local inicont
      for a = 1, #G_INIContList do
        if not inicont then
          inicont = G_INIContList[a]
        else
          inicont = inicont .. "\t" .. G_INIContList[a]
        end
      end
      local bakfile = io.open("/data/local/tmp/c/fail.txt", "a")
      bakfile:write(inicont .. "\n")
      bakfile:close()
      G_INIFalse = nil
      DebugLogId("ini??????...")
    else
      DebugLogId("ini???????¶ƒ???...")
    end
  end
  if G_APPscript and G_EngineMode ~= "IOS" then
    DebugLogId(string.format("????????????? %s ????????", i))
    JRWriteResult(ResultTable, i, NewOneActionList)
    if ret == 0 then
      retc = DeleteScript(scriptcontent, templist, i - retc, retc)
    else
      retb = FindScriptID(templist, i - retc)
      local errlog = string.format("ScriptErrorRow(%s): near the %s line Error??Script Content??%s", retb + reta, retb + reta, scriptcontent)
      if G_RSflag then
        VoucRecordScreen()
      end
      DebugLogId(errlog)
      if G_cyc_traverse == true then
        ret = reset()
      end
    end
  else
    RelTitletab = TableRemoveTitle(ResultTable[1], RelTitletab)
    if ret == 0 then
      retc = DeleteScript(scriptcontent, templist, i - retc, retc)
      CMWriteResultLog(ResultTable, {}, LastResultTable)
    else
      retb = FindScriptID(templist, i - retc)
      DebugLogId("ScriptErrorRow(" .. retb + reta .. "):??" .. retb + reta .. "?ßﬂ?????????:" .. scriptcontent, "???????")
      CMWriteResultLog(ResultTable, RelTitletab, LastResultTable)
      if G_cyc_traverse == true then
        ret = reset()
      end
    end
  end
  DebugLogId("--------------------------------------???????????--------------------------------------------")
  LastResultTable = ResultTable
  G_position1 = nil
  G_position2 = nil
  G_ActionElement = nil
  return ret, ResultTable, picidx
end
function JRWriteResult(ResultTable, i, NewOneActionList)
  local ActionEvent = NewOneActionList[1]
  if ResultTable[2] == 0 then
    resultRet = "ture"
  else
    resultRet = "false"
  end
  local oneResultTb = ResultTable[3]
  local ActionSTime = os.date("%Y-%m-%d %H:%M:%S", ResultTable[4])
  local ActionETime = os.date("%Y-%m-%d %H:%M:%S", ResultTable[5])
  local picname
  local tmpstr = string.format("%simages/shot.jpg", G_SysDbgPath)
  if File_Exists(tmpstr) then
    picname = i and string.format("%s_%s.jpg", os.date("%Y-%m-%d_%H%M%S", ResultTable[5]), i) or string.format("%s_.jpg", os.date("%Y-%m-%d_%H%M%S", ResultTable[5]))
    local tmpstr = string.format("%simages/%s", G_SysDbgPath, picname)
    local tmpPng = string.format("mv %simages/shot.jpg %s", G_SysDbgPath, tmpstr)
    local aa = _cfunc.Command(tmpPng)
  end
  local ActionImg = picname or ""
  DebugLogId(ActionImg)
  local ActionElement = G_ActionElement or "????"
  local position1 = G_position1 or ""
  local position2 = G_position2 or ""
  JRResult(ActionEvent, ActionSTime, ActionElement, ActionImg, resultRet, position1, position2)
end
function JRResult(event, time, element, img, result, position1, position2)
  local actionResult = string.format("event=\"%s\" time=\"%s\" element=\"%s\" img=\"%s\" result=\"%s\" value=\"\" position1=\"%s\" position2=\"%s\"", event, time, element, img, result, position1, position2)
  actionResult = string.format("<action %s />", actionResult)
  table.insert(G_JRResultXml, #G_JRResultXml - 1, actionResult)
  DebugLogId(actionResult)
end
function reset()
  G_flag_traverse = true
  local ret = -1
  for i = 1, 7 do
    r2 = _cfunc.FetchCharPoint()
    if G_r1 == r2 then
      ret = 0
      break
    else
      DebugLogId("???????????B??")
      GetAPI_Key("B", 3, 1)
    end
  end
  return ret
end
function Serv_OrderAndCancel(G_DeviceName, OrderCommandList, CancleCommandList)
  local ret, step
  G_Oderflag = 1
  ret, step = Serv_ALL_OneAction(G_DeviceName, OrderCommandList, step)
  DebugLogId("???????ret:" .. ret)
  if ret == 0 then
    OrderedFlag = true
  else
    OrderedFlag = false
  end
  if string.match(CancleCommandList[1][1], ",%[#") then
    CancleCommandList[1][1] = string.gsub(CancleCommandList[1][1], ",%[#", ",%[")
    step = nil
  end
  if not step then
    DebugLogId("????????????????")
    Device_SecondInit(G_DeviceName)
  end
  G_Oderflag = 2
  ret = Serv_ALL_OneAction(G_DeviceName, CancleCommandList, step)
  DebugLogId("???????ret:" .. ret)
  return ret
end
function Serv_Action(G_DeviceName, actionTab, stepflag)
  local i = 1
  local indexlist = {}
  local ProcessTab = actionTab
  local FailFlag, ret, wrflag, breakflag, tmpvc, CycFlag
  local ii = 1
  local URLTba
  local j = 1
  local idx = 1
  local errflag, rex
  G_scriptflag = true
  while i <= #ProcessTab do
    table.insert(indexlist, string.upper(ProcessTab[i][1]))
    i = i + 1
  end
  if stepflag and stepflag == "Y" then
    DebugLogId("??????,?????????....")
    if string.upper(TestMode) == "MONITOR" then
      URLTba = GetTestContent()
    else
      if G_Turnnumber == "1" then
        URLTba = GetTestContent()
        WriteTestLog(URLTba)
      end
      URLTba = GetTestLog()
    end
    if #URLTba == 0 then
      DebugLogId("?????????...")
      GetAPI_Sleep(60)
      return 0
    end
    DebugLogId("?????????....")
    CycFlag = #URLTba
    G_CycUrl = URLTba[ii]
    DebugLogId(G_CycUrl)
  end
  while j <= #indexlist do
    G_scriptactionID = j
    if stepflag and stepflag == "Y" and j == 1 then
      DebugLogId("????????" .. idx .. "??...")
      idx = idx + 1
    end
    if breakflag then
      DebugLogId("???" .. indexlist[j] .. "?????????")
      tmpvc = WriteTitleTab(ProcessTab[j][2], tmpvc)
      j = j + 1
      if j > #indexlist and CycFlag and CycFlag > 1 then
        j = 1
        breakflag = nil
        ii = ii + 1
        G_CycUrl = URLTba[ii]
        CycFlag = CycFlag - 1
      end
    else
      DebugLogId("??????:" .. indexlist[j])
      if ProcessTab[j][2] and 0 < #ProcessTab[j][2] then
        G_ExactionID = false
        G_ReActionID = false
        ret = Serv_ALL_OneAction(G_DeviceName, ProcessTab[j][2])
      else
        ret = -1
        errflag = true
        DebugLogId("Action??????,????Action????", "???????")
      end
      if ret ~= 0 then
        if not ProcessTab[j][4] or errflag then
          DebugLogId("??????????????????ß⁄???")
          ret = -1
        else
          for k = 1, 2 do
            G_ReActionID = true
            G_ExactionID = false
            DebugLogId("???????????")
            if G_FileName then
              DebugLogId("??????????????????????????!")
              GetAPI_perf_monitor(nil, nil, 1)
              G_FileName = nil
            end
            ret = Serv_ALL_OneAction(G_DeviceName, ProcessTab[j][4])
            if ret == 0 then
              DebugLogId("?????" .. k .. "?¶»???")
              G_ReActionID = false
              G_ExactionID = false
              ret = Serv_ALL_OneAction(G_DeviceName, ProcessTab[j][2])
              DebugLogId("????????" .. ret)
              if ret == 0 then
                break
              end
            else
              DebugLogId("????????????????????????ß⁄???")
              ret = -1
              break
            end
          end
        end
        if ret ~= 0 then
          if not ProcessTab[j][3] or ProcessTab[j][3] == "" or errflag then
            DebugLogId("??????????????????????...??????!")
            breakflag = true
          else
            FailFlag = true
            DebugLogId("??????" .. indexlist[j])
            if ProcessTab[j][3] and 0 < #ProcessTab[j][3] then
              for ii = 1, 3 do
                DebugLogId("??????" .. indexlist[j] .. "\t??" .. ii .. "?¶¬???")
                if G_FileName then
                  DebugLogId("?????????????????????!")
                  GetAPI_perf_monitor(nil, nil, 1)
                  G_FileName = nil
                end
                G_ReActionID = false
                G_ExactionID = true
                ret = Serv_ALL_OneAction(G_DeviceName, ProcessTab[j][3])
                if ret == 0 then
                  break
                else
                  DebugLogId("??????" .. indexlist[j])
                end
              end
            else
              ret = -1
              errflag = true
              DebugLogId("Action??????,????Action????", "???????")
            end
            if ret ~= 0 then
              breakflag = true
            else
              local k, t, tmpvc
              t = j
              k = FindNextIdxEX(j, indexlist, true)
              while true do
                t = FindNextIdxEX(t, indexlist, false)
                if t == k then
                  break
                else
                  tmpvc = WriteTitleTab(ProcessTab[t][2], tmpvc)
                end
              end
            end
          end
        end
        G_VideoUrl_cnt = G_VideoUrl_input_cnt
      end
      if breakflag then
        FailFlag = false
        j = j + 1
        if j > #indexlist and CycFlag and CycFlag > 1 then
          j = 1
          ii = ii + 1
          G_CycUrl = URLTba[ii]
          CycFlag = CycFlag - 1
          breakflag = nil
        end
      else
        j = FindNextIdxEX(j, indexlist, FailFlag)
        if j > #indexlist and CycFlag and CycFlag > 1 then
          j = 1
          ii = ii + 1
          G_CycUrl = URLTba[ii]
          CycFlag = CycFlag - 1
        end
        FailFlag = false
      end
    end
  end
  return ret
end
function CompTag(lasttag, nexttag, picidx)
  local lastlen = string.len(lasttag)
  local nextlen = string.len(nexttag)
  local retval
  local idxtab = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  }
  if lastlen < nextlen then
    if lasttag .. tostring(idxtab[tonumber(picidx)]) == nexttag then
      retval = true
    else
      retval = false
    end
  elseif lastlen > nextlen then
    if string.sub(lasttag, 1, nextlen) == nexttag then
      retval = true
    else
      retval = false
    end
  elseif lasttag == nexttag then
    retval = true
  else
    retval = false
  end
  return retval
end
function CompTagEX(lasttag, nexttag)
  local lastlen = string.len(lasttag)
  local nextlen = string.len(nexttag)
  local temptag, retval
  local i = -2
  local j, ret
  ret = FindStrAndNum(lasttag, nexttag)
  if ret then
    retval = true
  else
    while i >= -lastlen do
      temptag = string.sub(lasttag, 1, i)
      ret = FindStrAndNum(temptag, nexttag)
      if ret then
        retval = true
        break
      end
      i = i - 1
    end
  end
  return retval
end
function FindNextIdx(lasti, NewOneTagList, picidx)
  local lasttag
  lasttag = NewOneTagList[lasti]
  local nexttag
  lasti = lasti + 1
  while lasti <= #NewOneTagList do
    nexttag = NewOneTagList[lasti]
    if CompTag(lasttag, nexttag, picidx) then
      return lasti
    end
    lasti = lasti + 1
  end
  return
end
function FindNextIdxEX(lasti, NewOneTagList, FailFlag)
  local lasttag
  lasttag = NewOneTagList[lasti]
  local nexttag
  if not FailFlag then
    nexti = lasti + 1
    while nexti <= #NewOneTagList do
      nexttag = NewOneTagList[nexti]
      if string.upper(nexttag) >= string.upper(lasttag) then
        return nexti
      end
      nexti = nexti + 1
    end
  else
    nexti = lasti + 1
    while nexti <= #NewOneTagList do
      nexttag = NewOneTagList[nexti]
      if CompTagEX(lasttag, nexttag) then
        break
      end
      nexti = nexti + 1
    end
  end
  return nexti
end
function GetAffAction(nowi, AffActionList)
  local DoAffActionList = {}
  local i = 1
  while i <= #AffActionList do
    if nowi > AffActionList[i][1] then
      table.remove(AffActionList, i)
      i = i - 1
    elseif nowi == AffActionList[i][1] then
      table.remove(AffActionList[i], 1)
      table.insert(DoAffActionList, AffActionList[i])
      table.remove(AffActionList, i)
      i = i - 1
    end
    i = i + 1
  end
  return DoAffActionList, AffActionList
end
function CheckPicLine(InPics)
  local tmptb, tmpstr
  local failpos = "0"
  local retInPics, retlen
  tmptb = splittable(InPics, ",")
  tmpstr = tmptb[1]
  retlen = #splittable(tmpstr, "|")
  if string.sub(tmpstr, 1, 1) == "|" then
    failpos = "1"
    retInPics = string.sub(tmpstr, 2, -1)
  elseif string.sub(tmpstr, -1, -1) == "|" then
    failpos = "2"
    retInPics = string.sub(tmpstr, 1, -2)
  else
    retInPics = InPics
  end
  if failpos ~= "0" and tmptb[2] then
    retInPics = retInPics .. "," .. tmptb[2]
  end
  return failpos, retlen, retInPics
end
function TableRemoveTitle(RemoveTitle, Titletab)
  local ArguMentList, temptab
  local i = 1
  local removetab = {}
  if string.find(RemoveTitle, "+") then
    RemoveTitle = string.gsub(RemoveTitle, "+%d", "")
  end
  ArguMentList = splittable(RemoveTitle, "|")
  while i <= #ArguMentList do
    for j = 1, #Titletab do
      temptab = splittable(Titletab[j], "\t")
      if temptab[1] == ArguMentList[i] then
        if not InTable(j, removetab) then
          table.insert(removetab, j)
        end
        DebugLogId("???:" .. ArguMentList[i] .. ",?????????????????!")
      end
    end
    i = i + 1
  end
  table.sort(removetab)
  i = #removetab
  while i > 0 do
    table.remove(Titletab, removetab[i])
    i = i - 1
  end
  return Titletab
end
function WriteTitleTab(ActionTab, tmpvc, ResultContent)
  local Titletab
  local i = 1
  local ResultTable
  local cmflag = "N4"
  if ActionTab and #ActionTab > 0 then
    _, Titletab = PrevAction(ActionTab)
  else
    DebugLogId("Action??????,????Action????", "???????")
  end
  cmflag = ResultContent or cmflag
  _, ResultTable = MulitiMethod("Device_Title", cmflag, "", "", 1)
  if Titletab and #Titletab > 0 then
    CMWriteResultLog(ResultTable, Titletab)
  end
  return tmpvc
end
function rminterval(perfiles)
  local perfActions = ReadFileToTable(perfiles)
  local tmpname = {}
  for k, v in pairs(perfActions) do
    local Odatatb = _xsplit(v, "\t")
    local tmptb = {}
    tmptb.name = Odatatb[2]
    tmptb.value = Odatatb
    table.insert(tmpname, tmptb)
  end
  local vname = {}
  for k, v in pairs(tmpname) do
    table.insert(vname, v.name)
  end
  for i, s in ipairs(vname) do
    local ti = 0
    for k, v in pairs(tmpname) do
      if s == v.name then
        ti = ti + 1
      end
    end
    if ti > 1 then
      table.remove(tmpname, i)
    end
  end
  perfActions = tmpname
  for k, v in pairs(perfActions) do
    perfActions[k] = table.concat(v.value, "\t")
    DebugLogId(string.format("??????? [%s]:\t%s", k, v.value[2]))
  end
  wrfile(perfiles, perfActions, "\n")
end
function PrevAction(OneActionList)
  local i = 1
  local j, k, StaSetp, servcommandtb
  local Titletab, RelTitletab = {}, {}
  local tmptitle, titletmptb, tempflag
  local NewOneTagList, NewOneActionList = {}, {}
  local AffActionList = {}
  local retitle, inretitle
  local TestTime = 0
  local RltTypeTab
  local intervalf = string.format("%sinterval.txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg)
  while i <= #OneActionList do
    retitle = ""
    servcommandtb = splittable(string.sub(OneActionList[i][1], 2, -2), "%],")
    if servcommandtb[2] == "TestTime" and tonumber(servcommandtb[3]) then
      TestTime = tonumber(servcommandtb[3])
    elseif servcommandtb[1] == "0" then
      servcommandtb[1] = #NewOneTagList
      table.insert(AffActionList, servcommandtb)
    else
      if string.lower(servcommandtb[2]) == "interval" then
        if servcommandtb[4] ~= "" then
          if string.lower(servcommandtb[3]) == "start" then
            DebugLogId(string.format("?????????? [%s]:\t%s", i, servcommandtb[4]))
            _writeLog(intervalf, string.format("perf\t%s\t%s\t%s\t%s\t%s\t%s\n", servcommandtb[4], "0", "0", G_Id:match("%d+_%d+_(%d+)"), "04", servcommandtb[5] or ""))
          end
        else
          DebugLogId(string.format("?????????????????????????????: bad argument #4 to 'format []' (no value) \tlines[%s]:  %s", i, OneActionList[i][1]))
        end
      end
      table.insert(NewOneTagList, table.remove(servcommandtb, 1))
      table.insert(NewOneActionList, servcommandtb)
      if not servcommandtb[4] then
        DebugLogId("???Action??" .. i .. "?ß’???!", "???????")
        DebugLogId("????:" .. OneActionList[i][1], "???????")
        error("???????!!!!!!!")
      end
      tmptitle = servcommandtb[4]
      _, _, k = string.find(tmptitle, "+(%d)")
      if k then
        tmptitle = string.gsub(tmptitle, "+%d", "")
        StaSetp = i - k
        if StaSetp < 0 then
          StaSetp = 1
        end
      end
      titletmptb = splittable(tmptitle, "|")
      j = 1
      while j <= #titletmptb do
        if string.sub(titletmptb[j], 1, 1) == "<" and string.sub(titletmptb[j], -1, -1) == ">" then
          if G_CycUrl then
            local a, b, c, cyctab
            a, b, c = string.find(titletmptb[j], "[$]([%d]+)[$]")
            if c then
              DebugLogId("?????ùI???")
              cyctab = splittable(G_CycUrl, "\t")
              if cyctab[tonumber(c)] then
                titletmptb[j] = string.gsub(titletmptb[j], "[$][%d]+[$]", cyctab[tonumber(c)])
              end
            end
          elseif G_INIContList then
            local a, b, c
            a, b, c = string.find(titletmptb[j], "[$]([%d]+)[$]")
            if c then
              DebugLogId("?????ùI???")
              if G_INIContList[tonumber(c)] then
                titletmptb[j] = string.gsub(titletmptb[j], "[$][%d]+[$]", G_INIContList[tonumber(c)])
              end
            end
          elseif G_mgAppTest then
            local commantitle = titletmptb[j]
            if G_TmpValue and string.find(commantitle, "%b<>") then
              local AppTitle = string.gsub(G_TmpValue, ".apk", "")
              local endtitle = string.format("<%s%s>", commantitle:sub(2, -2), AppTitle)
              DebugLogId(string.format("?«¨????app???????????%s >>>>>> %s", commantitle, endtitle))
              titletmptb[j] = endtitle
            end
          end
          if not InTable(titletmptb[j], Titletab) then
            retitle = retitle .. "|" .. titletmptb[j]
          end
          RltTypeTab = "DNS,PING,VIDEO,VIDEO_SIG,DOWNH,DOWNBT,DOWNF,UPLOADF,INFOWLAN,NETSENSE"
          if string.find(RltTypeTab, servcommandtb[1]) then
            if servcommandtb[1] == "DNS" then
              tempflag = titletmptb[j] .. "\t" .. "dns"
            elseif servcommandtb[1] == "PING" then
              tempflag = titletmptb[j] .. "\t" .. "ping"
            else
              if servcommandtb[1] ~= "VIDEO" then
              end
              tempflag = titletmptb[j] .. "\t" .. "video"
              do break end
              if servcommandtb[1] == "DOWNH" then
                tempflag = titletmptb[j] .. "\t" .. "http"
              elseif servcommandtb[1] == "DOWNBT" or servcommandtb[2] == "DOWNF" or servcommandtb[2] == "UPLOADF" then
                tempflag = titletmptb[j] .. "\t" .. "file"
              elseif servcommandtb[1] == "INFOWLAN" then
                tempflag = titletmptb[j] .. "\t" .. "wifi"
              elseif servcommandtb[1] == "NETSENSE" then
                tempflag = titletmptb[j] .. "\t" .. "netsense"
              end
            end
          else
            tempflag = titletmptb[j] .. "\t" .. "auto"
          end
          if not InTable(tempflag, RelTitletab) then
            table.insert(RelTitletab, tempflag)
          end
        end
        j = j + 1
      end
      inretitle = string.sub(retitle, 2, -1)
      if inretitle ~= "" and not InTable(inretitle, Titletab) then
        table.insert(Titletab, inretitle)
      end
    end
    i = i + 1
  end
  if File_Exists(intervalf) then
    _writeLog(intervalf, "\n")
  end
  return Titletab, RelTitletab, NewOneTagList, NewOneActionList, AffActionList, TestTime, StaSetp
end
function DealOneCommand(OneCommandList)
  local hbtb, hbtimeout, ret, ResultTable, picidx, CompType, BuffType, parmTab, parmCommandImg, parmTimeOut, parmSPOrder, parmDestCode, parmRecvCont
  local nosmsflg = false
  local ResultFlag, tale, redu, inifile, FunName, paraflag1, paraflag, a, b, c, ii, cyctab
  local temp = ""
  local keyword, title
  G_Imgtime = nil
  G_first_time = nil
  G_Automatical = false
  G_ScriptPic = ""
  if G_Fuzzy_flag == true then
    G_img_flag = true
  else
    G_img_flag = false
  end
  if G_PackageName then
    if G_http_keyword then
      keyword = G_http_keyword
    else
      keyword = ""
    end
    Method_get_http_info(keyword, G_PackageName, 2)
  end
  title = OneCommandList[4] or ""
  if string.match(OneCommandList[1], "<") and string.match(OneCommandList[1], ">") then
    OneCommandList[1] = string.gsub(OneCommandList[1], "<", "")
    OneCommandList[1] = string.gsub(OneCommandList[1], ">", "")
    G_INIFalse = true
  end
  if string.sub(OneCommandList[1], 1, 1) == "#" then
    DebugLogId("????????????????")
    Device_SecondInit(G_DeviceName)
    OneCommandList[1] = string.gsub(OneCommandList[1], "#", "")
  end
  if string.sub(OneCommandList[1], 1, 1) == "*" then
    OneCommandList[1] = string.gsub(OneCommandList[1], "*", "")
    G_FuzzyFlag = true
    G_img_flag = false
  elseif string.sub(OneCommandList[1], 1, 1) ~= "*" and G_Fuzzy_flag == true then
    if string.sub(OneCommandList[1], 1, 1) ~= "&" then
      G_FuzzyFlag = true
    else
      OneCommandList[1] = string.gsub(OneCommandList[1], "&", "")
      G_FuzzyFlag = false
    end
  end
  OneCommandList[1] = string.upper(OneCommandList[1])
  if string.sub(OneCommandList[1], 1, 1) == "F" then
    if not G_res_x or not G_res_y then
      DebugLogId("??????????????????,???????" .. OneCommandList[1] .. ",????????")
      return
    else
      DebugLogId(string.format("???????(%s,%s)", G_res_x, G_res_y))
      G_FTouchFlag = true
    end
    OneCommandList[1] = string.sub(OneCommandList[1], 2, -1)
  end
  if G_CycUrl then
    for ii = 1, #OneCommandList do
      a, b, c = string.find(OneCommandList[ii], "[$]([%d]+)[$]")
      if c then
        cyctab = splittable(G_CycUrl, "\t")
        if cyctab[tonumber(c)] then
          OneCommandList[ii] = string.gsub(OneCommandList[ii], "[$][%d]+[$]", cyctab[tonumber(c)])
        end
      end
    end
  elseif G_INIContList then
    for ii = 1, #OneCommandList do
      a, b, c = string.find(OneCommandList[ii], "[$]([%d]+)[$]")
      if c and G_INIContList[tonumber(c)] then
        OneCommandList[ii] = string.gsub(OneCommandList[ii], "[$][%d]+[$]", G_INIContList[tonumber(c)])
      end
    end
  end
  if G_Replace_Turnnumber then
    for ii = 1, #OneCommandList do
      a, b, c = string.find(OneCommandList[ii], "[%%](.-)[%%]")
      if c == "round" then
        OneCommandList[ii] = string.gsub(OneCommandList[ii], "[%%].-[%%]", G_Turnnumber)
      end
    end
  end
  if string.upper(OneCommandList[1]) == "TOUCH" or string.upper(OneCommandList[1]) == "CLICK" or OneCommandList[1] == "KEY" then
    FunName = "Device_Touchs"
  elseif OneCommandList[1] == "CTOUCH" then
    FunName = "Device_CycTouchs"
    if OneCommandList[5] and tonumber(OneCommandList[5]) and OneCommandList[5] ~= "" then
      paraflag1 = OneCommandList[5]
    end
  elseif OneCommandList[1] == "RATE" then
    paraflag1 = OneCommandList[5]
    FunName = "Device_Rate"
  elseif OneCommandList[1] == "URL_AUTO" then
    FunName = "Device_WAP_VisitPageAUTO"
  elseif OneCommandList[1] == "APP_AUTO" then
    FunName = "Device_OpenAPP_Auto"
  elseif OneCommandList[1] == "SLEEP" then
    if tonumber(OneCommandList[2]) then
      GetAPI_Sleep(tonumber(OneCommandList[2]))
    end
    paraflag1 = 0
    FunName = "Device_ExecuteTargetResult"
  elseif OneCommandList[1] == "INPUT" or OneCommandList[1] == "INPUTINI" then
    if OneCommandList[1] == "INPUTINI" then
      if G_EngineMode == "IOS" then
        inifile = "/var/mobile/uusense/input.ini"
      else
        inifile = "/data/local/tmp/c/engine/input.ini"
      end
      OneCommandList[2] = GetFileValue(inifile, OneCommandList[2])
    end
    if G_DeviceName == "COMMON" then
      FunName = "Device_InputString"
    else
      FunName = "Device_Input"
    end
  elseif OneCommandList[1] == "INPUTC" or OneCommandList[1] == "TEXT" then
    paraflag1 = 1
    if G_DeviceName == "COMMON" then
      FunName = "Device_InputString"
    else
      FunName = "Device_Input"
    end
  elseif OneCommandList[1] == "COPY" then
    FunName = "Device_InputString"
  elseif OneCommandList[1] == "KILLPS" then
    FunName = "Device_KillProcess"
  elseif OneCommandList[1] == "COMMAND" then
    FunName = "Device_AdbCommand"
  elseif OneCommandList[1] == "DELETE" then
    FunName = "Device_deleteString"
  elseif OneCommandList[1] == "TITLE" then
    FunName = "Device_Title"
  elseif OneCommandList[1] == "PSTVPIC" or OneCommandList[1] == "PSTVBUF" or OneCommandList[1] == "RVRSPIC" or OneCommandList[1] == "RVRSBUF" then
    if OneCommandList[1] == "PSTVPIC" then
      paraflag1 = 0
      paraflag = 0
    elseif OneCommandList[1] == "PSTVBUF" then
      paraflag1 = 0
      paraflag = 1
    elseif OneCommandList[1] == "RVRSPIC" then
      paraflag1 = -1
      paraflag = 0
    elseif OneCommandList[1] == "RVRSBUF" then
      paraflag1 = -1
      paraflag = 1
    end
    FunName = "Device_TouchsByBuffer"
  elseif OneCommandList[1] == "CLEARSMS_SIG" then
    FunName = "Device_SMS_ClearSMSSIG"
  elseif OneCommandList[1] == "SENDSMS_SIG" then
    FunName = "Device_SMS_SendSMSSIG"
  elseif OneCommandList[1] == "RECVSMS_SIG" then
    if string.match(OneCommandList[2], "NOSMS") then
      paraflag1 = 1
    else
      paraflag1 = 0
    end
    FunName = "Device_SMS_RecvSMSSIG"
  elseif OneCommandList[1] == "REPLYSMS_SIG" then
    FunName = "Device_SMS_ReplySMSSIG"
    paraflag1 = 1
  elseif OneCommandList[1] == "TRANSMITSMS_SIG" then
    FunName = "Device_SMS_ReplySMSSIG"
    paraflag1 = 0
  elseif OneCommandList[1] == "VIDEO" then
    FunName = "Device_VideoTest"
  elseif OneCommandList[1] == "VIDEO_SIG" then
    FunName = "Device_VideoTest_sig"
  elseif OneCommandList[1] == "VIDEO_AUTO" then
    FunName = "Device_VideoTest_Auto"
  elseif OneCommandList[1] == "SFLOW" then
    paraflag1 = 0
    FunName = "Device_FlowCalculation"
  elseif OneCommandList[1] == "EFLOW" then
    paraflag1 = 1
    FunName = "Device_FlowCalculation"
  elseif string.upper(OneCommandList[1]) == "LOOP_START" then
    FunName = "Device_loop"
    paraflag1 = 1
  elseif string.upper(OneCommandList[1]) == "BREAK" then
    FunName = "Device_break"
  elseif string.upper(OneCommandList[1]) == "LOOP_END" then
    FunName = "Device_loop"
    paraflag1 = 2
  elseif OneCommandList[1] == "SPACKET" then
    FunName = "Device_PACKET"
    paraflag1 = 0
  elseif OneCommandList[1] == "EPACKET" then
    FunName = "Device_PACKET"
    paraflag1 = 1
  elseif OneCommandList[1] == "INTERACTA" then
    FunName = "Device_Interactive"
    paraflag1 = OneCommandList[5]
  elseif OneCommandList[1] == "INTERACTB" then
    FunName = "Device_Interactive_recv"
    paraflag1 = OneCommandList[5]
  elseif OneCommandList[1] == "MONITOR" then
    FunName = "Device_MonitorTest"
  elseif OneCommandList[1] == "CLEARLOG" then
    FunName = "Device_ClearLog"
  elseif OneCommandList[1] == "REMOVECACHE" then
    FunName = "Device_RemoveCache"
  elseif OneCommandList[1] == "CHECKFILE" then
    FunName = "Device_CheckFile"
  elseif OneCommandList[1] == "READINI" then
    FunName = "Device_readini"
  elseif OneCommandList[1] == "VERSION" then
    FunName = "Device_AdbVersion"
  elseif OneCommandList[1] == "GETINI" then
    FunName = "Device_readinicyc"
  elseif OneCommandList[1] == "MODIFYFILE" then
    FunName = "Device_modifyfile"
  elseif OneCommandList[1] == "CHECKNET" then
    FunName = "Device_CheckNet"
  elseif OneCommandList[1] == "GETWLAN" then
    FunName = "Device_GetWlanInfo"
  elseif OneCommandList[1] == "INFOWLAN" then
    FunName = "Device_WlanInfo"
  elseif OneCommandList[1] == "CONNECTWLAN" then
    FunName = "Device_ConnectWlan"
  elseif string.upper(OneCommandList[1]) == "SVC_WIFI" then
    FunName = "Device_svc_wifi"
  elseif OneCommandList[1] == "DOWNH" then
    FunName = "Device_HttpDownload"
  elseif OneCommandList[1] == "PING" then
    FunName = "Device_PingTest"
  elseif string.upper(OneCommandList[1]) == "PING_LOSS" then
    FunName = "Device_packet_loss"
  elseif OneCommandList[1] == "DNS" then
    FunName = "Device_DnsTest"
  elseif OneCommandList[1] == "TCP" then
    FunName = "Device_TCPTest"
  elseif OneCommandList[1] == "TRACEROUTE" then
    FunName = "Device_TraceRoute"
  elseif string.upper(OneCommandList[1]) == "RATE_URL" then
    FunName = "Device_rate_url"
  elseif OneCommandList[1] == "ENGINEUD" then
    FunName = "Device_UpdateEngine"
  elseif OneCommandList[1] == "UDFILE" then
    FunName = "Device_UpdateFile"
  elseif OneCommandList[1] == "STARTENERGY" then
    FunName = "Device_ENERGY"
    paraflag1 = 0
  elseif OneCommandList[1] == "STOPENERGY" then
    FunName = "Device_ENERGY"
    paraflag1 = 1
  elseif OneCommandList[1] == "CAPTURE" then
    FunName = "Device_CaptureImg"
  elseif OneCommandList[1] == "PICOCR" then
    FunName = "Device_ImgOcr"
  elseif OneCommandList[1] == "DIFSUB" then
    FunName = "Device_DiffOcr"
  elseif OneCommandList[1] == "VOUCHER" then
    FunName = "Device_Voucher"
  elseif OneCommandList[1] == "VIDEO_PLAYBACK" then
    FunName = "Device_video_playback"
    if OneCommandList[5] and OneCommandList[5] ~= "" then
      paraflag1 = OneCommandList[5]
    end
  elseif OneCommandList[1] == "PAGETURN" then
    FunName = "Device_pageturn"
    paraflag1 = OneCommandList[5]
  elseif string.upper(OneCommandList[1]) == "GET_VIEW_AREA" then
    FunName = "Device_get_area"
  elseif string.upper(OneCommandList[1]) == "GETTIME" then
    FunName = "Device_GetTime"
  elseif string.upper(OneCommandList[1]) == "GETVIEW" then
    FunName = "Device_getview"
  elseif string.upper(OneCommandList[1]) == "JUDGE" then
    FunName = "Device_judge"
  elseif string.upper(OneCommandList[1]) == "PERFS" then
    FunName = "Method_PerformanceManager"
  else
    if OneCommandList[1] == "CLEARSMS" then
      FunName = "Device_SMS_ClearSMS"
    elseif OneCommandList[1] == "SENDIMG" then
      FunName = "Device_SMS_SendIMG"
    elseif OneCommandList[1] == "SENDSMS" then
      FunName = "Device_SMS_SendSMS"
    elseif OneCommandList[1] == "RECVSMS" then
      if string.match(OneCommandList[2], "NOSMS") then
        paraflag = 1
      else
        paraflag = 0
      end
      FunName = "Device_SMS_RecvSMS"
    elseif OneCommandList[1] == "REPLYSMS" then
      FunName = "Device_SMS_ReplySMS"
    elseif OneCommandList[1] == "RECVSMS_SIG_UP" then
      paraflag1 = 2
      FunName = "Device_SMS_RecvSMSSIG"
    elseif OneCommandList[1] == "DBMOVE" then
      OneCommandList[2] = OneCommandList[2] .. "-DBM"
      FunName = "Device_Touchs"
    elseif OneCommandList[1] == "DBTOUCH" then
      OneCommandList[2] = OneCommandList[2] .. "-DBT"
      FunName = "Device_Touchs"
    elseif OneCommandList[1] == "DOWNBT" then
      FunName = "Device_BTDownTest"
    elseif OneCommandList[1] == "DOWNF" then
      paraflag1 = 0
      FunName = "Device_FtpDownAndUp"
    elseif OneCommandList[1] == "UPLOADF" then
      paraflag1 = 1
      FunName = "Device_FtpDownAndUp"
    elseif OneCommandList[1] == "SCROLL" then
      FunName = "Device_Drag"
      paraflag1 = 1
    elseif string.upper(OneCommandList[1]) == "SWIPE" then
      FunName = "Device_Drag"
      paraflag1 = 2
    elseif string.upper(OneCommandList[1]) == "DRAG" then
      FunName = "Device_Drag"
      paraflag1 = 3
    elseif string.upper(OneCommandList[1]) == "LONGCLICK" then
      FunName = "Device_Drag"
      paraflag1 = 4
    elseif OneCommandList[1] == "ENERGYRANDOM" then
      FunName = "Device_energyrandom"
    elseif OneCommandList[1] == "VIDEO_URL" then
      FunName = "Device_Urlvisit_video"
    elseif OneCommandList[1] == "INPUT_VIDEOURL" then
      FunName = "Device_Input_videourl"
      if string.find(OneCommandList[4], "%%s") and G_videoUrl_band_table[G_VideoUrl_input_cnt] ~= nil then
        OneCommandList[4] = string.format(OneCommandList[4], G_videoUrl_band_table[G_VideoUrl_input_cnt])
      end
    elseif OneCommandList[1] == "VIDEO_PLAY" then
      FunName = "Device_videoPlay"
      if string.find(OneCommandList[4], "%%s") and G_videoUrl_band_table[G_VideoUrl_cnt] ~= nil then
        OneCommandList[4] = string.format(OneCommandList[4], G_videoUrl_band_table[G_VideoUrl_cnt])
      end
    elseif OneCommandList[1] == "NETSENSE" then
      FunName = "Device_Netsense"
    elseif OneCommandList[1] == "PHONECALL" then
      FunName = "Device_PhoneCall"
    elseif OneCommandList[1] == "SIGNAL" then
      FunName = "Device_sig"
    elseif OneCommandList[1] == "SNR" then
      FunName = "Device_snr"
    elseif OneCommandList[1] == "SWITCHCARD" then
      FunName = "Device_SwitchCard"
    elseif string.upper(OneCommandList[1]) == "TOUCH_SLICE" then
      FunName = "Device_slice_pic"
      paraflag1 = OneCommandList[5]
    elseif OneCommandList[1] == "TRAVERSE" then
      FunName = "Device_traverse"
      paraflag1 = OneCommandList[5]
    elseif OneCommandList[1] == "URL" then
      FunName = "Device_WAP_VisitPage"
    elseif string.upper(OneCommandList[1]) == "WRITE" then
      FunName = "Device_write"
    elseif OneCommandList[1] == "INTERACT_SIM_B" then
      FunName = "Device_Interactive_sim_recv"
      paraflag1 = OneCommandList[5]
    elseif OneCommandList[1] == "MGHTTP" then
      FunName = "MGDevice_http"
    elseif OneCommandList[1] == "MGDUMP" then
      FunName = "MGDevice_tcpdump"
    elseif OneCommandList[1] == "UUHTTP" then
      FunName = "Device_UUhttp"
    elseif OneCommandList[1] == "SHOWV" then
      FunName = "Device_ShowHow"
    elseif OneCommandList[1] == "INTERVAL" then
      FunName = "Method_Interval"
    elseif OneCommandList[1] == "SCREEN" then
      FunName = "Method_SCREEN"
    else
      local myfunc = rawget(_G, OneCommandList[1])
      if myfunc ~= nil and type(myfunc) == "function" then
        DebugLogId(string.format("-------- run function [%s] --------", OneCommandList[1]))
        OneCommandList[2] = OneCommandList[2] or ""
        OneCommandList[3] = OneCommandList[3] or ""
        OneCommandList[4] = OneCommandList[4] or ""
        local myret, myResultValue = myfunc(OneCommandList[2], OneCommandList[3])
        DebugLogId(string.format("[%s] ret: %s\tresult: %s", OneCommandList[1], myret or "nil", myResultValue or "null"))
        local rfg
        if myret then
          rfg = myret == 0 and "Y" or "N"
        else
          DebugLogId("????éÔ????" .. OneCommandList[1] .. "??ßŸ??????")
        end
        FunName = "Device_Title"
        OneCommandList[2] = rfg
        paraflag1 = OneCommandList[4] ~= "" and string.format("%s", "????éÔ??") or OneCommandList[4]
      else
        paraflag1 = -2
        FunName = "Device_ExecuteTargetResult"
        DebugLogId("???'" .. OneCommandList[1] .. "'?????????!", "???????")
      end
    end
    if FunName == "Device_ExecuteTargetResult" then
      local status, info = pcall(function()
        if G_EngineMode == "Android" then
          dofile("/data/local/tmp/c/engine/ExpandEngine.lua")
        else
          require("ExpandEngine")
        end
      end)
      if not status then
        DebugLogId("¶ƒ???ExpandEngine.lua????,???Óï")
      end
    end
  end
  local startclock = GetAPI_OsClock()
  if check_view(OneCommandList[2]) == true then
    G_click_view = true
    if string.match(OneCommandList[2], "user_id='([^%']+)'") then
      OneCommandList[2] = ChangeUserId(OneCommandList[2])
    end
  end
  if check_view(OneCommandList[3]) == true then
    G_check_view = true
    if string.match(OneCommandList[3], "user_id='([^%']+)'") then
      OneCommandList[3] = ChangeUserId(OneCommandList[3])
    end
  end
  ret, ResultTable, picidx = MulitiMethod(FunName, OneCommandList[2], OneCommandList[3], OneCommandList[4], paraflag1, paraflag, #OneCommandList > 4 and OneCommandList[#OneCommandList] or "nil")
  JRoneCapture()
  G_FTouchFlag = false
  G_FuzzyFlag = false
  G_area = 0
  G_Automatical = false
  G_click_view = false
  G_check_view = false
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  if G_timeflag then
    if string.find(OneCommandList[4], "%+[%d]") and G_Imgtime then
      DelayTime = DelayTime - G_Imgtime
    end
  elseif G_Imgtime then
    DelayTime = DelayTime - G_Imgtime
  end
  table.insert(G_TestTimeTab, DelayTime)
  if G_PackageName then
    if G_http_keyword then
      keyword = G_http_keyword
    else
      keyword = ""
    end
    Method_get_http_info(keyword, G_PackageName, 3, title)
  end
  return ret, ResultTable, picidx
end
function MulitiMethod(FunName, strCommand, strCommandImg, ResultTitle, paraflag1, paraflag, lastPram)
  local actionTable = {
    "Device_VideoTest",
    "UPLOADF",
    "DOWNF",
    "Device_VideoTest_sig",
    "Device_Rate",
    "Device_traverse",
    "Device_Urlvisit_video",
    "Device_videoPlay",
    "Device_pageturn"
  }
  local ret, ResultContent, picidx, res
  local ActionStartTime = os.time()
  res, ret, ResultContent, picidx = pcall(_G[FunName], strCommand, strCommandImg, paraflag1, paraflag)
  ResultContent = ResultContent or {}
  if G_EngineMode == "Android" and ResultTitle:find("%b<>") and lastPram:find("%b<>") then
    DebugLogId(string.format("????migu?????: ResultTitle: %s ?????????????: %s", ResultTitle, lastPram))
    local ret, view_str
    lastPram = lastPram:match("%b<>"):gsub(" ", ""):sub(2, -2)
    DebugLogId(string.format("lastPram:%s", lastPram))
    ResultContent.provText = ResultContent.provText and ResultContent.provText or ""
    if lastPram:find("%=") then
      local ImgTmpTb = splittable(lastPram, ",")
      local timeOut = ImgTmpTb[2] and tonumber(ImgTmpTb[2]) or G_timeOut
      local userPram = not ImgTmpTb[2] and ImgTmpTb[1]
      ret, view_str = Dump_get_view(userPram, timeOut)
      view_str = _cfunc.Utf8ToGbk(view_str)
      DebugLogId(string.format("??????????: ret = %s\ttext = %s", ret, view_str))
      ResultContent.provText = ret ~= -1 and view_str or ""
    elseif lastPram:find("%d+_%d+_%d+_%d+") then
      local tmptb = {}
      local OCR_txt, pic_name
      for k in lastPram:gmatch("%d+") do
        table.insert(tmptb, k)
      end
      local tmpx1, tmpx2, tmpy1, tmpy2 = tmptb[1], tmptb[2], tmptb[3], tmptb[4]
      local pic_path = string.format("%s%s", string.sub(G_SysDbgPath, 1, -2), G_Pflg)
      if G_EngineMode == "Android" then
        pic_name = string.format("%s_%s_%s_%s_CapturePic.bmp", tmpx1, tmpx2, tmpy1, tmpy2)
        GetAPI_CaptureRectangle(pic_path .. pic_name)
      else
        pic_name = string.format("%s_%s_%s_%s_CapturePic.png", tmpx1, tmpx2, tmpy1, tmpy2)
        GetAPI_CaptureRectangle(pic_path .. pic_name, tmpx1, tmpx2, tmpy1, tmpy2)
      end
      local all_pic = pic_path .. pic_name
      DebugLogId("???°§??:" .. all_pic)
      OCR_txt = mgpic_Ocrhttps(all_pic)
      if OCR_txt == 0 then
        DebugLogId(string.format("PIC OCR FALSE !!!\t%s", all_pic))
        ret = -1
      end
      OCR_txt = _cfunc.Utf8ToGbk(OCR_txt)
      DebugLogId("OCR_txt:" .. OCR_txt)
      DebugLogId(string.format("OCR??????????: ret = %s\ttext = %s", tostring(ret), OCR_txt))
      ResultContent.provText = ret ~= -1 and OCR_txt or ""
    elseif lastPram == "A" and G_mgScriptFlg.A then
      ResultContent.provText = G_mgScriptFlg.A[3] or ""
    elseif lastPram == "B" and G_mgScriptFlg.B then
      ResultContent.provText = G_mgScriptFlg.B[3] or ""
    elseif lastPram == "C" and G_mgScriptFlg.C then
      ResultContent.provText = G_mgScriptFlg.C[3] or ""
    elseif lastPram == "D" and G_mgScriptFlg.D then
      ResultContent.provText = G_mgScriptFlg.D[3] or ""
    elseif G_mgScriptFlg[lastPram] then
      DebugLogId(string.format("???: G_mgScriptFlg[lastPram] = %s", G_mgScriptFlg[lastPram]))
      ResultContent.provText = G_mgScriptFlg[lastPram] or ""
      DebugLogId(string.format("???: ResultContent.provText = %s", ResultContent.provText))
    else
      ResultContent.provText = tostring(lastPram) or ""
      DebugLogId(string.format("???: ResultContent.provText = %s", ResultContent.provText))
    end
    if ResultContent.provText and ResultContent.provText ~= "" then
      ResultContent.provText = string.gsub(ResultContent.provText, "\n", "/n")
      ResultContent.provText = string.gsub(ResultContent.provText, "\t", "/t")
      ResultContent.provText = string.gsub(ResultContent.provText, "|", "$$$")
      DebugLogId("????????????????????")
    end
    DebugLogId(string.format("????????: text = %s", ResultContent.provText))
  end
  local ActionEndTime = os.time()
  if G_Imgtime then
    if G_first_time then
      G_Imgtime = G_Imgtime + G_first_time
    end
  elseif G_first_time then
    G_Imgtime = G_first_time
  end
  if G_Imgtime and ResultContent[2] and tonumber(ResultContent[2]) and not InTable(FunName, actionTable) then
    G_Imgtime = DecPoint(G_Imgtime, 3)
    ResultContent[2] = DecPoint(ResultContent[2], 3)
    DebugLogId("?????:" .. ResultContent[2])
    ResultContent[2] = tonumber(ResultContent[2]) - G_Imgtime
    DebugLogId("????????¶ ??:" .. G_Imgtime)
    ResultContent[2] = string.format("%.3f", ResultContent[2])
    DebugLogId("??????????:" .. ResultContent[2])
  end
  local ResultTable = {}
  table.insert(ResultTable, ResultTitle)
  table.insert(ResultTable, ret)
  table.insert(ResultTable, ResultContent)
  table.insert(ResultTable, ActionStartTime)
  table.insert(ResultTable, ActionEndTime)
  table.insert(ResultTable, paraflag1)
  return ret, ResultTable, picidx
end
function Print(str)
  if G_EngineMode == "Android" then
    _cfunc.Print(str)
  elseif G_EngineMode == "IOS" then
    print(str)
  elseif G_EngineMode == "MacIOS" then
    Print(str)
  end
end
function TableInStr_sigle(tab, s)
  for i = 1, #tab do
    if string.find(s, tab[i]) then
      return i
    end
  end
  return -1
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
    "value='",
    "user_id='"
  }
  local index = TableInStr_sigle(tab_view_attribute, str)
  if index > 0 and string.find(str, tab_view_attribute[index] .. "(.-)'") then
    return true
  end
  return false
end
function CopyFile(sourcefile, destfile)
  local inp = assert(io.open(sourcefile, "rb"))
  local out = assert(io.open(destfile, "wb"))
  local data = inp:read("*all")
  local ret
  if not sourcefile:find("dump.xml") and not sourcefile:match("shot_%d+.jpg") and not sourcefile:match("%%-%d+.jpg") and not sourcefile:match("shot.jpg") then
    local value = GetAPI_Command(string.format("ls %s -l", sourcefile))
    DebugLogId("ls -l:\t" .. value:gsub("\n", ""))
  end
  DebugLogId(string.format("copy >>> %s", destfile))
  if not out then
    DebugLogId("???????:" .. destfile .. "?????!")
  end
  out:write(data)
  out:close()
  inp:close()
  local deinp = assert(io.open(destfile, "rb"))
  local dedata = deinp:read("*all")
  deinp:close()
  ret = dedata == data and 0 or -1
  return ret
end
function randomnum(num1, num2)
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
  return tostring(math.random(num1, num2))
end
function traceroute(url)
  local ip, value, pingz, fp
  _, _, ip = string.find(url, "([%d]*.[%d]*.[%d]*.[%d]*)[//]")
  if ip then
    local cmd = string.format("su -c 'busybox traceroute -I %s'", ip)
    DebugLogId(cmd)
    value = GetAPI_Command(cmd .. [[

exit]])
    DebugLogId("value=" .. value)
    pingz = os.date("%Y%m%d%H%M%S") .. ".txt"
    fp = assert(io.open(G_SysDbgPath .. G_Pflg .. pingz, "wb"))
    fp:write(value)
    fp:close()
    table.insert(G_CaptureTab, pingz)
    DebugLogId("???value???????" .. pingz)
  end
end
function FindMax(a, b, typeflg)
  if tonumber(a) and tonumber(b) then
    a = tonumber(a)
    b = tonumber(b)
    if typeflg then
      if a > b then
        return b
      else
        return a
      end
    elseif a > b then
      return a
    else
      return b
    end
  else
    return b
  end
end
function Strip(str)
  local i
  if str then
    while true do
      while true do
        if string.sub(str, 1, 1) == " " or string.sub(str, 1, 1) == "\r" or string.sub(str, 1, 1) == "\n" then
          str = string.sub(str, 2, -1)
          break
        end
      end
    end
    while true do
      if string.sub(str, -1, -1) == " " or string.sub(str, -1, -1) == "\r" or string.sub(str, -1, -1) == "\n" then
        str = string.sub(str, 1, -2)
        break
      end
    end
  end
  return str
end
function comTabtoStr(str, tab)
  if str == nil or tab == {} or tab == nil then
    return false
  else
    for i, j in pairs(tab) do
      if individualContrast(str, j) then
        return true
      end
    end
    return false
  end
end
function ReadFileToTable(filename)
  local datalists = {}
  local sourcetxt = assert(io.open(filename, "rb"))
  for line in sourcetxt:lines() do
    table.insert(datalists, line)
  end
  sourcetxt:close()
  return datalists
end
function ReadPlogToTable(filename)
  local datalists = {}
  local tmplists = {}
  local sourcetxt = assert(io.open(filename, "rb"))
  for line in sourcetxt:lines() do
    tmplists = splittable(line, "}{")
    for i = 1, #tmplists do
      table.insert(datalists, tmplists[i])
    end
  end
  sourcetxt:close()
  return datalists
end
function ReadTxtToTable(filename, tablename)
  local sourcetxt = assert(io.open(filename, "rb"))
  local tmplists = {}
  for line in sourcetxt:lines() do
    tmplists = splittable(line, "\t")
    if #tmplists >= 2 then
      tablename[tmplists[1]] = tostring(tmplists[2])
    end
  end
  sourcetxt:close()
end
function GetFileValue(filename, ininame)
  local is, ie, tmptb, tptb, retval
  local i = 1
  retval = ininame
  tmptb = ReadFileToTable(filename)
  while i <= #tmptb do
    is, ie = string.find(tmptb[i], ininame)
    if is then
      tptb = splittable(tmptb[i], "=")
      if #tptb == 2 then
        retval = string.gsub(tptb[2], "\r", "")
        retval = string.gsub(retval, "\n", "")
        retval = string.gsub(retval, " ", "")
      end
      break
    end
    i = i + 1
  end
  return retval
end
function FindStrAndNum(lasttag, nexttag)
  local ret
  local n = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local vol
  if string.sub(lasttag, 1, -2) == string.sub(nexttag, 1, -2) then
    vol = string.find(n, string.sub(lasttag, -1))
    n = string.sub(n, vol + 1, -1)
    if string.find(n, string.sub(nexttag, -1)) then
      ret = true
    end
  end
  return ret
end
function CheckActionResults(Imgs, TimeOut, conflag)
  local ret, picidx
  if G_check_view == true then
    if G_EngineMode == "MacIOS" then
      ret, picidx = MacIOSF:Method_ActionEx(Imgs, _, TimeOut)
    else
      ret, picidx = Method_clickEx(Imgs, TimeOut, conflag)
    end
  else
    ret, picidx = ImgsWaitEx(Imgs, TimeOut, conflag)
  end
  return ret, picidx
end
function ImgsWaitEx(Imgs, TimeOut, conflag)
  local imgstart, imgend
  local picidx = 0
  local compimgres
  local onecetime = 0.2
  DebugLogId("??????:" .. Imgs)
  G_ScriptPic = Imgs
  imgstart = GetAPI_OsClock()
  local pi = 1
  while true do
    ret, picidx = WaitEx(Imgs, onecetime, conflag)
    imgend = GetAPI_OsClock()
    if GetAPI_SubTime(imgend, imgstart) > tonumber(TimeOut) then
      compimgres = string.format("%s?????????!", TimeOut)
      ret = 1
      break
    elseif ret == 0 then
      compimgres = string.format("??%s????????!", picidx)
      break
    elseif ret == -2 and not Imgs:find("|") and not Imgs:find("-") then
      compimgres = string.format("??????????????????!", Imgs)
      ret = 1
      break
    end
  end
  DebugLogId("??????:" .. compimgres)
  return ret, picidx
end
function Dump_wait_get_view(strCommandImg, TimeOut)
  local start_clock = GetAPI_OsClock()
  DebugLogId("????????????" .. strCommandImg)
  local value_table = GetAPI_att_cbt_get_view(strCommandImg)
  while true do
    local end_clock = GetAPI_OsClock()
    if TimeOut < GetAPI_SubTime(end_clock, start_clock) then
      DebugLogId(string.format("%s??????????????!", TimeOut))
      return -1
    end
    local single_start_clock = GetAPI_OsClock()
    local ret, view = GetAPI_Dump(value_table)
    local single_end_clock = GetAPI_OsClock()
    G_Imgtime = GetAPI_SubTime(single_end_clock, single_start_clock)
    if ret ~= -1 then
      DebugLogId("viewret:0" .. "\t\t" .. G_Imgtime)
      DebugLogId(string.format("??%s?????????????!", ret))
      local tmp_sci = splittable(strCommandImg, "|")
      local view_user = tmp_sci[ret]
      view_user = string.gsub(view_user, "='", "=\".*")
      if string.sub(view_user, -1, -1) == "'" then
        view_user = string.sub(view_user, 1, -2)
      end
      DebugLogId("??????????" .. view_user .. "(%w+)")
      _, _, G_Captcha = string.find(view, view_user .. "(%w+)")
      DebugLogId("????????" .. G_Captcha)
      return ret
    else
      DebugLogId("viewret:-1" .. "\t\t" .. G_Imgtime)
    end
  end
end
function Dump_get_view(strCommandImg, TimeOut)
  local start_clock = GetAPI_OsClock()
  DebugLogId("????????????????????????" .. strCommandImg)
  local value_table = GetAPI_att_cbt(strCommandImg)
  while true do
    local end_clock = GetAPI_OsClock()
    if TimeOut < GetAPI_SubTime(end_clock, start_clock) then
      DebugLogId(string.format("%s??????????????!", TimeOut))
      return -1, ""
    end
    local ret, view = GetAPI_Dump(value_table)
    if ret ~= -1 then
      DebugLogId(string.format("viewret:0\t?????????: %s", _cfunc.Utf8ToGbk(view)))
      local view_str = view_str ~= "" and view:match("text%=(%b\"\")"):sub(2, -2) ~= "" and view:match("text%=(%b\"\")"):sub(2, -2) or view:match("content%-desc%=(%b\"\")"):sub(2, -2)
      DebugLogId(string.format("???????????: %s", _cfunc.Utf8ToGbk(view_str)))
      return ret, view_str
    end
  end
end
function Dump_wait(strCommandImg, TimeOut, conflag)
  local start_clock = GetAPI_OsClock()
  local flag = false
  DebugLogId("????????????" .. strCommandImg)
  if string.find(strCommandImg, "NOMATCH_") or conflag and conflag == true then
    strCommandImg = string.gsub(strCommandImg, "NOMATCH_", "")
    flag = true
  end
  local value_table = GetAPI_att_cbt(strCommandImg)
  local xi = 0
  while true do
    local end_clock = GetAPI_OsClock()
    if TimeOut < GetAPI_SubTime(end_clock, start_clock) then
      DebugLogId(string.format("%s??????????????!", TimeOut))
      return -1, ""
    end
    local single_start_clock = GetAPI_OsClock()
    local ret, view = GetAPI_Dump(value_table, flag)
    local single_end_clock = GetAPI_OsClock()
    G_Imgtime = GetAPI_SubTime(single_end_clock, single_start_clock)
    xi = xi + 1
    G_Imgtime = xi == 1 and ret ~= -1 and G_Imgtime / 3 * 2 or G_Imgtime
    if ret ~= -1 then
      DebugLogId("viewret:0" .. "\t\t" .. G_Imgtime)
      DebugLogId(string.format("??%s?????????????!", ret))
      if G_FuzzyFlag then
        G_res_x, G_res_y = dump_Coordinate(view)
      end
      return ret, view
    else
      DebugLogId("viewret:-1" .. "\t\t" .. G_Imgtime)
      if G_UIAutoClick then
        UI_AutoClickOpen(pkgname, 7)
      end
    end
  end
end
function judge_wait_ex(strCommand, subtime)
  local tmp_table = splittable(string.gsub(strCommand, " ", ""), "|")
  local ret, index = -1, 0
  for i, j in pairs(tmp_table) do
    if j == "" then
      ret = true
    else
      ret = judge_wait_expr(j, subtime)
    end
    if ret == true then
      DebugLogId("???" .. j)
      return 0, i
    end
  end
  DebugLogId("???")
  return -1, 0
end
function judge_wait_expr(Expression, subtime)
  local tmp_tab = {}
  local flag = 0
  if string.find(Expression, "<") and not string.find(Expression, "=") then
    tmp_tab = splittable(Expression, "<")
    flag = 1
  elseif string.find(Expression, "<=") then
    tmp_tab = splittable(Expression, "<=")
    flag = 2
  elseif string.find(Expression, "==") and not string.find(Expression, ">") and not string.find(Expression, "<") and not string.find(Expression, "===") then
    tmp_tab = splittable(Expression, "==")
    flag = 3
  elseif string.find(Expression, "=") and not string.find(Expression, ">") and not string.find(Expression, "<") and not string.find(Expression, "==") then
    tmp_tab = splittable(Expression, "=")
    flag = 3
  elseif string.find(Expression, ">") and not string.find(Expression, "=") then
    tmp_tab = splittable(Expression, ">")
    flag = 4
  elseif string.find(Expression, ">=") then
    tmp_tab = splittable(Expression, ">=")
    flag = 5
  elseif string.find(Expression, "===") and not string.find(Expression, ">") and not string.find(Expression, "<") then
    tmp_tab = splittable(Expression, "===")
    flag = 6
  else
    return false
  end
  if #tmp_tab == 1 then
    return true
  end
  for i = 2, #tmp_tab do
    if string.upper(tmp_tab[i]) == "AREA" then
      tmp_tab[i] = G_area
    end
    if string.upper(tmp_tab[i - 1]) == "AREA" then
      tmp_tab[i - 1] = G_area
    end
    if string.upper(tmp_tab[i]) == "CNT" then
      tmp_tab[i] = G_cnt
    end
    if string.upper(tmp_tab[i - 1]) == "CNT" then
      tmp_tab[i - 1] = G_cnt
    end
    if string.upper(tmp_tab[i]) == "TIME" then
      tmp_tab[i] = subtime
    end
    if string.upper(tmp_tab[i - 1]) == "TIME" then
      tmp_tab[i - 1] = subtime
    end
    if string.upper(tmp_tab[i]) == "VIEW" then
      tmp_tab[i] = G_view
    end
    if string.upper(tmp_tab[i - 1]) == "VIEW" then
      tmp_tab[i - 1] = G_view
    end
    if flag == 1 then
      if tonumber(tmp_tab[i - 1]) >= tonumber(tmp_tab[i]) then
        return false
      end
    elseif flag == 2 then
      if tonumber(tmp_tab[i - 1]) > tonumber(tmp_tab[i]) then
        return false
      end
    elseif flag == 3 then
      if tonumber(tmp_tab[i - 1]) ~= tonumber(tmp_tab[i]) then
        return false
      end
    elseif flag == 4 then
      if tonumber(tmp_tab[i - 1]) <= tonumber(tmp_tab[i]) then
        return false
      end
    elseif flag == 5 then
      if tonumber(tmp_tab[i - 1]) < tonumber(tmp_tab[i]) then
        return false
      end
    elseif flag == 6 then
      DebugLogId("????1:" .. tmp_tab[i - 1])
      DebugLogId("????2:" .. tmp_tab[i])
      if tostring(tmp_tab[i]):match("^{.+}$") then
        DebugLogId("???????:" .. string.sub(tostring(tmp_tab[i]), 2, -2))
        if not tostring(tmp_tab[i - 1]):match(string.sub(tostring(tmp_tab[i]), 2, -2)) then
          return false
        end
      else
        DebugLogId("???????:" .. string.sub(tostring(tmp_tab[i - 1]), 2, -2))
        if not tostring(tmp_tab[i]):match(string.sub(tostring(tmp_tab[i - 1]), 2, -2)) then
          return false
        end
      end
    end
  end
  return true
end
function WaitEx(Imgs, onecetime, conflag)
  local i, ScriptPath, imgFile, ImgsTab, idx, CompImage, tempimg, resx, resy
  local flag = 0
  local imgret, imgidx = 1, 0
  if string.find(Imgs, "%-") then
    flag = 1
    Imgs = string.gsub(Imgs, "%-", "|")
  end
  ImgsTab = splittable(Imgs, "|")
  if G_FuzzyFlag then
    ScriptPath = G_SysScpPath
    tempimg = ScriptPath .. G_Pflg .. "temp.bmp"
    for idx, CompImage in pairs(ImgsTab) do
      if string.match(string.lower(CompImage), "engine") then
        ScriptPath = G_SysEngPath
      else
        ScriptPath = G_SysScpPath
      end
      imgFile = ScriptPath .. G_Pflg .. CompImage
      if G_img_flag == true then
        imgret, resx, resy = GetAPI_MatchScreenEX(imgFile, tempimg, ScriptPath, CompImage, conflag)
      else
        imgret, resx, resy = GetAPI_MatchScreenEX(imgFile, tempimg, ScriptPath, "", conflag)
      end
      if imgret == 0 then
        MathCoordinates(CompImage, resx, resy)
      end
      if imgret == 0 then
        imgidx = idx
        break
      end
    end
  elseif #ImgsTab > 70 then
    imgFile = ""
    local count = 0
    local tmp_tab_pic = {}
    for idx, CompImage in pairs(ImgsTab) do
      ScriptPath = string.match(string.lower(CompImage), "engine") and G_SysEngPath or G_SysScpPath
      if count == 70 then
        table.insert(tmp_tab_pic, imgFile)
        count = 0
        imgFile = ""
      else
        imgFile = imgFile .. ScriptPath .. G_Pflg .. CompImage .. "|"
        count = count + 1
      end
    end
    if imgFile ~= "" then
      table.insert(tmp_tab_pic, imgFile)
    end
    for i, j in pairs(tmp_tab_pic) do
      DebugLogId("??" .. i .. "?¶¡??????????" .. j)
      imgret = GetAPI_MatchScreen2(j, flag, conflag)
      if imgret == -1 then
        break
      else
        imgidx = imgret
        if flag == 1 then
          imgidx = 0
        end
        imgret = 0
      end
      GetAPI_Sleep(0.01)
    end
    DebugLogId("???????")
  elseif #ImgsTab > 3 or flag == 1 then
    imgFile = ""
    local count = 1
    local tmp_tab_pic = {}
    for idx, CompImage in pairs(ImgsTab) do
      ScriptPath = string.match(string.lower(CompImage), "engine") and G_SysEngPath or G_SysScpPath
      imgFile = imgFile .. ScriptPath .. G_Pflg .. CompImage .. "|"
    end
    imgret = GetAPI_MatchScreen2(imgFile, flag, conflag)
    if imgret > 0 then
      imgidx = imgret
      if flag == 1 then
        imgidx = 0
      end
      imgret = 0
    end
  else
    for idx, CompImage in pairs(ImgsTab) do
      ScriptPath = string.match(string.lower(CompImage), "engine") and G_SysEngPath or G_SysScpPath
      imgFile = ScriptPath .. G_Pflg .. CompImage
      imgret = GetAPI_MatchScreen(imgFile, conflag)
      if imgret == -2 then
        DebugLogId("????????: " .. imgFile)
      end
      if flag == 0 then
        if imgret == 0 then
          imgidx = idx
          break
        end
      elseif imgret ~= 0 then
        imgidx = -1
        break
      end
    end
  end
  if G_EngineMode == "MacIOS" then
    GetAPI_Sleep(0.02)
  end
  return imgret, imgidx
end
function MathCoordinates(ImgName, resx, resy)
  local x1, y1, x2, y2, retx, rety, ImgsTab
  ImgsTab = splittable(ImgName, "_")
  x1 = tonumber(ImgsTab[1])
  y1 = tonumber(ImgsTab[2])
  x2 = tonumber(ImgsTab[3])
  y2 = tonumber(ImgsTab[4])
  if G_EngineMode == "IOS" then
    retx = math.modf(x2 / 2)
    rety = math.modf(y2 / 2)
    G_res_x = resx + retx
    G_res_y = resy + rety
  elseif G_EngineMode == "Android" then
    retx = math.modf((x1 + x2) / 2)
    rety = math.modf((y1 + y2) / 2)
    G_res_x = resx - x1 + retx
    G_res_y = resy - y1 + rety
  else
    DebugLogId("MacIOS ??¶ƒ?????????????")
  end
end
function FindCaptcha(RecvContent, Compkeyword)
  local number = "0123456789"
  local i = 1
  local Contentlist, Content, word, tempflag, ret, w, b
  RecvContent = RecvContent .. "??"
  if G_FuzzyFlag then
    _, b = string.find(RecvContent, Compkeyword)
    if b then
      Content = string.sub(RecvContent, b + 1, -1)
      for w in string.gmatch(Content, "%w+") do
        ret = w
        if ret then
          G_Captcha = ret
          DebugLogId("??????:" .. G_Captcha)
          break
        end
      end
    end
  end
end
function MakePattern(a, c)
  local strings
  if a then
    strings = a .. c .. "\r\n"
  else
    strings = c .. "\r\n"
  end
  return strings
end
function CalVar(resultvalue)
  local resultTab, tempTab, testtime, TTL, ICMP, ret
  tempTab = splittable(string.sub(resultvalue, 1, -2), ",")
  testtime = tempTab[2]
  if not testtime then
    ret = 1
    testtime = "nil"
    TTL = "nil"
    ICMP = "nil"
  elseif tonumber(testtime) > 0 then
    ret = 0
    TTL = tempTab[3]
    ICMP = tempTab[4]
  else
    ret = 1
    TTL = tempTab[3]
    ICMP = tempTab[4]
  end
  return ret, testtime, TTL, ICMP
end
function CheckPingRes(pingret, times)
  local ret, temptab, tmtab
  local average = 0
  if not pingret then
    return 0
  elseif pingret == "" then
    return -1
  elseif #pingret > 0 then
    pingret = string.sub(pingret, 1, -2)
    temptab = splittable(pingret, "|")
    for i = 1, times do
      tmtab = splittable(temptab[i], ",")
      if 0 < tonumber(tmtab[2]) then
        average = average + tonumber(tmtab[2])
      else
        return -1
      end
    end
    if average > 1500 then
      return -2
    else
      return 0
    end
  else
    return -3
  end
end
function DecPoint(value, flag)
  value = tonumber(value)
  if not flag or flag == 2 then
    if math.floor(value * 100) ~= value * 100 then
      value = value - value % 0.01
    end
  elseif flag == 3 and math.floor(value * 1000) ~= value * 1000 then
    value = value - value % 0.001
  end
  return value
end
function WriteTestLog(urltab)
  local wlog
  DebugLogId("ß’????????...")
  for i = 1, #urltab do
    if not wlog then
      wlog = urltab[i]
    else
      wlog = wlog .. "\n" .. urltab[i]
    end
  end
  local filename
  filename = GetAPI_TestInfoPath()
  local file = io.open(filename, "w")
  file:write(wlog)
  file:close()
end
function GetTestLog()
  local URLTba = {}
  local filename
  filename = GetAPI_TestInfoPath()
  local cc = io.open(filename, "rb")
  local Content = cc:read("*all")
  cc:close()
  if string.sub(Content, -1, -1) ~= "\n" then
    Content = Content .. "\n"
  end
  local retval, a, b
  a, b = string.find(Content, "\n")
  if a then
    retval = string.sub(Content, 1, a - 1)
    Content = string.sub(Content, b + 1, -1) .. retval .. "\n"
    local file = io.open(filename, "w")
    file:write(Content)
    file:close()
  end
  if retval then
    table.insert(URLTba, retval)
  end
  return URLTba
end
function Redispose(UrlLine)
  local i
  if string.find(UrlLine, "://") then
    i = string.find(UrlLine, "//")
    UrlLine = string.sub(UrlLine, i + 2, -1)
  end
  if string.sub(UrlLine, -1) == "/" then
    UrlLine = string.sub(UrlLine, 1, -2)
  end
  return UrlLine
end
function WaitExeption(VocImg, Imgs)
  local ScriptPath, ImgsTab, ImgNameTb, idx, CompImage, ldx, ImgName, imgFile, imgret, retimg
  ScriptPath = G_SysEngPath
  ImgsTab = splittable(Imgs, "|")
  for idx, CompImage in pairs(ImgsTab) do
    if string.match(CompImage, "-") then
      ImgNameTb = splittable(CompImage, "-")
    else
      ImgNameTb = {CompImage}
    end
    for ldx, ImgName in pairs(ImgNameTb) do
      imgFile = ScriptPath .. G_Pflg .. ImgName
      imgret = GetAPI_MatchFileImg(VocImg, imgFile)
      if imgret ~= 0 then
        break
      else
        retimg = ImgName
      end
    end
    if imgret == 0 then
      break
    end
  end
  return imgret, retimg
end
function GetRedirectUrl(HUrl, Content)
  local nurl, ret, url, i, j, tempcontent
  if string.find(Content, "[ ]*400[ ]*[Bb][Aa][Dd][ ]*[Rr][Ee][Qq][Uu][Ee][Ss][Tt]") then
    ret = -1
  else
    if string.find(Content, "<[ ]*[Oo][Nn][Ee][Vv][Ee][Nn][Tt][ ]*[Tt][Yy][Pp][Ee][ ]*=[ ]*['\"][Oo][Nn][Ee][Nn][Tt][Ee][Rr][Ff][Oo][Rr][Ww][Aa][Rr][Dd]['\"][ ]*>") then
      i, j, url = string.find(Content, "[Hh][Rr][Ee][Ff][ ]*=[ ]*['\"]([^'\"]*)['\"][ ]*>")
      if url then
        ret = 0
        nurl = url
      else
        ret = 1
      end
    elseif string.find(Content, "<[ ]*[Mm][Ee][Tt][Aa][ ]*[Hh][Tt][Tt][Pp]%-[Ee][Qq][Uu][Ii][Vv][ ]*=[ ]*['\"][Rr][Ee][Ff][Rr][Ee][Ss][Hh]['\"]") then
      i, j, url = string.find(Content, "[Cc][Oo][Nn][Tt][Ee][Nn][Tt][ ]*=[ ]*['\"][ ]*[^;]*;[ ]*[Uu][Rr][Ll][ ]*=[ ]*([^'\"]*)['\"][ ]*")
      if url then
        ret = 0
        nurl = url
      else
        ret = 1
      end
    elseif string.find(Content, "[Oo][Nn][Tt][Ii][Mm][Ee][Rr][ ]*=[ ]*['\"]([^'\"]*)['\"][ ]*") then
      i, j = string.find(Content, "[Oo][Nn][Tt][Ii][Mm][Ee][Rr]")
      _, _, url = string.find(Content, "[Oo][Nn][Tt][Ii][Mm][Ee][Rr][ ]*=[ ]*['\"]([^'\"]*)['\"][ ]*")
      local tval
      tempcontent = string.sub(Content, j, j + 500)
      tval = string.match(tempcontent, "[Tt][Ii][Mm][Ee][Rr].*[Vv][Aa][Ll][Uu][Ee][ ]*[=][ ]*['\"]([^'\"]*)['\"]")
      if tval and tonumber(tval) and tonumber(tval) > 65 then
        ret = 1
      else
        ret = 0
        nurl = url
      end
    elseif string.find(Content, "[Oo][Nn][Ee][Vv][Ee][Nn][Tt]") then
      i = string.find(Content, "[Oo][Nn][Ee][Vv][Ee][Nn][Tt]")
      _, j = string.find(Content, "[/][ ]*[Oo][Nn][Ee][Vv][Ee][Nn][Tt][ ]*[>]")
      tempcontent = string.sub(Content, i, j)
      url = GetTagUrl(tempcontent, "go")
      if url ~= "" then
        ret = 0
        nurl = url
      else
        ret = 1
      end
    else
      ret = 1
    end
    if ret == 0 then
      nurl = RemakeUrl(HUrl, nurl)
    end
  end
  return ret, nurl
end
function RemakeUrl(VisitUrl, url)
  local i, j, nurl
  VisitUrl = string.gsub(VisitUrl, " ", "")
  url = string.gsub(url, " ", "")
  if string.find(url, "://") then
    i = string.find(url, "//")
    if i then
      nurl = string.sub(url, i + 2, -1)
    else
      VisitUrl = Redispose(VisitUrl)
      nurl = VisitUrl
    end
  else
    if string.sub(url, 1, 1) == "%." then
      url = string.sub(url, 2, 1)
    elseif string.sub(url, 1, 1) ~= "/" then
      url = "/" .. url
    end
    VisitUrl = Redispose(VisitUrl)
    nurl = VisitUrl .. url
  end
  return nurl
end
function GetUrlFromAHref(VisitUrl, content)
  local table1 = {}
  local table2 = {}
  local table3 = {
    "javascript:;",
    "",
    "/",
    "#url",
    "\r",
    "\n",
    "\n\r",
    "\r\n",
    "url",
    "#;",
    "#"
  }
  while true do
    local i, j, url, ret
    i, j, url = string.find(content, "<[ ]*[Aa][ ]*[Hh][Rr][Ee][Ff][ ]*=[ ]*['\"]([^'\"]*)['\"][^>]*>")
    if not url then
      break
    end
    url = string.gsub(url, " ", "")
    ret = InTable(url, table3)
    if not ret and not InTable(url, table1) then
      table.insert(table1, url)
    end
    content = string.sub(content, j + 1)
  end
  local i = 1
  while i <= #table1 do
    local nurl
    nurl = RemakeUrl(VisitUrl, table1[i])
    if not InTable(nurl, uutab) then
      table.insert(uutab, nurl)
      table.insert(table2, nurl)
    end
    i = i + 1
  end
  return table2
end
function GetTagUrl(XMLContent, Utype)
  local LinkContent, linkurl, lstart, lend, estart, eend, SearchData, fname, fvalue, connect
  LinkContent = XMLContent
  connect = "?"
  linkurl = GetFirstTagValue(LinkContent, "href")
  while true do
    if Utype == "go" then
      lstart, lend = string.find(LinkContent, "<postfield")
      if lstart ~= nil then
        LinkContent = right(LinkContent, len(LinkContent) - lstart + 1)
        estart, eend = string.find(LinkContent, ">")
        SearchData = string.sub(LinkContent, 1, eend)
        fname = GetFirstTagValue(SearchData, "name")
        fvalue = GetFirstTagValue(SearchData, "value")
        linkurl = linkurl .. connect .. fname .. "=" .. fvalue
        LinkContent = right(LinkContent, len(LinkContent) - eend)
      end
    else
      break
    end
    connect = "&"
  end
  return linkurl
end
function GetFirstTagValue(XMLContent, tag)
  local tstart, tend, xindex, tagvalue, hrefflag
  tagvalue = ""
  hrefflag = 0
  XMLContent = string.gsub(XMLContent, "'", "\"")
  XMLContent = string.gsub(XMLContent, "&amp;", "&")
  tstart, tend = string.find(XMLContent, tag .. "=\"")
  if tag == "href" and not tstart then
    tstart, tend = string.find(XMLContent, tag .. "=")
    hrefflag = 1
  end
  if tend ~= nil then
    xindex = tend + 1
    while true do
      if hrefflag == 0 and string.sub(XMLContent, xindex, xindex) == "\"" then
        tagvalue = string.sub(XMLContent, tend + 1, xindex - 1)
        break
      elseif hrefflag == 1 and string.sub(XMLContent, xindex, xindex) == ">" then
        tagvalue = string.sub(XMLContent, tend + 1, xindex - 1)
        break
      end
      xindex = xindex + 1
    end
  end
  return tagvalue
end
function WriteCMValueTable()
  local cmtVenderCode, cmtDevType, cmtDevCode, cmtIP, cmtMobileNum, cmtTotalNum, idx, srvtkey, srvtkeytb, srvtkeytbn, cmtServiceTb
  local i = 1
  local filename, valuefile, ValueStr, tmpstr, tmptb, voctb, vocpath, zipname, tmpfile, zuhestr, ArguMentList, zipret, wcmret, logzip, numbertab, CMPos, zupnstr
  zuhestr = ""
  vocpath = string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg
  ValueStr = ""
  tmpstr = ""
  srvtkeytb = {}
  srvtkeytbn = {}
  cmtServiceTb = {}
  voctb = {}
  cmtVenderCode = GetAPI_VenderCode()
  cmtDevType = GetAPI_DevType()
  cmtDevCode = GetAPI_DevCode()
  cmtIP = GetAPI_DeviceIP()
  for i = 1, 3 do
    local IPstr = GetAPI_PublicIP()
    if IPstr and IPstr ~= "nil" then
      cmtIP = IPstr
      break
    end
  end
  CMPos = GetAPI_GPSInfo()
  cmtMobileNum = GetAPI_MobileNum()
  cmtTotalNum = #G_CMValueTable
  ArguMentList = splittable(G_SysParms, "|")
  DebugLogId("**********************************************************************************************")
  DebugLogId("************************[title.table]***********************************************************")
  for i = 1, #G_CMValueTable do
    tmptb = splittable(string.sub(G_CMValueTable[i], 1, -2), "\t")
    DebugLogId("??????????:" .. tmptb[3])
    if tmptb[14] ~= "" then
      table.insert(voctb, tmptb[14])
      tmptb[14] = string.sub(tmptb[14], 1, -5) .. ".zip"
    end
    if #tmptb == 15 then
      G_CMValueTable[i] = tmptb[1] .. "\t" .. tmptb[2] .. "\t" .. tmptb[3] .. "\t" .. tmptb[4] .. "\t" .. tmptb[5] .. "\t" .. tmptb[6] .. "\t" .. tmptb[7] .. "\t" .. tmptb[8] .. "\t" .. tmptb[9] .. "\t" .. tmptb[10] .. "\t" .. tmptb[11] .. "\t" .. tmptb[12] .. "\t" .. tmptb[13] .. "\t" .. tmptb[14] .. "\t" .. tmptb[15] .. "\n"
    else
      G_CMValueTable[i] = tmptb[1] .. "\t" .. tmptb[2] .. "\t" .. tmptb[3] .. "\t" .. tmptb[4] .. "\t" .. tmptb[5] .. "\t" .. tmptb[6] .. "\t" .. tmptb[7] .. "\t" .. tmptb[8] .. "\t" .. tmptb[9] .. "\t" .. tmptb[10] .. "\t" .. tmptb[11] .. "\t" .. tmptb[12] .. "\t" .. tmptb[13] .. "\t" .. tmptb[14] .. "\n"
    end
    tmpstr = tmpstr .. G_CMValueTable[i]
  end
  if 1 > #G_CMValueTable then
    DebugLogId("¶ƒ??????????...", "???????")
  end
  DebugLogId("************************[title.table]***********************************************************")
  DebugLogId("**********************************************************************************************")
  if not Businesses then
    DebugLogId("???????¶ƒ????...", "???????")
  end
  if not Clientversion then
    Clientversion = "UNKNOWN"
  end
  if cmtVenderCode == "hzys-wlan" then
    numbertab = splittable(cmtMobileNum, "-")
    cmtMobileNum = numbertab[1]
    CMPos = CMPos .. "," .. numbertab[2]
  end
  RecordMode = RecordMode or -1
  ValueStr = cmtVenderCode .. "\t" .. cmtDevType .. "\t" .. cmtDevCode .. "\t" .. CMPos .. "\t" .. cmtIP .. "\t" .. cmtMobileNum .. "\t" .. ArguMentList[2] .. "\t" .. tostring(Businesses) .. "\t" .. Clientversion .. "\t" .. RecordMode .. "\t"
  ValueStr = string.sub(ValueStr, 1, -2) .. "\n" .. tmpstr
  filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_OpSrver .. ".txt"
  if cmtTotalNum > 0 and Businesses then
    DebugLogId(string.format("???????%s\n%s", filename, ValueStr))
    valuefile = io.open(filename, "a")
    valuefile:write(ValueStr)
    valuefile:close()
    DebugLogId("????????????...")
  end
  local rlvoctab = {}
  if string.upper(TestMode) ~= "MONITOR" and cmtTotalNum > 0 and Businesses then
    if G_EngineMode ~= "MacIOS" then
      DebugLogId("????result.txt")
      CopyFile(filename, string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. G_OpSrver .. ".txt")
    end
    if G_EngineMode == "Android" then
      pcall(function()
        CopyFile("/mnt/sdcard/Dresden.log", vocpath .. "Dresden.txt")
        GetAPI_Deletefile("/mnt/sdcard/Dresden.log")
      end)
      pcall(function()
        CopyFile("/mnt/sdcard/PELog.txt", vocpath .. "PELog.txt")
        GetAPI_Deletefile("/mnt/sdcard/PELog.txt")
      end)
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "logcat.txt", vocpath .. "logcat.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "kernel_log.txt", vocpath .. "kernel_log.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "traces.txt", vocpath .. "traces.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump_err_log.txt", vocpath .. "dump_err_log.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump_content_log.txt", vocpath .. "dump_content_log.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "packet_log.txt", vocpath .. "packet_log.txt")
      pcall(CopyFile, "/mnt/sdcard/packet_log.txt", vocpath .. "packet_log.txt")
      if G_MonitorSignal and pcall(function()
        local file = io.open("/data/data/com.autosense/files/java_sig.txt", "r")
        file:close()
      end) then
        pcall(CopyFile, "/data/data/com.autosense/files/java_sig.txt", vocpath .. "java_sig.txt")
        GetAPI_Deletefile("/data/data/com.autosense/files/java_sig.txt")
      end
      pcall(CopyFile, "/mnt/sdcard/video_dump.txt", vocpath .. "mgdump.txt")
      pcall(CopyFile, "/data/local/tmp/dump_tmp.txt", vocpath .. "dump_tmp.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "traceroute.txt", vocpath .. "traceroute.txt")
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "interval.txt", vocpath .. "interval.txt")
      filename = GetAPI_signalPath() .. "signal.txt"
      pcall(CopyFile, filename, vocpath .. "signal.txt")
    end
    DebugLogId("?????????...")
    if #voctb > 0 and cmtTotalNum > 0 then
      i = 1
      while i <= #voctb do
        if not InTable(voctb[i], rlvoctab) then
          table.insert(rlvoctab, voctb[i])
          zipname = vocpath .. string.sub(voctb[i], 1, -5) .. ".zip"
          tmpfile = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. voctb[i]
          if G_EngineMode == "Android" then
            zuhestr = tmpfile .. "|"
            for j = 1, #G_scriptimg do
              if G_scriptimg[j][2] == string.sub(voctb[i], 1, -5) then
                DebugLogId("??????????????????" .. G_scriptimg[j][1] .. "|" .. "????" .. vocpath .. G_scriptimg[j][2] .. ".zip")
                if string.sub(G_scriptimg[j][1], -1, -1) == "|" then
                  zipret = GetAPI_Zip(vocpath .. G_scriptimg[j][2] .. ".zip", G_scriptimg[j][1])
                else
                  zipret = GetAPI_Zip(vocpath .. G_scriptimg[j][2] .. ".zip", G_scriptimg[j][1] .. "|")
                end
              end
            end
            DebugLogId("???????" .. zuhestr .. "????" .. zipname)
            zipret = GetAPI_Zip(zipname, zuhestr)
          elseif G_EngineMode == "IOS" then
            zuhestr = string.sub(tmpfile, 1, -5) .. "|"
            DebugLogId("???????" .. zuhestr .. "????" .. zipname)
            zipret = GetAPI_Zip(zipname, zuhestr)
          elseif G_EngineMode == "MacIOS" then
            zuhestr = string.sub(tmpfile, 1, -5) .. "|"
            DebugLogId("???????" .. zuhestr .. "????" .. zipname:sub(2))
            zipret = GetAPI_Zip(zipname, zuhestr)
          end
        end
        i = i + 1
      end
      DebugLogId("????????????")
      logzip = "Voucher.zip"
      zipname = vocpath .. logzip
      zuhestr = ""
      if G_CaptureTab and 0 < #G_CaptureTab then
        for jj = 1, #G_CaptureTab do
          zuhestr = zuhestr .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_CaptureTab[jj] .. "|"
        end
        DebugLogId(zuhestr)
        GetAPI_Zip(zipname, zuhestr)
      end
    else
      DebugLogId("????????????")
      logzip = "Voucher.zip"
      zipname = vocpath .. logzip
      zuhestr = ""
      if G_CaptureTab and 0 < #G_CaptureTab then
        for jj = 1, #G_CaptureTab do
          zuhestr = zuhestr .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_CaptureTab[jj] .. "|"
        end
        DebugLogId(zuhestr)
        GetAPI_Zip(zipname, zuhestr)
      end
    end
    if #G_PNVouc ~= 0 then
      for i = 1, #G_PNVouc do
        GetAPI_Zip(vocpath .. G_PNVouc[i] .. ".zip", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_PNVouc[i] .. ".txt|")
      end
    end
    if #G_DNSVouc ~= 0 then
      for i = 1, #G_PNVouc do
        GetAPI_Zip(vocpath .. G_DNSVouc[i] .. ".zip", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_DNSVouc[i] .. ".txt|")
      end
    end
    if G_vm2flag then
      CopyFile(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_vm2flag, vocpath .. G_vm2flag)
    end
    if G_vm2flag_new and pcall(function()
      local file = io.open("/data/data/com.autosense/files/" .. G_vm2flag_new, "r")
      file:close()
    end) then
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_vm2flag_new, vocpath .. G_vm2flag_new)
      GetAPI_Deletefile("/data/data/com.autosense/files/" .. G_vm2flag_new)
    end
    for i = 1, #G_packet do
      DebugLogId("???ÂÔ??¶À???" .. vocpath .. G_packet[i])
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_packet[i], vocpath .. G_packet[i])
    end
    for i = 1, #G_fail_dump_tab do
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. G_fail_dump_tab[i], vocpath .. G_fail_dump_tab[i])
    end
    for i = 1, #G_WRITE_FILE do
      local file_name_write = GetAPI_GetFileName(G_WRITE_FILE[i])
      pcall(CopyFile, G_WRITE_FILE[i], vocpath .. file_name_write)
    end
    if pcall(function()
      local file = io.open(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "ping.txt", "r")
      file:close()
    end) then
      pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "ping.txt", vocpath .. "ping.txt")
    end
    if G_EngineMode ~= "MacIOS" then
      if G_EngineMode == "Android" and G_ATCID then
        local curlPath = (cmd_exists("curl") ~= 0 or not "curl") and File_Exists("/data/local/tmp/curl-7.40.0/bin/curl") and "/data/local/tmp/curl-7.40.0/bin/curl"
        if curlPath then
          DebugLogId(string.format("DELETE ATC shape : %s", G_ATCID))
          _cfunc.Command(string.format("%s -X DELETE -i -H 'Accept: application/json; indent=2' http://192.168.0.1:8000/api/v1/shape/", curlPath))
        end
      end
      filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "debug.txt"
      DebugLogId("????Debug.txt" .. filename)
      ret, err = pcall(CopyFile, filename, vocpath .. "debug.txt")
      if not ret then
        DebugLogId(err)
      end
    end
  end
  return 0
end
function UpLoad_Identify()
  local PhoneNum = GetAPI_MobileNum()
  local PhoneImei = GetAPI_DevCode()
  local NowTime = os.date("%Y-%m-%d %H:%M:%S")
  local content, PostContent, PostUrl, r1, r12
  content = string.format("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<root>\r\n<flag>script</flag>\r\n<device>%s</device>\r\n<content>%s</content>\r\n<mobile>%s</mobile>\r\n<client_time>%s</client_time>\r\n</root>\r\n", PhoneNum, G_Captcha, PhoneNum, NowTime)
  PostUrl = "a.netsense.cn"
  PostContent = string.format("POST /apps/telecomsms/insert_sms HTTP/1.1\r\nHOST:a.netsense.cn\r\nAccpt:*/*\r\nContent-Length:%s\r\nConnection:Close\r\n\r\n%s", #content, content)
  DebugLogId(string.format("????????%s\n%s", PostUrl, PostContent))
  for i = 1, 10 do
    r1, _, _, _, _, _, _, _, _, _, _, r12 = GetAPI_HttpClient(PostUrl, PostContent, PostUrl)
    if r1 == 6 and r12 and string.find(r12, "0000") then
      DebugLogId("??????...")
      break
    end
    DebugLogId("??????...??" .. i .. "??")
  end
end
function EngineDownload(Dlurl, Dlmode, Dlname)
  local ret, DLName, filesize, i, HUrl, DUrl, Content, dltime, urlhand, HTTPReturn, file
  if Dlmode == 1 and not Dlname then
    DLName = os.date("%Y%m%d%H%M%S")
    Dlname = G_SysDbgPath .. DLName .. ".dat"
  end
  i = string.find(Dlurl, "/")
  if i then
    HUrl = string.sub(Dlurl, 1, i - 1)
    DUrl = string.format("GET /%s HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", string.sub(Dlurl, i + 1, -1), string.sub(Dlurl, 1, i - 1))
  else
    HUrl = Dlurl
    DUrl = string.format("GET / HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", Dlurl)
  end
  ret, _, _, _, _, _, dltime, _, _, urlhand, Content = GetAPI_HttpClient(HUrl, DUrl, Dlurl)
  DebugLogId("??????:ret=" .. ret .. "(6????)")
  if ret == 6 then
    if tonumber(urlhand) then
      HTTPReturn = tostring(urlhand)
    else
      _, _, HTTPReturn = string.find(urlhand, "[Hh][Tt][Tt][Pp][/][^ ]*[ ]*(%w+)")
    end
    DebugLogId("HTTPReturn:" .. HTTPReturn)
    if string.sub(HTTPReturn, 1, 1) == "2" or string.sub(HTTPReturn, 1, 1) == "3" then
      if dltime == 0 then
        dltime = 1
      end
      ret = dltime
    else
      ret = 0
    end
  else
    ret = 0
  end
  DebugLogId("Dlname:" .. Dlname)
  if ret ~= 0 and Dlmode == 1 then
    file = io.open(Dlname, "w")
    file:write(Content)
    file:close()
  end
  return ret
end
function GetSurplusResultTitle()
  G_CMValueTable = {}
  local ReTitletab, Titletab, TitletabA, TitletabB, i
  if ScriptAction then
    i = 1
    while i <= #ScriptAction do
      WriteTitleTab(ScriptAction[i][2], "", "N1")
      i = i + 1
    end
  elseif CycAction then
    i = 1
    while i <= #CycAction do
      WriteTitleTab(CycAction[i][2], "", "N1")
      i = i + 1
    end
  elseif BusinessActionA and not BusinessActionB then
    WriteTitleTab(BusinessActionA, "", "N1")
  elseif BusinessActionA and BusinessActionB then
    WriteTitleTab(BusinessActionA, "", "N1")
    WriteTitleTab(BusinessActionB, "", "N1")
  end
end
function GetGVM(GVMstr, GVMtab)
  local retGVM
  local i = 1
  while i <= #GVMtab do
    if not GVMtab[i] then
      GVMtab[i] = ""
    end
    i = i + 1
  end
  retGVM = string.format(GVMstr, GVMtab[1], GVMtab[2], GVMtab[3], GVMtab[4], GVMtab[5], GVMtab[6], GVMtab[7], GVMtab[8], GVMtab[9], GVMtab[10])
  retGVM = "[" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. retGVM
  if not G_GlbVocMsg or G_GlbVocMsg == "" then
    return retGVM
  else
    return G_GlbVocMsg .. "\n" .. retGVM
  end
end
function InTable(value, tab)
  for i, k in ipairs(tab) do
    if k == value then
      return i
    end
  end
  return false
end
function TabInStr(tab, str, flag)
  for i = 1, #tab do
    local tmp_tab
    local tmp_str = str
    local tab_str = tab[i]
    if G_FuzzyFlag and flag == 1 then
      tmp_tab = splittable(tab[i], "=\"")
      if string.find(str, tmp_tab[1] .. "=\"") then
        for k in string.gmatch(str, tmp_tab[1] .. "=\"(.-)\"") do
          tmp_str = k
        end
      else
        return false
      end
      tab_str = string.gsub(tmp_tab[2], "\"", "")
      tab_str = _cfunc.GbkToUtf8(tab_str)
      if not individualContrast(tmp_str, tab_str) then
        return false
      end
    else
      local x = _cfunc.GbkToUtf8(tab[i])
      if not x or x == "" then
        return false
      end
      if not string.find(str, x) then
        return false
      end
    end
  end
  return true
end
function ReBuiltList(ScriptList, KeyWord)
  local list = {}
  local x = -1
  if not KeyWord then
    return {}, -1
  end
  for i = 1, #ScriptList do
    if string.find(ScriptList[i], KeyWord) then
      x = i
      for j = i + 1, #ScriptList do
        ScriptList[j] = Strip(ScriptList[j])
        if ScriptList[j] == "" then
          table.insert(list, ScriptList[j])
        elseif string.find(ScriptList[j], "}") and string.sub(ScriptList[j], 1, string.find(ScriptList[j], "}") - 1) ~= "" then
          table.insert(list, ScriptList[j])
        else
          break
        end
      end
      break
    end
  end
  return list, x
end
function FindScriptID(list, a)
  i = 1
  while a > i do
    if list[i] == "" then
      a = a + 1
    end
    i = i + 1
  end
  while true do
    if list[a] == "" then
      a = a + 1
      break
    end
  end
  return a
end
function DeleteScript(SingleScript, list, a, c)
  local b
  a = FindScriptID(list, a)
  if list[a] == SingleScript then
    list[a] = ""
    c = c + 1
  end
  return c
end
function individualContrast(str, str_com_ed)
  return string.find(str, str_com_ed) and true or false
end
function StringFindIdx(str, fd)
  local i = 1
  local thestr
  thestr = tostring(str)
  while thestr and i <= string.len(thestr) do
    if string.sub(thestr, i, i) == fd then
      return i
    end
    i = i + 1
  end
end
function splittable(string, split)
  local tab = {}
  if not string then
    return tab
  end
  local b = 0
  local s, e
  while true do
    s, e = string.find(string, split, b)
    if s then
      local temp = string.sub(string, b, s - 1)
      table.insert(tab, temp)
      b = s + string.len(split)
    else
      local temp = string.sub(string, b, -1)
      table.insert(tab, temp)
      break
    end
  end
  return tab
end
function splittableEx(string, split, i)
  local b = 0
  local s, e, retn
  for j = 1, i do
    s, e = string.find(string, split, b)
    if s then
      local temp = string.sub(string, b, s - 1)
      b = s + string.len(split)
      if j == i then
        retn = temp
      end
    else
      break
    end
  end
  return retn
end
function left(string, index)
  return string.sub(string, 1, index)
end
function right(string, index)
  return string.sub(string, string.len(string) - index + 1, string.len(string))
end
function upper(string)
  return string.upper(string)
end
function lower(string)
  return string.lower(string)
end
function findword(str, words)
  local s, slen, wlen
  slen = string.len(str)
  wlen = string.len(words)
  s = 1
  while slen >= s do
    if string.sub(str, s, s + wlen - 1) == words then
      return true
    end
    s = s + 1
  end
  return false
end
function DebugLogIdZXY(DataLog, ddate)
  DataLog = "ZXY:--> " .. DataLog
  DebugLogId(DataLog, ddate)
end
function DebugLogId(DataLog, ddate)
  local time
  if not DataLog then
    DataLog = "DebugLogId??????????..."
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
  ddate = ddate or "Debug" or "???????" or "UULog"
  time = GetAPI_OsClock()
  if G_EngineMode == "MacIOS" then
    DataLog = "[" .. os.date("%Y-%m-%d %H:%M:%S") .. "." .. string.sub(time, -5, -3) .. " " .. ddate .. "]" .. DataLog .. "\t\n"
  else
    DataLog = "[" .. os.date("%Y-%m-%d %H:%M:%S", string.sub(time, 1, -4)) .. "." .. string.sub(time, -3, -1) .. " " .. ddate .. "]" .. DataLog .. "\t\n"
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
function DebugLogByFile(DataLog, ddate)
  local time
  if not DataLog then
    DataLog = "DebugLogId??????????..."
  elseif type(DataLog) == "table" then
    DataLog = table.concat(DataLog, "\n")
  end
  local debugfile
  local filename = "/data/local/tmp/c/filelog.txt"
  while true do
    debugfile = io.open(filename, "a")
    if not debugfile then
      GetAPI_Sleep(5)
    else
      break
    end
  end
  ddate = ddate or "???????"
  time = GetAPI_OsClock()
  DataLog = "[" .. os.date("%Y-%m-%d %H:%M:%S", string.sub(time, 1, -4)) .. "." .. string.sub(time, -3, -1) .. " " .. ddate .. "]" .. DataLog .. "\t\n"
  debugfile:write(DataLog)
  debugfile:close()
  print(DataLog)
end
function DebugLog(G_Id, DataLog, ActName)
  DataLog = DataLog or "nil value"
  ActName = ActName or "UNKNOWN"
  local debugfile
  local path = GetAPI_UusensePath()
  local filename
  filename = path .. "log.txt"
  while true do
    debugfile = io.open(filename, "a")
    if not debugfile then
      GetAPI_Sleep(5)
    else
      break
    end
  end
  DataLog = G_Id .. "--[" .. os.date("%Y-%m-%d %H:%M:%S") .. "]" .. " ???????:" .. ActName .. ",????:" .. DataLog .. "\t\n"
  debugfile:write(DataLog)
  debugfile:close()
end
function _writeLog(filename, filevalue, wtype)
  local vfile
  wtype = wtype or "a+"
  filename = filename or logfile
  vfile = io.open(filename, wtype)
  if vfile then
    filevalue = filevalue or "nil"
    vfile:write(filevalue)
    vfile:close()
  end
end
function DetectionNetwork(Purls, Ptimes, Ppcgsize, Psuccal)
  local res, pvalue, utab, ptab, vtab
  local succount = 0
  local i, j
  DebugLogId("***************************************Ping ??????***************************************")
  utab = splittable(Purls, "|")
  i = 1
  while i <= #utab do
    res, pvalue = GetAPI_PingInfo(utab[i], Ptimes, Ppcgsize)
    if res == 0 then
      ptab = splittable(string.sub(pvalue, 1, -2), "|")
      j = 1
      while j <= #ptab do
        vtab = splittable(ptab[j], ",")
        if 0 < tonumber(vtab[2]) then
          succount = succount + 1
        end
        DebugLogId("" .. string.format("Reply from %s: bytes=%s time=%sms TTL=%s", utab[i], Ppcgsize, vtab[2], vtab[3]))
        j = j + 1
      end
      if Psuccal <= succount then
        DebugLogId("***************************************Ping ???????**************************************")
        return 0
      end
    else
      DebugLogId("noReply from " .. utab[i])
    end
    i = i + 1
  end
  DebugLogId("***************************************Ping ???????***************************************")
  return 1
end
function CMCheckResultFile(ResultTitle)
  local CMResultList, CMTitleList
  local CMRetTable = {}
  local CMList
  local typetab = {
    "P",
    "T",
    "S",
    "I",
    "C",
    "N",
    "L",
    "K",
    "G"
  }
  local cmtype
  CMTitleList = splittable(ResultTitle, "|")
  for i = 1, #CMTitleList do
    if string.sub(CMTitleList[i], 1, 1) == "<" and string.sub(CMTitleList[i], -1, -1) == ">" then
      CMList = splittable(string.sub(CMTitleList[i], 2, -2), "#")
      if #CMList == 2 then
        cmtype = InTable(string.upper(CMList[2]), typetab)
        cmtype = cmtype or FindTitleType(CMList[1])
      else
        cmtype = FindTitleType(CMList[1])
      end
      table.insert(CMRetTable, CMList[1] .. "\t" .. cmtype)
    end
  end
  return CMRetTable
end
function FindTitleType(ret)
  local cmtype
  if string.find(ret, "?????") then
    cmtype = 1
  elseif string.find(ret, "???") or string.find(ret, "???") or string.find(ret, "??????") or string.find(ret, "?????") then
    cmtype = 2
  elseif string.find(ret, "????") then
    cmtype = 3
  else
    cmtype = 1
  end
  return cmtype
end
function GetVoucTale(G_Id)
  local retvouc = ""
  local strid = G_Id:match("%d+_%d+_%d+") or G_Id:match("%d+")
  strid = string.gsub(tostring(strid), "_", "")
  local i = 1
  while i <= 5 - string.len(strid) do
    retvouc = retvouc .. "0"
    i = i + 1
  end
  retvouc = retvouc .. strid
  return retvouc
end
function CMVoucFile(MakeLogfile, CMVouc)
  local vret, VoucAllPath
  local i = 1
  local retCMRlt, TempTab, ret, tb, retimg, res
  vret = -100
  VoucAllPath = MakeLogfile .. CMVouc
  vret = GetAPI_CaptureImg(VoucAllPath)
  DebugLogId("?????????????" .. VoucAllPath .. ",?????" .. vret)
  if ErrImageTab then
    DebugLogId("#########################################################################")
    DebugLogId("##########################??????????###############################")
    while i <= #ErrImageTab do
      TempTab = splittable(string.sub(ErrImageTab[i], 2, -2), "%],")
      ret, retimg = WaitExeption(VoucAllPath, TempTab[1])
      if ret == 0 then
        DebugLogId("???????????" .. retimg)
        tb = splittable(retimg, "_")
        retCMRlt = string.sub(tb[#tb], 1, -5)
        if TempTab[2] then
          Method_Touchs(TempTab[2], "", 2)
        end
        res = "2"
        break
      end
      i = i + 1
    end
    DebugLogId("##########################???????????###############################")
    DebugLogId("#########################################################################")
  end
  if retCMRlt and tonumber(retCMRlt) then
    print("????????")
  else
    retCMRlt = false
  end
  return retCMRlt, res
end
function CMVoucFileTxt(MakeLogfile, CMVouc)
  local lfile
  lfile = io.open(MakeLogfile .. CMVouc, "a")
  lfile:write(G_GlbVocMsg .. "\n")
  lfile:close()
end
function CMVoucSuccessTxt(G_Id, MakeLogfile, CMVouc, CMRlt, CMResultTitile)
  local lfile
  lfile = io.open(MakeLogfile .. CMVouc, "a")
  lfile:write(G_GlbVocMsg .. "\n")
  lfile:close()
end
function SplitSpnumContent(OldReceiveContent)
  local SPNumReceiveContent = ""
  local ReceiveContent = ""
  local TmpTab, tmptb
  local t = 1
  TmpTab = splittable(OldReceiveContent, "|")
  while t <= #TmpTab do
    if string.match(TmpTab[t], "-") then
      tmptb = splittable(TmpTab[t], "-")
      SPNumReceiveContent = SPNumReceiveContent .. "|" .. tmptb[1]
      ReceiveContent = ReceiveContent .. "|" .. tmptb[2]
    else
      ReceiveContent = ReceiveContent .. "|" .. TmpTab[t]
    end
    t = t + 1
  end
  SPNumReceiveContent = string.sub(SPNumReceiveContent, 2, -1)
  ReceiveContent = string.sub(ReceiveContent, 2, -1)
  return SPNumReceiveContent, ReceiveContent
end
function CheckGlbVocMsg()
  local retval, voctab, vi
  retval = false
  voctab = splittable(G_GlbVocMsg, "\n")
  vi = #voctab
  while vi > 0 do
    if voctab[vi] ~= "" and (string.match(voctab[vi], "%)???") or string.match(voctab[vi], "%)???") or string.match(voctab[vi], "???/???")) then
      retval = true
      break
    end
    vi = vi - 1
  end
  return retval
end
function ChangeUDTpye(nowtype, resulttitle)
  nowtype = tonumber(nowtype)
  if nowtype == 2 then
    if string.find(resulttitle, "????") or string.find(resulttitle, "????") then
      nowtype = 4
    elseif string.find(resulttitle, "???") and not string.find(resulttitle, "?????") then
      nowtype = 11
    elseif string.find(resulttitle, "?????") then
      nowtype = 15
    elseif string.find(resulttitle, "????") then
      nowtype = 16
    elseif string.find(resulttitle, "??????") then
      nowtype = 1
    elseif string.find(resulttitle, "ping") and string.find(resulttitle, "?") then
      nowtype = 8
    elseif string.find(string.lower(resulttitle), "dns") then
      nowtype = 8
    elseif string.find(string.lower(resulttitle), "tcp") then
      nowtype = 8
    else
      nowtype = 3
    end
  elseif nowtype == 3 then
    nowtype = 2
  end
  if nowtype == 10 then
    nowtype = 11
  end
  if string.find(resulttitle, "????") or string.find(resulttitle, "????") then
    nowtype = nowtype == 6 or nowtype == 7 and 1 or true
  elseif string.find(resulttitle, "[Cc][Pp][Uu]") and string.find(resulttitle, "???") or string.find(resulttitle, "[Cc][Pp][Uu]") and string.find(resulttitle, "???") or string.find(resulttitle, "[Cc][Pp][Uu]") and string.find(resulttitle, "???") or string.find(resulttitle, "???") and string.find(resulttitle, "???") then
    nowtype = 1
  elseif string.find(resulttitle, "???") and string.find(resulttitle, "???") or string.find(resulttitle, "???") and string.find(resulttitle, "???") then
    nowtype = 7
  end
  return nowtype
end
function instant_resValue(oneValue, cmtTestResult)
  if cmtTestResult == "03" and G_WebTurl then
    local Content = G_WebTurl
    if string.find(Content, "39.156.1.13:9091") or Content:match("183.192.162.204:9091") then
      local host = Content:match("^.*/(.*)")
      oneValue = string.gsub(oneValue, "\n", "")
      Businesses = string.gsub(Businesses, "\"", "")
      local ArguMentList = splittable(G_SysParms, "|")
      local taskID = ArguMentList[2]
      DebugLogId(string.format("??? [taskId=%s\tserviceName=%s] ??????: \n%s", taskID, Businesses, oneValue))
      local result = _cfunc.GbkToUtf8(oneValue)
      local serviceName = _cfunc.GbkToUtf8(Businesses)
      local updatestr = string.format("taskId=%s&serviceName=%s&result=%s", taskID, serviceName, result)
      local curlPath = "/data/local/tmp/curl-7.40.0/bin/curl"
      local pushCmd = string.format("%s/apps/instant_results/upload_result -H 'Cache-Control: no-cache' -H 'Connection: Close' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'HOST: %s' -d '%s'", Content, host, updatestr)
      _cfunc.Print(string.format("%s -s -X POST %s", curlPath, pushCmd))
      local ret = _cfunc.Command(string.format("%s -s -X POST %s", curlPath, pushCmd))
      _cfunc.Print(ret)
      if ret == "" or not ret then
        ret = "{status:1, msg:\"??????, ????curl??????????\"}"
      end
      DebugLogId(string.format("???????(%s)\treturn??0?????\t1??????: \n%s", Content, ret))
    end
  end
end
function CMWriteResultLog(ResultTable, Titletab, LastTab)
  local ResultTitle = ResultTable[1]
  local ret = ResultTable[2]
  local ResultContent = ResultTable[3]
  local ActionStartTime = os.date("%Y%m%d%H%M%S", ResultTable[4])
  local ActionEndTime = os.date("%Y%m%d%H%M%S", ResultTable[5])
  local CMRetIdxTable, ArguMentList
  local resultEdt = "1.0.0"
  local cmtTestMode, cmtTestNum
  local ReTestCount = "0"
  local ResultType
  local ResultTypeTab = {
    "auto",
    "auto_capture",
    "video",
    "auto_video",
    "dns",
    "http",
    "ping",
    "file",
    "wifi",
    "netsense"
  }
  local CMRecordTab, cmtServiceCode, CMRetFlag, CMRetFlagEx, cmtTestResult, vocchkflg, CMRlt, TestValue, Netflag, cmtNetworkFlag, CMValue, AttachFileType, reltype, setp
  local tstime = 0
  local imgret, imgidx, autoret, autoid, ImgFileName, scriptpath, scriptfile, tempscript, tmpcontect, tempscript1
  local abc = -1
  local TempTime, TempImgName
  local TempIMGtable = {}
  local scriptIMG, pic_path
  local SinglePicList = {}
  local LastIMG = {}
  local retx, err
  cmtTestMode = GetAPI_TestMode()
  ArguMentList = splittable(G_SysParms, "|")
  cmtTestNum = ArguMentList[4]
  if string.find(ResultTitle, "+(%d)") then
    _, _, setp = string.find(ResultTitle, "+(%d)")
    ResultTitle = string.gsub(ResultTitle, "+%d", "")
    for i = #G_TestTimeTab - tonumber(setp), #G_TestTimeTab do
      tstime = tstime + G_TestTimeTab[i]
    end
    ResultContent[2] = tstime
    if ResultContent[5] == "rate" then
      ResultContent[3] = DecPoint(ResultContent[4] / ResultContent[2])
    end
  end
  CMRetIdxTable = CMCheckResultFile(ResultTitle)
  cmtNetworkFlag = GetAPI_NetFlag()
  DebugLogId("?????????" .. cmtNetworkFlag)
  if ret ~= 0 then
    G_fail_flag = true
    vocchkflg = CheckGlbVocMsg()
    if G_GlbVocMsg == "" or not vocchkflg then
      if G_CMVouc == "" then
        TempTime = os.date("%Y%m%d%H%M%S")
        if G_EngineMode == "MacIOS" then
          G_CMVouc = "hzys_" .. TempTime .. GetVoucTale(G_Id) .. ".jpeg"
        else
          G_CMVouc = "hzys_" .. TempTime .. GetVoucTale(G_Id) .. ".png"
        end
        DebugLogId("??????????...")
        if G_EngineMode == "Android" then
          CMRlt = CMVoucFile(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg, G_CMVouc)
          if G_RSflag then
            VoucRecordScreen()
          end
          if pcall(function()
            local file = io.open(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump.xml", "r")
            file:close()
          end) then
            DebugLogId("????dump.xml")
            local filename = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump.xml"
            local filename_timestamp = "hzys_" .. TempTime .. GetVoucTale(G_Id) .. ".xml"
            retx, err = pcall(CopyFile, filename, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. filename_timestamp)
            if retx then
              table.insert(G_fail_dump_tab, filename_timestamp)
            end
          end
        elseif G_EngineMode == "IOS" then
          pic_path = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "hzys_" .. TempTime .. GetVoucTale(G_Id)
          GetAPI_CreateDir(pic_path)
          CMRlt = CMVoucFile(pic_path .. G_Pflg, G_CMVouc)
        elseif G_EngineMode == "MacIOS" then
          DebugLogId("????????????????????????????")
          pic_path = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg .. "hzys_" .. TempTime .. GetVoucTale(G_Id)
          CMRlt = CMVoucFile(pic_path, ".jpeg")
        end
        if G_ScriptPic ~= "" then
          G_ScriptPic = string.gsub(G_ScriptPic, "%-", "|")
          SinglePicList = splittable(G_ScriptPic, "|")
          for i = 1, #SinglePicList do
            local Imgtmp
            scriptIMG = "hzys_" .. TempTime .. GetVoucTale(G_Id)
            TempIMGtable = splittable(SinglePicList[i], "_")
            scriptIMG = scriptIMG .. "_" .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_(" .. i .. ")"
            if not InTable(TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4], LastIMG) then
              if G_EngineMode == "Android" then
                Imgtmp = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "hzys_" .. TempTime .. GetVoucTale(G_Id) .. "_" .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_ComPoSc.bmp"
                GetAPI_CaptureRectangle(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.bmp")
                CopyFile(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.bmp", Imgtmp)
                GetAPI_Deletefile(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.bmp")
                table.insert(LastIMG, TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4])
              elseif G_EngineMode == "IOS" then
                Imgtmp = pic_path .. G_Pflg .. "hzys_" .. TempTime .. GetVoucTale(G_Id) .. "_" .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_ComPoSc.png"
                GetAPI_CaptureRectangle(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.png", TempIMGtable[1], TempIMGtable[2], TempIMGtable[3], TempIMGtable[4])
                pcall(CopyFile, "/var/mobile/ua_small.png", Imgtmp)
                pcall(CopyFile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.png", Imgtmp)
                pcall(GetAPI_Deletefile, "/var/mobile/ua_small.png")
                pcall(GetAPI_Deletefile, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_.png")
                table.insert(LastIMG, TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4])
              end
            else
              Imgtmp = ""
            end
            if G_EngineMode == "Android" then
              retx, err = pcall(CopyFile, G_SysScpPath .. G_Pflg .. SinglePicList[i], string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. scriptIMG .. string.sub(SinglePicList[i], -4, -1))
              if retx then
                DebugLogId("???°§????" .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. scriptIMG .. string.sub(SinglePicList[i], -4, -1) .. "|" .. Imgtmp)
                DebugLogId("???°§????" .. "hzys_" .. TempTime .. GetVoucTale(G_Id))
                table.insert(G_scriptimg, {
                  string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. scriptIMG .. string.sub(SinglePicList[i], -4, -1) .. "|" .. Imgtmp,
                  "hzys_" .. TempTime .. GetVoucTale(G_Id)
                })
              end
            elseif G_EngineMode == "IOS" then
              retx, err = pcall(CopyFile, G_SysScpPath .. G_Pflg .. SinglePicList[i], pic_path .. G_Pflg .. scriptIMG .. string.sub(SinglePicList[i], -4, -1))
            end
            if err then
              DebugLogId("?????????????" .. err)
            end
          end
        end
        if G_Automatical == true then
          if G_EngineMode == "Android" then
            autoret, autoid, ImgFileName = auto_WaitEx(G_ScriptPic)
          else
            print("?????????")
          end
        end
      end
    elseif G_CMVouc == "" then
      G_CMVouc = "hzys_" .. os.date("%Y%m%d%H%M%S") .. GetVoucTale(G_Id) .. ".txt"
      CMVoucFileTxt(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg, G_CMVouc)
      G_GlbVocMsg = ""
    end
  else
    G_GlbVocMsg = ""
  end
  if ResultContent[1] == "TITLE" then
    if ResultContent[2] == "N4" then
      reltype = "04"
    elseif ResultContent[2] == "N3" then
      reltype = "03"
    elseif ResultContent[2] == "N2" then
      reltype = "02"
    elseif ResultContent[2] == "N1" then
      reltype = "01"
    elseif ResultContent[2] == "N10" then
      reltype = "10"
    elseif ResultContent[2] == "N11" then
      reltype = "11"
    elseif ResultContent[2] == "N12" then
      reltype = "12"
    elseif ResultContent[2] == "N13" then
      reltype = "13"
    elseif ResultContent[2] == "N14" then
      reltype = "14"
    elseif ResultContent[2] == "Y" then
      reltype = "00"
    else
      reltype = "01"
      DebugLogId("TITLE???????'" .. ResultContent[2] .. "'????!", "???????")
    end
    if LastTab then
      ResultContent = LastTab[3]
      ActionStartTime = os.date("%Y%m%d%H%M%S", LastTab[4])
      ActionEndTime = os.date("%Y%m%d%H%M%S", LastTab[5])
    end
  end
  local connectionflag
  for i = 1, #CMRetIdxTable do
    connectionflag = true
    TestValue = ""
    if InTable(ResultContent[1], ResultTypeTab) then
      ResultType = ResultContent[1]
    else
      ResultType = "auto"
    end
    CMRecordTab = splittable(CMRetIdxTable[i], "\t")
    cmtServiceCode = CMRecordTab[1]
    CMRetFlag = CMRecordTab[2]
    if ret == 0 then
      cmtTestResult = "00"
      AttachFileType = "0"
    else
      AttachFileType = "1"
      if CMRlt then
        cmtTestResult = CMRlt
      end
      if ret == 5 then
        cmtTestResult = "05"
      elseif autoret == 0 then
        cmtTestResult = "14"
      elseif reltype then
        cmtTestResult = reltype
      else
        cmtTestResult = "03"
      end
    end
    if ResultType == "auto" or ResultType == "netsense" or ResultType == "ping" or ResultType == "dns" or ResultType == "auto_capture" then
      CMRetFlagEx = ChangeUDTpye(CMRetFlag, cmtServiceCode)
      if ResultContent[tonumber(CMRetFlag)] then
        if ResultContent[tonumber(CMRetFlag)] == "auto" or ResultContent[tonumber(CMRetFlag)] == "netsense" or ResultContent[tonumber(CMRetFlag)] == "ping" or ResultContent[tonumber(CMRetFlag)] == "dns" or ResultContent[tonumber(CMRetFlag)] == "auto_capture" then
          if ret == 0 then
            TestValue = "1|" .. CMRetFlagEx .. string.rep("|NA", 8)
          else
            TestValue = "0|" .. CMRetFlagEx .. string.rep("|NA", 8)
          end
        else
          TestValue = ResultContent[tonumber(CMRetFlag)] .. "|" .. CMRetFlagEx .. string.rep("|NA", 8)
        end
      else
        DebugLogId("??????????????!", "???????")
        TestValue = "nil|" .. CMRetFlagEx .. string.rep("|NA", 8)
      end
    else
      for j = 2, #ResultContent do
        TestValue = TestValue .. ResultContent[j] .. "|"
      end
      if ResultType ~= "video" or ResultType == "auto_video" then
        TestValue = TestValue .. "NA" .. string.rep("|NA", 10 - #ResultContent)
      else
        TestValue = string.sub(TestValue, 1, -2)
      end
    end
    TestValue = ResultContent.provText and string.format("%s|%s", TestValue, ResultContent.provText) or TestValue
    if ResultType == "netsense" then
      CMValue = ResultType .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. AttachFileType .. "\t" .. G_CMVouc .. "\t" .. G_NETSENSE .. "\n"
    elseif ResultType == "auto_capture" then
      CMValue = "auto" .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. "1" .. "\t" .. G_CaptureImg .. "\n"
    elseif ResultType == "ping" then
      CMValue = "auto" .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. "1" .. "\t" .. G_CMPNVouc .. "\n"
    elseif ResultType == "dns" then
      CMValue = "auto" .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. "1" .. "\t" .. G_CMDNSVouc .. "\n"
    else
      CMValue = ResultType .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. AttachFileType .. "\t" .. G_CMVouc .. "\n"
    end
    DebugLogId("??????????:" .. CMValue)
    DebugLogId(string.format("TestValue[%s]: %s\t%s", ret, TestValue, cmtTestResult))
    if ret ~= 0 then
      instant_resValue(CMValue, cmtTestResult)
    end
    table.insert(G_CMValueTable, CMValue)
  end
  if #CMRetIdxTable > 0 and reltype then
    reltype = false
  end
  if #Titletab > 0 and not G_cyc_traverse then
    local temptab
    if reltype then
      cmtTestResult = reltype
    elseif connectionflag then
      cmtTestResult = "11"
    else
      cmtTestResult = "04"
    end
    AttachFileType = "1"
    for i = 1, #Titletab do
      TestValue = ""
      temptab = splittable(Titletab[i], "\t")
      ResultTitle = temptab[1]
      ResultType = temptab[2]
      CMRetIdxTable = CMCheckResultFile(ResultTitle)
      CMRecordTab = splittable(CMRetIdxTable[1], "\t")
      cmtServiceCode = CMRecordTab[1]
      CMRetFlag = CMRecordTab[2]
      if ResultType == "auto" or ResultType == "netsense" or ResultType == "ping" or ResultType == "dns" then
        CMRetFlagEx = ChangeUDTpye(CMRetFlag, cmtServiceCode)
        TestValue = "0|" .. CMRetFlagEx .. string.rep("|NA", 8)
      elseif ResultType == "video" or ResultType == "auto_video" then
        TestValue = "0" .. string.rep("|0", 14)
      elseif ResultType == "http" or ResultType == "file" then
        TestValue = "0" .. string.rep("|0", 3) .. string.rep("|NA", 6)
      elseif ResultType == "wifi" then
        TestValue = "0" .. string.rep("|0", 5) .. string.rep("|NA", 4)
      end
      if ResultType == "netsense" then
        CMValue = ResultType .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. AttachFileType .. "\t" .. G_CMVouc .. "\t" .. G_NETSENSE .. "\n"
      else
        CMValue = ResultType .. "\t" .. resultEdt .. "\t" .. cmtServiceCode .. "\t" .. cmtTestMode .. "\t" .. ActionStartTime .. "\t" .. ActionEndTime .. "\t" .. cmtTestNum .. "\t" .. ReTestCount .. "\t" .. cmtTestResult .. "\t" .. TestValue .. "\t" .. cmtNetworkFlag .. "\t0\t" .. AttachFileType .. "\t" .. G_CMVouc .. "\n"
      end
      DebugLogId("??????????:" .. CMValue)
      instant_resValue(CMValue, cmtTestResult)
      table.insert(G_CMValueTable, CMValue)
    end
  end
end
AppEdt = "3.0.1"
function APPtestMain(ArguMentList)
  local appVer, pkgname, md5Value, TaskPtype, AppPtype, AppUrlPath, webUrlPath, appActivity, flag, BLtime
  if not TestMode then
    TestMode = ""
  end
  if DebugFlag and DebugFlag:match("Android") then
    appVer, pkgname, md5Value, TaskPtype, AppPtype, AppUrlPath, webUrlPath, BLtime = ListJudge(ArguMentList, 2)
  else
    appVer, pkgname, md5Value, TaskPtype, AppPtype, AppUrlPath, webUrlPath, BLtime = ListJudge(ArguMentList, 1)
  end
  GetAPI_CreateDir(G_SysDbgPath .. "/images")
  DebugLogId(string.format("APP?????APP_??????%s   APP_?∑⁄??%s   APP_MD5??%s", pkgname, appVer, md5Value))
  if APP_MainActivity then
    DebugLogId("App_MainActivity: " .. APP_MainActivity)
    appActivity = string.format("%s/%s", pkgname, APP_MainActivity)
  end
  if (pkgname == "UNKNOWN" or not DebugFlag) and md5Value == "UNKNOWN" then
    DebugLogId("APP??????MD5???????????app??????????")
    return 0
  end
  if string.find(AppUrlPath, "http:") or Businesses == "Z.X.Y" then
    local tasktmp = "¶ƒ????"
    if tonumber(TaskPtype) == 1 then
      G_APPJRscript = true
      tasktmp = "????"
    elseif tonumber(TaskPtype) == 2 then
      G_APPBLscript = true
      tasktmp = "ripper????"
      DebugLogId(string.format("???ripper???????images??%s", "/sdcard/autosense_ripper_data/"))
      os.execute(string.format("rm -f %s*", "/sdcard/autosense_ripper_data/"))
      os.execute(string.format("rm -f %s*", "/sdcard/autosense_ripper_data/images/"))
    elseif tonumber(TaskPtype) == 3 then
      G_APPMonkey = true
      tasktmp = "Monkey"
    else
      DebugLogId("App????????????????????:" .. TaskPtype)
    end
    local strtmp = tonumber(AppPtype) == 0 and "ßÿ??" or tonumber(AppPtype) == 1 and "????" or "false"
    DebugLogId(string.format("App?????????%s?????????????%s??????????%s", tasktmp, strtmp, AppUrlPath))
  else
    G_APPJRscript = true
    DebugLogId(string.format("App?????????%s?????????????%s??????????%s", "????", "ßÿ??", AppUrlPath))
  end
  if G_EngineMode ~= "Android" then
    DebugLogId(string.format("?? Android ??????????????break ??????????"))
    return
  end
  UI_AutoClickOpen(pkgname)
  local head = "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>"
  table.insert(G_JRResultXml, head)
  table.insert(G_JRResultXml, "<result>")
  table.insert(G_JRResultXml, "<results>")
  table.insert(G_JRResultXml, "</results>")
  table.insert(G_JRResultXml, "</result>")
  if tonumber(AppPtype) == 0 and not G_APPMonkey then
    ret = CheckPKG(pkgname)
    if ret == 0 then
      local stimer = os.date("%Y-%m-%d %H:%M:%S")
      DebugLogId(string.format("app %s ????,???ßÿ?? ", pkgname))
      local ret, ereason = AppUnInstall(pkgname)
      if ret ~= 0 then
        DebugLogId(string.format("app %s ßÿ?????,??????????????? ", pkgname))
        Insert_AppInfo(0, _, _, 33, "????????????ßÿ????????????????" .. ereason)
        JRoneCapture("app_uninstall_failed")
        if G_RSflag then
          VoucRecordScreen()
        end
        JRResult("uninstall", stimer, "cmd", "app_uninstall_failed", "false", "", "")
        return 0
      end
    else
      DebugLogId(string.format("APP %s ¶ƒ???,???????ßÿ???", pkgname))
    end
  end
  if not JRAPPTEST_uninstall then
    local stimer = os.date("%Y-%m-%d %H:%M:%S")
    local ret, appResult = AppDownload(AppUrlPath, md5Value)
    if ret == 0 then
      APP_Deployment(pkgname, appActivity, appResult, BLtime)
    else
      if webUrlPath and webUrlPath ~= "" then
        ret, appResult = AppDownload(webUrlPath, md5Value)
      end
      if ret == 0 then
        APP_Deployment(pkgname, appActivity, appResult, BLtime)
      else
        JRoneCapture("app_download_failed")
        if G_RSflag then
          VoucRecordScreen()
        end
        Insert_AppInfo(0, 0, _, 4, appResult)
        JRResult("download", stimer, "cmd", "app_download_failed", "false", "", "")
      end
    end
  end
  GetAPI_logcat("end", pkgname)
  if JRAPPTEST_install then
    return 0
  end
  if not DebugFlag then
    ret = CheckPKG(pkgname)
    if ret == 0 then
      local ret, ereason = AppUnInstall(pkgname)
      if ret ~= 0 then
        local appinfo = G_JRResultXml[3]
        local t = string.match(appinfo, " result=%b\"\"")
        local appinfo = string.gsub(appinfo, t, string.format(" result=\"%s\"", "33"))
        local t = string.match(appinfo, " error_reason=%b\"\"")
        local appinfo = string.gsub(appinfo, t, string.format(" error_reason=\"%s\"", ereason))
        JRresultTb[3] = appinfo
        DebugLogId(string.format("app %s ßÿ?????,??????????????? ", pkgname))
        if G_RSflag then
          VoucRecordScreen()
        end
      end
    end
  end
  return 0
end
function ListJudge(ArguMentList, flag)
  local appVer, pkgname, md5Value, TaskPtype, AppPtype, BLtime, AppUrlPath, webUrlPath
  if flag == 1 then
    local appInfo = ArguMentList[#ArguMentList - 1]
    local appStr = splittable(appInfo, "##")
    appVer = APP_Version or appStr[7] or "UNKNOWN"
    pkgname = APP_PacketName or appStr[6] or "UNKNOWN"
    md5Value = appStr[9] or "UNKNOWN"
    BLtime = not appStr[10] and appStr[10] == "" and 5 or appStr[10]
    TaskPtype = appStr[2]
    AppPtype = appStr[3]
    local Monktype = appStr[15] or -1
    if tonumber(Monktype) == 1 then
      local values = appStr[17] or 15
      local unit = appStr[18] or 1
      DebugLogId(string.format("monkey : %s %s", values, tonumber(unit) == 1 and "????" or "ß≥?"))
      BLtime = tonumber(unit) == 2 and values * 60 or values
      TaskPtype = 3
    end
    webUrlPath = appStr[4] == "" and "" or appStr[5]
    AppUrlPath = appStr[4] == "" and appStr[5] or appStr[4]
  elseif flag == 2 then
    appVer = APP_Version or ArguMentList[10] or "UNKNOWN"
    pkgname = APP_PacketName or ArguMentList[8] or "UNKNOWN"
    md5Value = ArguMentList[13] or "UNKNOWN"
    TaskPtype, AppPtype = 1, 0
    AppUrlPath = ArguMentList[9]
    webUrlPath = ""
  end
  return appVer, pkgname, md5Value, TaskPtype, AppPtype, AppUrlPath, webUrlPath, BLtime
end
function UI_AutoClickOpen(package, time)
  local shell
  package = G_pkgName or package
  if package then
    shell = string.format("uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e isAutoinstaller true -e package %s", package)
  else
    shell = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e isAutoinstaller true"
  end
  local backRun = "/data/local/tmp/c/program/commandd /system/bin/uiautomator"
  local tmpstr = string.format("%s %s", backRun, shell)
  _cfunc.Command(tmpstr)
  if time then
    DebugLogId(string.format("UI_AutoClick Open??Keep live in %ds", time))
    GetAPI_Sleep(tonumber(time))
  else
    DebugLogId("UI?????????????")
  end
end
function CheckPKG(pkgname)
  local ret = -1
  local cmd = "pm list packages"
  local cmdReturn = _cfunc.Command(cmd)
  if cmdReturn == "" then
    DebugLogId(string.format("_cfunc.Command :%s return log is nil", cmd))
    return ret
  end
  local apkLists = splittable(cmdReturn, "\n")
  for i, v in ipairs(apkLists) do
    if string.find(v, pkgname) then
      ret = 0
      break
    end
  end
  return ret
end
function AppUnInstall(pkgname)
  local tmpstr = string.format("pm uninstall %s", pkgname)
  local status = _cfunc.Command(tmpstr)
  DebugLogId(string.format("app %s status: %s", tmpstr, status:gsub("\n", "")))
  local ret = 0
  if not string.find(status, "Success") then
    ret = 1
    local tmpstr = string.format("dumpsys package %s | grep versionName ", pkgname)
    DebugLogId("app versionName :" .. tmpstr)
  end
  return ret, status
end
function AppInstall(pkgpath, pkgname)
  local tmpstr = string.format("pm install -r %s", pkgpath)
  local logs = _cfunc.Command(tmpstr, 180)
  local ret = -1
  local sclock = GetAPI_OsClock()
  DebugLogId(string.format("app install return log :\n%s ??", logs))
  if logs == "" then
    DebugLogId(string.format("_cfunc.Command :%s return log is nil", tmpstr))
    logs = "Command not return log"
  end
  while true do
    ret = CheckPKG(pkgname)
    if ret == 0 then
      break
    end
    if 180 < GetAPI_SubTime(GetAPI_OsClock(), sclock) then
      break
    end
  end
  if ret ~= 0 then
    ret = 1
  end
  return ret, logs
end
function AppInstall_commandd(pkgpath, pkgname)
  local tmpstr = string.format("pm install %s", pkgpath)
  local sclock = GetAPI_OsClock()
  uu_cmd_bin(tmpstr)
  local ret = -1
  while true do
    ret = CheckPKG(pkgname)
    if ret == 0 then
      break
    end
    if GetAPI_SubTime(GetAPI_OsClock(), sclock) > 120 then
      DebugLogId(string.format("app install timeout(%ss)??", 120))
      break
    else
      DebugLogId("??ˆó????????????????????")
    end
  end
  return ret, "FAILED"
end
function DumpWindows(pkgname)
  local check_win = function(pkgname)
    local cmdd = "dumpsys window windows | grep -E 'mCurrentFocus'"
    local dumplog = _cfunc.Command(cmdd)
    if dumplog:match(pkgname) then
      DebugLogId(string.format("??????????????????????????(%s), dumpsys window : %s", pkgname, dumplog))
      return 0
    else
      DebugLogId(string.format("???????????????????????????(%s), dumpsys window : %s", pkgname, dumplog))
      return 1
    end
  end
  local ret, pid, appstarttime
  ret = check_win(pkgname)
  if ret ~= 0 then
    _cfunc.Key(4, 3)
    _cfunc.Sleep(1836)
    _cfunc.Key(3, 3)
    _cfunc.Sleep(1836)
    ret, pid, appstarttime = StartAppUI(pkgname, appActivity)
  end
  DebugLogId("Second App Start Time :" .. appstarttime or "0.0")
  ret = check_win(pkgname)
  return ret
end
function StartAppUI(pkgname, appActivity)
  local ret, pid, tmpstr
  local starttime = 0
  local sclock, rlog = 0, ""
  if appActivity then
    tmpstr = string.format("am start -n %s", appActivity)
    DebugLogId("app start mainUI :" .. tmpstr)
    sclock = GetAPI_OsClock()
    rlog = _cfunc.Command(tmpstr)
  else
    DebugLogId("app start pkgname :" .. pkgname)
    sclock = GetAPI_OsClock()
    rlog = _cfunc.OpenApplication(pkgname, "")
    tmpret, pid, starttime = PidGrepPS(pkgname, sclock, 30)
    if tmpret == 3 then
      tmpstr = string.format("monkey -p %s -c android.intent.category.LAUNCHER 1", pkgname)
      sclock = GetAPI_OsClock()
      rlog = _cfunc.Command(tmpstr)
    end
  end
  DebugLogId("app start return :" .. rlog)
  ret, pid, starttime = PidGrepPS(pkgname, sclock, 60)
  DebugLogId(string.format("app start ret = %s??pid =%s??time = %s ", ret, pid, starttime))
  DebugLogId(string.format("to sleep 10s;"))
  _cfunc.Sleep(10000)
  return ret, pid, starttime
end
function Insert_AppInfo(installtime, appstarttime, pid, result, error_reason)
  installtime = installtime or ""
  appstarttime = appstarttime or ""
  result = result or ""
  pid = pid or "-1"
  error_reason = error_reason or ""
  local starttime = os.date("%Y-%m-%d %H:%M:%S")
  local info = string.format("result=\"%s\" installtime=\"%s\" appstarttime=\"%s\" starttime=\"%s\" endtime=\"\" hasloginevent=\"0\" pid=\"%s\" error_reason=\"%s\" ", result, installtime, appstarttime, starttime, pid, error_reason)
  info = string.format("<resultinfo %s />", info)
  table.insert(G_JRResultXml, 3, info)
  DebugLogId("App info:" .. info)
end
function APP_Deployment(pkgname, appActivity, pkgpath, bltime)
  local sclock = GetAPI_OsClock()
  DebugLogId("App install start?? " .. pkgpath)
  local stimer = os.date("%Y-%m-%d %H:%M:%S")
  local ret, log = AppInstall(pkgpath, pkgname)
  local installtime = GetAPI_SubTime(GetAPI_OsClock(), sclock)
  DebugLogId(string.format("App install time :%s ret = %s", installtime, ret))
  if ret == 0 then
    local stimer = os.date("%Y-%m-%d %H:%M:%S")
    local ret, pid, appstarttime
    ret, pid, appstarttime = StartAppUI(pkgname, appActivity)
    DebugLogId("App start time :" .. appstarttime)
    if ret ~= 0 then
      DebugLogId("App start failed exit test !.")
      local log = appActivity
      JRoneCapture("app_start_failed")
      if G_RSflag then
        VoucRecordScreen()
      end
      Insert_AppInfo(installtime, appstarttime, pid, ret, log)
      JRResult("APPstart", stimer, "cmd", "app_start_failed", "false", "", "")
      AppUnInstall(pkgname)
    else
      DebugLogId("APP AUTO DEPLOYMENT COMPLETE ...")
      Method_PerformanceManager("start", pkgname)
      GetAPI_logcat("start", pkgname)
      Insert_AppInfo(installtime, appstarttime, pid)
      if G_APPJRscript then
        DebugLogId("-------------------------------------???[????]??????------------------------------------------")
        status, err = pcall(MainFunction)
        if not status then
          DebugLogId(string.format("MainFunction:%s", err))
        end
        DebugLogId("-------------------------------------???[????]???????------------------------------------------")
      elseif G_APPBLscript then
        DebugLogId("-------------------------------------???[????]??????------------------------------------------")
        status, err = pcall(APPTraveler, pkgname, bltime, appstarttime, installtime)
        if not status then
          DebugLogId(string.format("APPTraveler:%s", err))
        end
        DebugLogId("-------------------------------------???[????]???????------------------------------------------")
      elseif G_APPMonkey then
        DebugLogId("-------------------------------------???[monkey]??????------------------------------------------")
        status, err = pcall(APPMonkeyer, pkgname, bltime)
        if not status then
          DebugLogId(string.format("APPMonkeyer:%s", err))
        end
        DebugLogId("-------------------------------------???[monkey]???????------------------------------------------")
      else
        DebugLogId("error TestInfo UnDefine , exit !!!")
        status, err = 1, "App TestInfo UnDefine"
      end
      DebugLogId("App Test Complete !")
    end
  else
    DebugLogId("App install failed exit test !")
    JRoneCapture("app_install_failed")
    if G_RSflag then
      VoucRecordScreen()
    end
    Insert_AppInfo(installtime, appstarttime, pid, ret, log)
    JRResult("install", stimer, "cmd", "app_install_failed", "false", "", "")
  end
end
function HttpDownAPK(DownUrl)
  local host, url
  local i = string.find(DownUrl, "/")
  local header = "User-Agent:Mozilla/5.0(Linux;U;Android 5.1.1, GT-I9108) Mobile\r\nAccpt: */*\r\nContent-Length: 0\r\nConnection: Close\r\n\r\n"
  host = string.match(DownUrl, "(%d+.%d+.%d+.%d+)")
  url = string.match(DownUrl, "%d+.%d+.%d+.%d+(.*)")
  local httpStr = string.format("GET %s HTTP/1.1\r\nHost: %s\r\n%s", url, host, header)
  local hosturl = port and string.format("%s:%s", host, port) or host
  DebugLogId("???????:" .. DownUrl)
  DebugLogId("httpSendStr:\n" .. httpStr)
  DebugLogId("hosturl\t" .. hosturl)
  local Doret, r2, r3, r4, r5, r6, ret, r8, r9, r10, connect, r12 = GetAPI_HttpClient(hosturl, httpStr)
  local DLName = os.date("%Y%m%d%H%M%S")
  local app_DbgPath = string.format("%s%s.apk", G_SysDbgPath, DLName)
  if ret > 0 then
    local lfile = io.open(app_DbgPath, "a")
    lfile:write(connect)
    lfile:close()
    DebugLogId("HTTP????app???: " .. app_DbgPath)
    return 0, app_DbgPath
  else
    local idurl = string.format("info: %s ???????:%s", G_Id, DownUrl)
    _cfunc.Print(idurl)
    _cfunc.Print("httpSendStr:\n" .. httpStr)
    _cfunc.Print("hosturl\t" .. hosturl)
    _cfunc.Print("return value :\n")
    _cfunc.Print("return r1 :" .. Doret)
    _cfunc.Print("return r2 :" .. r2)
    _cfunc.Print("return r3 :" .. r3)
    _cfunc.Print("return r4 :" .. r4)
    _cfunc.Print("return r5 :" .. r5)
    _cfunc.Print("return r6 :" .. r6)
    _cfunc.Print("return r7 :" .. ret)
    _cfunc.Print("return r8 :" .. r8)
    _cfunc.Print("return r9 :" .. r9)
    _cfunc.Print("return r10 :" .. r10)
    _cfunc.Print("return r11 :" .. connect)
    _cfunc.Print("return r12 :" .. r12)
    local elog = {
      "???",
      "Dns",
      "????",
      "????",
      "???",
      "????",
      "???"
    }
    log = "HTTP-->" .. elog[Doret + 1]
    DebugLogId("HTTP????app???:(" .. Doret .. ")" .. log)
    return 1, log
  end
end
function AppDownload(appUrlPath, md5Value)
  local ret = -1
  local appPath, appDlog = "", ""
  local pkgpath = appUrlPath
  if string.find(appUrlPath, "http:") then
    local curlPathstr = (cmd_exists("curl") ~= 0 or not "curl") and File_Exists("/data/local/tmp/curl-7.40.0/bin/curl") and "/data/local/tmp/curl-7.40.0/bin/curl"
    if curlPathstr then
      DebugLogId(" ??" .. curlPathstr)
      local DLtime = 180
      local app_DbgPath = string.format("%s%s.apk", G_SysDbgPath, md5Value)
      for i = 1, 3 do
        if i == 2 then
          DLtime = DLtime + 120
        end
        if i == 3 then
          DLtime = DLtime + 300
        end
        _cfunc.Command(string.format("am force-stop %s", curlPathstr))
        _cfunc.KillProcess(curlPathstr)
        DebugLogId(string.format("????app????(%ss)??:%s", DLtime, app_DbgPath))
        local cmddurl = string.format("%s -C - -o %s %s", curlPathstr, app_DbgPath, appUrlPath)
        DebugLogId(" ??" .. cmddurl)
        local curllog = _cfunc.Command(cmddurl, DLtime + 100)
        DebugLogId("curl return log??\n??" .. curllog)
        ret, appDlog = MatchMD5(app_DbgPath, md5Value)
        if ret == 0 then
          break
        end
        if ret == -1 then
          DebugLogId(string.format("MD5 ??˙G???ßµ???????????????????"))
          break
        end
        DebugLogId(string.format("app downLoad %ss timeout,Try for Longer minutes??", DLtime))
      end
      appPath = ret == 0 and app_DbgPath or string.format("%s : %s", appDlog, app_DbgPath:match("^.*/(.*)") or app_DbgPath or "")
    else
      appPath = "????????curl ??˙G???"
      DebugLogId(appPath)
      ret = 1
    end
  else
    DebugLogId("???????app???????????????")
    if File_Exists(appUrlPath) then
      ret = 0
      appPath = appUrlPath
    else
      ret = 1
      DebugLogId("error ¶ƒ????app??????" .. appUrlPath)
    end
  end
  return ret, appPath
end
function cmd_exists(cmdd)
  local vlog = GetAPI_Command(cmdd)
  vlog = vlog:match("not") and 1 or 0
  return vlog
end
function File_Exists(path, flg)
  local file = io.open(path, "rb")
  if file then
    file:close()
    if not flg then
      if not (length_of_file(path) > 1) or not file then
        file = nil
      end
    else
      file = 0
    end
  end
  return file ~= nil
end
function length_of_file(filename)
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end
function MatchMD5(appPath, md5Value)
  local ret = -1
  local appDlog = ""
  local md5cmd = cmd_exists("md5sum") == 0 and "md5sum" or cmd_exists("md5") == 0 and "md5"
  if not File_Exists(appPath) then
    DebugLogId("??????ßﬁ???, ?????????")
    return 1, string.format("??????ßﬁ???, ?????????")
  end
  if md5cmd then
    local md5str = string.format("%s %s", md5cmd, appPath)
    local md5log = _cfunc.Command(md5str)
    local localmd5 = string.match(md5log, "(.-) ")
    if tostring(localmd5) ~= tostring(md5Value) then
      ret = 1
      appDlog = string.format("web md5: %s != local md5: %s", md5Value, localmd5)
    else
      ret = 0
    end
    DebugLogId(string.format("  web  md5: %s\t%s\n[2017/17/17 17:17:17.172 ???????] local md5: %s", md5Value, appPath, md5log:gsub("\n", "")))
  else
    appDlog = string.format("md5??˙G?????????ßﬁ???")
    DebugLogId(appDlog)
  end
  return ret, appDlog
end
function Am_monitor()
  local amcfunc = "/data/local/tmp/c/program/commandd /system/bin/am"
  local tmpstr = string.format("%s am monitor > %s/activity.txt", amcfunc, G_SysDbgPath)
  DebugLogId("app activity monitor??" .. tmpstr)
  _cfunc.Command(tmpstr)
end
function JRoneCapture(picname)
  if G_APPscript == 1 and G_EngineMode == "Android" then
    picname = picname or "shot"
    local imgPath = string.format("%simages/%s.jpg", G_SysDbgPath, picname)
    DebugLogId("??????:" .. imgPath)
    _cfunc.CaptureAsJpg(imgPath, 50)
    if picname:match("failed") then
      local imglists = _cfunc.Command(string.format("ls %simages -l |grep faile", G_SysDbgPath))
      DebugLogId("failed images:\n" .. imglists)
    end
    return imgPath
  end
end
function GetAPI_logcat(flg, pkgname)
  local ret = 0
  local err
  local logcfunc = "/data/local/tmp/c/program/commandd /system/bin/logcat"
  local cmdd = " logcat -v time -f "
  local logpath = DebugSCPath .. "/logcat.log"
  if G_APPscript == 1 then
    if G_EngineMode ~= "IOS" then
      if flg == "start" then
        _cfunc.Command("/data/local/tmp/c/program/commandd /system/bin/logcat logcat -v time -f /mnt/sdcard/watchlog.txt")
        _cfunc.Command("/data/local/tmp/c/program/commandd /system/bin/logcat logcat -v long -f /mnt/sdcard/watchlog.log")
        DebugLogId("App Test,OpenWatchLogcat : " .. pkgname)
        ret, err = pcall(L_OpenWatchLogcat, pkgname)
        if ret then
          DebugLogId("OpenWatchLogcat???????")
          local logcat_ret = _cfunc.Command("ps|grep logcat")
          DebugLogId("??logcat?????\n" .. logcat_ret)
        else
          DebugLogId("OpenWatchLogcat???????:\t" .. err)
        end
      else
        DebugLogId("App Test,CloseWatchLogcat : " .. pkgname)
        ret, err = pcall(L_CloseWatchLogcat)
        if ret then
          DebugLogId("L_CloseWatchLogcat?????")
        else
          DebugLogId("L_CloseWatchLogcat??????:\t" .. err)
        end
        GetAPI_KillProcess("logcat")
        local rlog = _cfunc.Command("ls -l /mnt/sdcard/ |grep watch")
        DebugLogId("??/mnt/sdcard/??logcat????ß“???\n" .. rlog)
      end
    else
      print("ios????????Logcat???????")
    end
  elseif G_EngineMode == "Android" then
    local filePath = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "logcat.log"
    if flg == "start" then
      local file = assert(io.open(filePath, "wb"))
      file:close()
      DebugLogId("???logcat??????\t" .. filePath)
      _cfunc.Command(logcfunc .. " logcat -v time -f " .. filePath)
    else
      GetAPI_KillProcess("logcat")
      DebugLogId("????logcat???????????? " .. filePath)
      _cfunc.Command("chmod 666 " .. filePath)
    end
  else
    ret = -1
  end
  return ret
end
function PidGrepPS(pkgname, sclock, timeout)
  local tmpstr = string.format("ps|grep %s", pkgname)
  local ret, pid, starttime
  sclock = sclock or GetAPI_OsClock()
  while true do
    local tmp_pidstr = _cfunc.Command(tmpstr)
    ret, pid = getPidString(tmp_pidstr, pkgname)
    starttime = GetAPI_SubTime(GetAPI_OsClock(), sclock)
    if timeout < starttime then
      ret = 3
      if timeout == 60 then
        DebugLogId(string.format("app start timeout(%ss)??", timeout))
      end
      break
    end
    if ret == 0 then
      break
    end
  end
  return ret, pid, starttime
end
function getPidString(str, pkgname)
  for pidstring in string.gmatch(str, "([^\n]*)[\n\r]") do
    for i in string.gmatch(pidstring, "([^ ]*)") do
      if i == pkgname then
        DebugLogId("app start pids :" .. pidstring)
        local _, _, pid = string.find(pidstring, "( %d+)")
        return 0, pid
      end
    end
  end
  return -1, -1
end
function APPMonkeyer(package, bltime)
  local BLtime = tonumber(bltime) or 6
  if package == nil or package == "" then
    DebugLogId("error App?????????????? packagename ????")
    return -1
  end
  local checkMonkey = function(TaskId)
    local web_uri = G_WebTurl
    local hturl = string.format("%s/apps/httpapi/getMonkeytestStatus", web_uri)
    local curlp = "/data/local/tmp/curl-7.40.0/bin/"
    local postdata = string.format("<Request>\r\n<TaskId>%s</TaskId>\r\n</Request>", TaskId)
    local urlexc = string.format("%scurl -H '%s' -d '%s' %s", curlp, "Content-type:text/xml", postdata, hturl)
    local statuslog = _cfunc.Command(urlexc)
    if statuslog ~= "" then
      statuslog = statuslog:match("<%a+.*") or statuslog
    end
    DebugLogId(string.format("??????Monkey??: <TaskId>%s</TaskId> : %s", TaskId, statuslog))
    return statuslog
  end
  local runMonkeyer = function(Monkeyer)
    local backRuner = "/data/local/tmp/c/program/commandd /system/bin/monkey"
    _cfunc.Command(string.format("%s %s", backRuner, Monkeyer))
  end
  DebugLogId(string.format("monkey????%s????????%smin\t-->\t%s\t%s", G_Id:match("%d+"), BLtime, package, BLtime * 60 * 5))
  local moklistf = string.format("%s/appwhite.txt", string.sub(G_SysDbgPath, 1, -2))
  _cfunc.Command(string.format("echo '%s' > %s", package, moklistf))
  local applist = _cfunc.Command(string.format("cat %s", moklistf))
  DebugLogId(string.format("monkey whitelist: %s", applist:gsub("\n", "")))
  local parmer = string.format("--pct-syskeys 0 --pct-touch 70 --throttle 500")
  parmer = string.format("--pkg-whitelist-file %s %s", moklistf, parmer)
  local Mnkerlog = "" or string.format("> %s/monkey_log.txt", string.sub(G_SysDbgPath, 1, -2), logpath)
  local Monkeyer = string.format("monkey %s -v -v -v %s %s", parmer, BLtime * 60 * 5, Mnkerlog)
  DebugLogId(string.format("monkeyRuner : %s", Monkeyer))
  runMonkeyer(Monkeyer)
  local idstatus = -1
  local taskid = G_Id:match("%d+")
  local sclock = GetAPI_OsClock()
  local logclock = GetAPI_OsClock()
  while true do
    DebugLogId(string.format(" monkey backRuner .... "))
    local stimer = os.date("%Y-%m-%d %H:%M:%S")
    local picname = string.format("shot_%s", os.date("%H%M%S", tonumber(stimer)))
    local npicf = JRoneCapture(picname)
    if 6 < #G_JRResultXml then
      local opicf = npicf:match("^.*/") .. G_JRResultXml[#G_JRResultXml - 2]:match("img.-%\"(.-)%\"") .. ".jpg"
      local osize = GetAPI_FileLength(opicf)
      local nsize = GetAPI_FileLength(npicf)
      local fret = math.abs(nsize - osize) < 1000 and 0 or 1
      if fret == 0 then
        DebugLogId(string.format("??????Å£(%s == %s)|%s|?????????????? : %s", osize, nsize, math.abs(nsize - osize), picname))
        GetAPI_Deletefile(npicf)
      else
        JRResult("monkey", stimer, "Event", picname, "true", "", "")
      end
    else
      JRResult("monkey", stimer, "Event", picname, "true", "", "")
    end
    GetAPI_Sleep(1.1)
    local tmp_pidstr = _cfunc.Command("ps|grep monkey")
    if tmp_pidstr:match("monkey") then
      local monps = tmp_pidstr:match("com.*[^%s]")
      local runtime = GetAPI_SubTime(GetAPI_OsClock(), sclock)
      if runtime > BLtime * 60 or tonumber(idstatus) == 1 then
        DebugLogId(string.format("ps|grep monkey??%s", tmp_pidstr:gsub("\n", "")))
        DebugLogId(string.format("overtime or action stop monkey(%smin)??", BLtime))
        _cfunc.Command(string.format("am force-stop %s", monps))
        _cfunc.KillProcess(monps)
        break
      end
      local rstatus = checkMonkey(taskid)
      idstatus = rstatus:match("%d+") or 0
      if tonumber(idstatus) == 1 then
        DebugLogId(string.format("web action stop monkey ! \t[%s] : %s", taskid, rstatus))
      end
    else
      DebugLogId(string.format("ps monkey pid not found ??re-invokes ??"))
      local tMonkeyer = string.format("monkey %s -v -v -v %s %s", parmer, BLtime * 60 * 5, Mnkerlog)
      runMonkeyer(tMonkeyer)
    end
    GetAPI_Sleep(1.6)
    local logtime = GetAPI_SubTime(GetAPI_OsClock(), logclock)
    if logtime > 1200 then
      local logsub = GetAPI_FileLength("/mnt/sdcard/watchlog.txt")
      if logsub > 100000000 then
        DebugLogId(string.format("watchlog.txt ???????[%s]??echo ???? ", logsub))
        _cfunc.Command("echo > /mnt/sdcard/watchlog.log")
        _cfunc.Command("echo > /mnt/sdcard/watchlog.txt")
        logclock = GetAPI_OsClock()
      end
    end
  end
end
function getTraParam()
  local TraParamUrl = string.format("%s/uapi/Traverse/getTraverseParameters", G_WebTurl)
  local idbody = string.format("{ \"data\": {\"taskId\": %s}}", G_Id:match("%d+"))
  local webUrl = TraParamUrl
  local TraPramFile = string.format("%sTraPram.json", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg)
  DebugLogId(string.format("Get WEB Pram ID: %s\tURL: %s", idbody:match("%d+"), webUrl:match("^http://[^/]+")))
  local curlPram = string.format("/data/local/tmp/curl-7.40.0/bin/curl -s -X POST -d '%s' %s", idbody, webUrl)
  DebugLogId(string.format("HTTP -> %s", curlPram:match("(POST.*)http")))
  local httplog = _cfunc.Command(curlPram)
  if httplog:match("%b{}") then
    local retpram = httplog:match("{.*}")
    DebugLogId(string.format("retbody: %s", _cfunc.Utf8ToGbk(retpram)))
    local AccountLogin = retpram:match("useAccountLogin%p+(%w+)")
    if AccountLogin:match("0") then
      DebugLogId(string.format("AccountLogin prams null: %s", retpram))
      return false
    else
      DebugLogId(string.format("save task prams : %s", TraPramFile))
      _writeLog(TraPramFile, retpram:match("data%p+(%b{})"), "w+")
    end
    return TraPramFile
  else
    DebugLogId(string.format("???????????????%s", httplog))
  end
end
function APPTraveler(package, bltime, installTime, startTime)
  local BLtime = tonumber(bltime)
  local cshell = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap"
  if package == nil or package == "" then
    DebugLogId("error App?????????????? packagename ????")
    return -1
  end
  local TraPramFile, TraTypesIni = getTraParam()
  local parm
  if not TraPramFile then
    parm = string.format("-e package %s -e isTraveler true -e output true -e timeout %s", package, BLtime * 60 * 1000)
  else
    DebugLogId(string.format("????????????ßµ?%s", TraPramFile))
    local trflog = _cfunc.Command(string.format("ls %s -l", TraPramFile))
    DebugLogId(string.format("trlog: %s", trflog:gsub("\n", "")))
    parm = string.format("-e package %s -e loginConfig %s -e isTraveler true -e output true -e timeout %s", package, TraPramFile, BLtime * 60 * 1000)
    local initRipperLogin = "LuaCommonManager:getInstance():initRipperLogin"
    local username, password, thirdParty, smsLogin, miguLogin = "", "", "false", "false", TraPramFile
    local pramRipper = string.format("\"%s\",\"%s\",%s,%s,\"%s\"", username, password, thirdParty, smsLogin, miguLogin)
    ExecScriptJava(initRipperLogin, pramRipper)
  end
  _cfunc.Command("am force-stop uiautomator")
  _cfunc.KillProcess("uiautomator")
  local outtime = BLtime + 1
  local mode_version = tonumber(G_Id:match("^.*_(.*)"):match("%d")) or "nil"
  DebugLogId(string.format("??????????(v%s)?????????%smin\t-->\t", mode_version, BLtime) .. package)
  local Traveler = string.format("%s %s", cshell, parm)
  local pkgname = package
  local crawlerType = TraTypesIni and TraTypesIni.crawlerType or "\"DFS\""
  local testType = TraTypesIni and TraTypesIni.testType or "\"stability\""
  local UIAType = tonumber(G_Id:match("^.*_(.*)"):match("%d")) >= 5 and "2" or "1"
  local duration = outtime
  local pramRipper = string.format("\"%s\",%s,%s,%s,%s,-1,-1", pkgname, crawlerType, testType, UIAType, duration)
  ExecScriptJava("LuaCommonManager:getInstance():initRipper", pramRipper)
  DebugLogId(string.format("initRipper ... OK \t%s\t%s", installTime, startTime))
  _cfunc.Sleep(1000)
  local startRipper = "LuaCommonManager:getInstance():startRunRipper"
  ExecScriptJava(startRipper, "")
  local loopfile = function()
    local ret = File_Exists("/sdcard/ripper_exit", 1) and 1 or 0
    return ret
  end
  _cfunc.Sleep(20000)
  loopTimeout(duration * 60 + 70, loopfile, pkgname)
  DebugLogId("?????????????????????????/sdcard/autosense/")
  local cstr = _cfunc.Command("ls /sdcard/autosense_ripper_data/ -l")
  DebugLogId("??????????????????ß“???\n" .. cstr)
end
function loopTimeout(timeOut, funcname, funcpram)
  local ret = -1
  local sclock = GetAPI_OsClock()
  while true do
    ret = funcname(funcpram)
    local eclock = GetAPI_OsClock()
    local esclock = GetAPI_SubTime(eclock, sclock)
    local comdstr = _cfunc.Command(string.format("ps|grep -E 'ripper|%s'", funcpram))
    DebugLogId(string.format([[
 ps|grep ripper|%s : 
%s]], funcpram, comdstr))
    if esclock > tonumber(timeOut) then
      DebugLogId(string.format("loopTimeout : %s", timeOut - 70))
      return 1
    end
    if ret == 1 then
      DebugLogId(string.format("loop file exit : %s", ret))
      return 1
    end
    _cfunc.Sleep(30000)
  end
end
function WriteJRVakueTable(DebugFlag)
  local JRresultTb = G_JRResultXml
  DebugLogId("????????????????.")
  local xmlInfo, retFlg
  for i, v in ipairs(JRresultTb) do
    if string.find(v, "<resultinfo") then
      xmlInfo = v
    end
    if string.find(v, "false") then
      retFlg = true
    end
  end
  if string.find(xmlInfo, " endtime=%\"(.-)%\"") then
    local s = os.date("%Y-%m-%d %H:%M:%S")
    local t = string.match(xmlInfo, " endtime=%b\"\"")
    xmlInfo = string.gsub(xmlInfo, t, string.format(" endtime=\"%s\"", s))
  end
  local t = string.match(xmlInfo, " result=%b\"\"")
  local resultRet = string.match(t, "%d") or ""
  if not string.match(t, "%d") then
    if not retFlg then
    else
      resultRet = "0" or "6"
    end
  end
  if not upSelfScriptFlg then
    if File_Exists("/mnt/sdcard/crashlog.txt") then
      resultRet = "34"
      DebugLogId(string.format("????????????ßﬂ??ßµ?Ôì(%s >> result = \"%s\")??", t, resultRet))
    elseif File_Exists("/mnt/sdcard/anrlog.txt") then
      resultRet = "8"
      DebugLogId(string.format("????????????ßﬂ??ßµ?Ôì(%s >> result = \"%s\")??", t, resultRet))
    elseif File_Exists("/data/anr/traces.txt") and not DebugFlag then
      local tmps = _cfunc.Command("cat /data/anr/traces.txt")
      DebugLogId(string.format("android traces ??\n%s", tmps))
    end
  elseif File_Exists("/data/anr/traces.txt") and not DebugFlag then
    local tmps = _cfunc.Command("cat /data/anr/traces.txt")
    DebugLogId(string.format("android traces ??\n%s", tmps))
  end
  xmlInfo = string.gsub(xmlInfo, t, string.format(" result=\"%s\"", resultRet))
  JRresultTb[3] = xmlInfo
  for i, v in ipairs(JRresultTb) do
    DebugLogId(v .. "\n")
  end
  local JRresultPath = string.format("%s/result.txt", G_SysDbgPath)
  if DebugFlag then
    DebugLogId("??????????")
    wrfile(JRresultPath, JRresultTb, "\n")
    local JRlocalPath = G_SysDbgPath
    local tmpfile = "/mnt/sdcard/crashlog.txt"
    if File_Exists(tmpfile) then
      local ret, err = pcall(CopyFile, tmpfile, JRlocalPath .. "crash.txt")
      if not ret then
        DebugLogId(err)
      end
    end
    local tmpfile = "/mnt/sdcard/anrlog.txt"
    if File_Exists(tmpfile) then
      local ret, err = pcall(CopyFile, tmpfile, JRlocalPath .. "crash.txt")
      if not ret then
        DebugLogId(err)
      end
    end
    local tmpfile = "/data/anr/traces.txt"
    if File_Exists(tmpfile) then
      local ret, err
      if not File_Exists("/mnt/sdcard/crashlog.txt") and not File_Exists("/mnt/sdcard/anrlog.txt") then
        DebugLogId("traces ??? --> anrlog")
        ret, err = pcall(CopyFile, tmpfile, JRlocalPath .. "anrlog.txt")
      else
        ret, err = pcall(CopyFile, tmpfile, JRlocalPath .. "traces.txt")
      end
      if not ret then
        DebugLogId(err)
      end
    end
    local str = _cfunc.Command(string.format("ls %s -l", JRlocalPath))
    DebugLogId("??????????ß“???\n" .. str)
  else
    DebugLogId("?????????ûD?...")
    getHeaderResult()
    wrfile(JRresultPath, JRresultTb, "\n", "UTF8")
    pkgJRresult(retFlg)
  end
end
function getHeaderResult()
  local ArguMentList = splittable(G_SysParms, "|")
  local cmtVenderCode = GetAPI_VenderCode()
  local cmtDevType = GetAPI_DevType()
  local cmtDevCode = GetAPI_DevCode()
  local cmtIP = GetAPI_DeviceIP()
  local CMPos = GetAPI_GPSInfo()
  local cmtMobileNum = GetAPI_MobileNum()
  local NetProxy = GetAPI_Proxy()
  local NetFlag = GetAPI_NetFlag()
  Businesses = Businesses or "¶ƒ????"
  Businesses = G_APPBLscript and _cfunc.Utf8ToGbk(Businesses) or Businesses
  if not Clientversion then
    Clientversion = "UNKNOWN"
  end
  local ValueStr = cmtVenderCode .. "\t" .. cmtDevType .. "\t" .. cmtDevCode .. "\t" .. CMPos .. "\t" .. cmtIP .. "\t" .. cmtMobileNum .. "\t" .. ArguMentList[2] .. "|" .. ArguMentList[3] .. "\t" .. tostring(Businesses) .. "\t" .. Clientversion .. "\t" .. "NA" .. "\t" .. NetProxy .. "\t" .. NetFlag .. "\t" .. Edition
  DebugLogId("mob_??????  " .. ValueStr)
  local JRresult_HaderPath = string.format("%s%sresult.txt", string.sub(G_SysRstPath, 1, -2), G_Pflg)
  DebugLogId("JRresult_HaderPath  " .. JRresult_HaderPath)
  wrfile(JRresult_HaderPath, ValueStr, "\n", "UTF8")
end
function GetAPI_Proxy()
  local netret
  if G_EngineMode == "IOS" then
    netret = ""
  else
    local net = GetAPI_NetFlag()
    if net ~= "WIFI" then
      local NetInfo = GetAPI_NetworkInfo()
      local Proxy = _cfunc.DevIsUseProxy()
      Proxy = tonumber(Proxy)
      if tonumber(NetInfo) == 46003 then
        if Proxy == 1 then
          netret = "CTWAP"
        elseif Proxy == 2 then
          netret = "CTNET"
        else
          DebugLogId("??????????" .. netret)
          netret = "UNKNOWN"
        end
      elseif Proxy == 1 then
        netret = "CMWAP"
      elseif Proxy == 2 then
        netret = "CMNET"
      else
        DebugLogId("??????????" .. netret)
        netret = "UNKNOWN"
      end
    else
      netret = "LAN"
    end
  end
  return netret
end
function wrfile(scfile, txt, line, fmtcode)
  local f = io.open(scfile, "wb")
  if type(txt) == "table" then
    for i in pairs(txt) do
      if fmtcode then
        if fmtcode == "GBK" then
          txt[i] = _cfunc.Utf8ToGbk(txt[i])
        elseif fmtcode == "UTF8" then
          txt[i] = _cfunc.GbkToUtf8(txt[i])
        end
      end
      local t
      if i == #txt then
        t = txt[i]
      else
        t = line and txt[i] .. line or txt[i]
      end
      f:write(t)
    end
  else
    f:write(txt .. "\n")
  end
  f:close()
end
function pkgJRresult(retFlg)
  local JRResultpath = string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg
  local JRlocalPath = G_SysDbgPath
  DebugLogId("?????????????------")
  copyResultFile("result.txt")
  copyResultFile("dump.xml")
  copyResultFile("signal.txt")
  DebugLogId("???π¡????????")
  local imgLocal = string.format("%simages%s", JRlocalPath, G_Pflg)
  DebugLogId("imgPath:" .. imgLocal)
  copyImgFList(imgLocal, JRResultpath)
  pcall(CopyFile, "/mnt/sdcard/crashlog.txt", JRResultpath .. "crashlog.txt")
  pcall(CopyFile, "/mnt/sdcard/anrlog.txt", JRResultpath .. "anrlog.txt")
  pcall(CopyFile, "/mnt/data/anr/traces.txt", JRResultpath .. "traces.txt")
  pcall(CopyFile, "/mnt/sdcard/watchlog.txt", JRResultpath .. "log.txt")
  local rlog = _cfunc.Command(string.format("ls -l %s", JRResultpath))
  DebugLogId("???????????ß“???\n" .. rlog)
  DebugLogId("?????????????...")
  copyResultFile("debug.txt")
end
function copyResultFile(filename, filePath, Resultpath, resultName)
  local JRlocalPath = G_SysDbgPath
  local JRResultpath = string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg
  filePath = filePath or JRlocalPath
  Resultpath = Resultpath or JRResultpath
  resultName = resultName or filename
  if File_Exists(filePath .. filename) then
    local ret, err = pcall(CopyFile, filePath .. filename, Resultpath .. resultName)
    if not ret then
      DebugLogId(err)
    end
  else
    DebugLogId(string.format("?????%s??¶ƒ?????????%s", filename, filePath))
  end
end
function copyImgFList(imgLocal, JRResultpath)
  local tmpImags = getPathFiles(imgLocal)
  local imgResult = string.format("%simages%s", JRResultpath, G_Pflg)
  for k, v in ipairs(tmpImags) do
    if v ~= "" then
      DebugLogId("Imags: " .. v)
      copyResultFile(v, imgLocal, imgResult)
    end
  end
end
function getPathFiles(lpath, ltr)
  local filesTb = {}
  lpath = lpath or " "
  local lscmd = ltr and "ls -l" or "ls"
  local tmps = _cfunc.Command(string.format("%s %s", lscmd, lpath))
  local dumptb = splittable(tmps, "\n")
  if dumptb then
    for k, v in ipairs(dumptb) do
      table.insert(filesTb, v)
    end
  end
  return filesTb
end
function filterMonkeyRes(JRresultTb)
  if #JRresultTb < 106 then
    return JRresultTb
  end
  DebugLogId(string.format("monkey ????????????????????????"))
  local mi = 0
  for i = #JRresultTb, 1, -1 do
    if JRresultTb[i]:match("<action") then
      mi = mi + 1
    end
    if mi > 100 and JRresultTb[i]:match("<action") then
      DebugLogId(string.format("remove MonkeyTb[%s] :%s", i, JRresultTb[i]))
      local imgs = JRresultTb[i]:match("img%p%b\"\"")
      local imgname = string.format("%simages/%s.jpg", G_SysDbgPath, imgs:match("%\"(.*)%\""))
      DebugLogId(string.format("del: %s", imgname))
      table.remove(JRresultTb, i)
      GetAPI_Deletefile(imgname)
    end
  end
  DebugLogId(string.format("removed results.len ?? [%s]", mi - 100))
  return JRresultTb
end
function WriteBLValueTable(typeflg)
  local JRresultTb = G_JRResultXml
  local resultInfo
  for i, v in ipairs(JRresultTb) do
    if string.find(v, "<resultinfo") then
      resultInfo = v
      break
    end
  end
  local m_installtime = string.match(resultInfo, " installtime=%b\"\"")
  local m_appstarttime = string.match(resultInfo, " appstarttime=%b\"\"")
  local m_pid = string.match(resultInfo, " pid=%b\"\"")
  local m_result = string.match(resultInfo, " result=%b\"\"")
  local jrInfoResult = "/mnt/sdcard/mobileSense/result.xml"
  local JRlocalPath = G_SysDbgPath
  local JRresultPath = string.format("%s/result.txt", JRlocalPath)
  local testype = typeflg and "monkey" or "????"
  local TraverResult
  if typeflg and typeflg:match("monkey") then
    JRresultTb = filterMonkeyRes(JRresultTb)
    wrfile(JRresultPath, JRresultTb, "\n", "UTF8")
    jrInfoResult = JRresultPath
  elseif typeflg and typeflg:match("ripper") then
    testype = "ripper"
    wrfile(JRresultPath, JRresultTb, "\n", "UTF8")
    TraverResult = "/sdcard/autosense_ripper_data/actions.json"
    jrInfoResult = JRresultPath
    if not File_Exists(TraverResult) then
      local cstr = _cfunc.Command("ls /sdcard/autosense_ripper_data -l")
      DebugLogId(string.format("%s??????(actions.json)¶ƒ?????\n%s", testype, cstr))
      TraverResult = "/sdcard/autosense_ripper_data/actions.csv"
      DebugLogId(string.format("?????csv??????: %s", TraverResult))
    end
  end
  if File_Exists(jrInfoResult) then
    local blRstXmltb, installtime, appstarttime, pid, resultRet, i = getjrinfo(jrInfoResult)
    blRstXmltb[i] = Sgsub(blRstXmltb[i], installtime, m_installtime)
    blRstXmltb[i] = Sgsub(blRstXmltb[i], appstarttime, m_appstarttime)
    blRstXmltb[i] = Sgsub(blRstXmltb[i], pid, m_pid)
    local errRet = typeflg and m_result:match("%d+") or "0"
    if not typeflg or not errRet then
      errRet = nil
    end
    if File_Exists("/mnt/sdcard/crashlog.txt") then
      errRet = "34"
      DebugLogId(string.format("????crash?????ßﬂ????????(%s >> result = \"%s\")??", resultRet, errRet))
    elseif File_Exists("/mnt/sdcard/anrlog.txt") then
      errRet = "8"
      DebugLogId(string.format("????anr?????ßﬂ????????(%s >> result = \"%s\")??", resultRet, errRet))
    end
    if errRet then
      blRstXmltb[i] = Sgsub(blRstXmltb[i], resultRet, string.format(" result=\"%s\"", errRet))
    end
    DebugLogId(string.format("???%s??????", testype))
    for i, v in ipairs(blRstXmltb) do
      DebugLogId(_cfunc.Utf8ToGbk(v) .. "\n")
    end
    wrfile(JRresultPath, blRstXmltb, "><")
  else
    if testype ~= "ripper" then
      local cstr = _cfunc.Command("ls /mnt/sdcard/mobileSense -l")
      DebugLogId(string.format("%s??????¶ƒ?????\n%s", testype, cstr))
    end
    wrfile(JRresultPath, JRresultTb, "\n", "UTF8")
  end
  pkgBLresult(typeflg)
end
function Sgsub(str, mstr, gstr)
  mstr = string.find(mstr, "%-") and string.gsub(mstr, "-", "%%-") or mstr
  return string.gsub(str, mstr, gstr)
end
function getjrinfo(fileResult)
  local installtime, appstarttime, pid, result
  local f = io.open(fileResult, "rb")
  local file = f:read("*all")
  f:close()
  local blRsttb = splittable(file, "><")
  local resultInfo, infoi
  for i, v in ipairs(blRsttb) do
    if string.find(v, "resultinfo") then
      resultInfo = v
      infoi = i
      break
    end
  end
  installtime = string.match(resultInfo, " installtime=%b\"\"")
  appstarttime = string.match(resultInfo, " appstarttime=%b\"\"")
  pid = string.match(resultInfo, " pid=%b\"\"")
  result = string.match(resultInfo, " result=%b\"\"")
  return blRsttb, installtime, appstarttime, pid, result, infoi
end
function pkgBLresult(resFlg)
  local JRResultpath = string.sub(G_SysRstPath, 1, -2) .. G_Pflg .. "FILE" .. G_Pflg
  local JRlocalPath = G_SysDbgPath
  DebugLogId(string.format("???%s????????????------", resFlg or ""))
  getHeaderResult()
  copyResultFile("result.txt")
  copyResultFile("signal.txt")
  DebugLogId("???π¡????????")
  local imgLocal = resFlg and string.format("%simages/", JRlocalPath) or "/mnt/sdcard/mobileSense/images/"
  imgLocal = resFlg and resFlg:match("ripper") and string.format("%simages/", "/sdcard/autosense_ripper_data/") or imgLocal
  DebugLogId("imgPath:" .. imgLocal)
  copyImgFList(imgLocal, JRResultpath)
  copyImgFList(string.format("%simages/", JRlocalPath), JRResultpath)
  local TraverResult = "/sdcard/autosense_ripper_data/actions.json"
  copyResultFile("actions.json", "/sdcard/autosense_ripper_data/", JRResultpath, "actions.json")
  local TraverResult2 = "/sdcard/autosense_ripper_data/actions.csv"
  copyResultFile("actions.csv", "/sdcard/autosense_ripper_data/", JRResultpath, "actions.csv")
  copyResultFile("Traversal.txt", "/sdcard/autosense_ripper_data/", JRResultpath, "Traversal.txt")
  copyResultFile("crashlog.txt", "/mnt/sdcard/", JRResultpath, "crash.txt")
  copyResultFile("anrlog.txt", "/mnt/sdcard/", JRResultpath, "anr.txt")
  copyResultFile("bootstrap_log.txt", "/mnt/sdcard/mobileSense/")
  pcall(CopyFile, "/mnt/sdcard/watchlog.txt", JRResultpath .. "log.txt")
  local rlog = _cfunc.Command(string.format("ls -l %s", JRResultpath))
  DebugLogId("???????????ß“???\n" .. rlog)
  copyResultFile("debug.txt")
  DebugLogId("?????????????...")
end
LibEdt = "3.0.8"
function Method_SendSMS_SIG(SPOrder, DestCode, FlowStep)
  local startclock = GetAPI_OsClock()
  local ret = 0
  local i = 1
  local j, DestCodelist
  DestCodelist = splittable(DestCode, ",")
  while i <= #DestCodelist do
    j = 1
    while j <= 10 do
      ret = GetAPI_SendSms(SPOrder, DestCodelist[i])
      DebugLogId("SendSMS-??" .. j .. "??,SPOrder=" .. SPOrder .. ",DestCode=" .. DestCodelist[i] .. ",ret=" .. ret)
      if ret == 0 then
        G_GlbVocMsg = GetGVM("????(%s)??(%s)???", {SPOrder, DestCode})
        break
      else
        G_GlbVocMsg = GetGVM("????(%s)??(%s)???", {SPOrder, DestCode})
      end
      j = j + 1
    end
    i = i + 1
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_RecvSMS_SIG(RecvCotent, TimeOut, FlowStep)
  local startclock, endclock, DelayTime, ret, retidx
  DebugLogId("??????????,????????:" .. RecvCotent .. ",???????:" .. TimeOut)
  startclock = GetAPI_OsClock()
  ret, retidx = GetAPI_RecvSms(TimeOut, RecvCotent, FlowStep)
  if FlowStep and FlowStep == 1 then
    if ret == 0 then
      ret = 1
    else
      ret = 0
    end
  end
  if ret == 0 then
    DebugLogId("?????????...")
    G_GlbVocMsg = GetGVM("***????(%s)???***\n", {RecvCotent})
  else
    DebugLogId("?????????...")
    G_GlbVocMsg = GetGVM("***????(%s)???***\n", {RecvCotent})
  end
  endclock = GetAPI_OsClock()
  DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, retidx
end
function Method_Wap_SIG(URL, URLImage, FlowStep)
  local startclock, ret, CompImgTab
  local TimeOut = G_timeOut
  local picidx = 0
  DebugLogId("???¶¬??????:" .. URL)
  ret = GetAPI_OpenBrowser(URL)
  startclock = GetAPI_OsClock()
  if URLImage == "" then
    print("No pic compare")
  elseif ret == 0 then
    CompImgTab = splittable(URLImage, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Reboot()
  if pcall(function()
    local file = io.open("/data/local/tmp/c/reboot.txt", "r")
    file:close()
  end) then
    dofile("/data/local/tmp/c/reboot.txt")
    RebootTime = os.time(time)
    NowTime = os.time()
    if NowTime - tonumber(RebootTime) > tonumber(G_Reboot) then
      time = "time={ year = " .. tostring(os.date("%Y", NowTime)) .. ",month = " .. tostring(os.date("%m", NowTime)) .. ",day = " .. tostring(os.date("%d", NowTime)) .. ",hour = " .. tostring(os.date("%H", NowTime)) .. ",min = " .. tostring(os.date("%M", NowTime)) .. ",sec = " .. tostring(os.date("%S", NowTime)) .. " }"
      RebootFile = io.open("/data/local/tmp/c/reboot.txt", "w")
      RebootFile:write(time)
      RebootFile:close()
      _cfunc.Command("reboot")
    end
  else
    NowTime = os.time()
    time = "time={ year = " .. tostring(os.date("%Y", NowTime)) .. ",month = " .. tostring(os.date("%m", NowTime)) .. ",day = " .. tostring(os.date("%d", NowTime)) .. ",hour = " .. tostring(os.date("%H", NowTime)) .. ",min = " .. tostring(os.date("%M", NowTime)) .. ",sec = " .. tostring(os.date("%S", NowTime)) .. " }"
    RebootFile = io.open("/data/local/tmp/c/reboot.txt", "w")
    RebootFile:write(time)
    RebootFile:close()
    _cfunc.Command("reboot")
  end
end
function Method_OpenAPPEx(APPName, APPImage, FlowStep)
  local ret, CompImgTab
  local TimeOut = G_timeOut
  local picidx = 0
  ret = GetAPI_Open_App(APPName)
  local startclock = GetAPI_OsClock()
  if APPImage == "" then
    print("No pic compare")
  elseif ret == 0 then
    CompImgTab = splittable(APPImage, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Touchs(strCommand, strCommandImg, TimeOut)
  local picidx = 0
  local ret
  local startclock = GetAPI_OsClock()
  ret = Method_TouchsPub(strCommand)
  if ret == 0 then
    ret, picidx = Method_TouchsEx(strCommand, strCommandImg, TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = ret == 0 and GetAPI_SubTime(endclock, startclock) or TimeOut
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Touchs_Rate(strCommand, strCommandImg, FileSize)
  local parmCommandImg, picidx, parmTab
  local parmTimeOut = G_timeOut
  local ResultContent = 0
  parmTab = splittable(strCommandImg, ",")
  parmCommandImg = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  local startclock = GetAPI_OsClock()
  ret = Method_TouchsPub(strCommand)
  if ret == 0 then
    ret, picidx = Method_TouchsEx(strCommand, parmCommandImg, parmTimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  FileSize = tonumber(FileSize)
  if G_Imgtime and G_first_time then
    G_Imgtime = G_Imgtime + G_first_time
  elseif G_first_time then
    G_Imgtime = G_first_time
  end
  if G_Imgtime then
    DelayTime = DelayTime - G_Imgtime
  end
  if ret == 0 then
    ResultContent = DecPoint(FileSize / DelayTime)
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  table.insert(ResultTable, ResultContent)
  table.insert(ResultTable, FileSize)
  table.insert(ResultTable, "rate")
  return ret, ResultTable, picidx
end
function Method_TouchsPub(strCommand)
  local ret = 0
  local first_time = 0
  if G_click_view == true then
    G_click_coor = false
    G_ActionElement = "????"
    ret, first_time = Method_ClickPubEx(strCommand)
  else
    G_click_coor = true
    first_time = Method_TouchsPubEx(strCommand)
    DebugLogId("?????????" .. first_time)
  end
  G_first_time = first_time
  return ret, first_time
end
function Method_TouchsPubEx(strCommand)
  local keyflag, dwait, twait
  local dbtflag = false
  local cmdtb, docount, movtime, touchax, touchay, touchbx, touchby, touchcx, touchcy, touchdx, touchdy
  local res_x = 0
  local res_y = 0
  local start_clock = GetAPI_OsClock()
  local end_clock = start_clock
  local first_time = 0
  local first_twait = 0
  if G_FTouchFlag then
    res_x = G_res_x
    res_y = G_res_y
  end
  strCommand = string.gsub(strCommand, " ", "")
  strCommand = string.upper(strCommand)
  commandlist = splittable(strCommand, "|")
  if #commandlist == 1 and commandlist[1] == "" then
    commandlist = {}
  end
  for name, value in pairs(commandlist) do
    dwait = 5
    twait = 2
    if string.match(value, "-DBT") then
      cmdtb = splittable(value, "-D")
      value = cmdtb[1]
      dbtflag = true
    end
    if string.sub(value, 1, 1) == "<" then
      keyflag = 3
    elseif string.sub(value, 1, 1) == "(" then
      if string.match(value, "-DBM") then
        cmdtb = splittable(value, "-D")
        value = cmdtb[1]
        keyflag = 5
      else
        keyflag = 4
      end
    elseif tonumber(string.sub(value, 1, 1)) or string.sub(value, 1, 1) == "-" and tonumber(string.sub(value, 2, 2)) then
      keyflag = 2
    else
      keyflag = 1
    end
    touchs = splittable(value, ",")
    docount = 1
    movtime = 1
    if keyflag == 1 then
      keyvalue = touchs[1]
      twait = tonumber(touchs[2])
      docount = tonumber(touchs[3])
    elseif keyflag == 2 then
      touchx = tonumber(touchs[1]) + res_x
      touchy = tonumber(touchs[2]) + res_y
      twait = tonumber(touchs[3])
      docount = tonumber(touchs[4])
    elseif keyflag == 3 then
      touchx = tonumber(string.sub(touchs[1], 2, -1)) + res_x
      touchy = tonumber(string.sub(string.gsub(touchs[2], ">", ""), 1, -1)) + res_y
      if touchs[3] then
        dwait = tonumber(string.sub(string.gsub(touchs[3], ">", ""), 1, -1))
      end
      if touchs[4] then
        twait = tonumber(string.sub(string.gsub(touchs[4], ">", ""), 1, -1))
      end
      if touchs[5] then
        docount = tonumber(string.sub(string.gsub(touchs[5], ">", ""), 1, -1))
      end
    elseif keyflag == 4 then
      touchax = tonumber(string.sub(touchs[1], 2, -1)) + res_x
      touchay = tonumber(touchs[2]) + res_y
      touchbx = tonumber(touchs[3]) + res_x
      touchby = tonumber(string.sub(string.gsub(touchs[4], "%)", ""), 1, -1)) + res_y
      if touchs[5] then
        movtime = tonumber(string.sub(string.gsub(touchs[5], "%)", ""), 1, -1))
      end
      if touchs[6] then
        twait = tonumber(string.sub(string.gsub(touchs[6], "%)", ""), 1, -1))
      end
      if touchs[7] then
        docount = tonumber(string.sub(string.gsub(touchs[7], "%)", ""), 1, -1))
      end
    else
      touchax = tonumber(string.sub(touchs[1], 2, -1)) + res_x
      touchay = tonumber(touchs[2]) + res_y
      touchbx = tonumber(touchs[3]) + res_x
      touchby = tonumber(touchs[4]) + res_y
      touchcx = tonumber(touchs[5]) + res_x
      touchby = tonumber(touchs[6]) + res_y
      touchdx = tonumber(touchs[7]) + res_x
      touchdy = tonumber(string.sub(string.gsub(touchs[8], "%)", ""), 1, -1)) + res_y
      if touchs[9] then
        twait = tonumber(string.sub(string.gsub(touchs[9], "%)", ""), 1, -1))
      end
      if touchs[10] then
        docount = tonumber(string.sub(string.gsub(touchs[10], "%)", ""), 1, -1))
      end
    end
    twait = twait or 2
    docount = docount or 1
    dwait = dwait or 5
    movtime = movtime or 1
    if keyflag == 1 then
      for i = 1, docount do
        DebugLogId("new keyvalue=" .. keyvalue)
        GetAPI_Key(keyvalue, 3, twait)
        if i == 1 then
          end_clock = GetAPI_OsClock()
          first_twait = twait
        end
        G_position1 = keyvalue
      end
    elseif keyflag == 2 then
      for i = 1, docount do
        if dbtflag then
          DebugLogId("new dbtouchx=" .. touchx .. ",touchy=" .. touchy)
          GetAPI_Touch(touchx, touchy, 3, 0.2)
          GetAPI_Touch(touchx, touchy, 3, twait)
          dbtflag = false
        else
          DebugLogId("new touchx=" .. touchx .. ",touchy=" .. touchy)
          GetAPI_Touch(touchx, touchy, 3, twait)
        end
        if i == 1 and name == 1 then
          end_clock = GetAPI_OsClock()
          first_twait = twait
        end
        G_position1 = string.format("%s,%s", touchx, touchy)
      end
    elseif keyflag == 3 then
      for i = 1, docount do
        DebugLogId("new long touchx=" .. touchx .. ",touchy=" .. touchy .. ",dwait=" .. dwait)
        if G_EngineMode == "MacIOS" then
          GetAPI_Touch(touchx, touchy, 2, dwait)
        else
          GetAPI_Touch(touchx, touchy, 1, dwait)
          GetAPI_Touch(touchx, touchy, 2, twait)
        end
        if i == 1 and name == 1 then
          end_clock = GetAPI_OsClock()
          first_twait = twait
        end
        G_position1 = string.format("%s,%s", touchx, touchy)
      end
    elseif keyflag == 4 then
      for i = 1, docount do
        GetAPI_Move(touchax, touchay, touchbx, touchby, twait, movtime)
        if i == 1 and name == 1 then
          end_clock = GetAPI_OsClock()
          first_twait = twait
        end
        G_position1 = string.format("%s,%s", touchax, touchay)
        G_position2 = string.format("%s,%s", touchbx, touchby)
      end
    else
      for i = 1, docount do
        DebugLogId("new toucha=" .. touchax .. "," .. touchay .. ",touchb=" .. touchbx .. "," .. touchby)
        DebugLogId("new touchc=" .. touchcx .. "," .. touchcy .. ",touchd=" .. touchdx .. "," .. touchdy)
        GetAPI_DoubleMove(touchax, touchay, touchbx, touchby, touchcx, touchcy, touchdx, touchdy, twait)
        if i == 1 and name == 1 then
          end_clock = GetAPI_OsClock()
          first_twait = twait
        end
      end
    end
    if name == 1 and end_clock ~= start_clock then
      first_time = GetAPI_SubTime(end_clock, start_clock) - tonumber(first_twait)
    end
    DebugLogId("??¶≈?????????????????????" .. first_time)
  end
  return first_time
end
function Method_ClickPubEx(strCommand)
  local time_first = 0
  local touch_time_first = 0
  if G_EngineMode == "MacIOS" then
    local ret = -1
    ret, time_first = MacIOSF:Method_ActionEx(strCommand, 1)
    return ret, time_first
  else
    local view_tab = splittable(strCommand, "|")
    local start_time = GetAPI_OsClock()
    for i = 1, #view_tab do
      local ret, str_command = GetAPI_getCoordinate(view_tab[i])
      if i == 1 then
        local end_time = GetAPI_OsClock()
        time_first = GetAPI_SubTime(end_time, start_time)
        DebugLogId("????¶¬????????????????" .. time_first)
        if ret ~= -1 then
          touch_time_first = Method_TouchsPubEx(str_command)
        else
          DebugLogId("¶ƒ??????????????????")
          return -1, 0
        end
        time_first = time_first + touch_time_first
      elseif ret ~= -1 then
        Method_TouchsPubEx(str_command)
      else
        DebugLogId("¶ƒ??????????????????")
        return -1, 0
      end
    end
  end
  return 0, time_first
end
function Method_TouchsEx(strCommand, strCommandImg, TimeOut)
  local ret, picidx
  if strCommandImg == "" then
    ret = 0
    picidx = 0
  else
    ret, picidx = CheckActionResults(strCommandImg, TimeOut)
  end
  return ret, picidx
end
function Method_clickEx(strCommandImg, TimeOut, conflag)
  local ret, picidx
  if strCommandImg == "" then
    return 0, 0
  else
    ret, view = Dump_wait(strCommandImg, TimeOut, conflag)
    if ret ~= -1 then
      return 0, ret
    end
  end
  return 1, 0
end
function Method_getviewEx(strCommandImg, TimeOut)
  local ret, picidx, view_str
  if strCommandImg == "" then
    return 0, 0, ""
  else
    local viewRegex
    if strCommandImg:find("regex") then
      strCommandImg = strCommandImg:gsub(" ", "")
      local viewrule = strCommandImg:match(",?regex:%'.-%'") or ""
      viewRegex = viewrule:match("regex:%'(.-)%',?") or ""
      strCommandImg = strCommandImg:gsub(viewrule, "") or ""
      DebugLogId(string.format("??????ßµ??regex: %s", viewRegex))
    end
    ret, view_str = Dump_get_view(strCommandImg, TimeOut)
    if ret ~= -1 then
      view_str = _cfunc.Utf8ToGbk(view_str)
      if view_str:find("?????????") or view_str:find("?????") or view_str:find("???????") or view_str:find("????????ßπ") or view_str:find("????") then
        DebugLogId(string.format("??????????????%s", view_str:match("(%d+)")))
        G_Captcha = view_str:match("(%d+)")
      elseif viewRegex then
        DebugLogId(string.format("??????: %s\nßµ??regex: %s", view_str, viewRegex))
        local regeStr = view_str:match("viewRegex") or ""
        ret = regeStr == "" and -1 or 0
      end
      return 0, ret, view_str
    end
  end
  return 1, 0, ""
end
function Method_TouchsCross(strCommand, strCommandImg, TimeOut, paraflag1)
  local startclock = GetAPI_OsClock()
  local picidx = 0
  local ret
  picidx = Method_TouchsCrossEx(strCommand, strCommandImg, TimeOut, paraflag1)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  if picidx == 0 and strCommandImg ~= "" then
    ret = 1
  else
    ret = 0
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_TouchsCrossEx(strCommand, strCommandImg, TimeOut, paraflag1)
  local picidx, cmdtb, exitcommandflag, waitstartclock, waitendclock, onecetime
  if paraflag1 and paraflag1 ~= "" and tonumber(paraflag1) then
    onecetime = tonumber(paraflag1)
  else
    onecetime = 6
  end
  waitstartclock = GetAPI_OsClock()
  while true do
    picidx = 0
    waitendclock = GetAPI_OsClock()
    if TimeOut <= GetAPI_SubTime(waitendclock, waitstartclock) then
      break
    end
    ret = Method_TouchsPub(strCommand)
    if ret == 0 then
      if strCommandImg == "" then
        picidx = 0
        break
      else
        ret, picidx = CheckActionResults(strCommandImg, onecetime)
        if ret == 0 then
          break
        end
      end
    end
  end
  DebugLogId("picidx:" .. picidx)
  return picidx
end
function Method_TouchsByBuffer(strCommand, strCommandImg, CompType, BuffType)
  local res, buffnum, bufftime, picidx, ret, parmTab, parmCommandImg
  local parmTimeOut = G_timeOut
  parmTab = splittable(strCommandImg, ",")
  parmCommandImg = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  local startclock = GetAPI_OsClock()
  res, buffnum, bufftime, picidx = Method_TouchsByBufferEx(strCommand, parmCommandImg, CompType, BuffType, parmTimeOut)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  if res then
    ret = 0
  else
    ret = 1
  end
  if BuffType == 0 then
    table.insert(ResultTable, "auto")
    table.insert(ResultTable, DelayTime)
  else
    table.insert(ResultTable, "auto")
    table.insert(ResultTable, bufftime)
    table.insert(ResultTable, buffnum)
  end
  return ret, ResultTable, picidx
end
function Method_TouchsByBufferEx(strCommand, strCommandImg, CompType, BuffType, TimeOut)
  local bufnum = 0
  local buftime = 0
  local buffflag = false
  local picflag = false
  local tmpnum = 0
  local picidx = 0
  ret = Method_TouchsPub(strCommand)
  if ret ~= 0 then
    return picflag, nil, nil, picidx
  end
  local hess, dtflag, touchstr, compimgres
  if strCommandImg == "" then
    picidx = 0
  else
    imglist = splittable(strCommandImg, "|")
    ostime = GetAPI_OsClock()
    while true do
      picidx = 0
      for imgname, imgvalue in pairs(imglist) do
        dtflag = false
        picidx = picidx + 1
        hess = string.find(imgvalue, "%(")
        if not hess then
          hess = string.find(imgvalue, "%<")
          if hess then
            dtflag = true
          end
        end
        if hess then
          touchstr = string.sub(imgvalue, hess + 1, -2)
          imgvalue = string.sub(imgvalue, 1, hess - 1)
          touchs = splittable(touchstr, " ")
          docount = 1
          for touchindex, touchname in pairs(touchs) do
            if touchindex == 1 then
              touchx = tonumber(touchname)
            end
            if touchindex == 2 then
              touchy = tonumber(touchname)
            end
            if touchindex == 3 then
              docount = tonumber(touchname)
            end
          end
        end
        ret = WaitEx(imgvalue, 0.5)
        DebugLogId("??????(ret):" .. ret)
        if CompType < 0 then
          if ret == 0 then
            compimgres = "???!"
            ret = 1
          else
            compimgres = "???!"
            ret = 0
          end
        end
        if ret == 0 then
          break
        end
      end
      if ret == 0 then
        tmpnum = tmpnum + 1
        picflag = true
        if BuffType ~= 0 then
          if tmpnum == 1 then
            bfstime = GetAPI_OsClock()
          end
          if tmpnum == 2 then
            buffflag = true
            bufnum = bufnum + 1
          end
          if tmpnum >= 2 and hess then
            while 0 < docount do
              if dtflag then
                GetAPI_Touch(touchx, touchy, 3, 0.2)
                GetAPI_Touch(touchx, touchy, 3, 0.2)
                DebugLogId("buff dbtouchx=" .. touchx .. ",buff dbtouchy=" .. touchy)
              else
                GetAPI_Touch(touchx, touchy, 3, 2)
                DebugLogId("buff touchx=" .. touchx .. ",buff touchy=" .. touchy)
              end
              docount = docount - 1
            end
          end
        end
      else
        tmpnum = 0
        if BuffType ~= 0 and buffflag then
          bfetime = GetAPI_OsClock()
          bfutime = GetAPI_SubTime(bfetime, bfstime)
          buftime = buftime + bfutime
          buffflag = false
        end
      end
      if BuffType == 0 and picflag then
        break
      end
      GetAPI_Sleep(1)
      oetime = GetAPI_OsClock()
      if TimeOut < GetAPI_SubTime(oetime, ostime) then
        break
      end
    end
  end
  if BuffType == 0 then
    return picflag, nil, nil, picidx
  else
    return true, bufnum, buftime, picidx
  end
end
function Method_InputString(InputContent, InputImg, MobType)
  local picidx = 0
  local ret = 0
  local CompImgTab
  local TimeOut = G_timeOut
  DebugLogId("????????:" .. InputContent)
  ret = GetAPI_InputString(InputContent)
  local startclock = GetAPI_OsClock()
  if InputImg == "" then
    print("No pic compare")
  else
    CompImgTab = splittable(InputImg, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Input(InputContent, InputImg, MobType)
  local picidx = 0
  local ret = 0
  local CompImgTab
  local TimeOut = G_timeOut
  DebugLogId("????????:" .. InputContent)
  ret = GetAPI_Input(InputContent, MobType)
  local startclock = GetAPI_OsClock()
  if InputImg == "" then
    print("No pic compare")
  else
    CompImgTab = splittable(InputImg, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_KillProcess(process, times, FlowStep)
  local ret = 0
  local startclock = GetAPI_OsClock()
  Method_KillProcessEx(process, times)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_KillProcessEx(process, times)
  local processtab = splittable(process, "|")
  local timestab = splittable(times, ",")
  if tonumber(timestab[1]) then
    timestab[1] = tonumber(timestab[1])
  else
    timestab[1] = 1
  end
  if timestab[2] and tonumber(timestab[2]) then
    timestab[2] = tonumber(timestab[2])
  else
    timestab[2] = 1
  end
  DebugLogId(string.format("????????: %s\t??????: %s", timestab[2], timestab[1]))
  DebugLogId("??????:" .. table.concat(processtab, "\r"))
  for j = 1, timestab[2] do
    for i = 1, #processtab do
      GetAPI_KillProcess(processtab[i])
    end
    GetAPI_Sleep(timestab[1])
  end
end
function Method_deleteString(times, imgs)
  local ret = 0
  local picidx = 0
  local CompImgTab
  local TimeOut = G_timeOut
  Method_deleteStringEX(times)
  local startclock = GetAPI_OsClock()
  if imgs == "" then
    print("No pic compare")
  else
    CompImgTab = splittable(imgs, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_deleteStringEX(times)
  local timestab
  timestab = splittable(times, ",")
  if string.upper(timestab[1]) == "ALL" then
    DebugLogId("method ??? ??????????¶ƒ?????????????????? ??")
    local uudelete = "am broadcast -a com.uusense.inputmethod.broadcastdeletall"
    _cfunc.Command(uudelete)
  elseif timestab[1] and tonumber(timestab[1]) then
    timestab[1] = tonumber(timestab[1])
  else
    timestab[1] = 1
  end
  DebugLogId("???????:" .. timestab[1])
  GetAPI_deleteString(timestab[1])
end
function Method_readinicyc(filepath)
  local ret = 0
  local index = 0
  local startclock = GetAPI_OsClock()
  local fx = io.open(filepath, "rb")
  if not fx then
    DebugLogId("????????°§?????????????????????????ß’??????")
  end
  local element = fx:read("*all")
  fx:close()
  element = string.gsub(element, "\r", "\n")
  element = string.gsub(element, [[


]], "\n")
  element = Strip(element) .. "\n"
  local a = Strip(string.sub(element, 1, string.find(element, "\n") - 1))
  local c = Strip(string.sub(element, string.find(element, "\n") + 1, -1))
  local b = c .. "\n" .. a
  DebugLogId("????????????" .. a)
  G_INIContList = splittable(a, "\t")
  fv = io.open(filepath, "wb")
  fv:write(b)
  fv:close()
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, index
end
function Method_Interactive(strCommand, strCommandImg, TimeOut)
  local parmTimeOut = G_timeOut
  local parmCommandImg, picidx, parmTab, ret, times
  local ResultContent = 0
  parmTab = splittable(strCommandImg, ",")
  imei = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  ret, times, picidx = Method_Interactiveex(strCommand, imei, parmTimeOut)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, times)
  return ret, ResultTable, picidx
end
function Method_Interactiveex(strCommand, imei, parmTimeOut)
  local from_imei = GetAPI_DevCode()
  local to_imei = imei
  local ret, times, res, picidx = 1, 0, 1, 1
  local status
  status = GetApi_inter(from_imei, to_imei, "clear_status")
  if status == "1" then
    status = GetApi_inter(from_imei, from_imei, "set_status")
    if status == "1" then
      for i = 1, parmTimeOut do
        status = GetApi_inter(from_imei, to_imei, "query_status")
        if status == "1" then
          break
        end
        GetAPI_Sleep(1)
      end
      if status ~= "1" then
        status = GetApi_inter(to_imei, from_imei, "clear_status")
        status = GetApi_inter(from_imei, to_imei, "clear_status")
        return -1, 0, 0
      end
      res = Method_TouchsPub(strCommand)
      if res == 0 and status == "1" then
        status = GetApi_inter(from_imei, to_imei, "send_message")
        if status == "1" then
          for i = 1, parmTimeOut do
            status, r12 = GetApi_inter(from_imei, to_imei, "query_message")
            if status == "1" then
              _, _, times = string.find(r12, "\"time\":(%d.-)}")
              ret = 0
              picidx = 0
              break
            end
          end
        end
      end
    end
  end
  status = GetApi_inter(to_imei, from_imei, "clear_status")
  status = GetApi_inter(from_imei, to_imei, "clear_status")
  return ret, times, picidx
end
function Method_Interactive_recv(strCommand, strCommandImg, imei)
  local parmTimeOut = G_timeOut
  local parmCommandImg, picidx, parmTab, ret
  local ResultContent = 0
  parmTab = splittable(strCommandImg, ",")
  parmCommandImg = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  local to_imei = GetAPI_DevCode()
  local ret, res, picidx = 1, 1, 1
  status = GetApi_inter(to_imei, to_imei, "clear_status")
  if status == "1" then
    status = GetApi_inter(to_imei, to_imei, "set_status")
    if status == "1" then
      local startclock = GetAPI_OsClock()
      ret, picidx = Method_TouchsEx("", parmCommandImg, parmTimeOut)
      local endclock = GetAPI_OsClock()
      local DelayTime = GetAPI_SubTime(endclock, startclock)
      if ret == 0 then
        status = GetApi_inter(to_imei, to_imei, "receive_message")
      end
    end
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function sliceAndCopyImage(strCommandImg, paraflag1)
  local coor_tmp_source_tab = splittable(strCommandImg, "_")
  local x1_sr, y1_sr, x2_sr, y2_sr = tonumber(coor_tmp_source_tab[1]), tonumber(coor_tmp_source_tab[2]), tonumber(coor_tmp_source_tab[3]), tonumber(coor_tmp_source_tab[4])
  local img_name = ""
  local pic_name_str = ""
  for i = 5, #coor_tmp_source_tab do
    img_name = img_name .. "_" .. coor_tmp_source_tab[i]
  end
  local width_img = x2_sr - x1_sr
  local height_img = y2_sr - y1_sr
  local region_coor_tab = splittable(paraflag1, "_")
  local start_x, start_y, end_x, end_y = tonumber(region_coor_tab[1]), tonumber(region_coor_tab[2]), tonumber(region_coor_tab[3]), tonumber(region_coor_tab[4])
  local get_pic_start_x = start_x
  local get_pic_end_x = get_pic_start_x + width_img
  local pic_name_string = ""
  local pic_name_table
  local get_pic_start_y = start_y
  local get_pic_end_y = get_pic_start_y + height_img
  while end_x > get_pic_end_x do
    get_pic_start_y = start_y
    get_pic_end_y = get_pic_start_y + height_img
    while end_y > get_pic_end_y do
      pic_name = tostring(get_pic_start_x) .. "_" .. tostring(get_pic_end_x) .. "_" .. tostring(get_pic_start_y) .. "_" .. tostring(get_pic_end_y) .. img_name
      local cp_ret = pcall(CopyFile, G_SysScpPath .. G_Pflg .. strCommandImg, G_SysScpPath .. G_Pflg .. pic_name)
      if cp_ret then
        pic_name_str = pic_name_str .. pic_name .. "-"
      end
      get_pic_start_y = get_pic_start_y + height_img
      get_pic_end_y = get_pic_start_y + height_img
    end
    if end_y <= get_pic_end_y then
      get_pic_end_y = end_y
      get_pic_start_y = get_pic_end_y - height_img
      pic_name = tostring(get_pic_start_x) .. "_" .. tostring(get_pic_end_x) .. "_" .. tostring(get_pic_start_y) .. "_" .. tostring(get_pic_end_y) .. img_name
      local cp_ret = pcall(CopyFile, G_SysScpPath .. G_Pflg .. strCommandImg, G_SysScpPath .. G_Pflg .. pic_name)
      if cp_ret then
        pic_name_str = pic_name_str .. pic_name .. "-"
      end
    end
    get_pic_start_x = get_pic_start_x + width_img
    get_pic_end_x = get_pic_start_x + width_img
  end
  if end_x <= get_pic_end_x then
    get_pic_end_x = end_x
    get_pic_start_x = get_pic_end_x - width_img
    get_pic_start_y = start_y
    get_pic_end_y = get_pic_start_y + height_img
    while end_y > get_pic_end_y do
      pic_name = tostring(get_pic_start_x) .. "_" .. tostring(get_pic_end_x) .. "_" .. tostring(get_pic_start_y) .. "_" .. tostring(get_pic_end_y) .. img_name
      local cp_ret = pcall(CopyFile, G_SysScpPath .. G_Pflg .. strCommandImg, G_SysScpPath .. G_Pflg .. pic_name)
      if cp_ret then
        pic_name_str = pic_name_str .. pic_name .. "-"
      end
      get_pic_start_y = get_pic_start_y + height_img
      get_pic_end_y = get_pic_start_y + height_img
    end
    if end_y <= get_pic_end_y then
      get_pic_end_y = end_y
      get_pic_start_y = get_pic_end_y - height_img
      pic_name = tostring(get_pic_start_x) .. "_" .. tostring(get_pic_end_x) .. "_" .. tostring(get_pic_start_y) .. "_" .. tostring(get_pic_end_y) .. img_name
      local cp_ret = pcall(CopyFile, G_SysScpPath .. G_Pflg .. strCommandImg, G_SysScpPath .. G_Pflg .. pic_name)
      if cp_ret then
        pic_name_str = pic_name_str .. pic_name .. "-"
      end
    end
  end
  pic_name_str = string.sub(pic_name_str, 1, -2)
  return pic_name_str
end
function Method_get_area(strCommand, strCommandImg, TimeOut)
  local picidx = 0
  local ret = 0
  local startclock = GetAPI_OsClock()
  ret = Method_TouchsPub(strCommand)
  if ret == 0 then
    ret, picidx = Method_get_areaEx(strCommandImg, TimeOut)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_get_areaEx(strCommandImg, TimeOut)
  local ret, picidx = 0, 0
  if strCommandImg == "" then
    ret = -1
  else
    ret = get_view_area(strCommandImg, TimeOut)
  end
  return ret, picidx
end
function get_view_area(strCommandImg, TimeOut)
  local ret = 0
  local ret, view = Dump_wait(strCommandImg, TimeOut)
  if ret ~= -1 then
    local tmp_coordinate_tab = {}
    local _, _, tmp_coordinate = string.find(view, "bounds=\"%[(.-)\"")
    for i in string.gmatch(tmp_coordinate .. "[", "(.-)%]%[") do
      table.insert(tmp_coordinate_tab, i)
    end
    tmp_coordinate_tab[1] = splittable(tmp_coordinate_tab[1], ",")
    tmp_coordinate_tab[2] = splittable(tmp_coordinate_tab[2], ",")
    local width = tonumber(tmp_coordinate_tab[2][1]) - tonumber(tmp_coordinate_tab[1][1])
    local height = tonumber(tmp_coordinate_tab[2][2]) - tonumber(tmp_coordinate_tab[1][2])
    DebugLogId("?????????????????" .. width)
    DebugLogId("?????????????????" .. height)
    G_area = width * height
    DebugLogId("???????????????" .. G_area)
    ret = 0
  else
    G_area = 0
    DebugLogId("???????????????")
  end
  return ret
end
function Method_judge(strCommand, strCommandimg, TimeOut)
  local picidx = 0
  local ret = 0
  local rets, view, subtime
  local startclock = GetAPI_OsClock()
  if strCommand ~= "" then
    rets, view = Dump_wait(strCommand, TimeOut)
    if rets ~= -1 then
      local checktime = cmrad_dump_time(view)
      subtime = tonumber(G_GetTime) - tonumber(checktime)
      DebugLogId("??????TIME= " .. subtime .. "s")
    else
      ret = -1
    end
  end
  if ret == 0 then
    ret, picidx = judge_wait_ex(strCommandimg, subtime)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function cmrad_dump_time(view)
  local checktime
  local _, _, str1, str2 = string.find(view, "text=\"(.-) (.-)\"")
  if str1 and str2 then
    local nowdata = os.date("%Y-%m-%d", os.time())
    local data_tab = splittable(nowdata, "-")
    local year = data_tab[1]
    local month, day
    if str1 == "????" then
      month = data_tab[2]
      day = data_tab[3]
    else
      local data_tmp_tab = splittable(str1, "-")
      month = data_tmp_tab[1]
      day = data_tmp_tab[2]
    end
    local time_tab = splittable(str2, ":")
    local hour = time_tab[1]
    local min = time_tab[2]
    checktime = os.time({
      year = year,
      month = month,
      day = day,
      hour = hour,
      min = min
    })
    DebugLogId(string.format("???????ß÷????%d-%d-%d %d:%d", year, month, day, hour, min) .. "?????????????" .. checktime)
  end
  return checktime
end
function Method_loop(times, flag)
  local picidx = 0
  local ret = 0
  local startclock = GetAPI_OsClock()
  G_loop_flag = 0
  if flag == 1 and 1 <= tonumber(times) then
    G_loop = tonumber(times)
    DebugLogId("?????????????????" .. tostring(G_loop))
    G_loop_flag = 1
  elseif flag == 2 and G_loop then
    G_loop_flag = 2
    G_loop = G_loop - 1
    if G_loop == 0 then
      G_loop = nil
    end
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_break()
  local picidx = 0
  local ret = 0
  local startclock = GetAPI_OsClock()
  DebugLogId("???????")
  G_loop = nil
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_video_Playback(strCommand, strCommandImg, TimeOut, paraflag1)
  local picidx, ret, first_time, startclock = 0, 0, 0, GetAPI_OsClock()
  local flag = 0
  local ret = 0
  local times = 1
  local paratable
  if strCommand and strCommand ~= "" then
    ret, first_time = Method_TouchsPub(strCommand)
  end
  local capt_time
  if paraflag1 then
    flag = 2
    paratable = splittable(paraflag1, ",")
    if paratable[2] and tonumber(paratable[2]) then
      times = tonumber(paratable[2])
      DebugLogId("????4??????:" .. times)
    end
  else
    flag = 1
  end
  if ret == 0 then
    if flag == 1 then
      capt_time = GetAPI_CaptureRectangle(G_SysScpPath .. G_Pflg .. strCommandImg)
      ret, picidx = CheckActionResults(strCommandImg, TimeOut, true)
    else
      if strCommandImg == "" then
        ret = 0
        picidx = 0
      else
        ret, picidx = CheckActionResults(strCommandImg, TimeOut)
      end
      if ret == 0 then
        local i = 1
        while true do
          DebugLogId("????4????" .. times .. "??,??????ß÷?" .. i .. "??")
          local time_out = TimeOut - GetAPI_SubTime(GetAPI_OsClock(), startclock)
          GetAPI_CaptureRectangle(G_SysScpPath .. G_Pflg .. paratable[1])
          G_check_view = false
          ret, picidx = CheckActionResults(paratable[1], time_out, true)
          if ret == 0 then
            i = i + 1
            if times < i then
              break
            end
          else
            break
          end
        end
      end
    end
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_energy(processname, flag)
  local startenergy, endenergy
  local energy = 0
  local res
  local ret = -1
  uid = GetApi_GetUidByPackageName(processname)
  res = _cfunc.Command("dumpsys batterystats --unplugged " .. processname)
  if flag == 0 then
    DebugLogId("?????????????")
    _, _, startenergy = string.find(res, "Uid *" .. uid .. " *: *(%d+%.%d+)")
    if startenergy then
      ret = 0
      G_startenergy = startenergy
    else
      ret = 0
      G_startenergy = 0
    end
  elseif G_startenergy then
    _, _, endenergy = string.find(res, "Uid *" .. uid .. " *: *(%d+%.%d+)")
    if endenergy then
      energy = tonumber(endenergy) - tonumber(G_startenergy)
      ret = 0
      DebugLogId("??????????????????¶¬???app?<" .. processname .. ">,??????" .. tostring(energy) .. "mAh????")
    else
      energy = 0
      ret = 0
      DebugLogId("??????????????????¶¬???app?<" .. processname .. ">,??????" .. tostring(energy) .. "mAh????")
    end
  else
    DebugLogId("??????????????⁄Ö???????µœ????")
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, energy)
  return ret, ResultTable
end
function Method_Dns(DnsUrl, FlowStep)
  local ret, NowDns, DNStime, DNSIP
  local TempTime = os.date("%Y%m%d%H%M%S")
  local DNSFileName = "DNS_" .. TempTime .. GetVoucTale(G_Id)
  local fl = io.open(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. DNSFileName .. ".txt", "w")
  DebugLogId("????DNS??????:" .. DnsUrl)
  ret, NowDns, DNStime, DNSIP = Method_DnsEx(DnsUrl)
  fl:write("???????????" .. DnsUrl .. "\t???dns???????????" .. NowDns .. ".\tDNS???????:" .. DNStime .. "ms\t?????????????ip?????" .. DNSIP .. "\n")
  fl:close()
  G_CMDNSVouc = DNSFileName .. ".zip"
  table.insert(G_DNSVouc, DNSFileName)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DNStime)
  return ret, ResultTable
end
function Method_DnsEx(DnsUrl)
  local Dnstime, DnsIP, ret, NowDns
  local res = 0
  NowDns = GetAPI_DnsIp()
  DebugLogId("???DNS?????????:" .. NowDns)
  if res == 0 then
    Dnstime, DnsIP = GetAPI_DnsInfo(DnsUrl)
    DebugLogId("DNS???:" .. Dnstime .. ",DNS???:" .. DnsIP)
    if Dnstime > 0 and string.find(DnsIP, ".") then
      ret = 0
    else
      G_GlbVocMsg = GetGVM("???¶¬???(DNS)???,?????:%s", {
        tostring(Dnstime)
      })
      ret = 1
      Dnstime = 0
      DnsIP = "0.0.0.0"
    end
  else
    ret = 1
    Dnstime = 0
    DnsIP = "0.0.0.0"
    G_GlbVocMsg = GetGVM("???¶¬???(DNS)???,???DNS??????...%s", {
      tostring(Dnstime)
    })
  end
  return ret, NowDns, Dnstime, DnsIP
end
function Method_Ping(PingUrl, pingtimes, pingvalue, FlowStep)
  local DelayTime, ResultContent, ActionValue, ret, res, resultvalue, ping_avgtime
  local TempTime = os.date("%Y%m%d%H%M%S")
  local PingFileName = "ping_" .. TempTime .. GetVoucTale(G_Id)
  local fl = io.open(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. PingFileName .. ".txt", "w")
  DebugLogId("????PING??????:" .. PingUrl .. ",???????:" .. pingtimes .. ",PING????ß≥:" .. pingvalue)
  res, resultvalue, ping_avgtime = GetAPI_PingInfo(PingUrl, pingtimes, pingvalue)
  DebugLogId("???¶¬????:" .. resultvalue .. ping_avgtime)
  ret, DelayTime, ResultContent, ActionValue = CalVar(resultvalue)
  if ret ~= 0 then
    DelayTime = 0
    G_GlbVocMsg = GetGVM("???¶¬???(PING)???,?????:%s", {resultvalue})
    fl:write("0\t0\t0")
  else
    fl:write("???ping??????" .. PingUrl .. "\ttime=" .. DelayTime .. "ms\tttl=" .. ResultContent .. "\tICMP=" .. ActionValue .. "\n")
  end
  fl:close()
  G_CMPNVouc = PingFileName .. ".zip"
  table.insert(G_PNVouc, PingFileName)
  local ResultTable = {}
  table.insert(ResultTable, "ping")
  table.insert(ResultTable, ping_avgtime)
  return ret, ResultTable
end
function Method_TCP(Url, Dtimes, FlowStep)
  local ret, r4
  ret, r2, r3, r4, r5, r6, r7, r8, r9, content, body, all = GetAPI_HttpVisit(Url)
  if G_EngineMode == "IOS" then
    r10 = content
  else
    _, _, r10 = string.find(content, "[Hh][Tt][Tt][Pp][/][^ ]*[ ]*(%w+)")
  end
  if ret == 6 then
    ret = 0
  else
    ret = 1
  end
  DebugLogId("???¶¬?????:" .. ret .. ",???????:" .. tostring(r4) .. "ms")
  if ret ~= 0 then
    r10 = 0
    G_GlbVocMsg = GetGVM("???¶¬???(DOWNH)???,?????:%s", {ret})
  end
  local ResultTable = {}
  table.insert(ResultTable, "tcp")
  table.insert(ResultTable, r4)
  return ret, ResultTable
end
function Method_HttpDownload(DownUrl, Dtimes, FlowStep)
  local ret, r4, r6, r7, r10
  ret, r4, r6, r7, r10 = Method_HttpDownloadEx(DownUrl, Dtimes)
  local ResultTable = {}
  table.insert(ResultTable, "http")
  table.insert(ResultTable, r10)
  table.insert(ResultTable, r4)
  table.insert(ResultTable, r6)
  table.insert(ResultTable, r7)
  return ret, ResultTable
end
function Method_HttpDownloadEx(DownUrl, Dtimes)
  local k, i, HUrl, DUrl, ret, r3, r4, r6, r10, r7, content
  ret, r2, r3, r4, r5, r6, r7, r8, r9, content, body, all = GetAPI_HttpVisit(DownUrl)
  DebugLogId("???????âÿ" .. all)
  if G_EngineMode == "IOS" then
    r10 = content
  else
    _, _, r10 = string.find(content, "[Hh][Tt][Tt][Pp][/][^ ]*[ ]*(%w+)")
  end
  if ret == 6 then
    ret = 0
  else
    ret = 1
  end
  DebugLogId("???¶¬?????:" .. ret .. ",???????:" .. tostring(r4) .. ",??????:" .. tostring(r6) .. ",???????:" .. tostring(r7) .. ",??????:" .. tostring(r10))
  if ret ~= 0 then
    r10 = 0
    G_GlbVocMsg = GetGVM("???¶¬???(DOWNH)???,?????:%s", {ret})
  end
  return ret, r4, r6, r7, r10
end
function Method_Video(strCommand, strCommandImg, TimeOut, FlowStep)
  local VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url, ret, LogName
  if strCommand ~= "" and strCommand then
    Method_Touchs(strCommand, "")
  end
  VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url = Method_VideoEX(strCommandImg, TimeOut)
  if VId == -1 then
    ret = 1
  else
    ret = 0
  end
  if G_EngineMode == "Android" then
    if G_vm2time and G_vm2timeflag == false then
      LogName = "vm2_" .. tostring(os.date("%Y%m%d%H%M%S", G_vm2time)) .. ".log"
    elseif G_vm2time and G_vm2timeflag == true then
      if pcall(function()
        local file = io.open("/data/data/com.autosense/files/vm2_" .. tostring(os.date("%Y%m%d%H%M%S", G_vm2time)) .. ".log", "r")
        file:close()
      end) then
        LogName = "vm2_" .. tostring(os.date("%Y%m%d%H%M%S", G_vm2time)) .. ".log"
      else
        LogName = "vm2_" .. tostring(os.date("%Y%m%d%H%M%S", G_vm2time - 1)) .. ".log"
      end
    end
    if ret == 0 then
      if LogName then
        DebugLogId("????????" .. "/data/data/com.autosense/files/" .. LogName)
        GetAPI_Deletefile("/data/data/com.autosense/files/" .. LogName)
        if pcall(function()
          local file = io.open("/system/xbin/busybox", "rb")
          file:close()
        end) then
          traceroute(VUrl)
        else
          DebugLogId("¶ƒ???busybox??ÔÖ????")
        end
      end
    elseif LogName and pcall(function()
      local file = io.open("/data/data/com.autosense/files/vm2_" .. tostring(os.date("%Y%m%d%H%M%S", G_vm2time)) .. ".log", "r")
      file:close()
    end) then
      DebugLogId("?????????/data/data/com.autosense/files/" .. LogName .. "??" .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. LogName)
      CopyFile("/data/data/com.autosense/files/" .. LogName, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. LogName)
      DebugLogId("????????" .. "/data/data/com.autosense/files/" .. LogName)
      GetAPI_Deletefile("/data/data/com.autosense/files/" .. LogName)
      G_vm2flag = LogName
      DebugLogId("????????" .. G_vm2flag)
    end
  end
  local ResultTable = {}
  table.insert(ResultTable, "video")
  table.insert(ResultTable, VId)
  table.insert(ResultTable, VDuration)
  table.insert(ResultTable, VUrl)
  table.insert(ResultTable, VConnectTime)
  table.insert(ResultTable, VFb)
  table.insert(ResultTable, Cnt)
  table.insert(ResultTable, bufftime)
  table.insert(ResultTable, VBT)
  table.insert(ResultTable, VDlt)
  table.insert(ResultTable, VDownloadRate)
  table.insert(ResultTable, VWH)
  table.insert(ResultTable, VbitRATE)
  table.insert(ResultTable, FFP)
  table.insert(ResultTable, packet_loss_rate)
  table.insert(ResultTable, M3u8url)
  return ret, ResultTable
end
function Method_VideoEX(strCommandImg, TimeOut)
  GetAPI_VM2_Video_Set_Play_Point()
  local endtime
  local vmtab = {}
  local urllist = {}
  local endflag = false
  local Vlist = {}
  local VId, VDuration, VUrl, VBufferCnt, VBufferTime, VConnectTime, VFirstPKTTime, VDownloadTime, VDownloadRate, VFb, VBT, VDlt, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url, Cnt, ret, VWIDTH, VHIGH, cnttime
  local tmplist = {}
  local bufftime = 0
  local breakflag
  local startime = GetAPI_OsClock()
  local VBT = ""
  local ret = 0
  local startclock = GetAPI_OsClock()
  local endclock, DelayTime, imgret, picidx
  if strCommandImg and strCommandImg ~= "" then
    startclock = GetAPI_OsClock()
    imgret, picidx = CheckActionResults(strCommandImg, 30)
    DelayTime = 0
    if imgret == 0 then
      while true do
        if DelayTime > 30 then
          ret = -1
          break
        else
          imgret = WaitEx(strCommandImg, 0.2)
          endclock = GetAPI_OsClock()
          DelayTime = GetAPI_SubTime(endclock, startclock)
          if imgret ~= 0 then
            ret = 0
            DelayTime = DelayTime - G_Imgtime
          else
            ret = -1
          end
        end
      end
  end
  if DelayTime then
    DebugLogId("????????? ??" .. DelayTime)
  end
  if ret == -1 then
    return -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  end
  while true do
    endtime = GetAPI_OsClock()
    if GetAPI_SubTime(endtime, startime) >= tonumber(TimeOut) then
      DebugLogId("???????,????????????")
      GetAPI_VM2_Video_Force_Check()
      DebugLogId("????????????????")
      while true do
        VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url = Info_Video()
        if VId >= 0 then
          tmplist = {
            VId,
            VDuration,
            VConnectTime,
            VFb,
            Cnt,
            bufftime,
            VBT,
            VDlt,
            VDownloadRate,
            VWH,
            VbitRATE,
            FFP,
            packet_loss_rate,
            M3u8url
          }
          table.insert(vmtab, tmplist)
          table.insert(urllist, VUrl)
          GetAPI_VM2_Video_Reset(VId)
        else
          break
        end
      end
      break
    end
    VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url = Info_Video()
    if VId >= 0 then
      tmplist = {
        VId,
        VDuration,
        VConnectTime,
        VFb,
        Cnt,
        bufftime,
        VBT,
        VDlt,
        VDownloadRate,
        VWH,
        VbitRATE,
        FFP,
        packet_loss_rate,
        M3u8url
      }
      table.insert(vmtab, tmplist)
      table.insert(urllist, VUrl)
      GetAPI_VM2_Video_Reset(VId)
    end
    GetAPI_Sleep(5)
  end
  local Vurllist = {}
  local VDuration = 0
  local VDlt = 0
  local bufftime = 0
  local VDownloadRate = 0
  local VId, VConnectTime, VFb, Cnt, VBT, VWH, VbitRATE, FFP, M3u8url
  for i = 1, #vmtab do
    if tonumber(vmtab[i][12]) ~= 0 and urllist[i] ~= "" then
      table.insert(Vlist, vmtab[i])
      table.insert(Vurllist, urllist[i])
    end
  end
  for i = 1, #Vlist do
    if i == 1 then
      VDuration = Vlist[i][2]
      bufftime = Vlist[i][6]
      VDownloadRate = Vlist[i][9]
      VDlt = Vlist[i][8]
      FFP = tonumber(Vlist[i][12])
      M3u8url = Vlist[i][14]
    else
      VDuration = VDuration + Vlist[i][2]
      bufftime = bufftime + Vlist[i][6]
      VDownloadRate = (VDownloadRate * VDlt + Vlist[i][8] * Vlist[i][9]) / (VDlt + Vlist[i][8])
      VDlt = VDlt + Vlist[i][8]
    end
    if not VUrl or VUrl == "" then
      VUrl = Vurllist[i]
    end
    VId = VId or Vlist[i][1]
    if not Cnt then
      Cnt = tonumber(Vlist[i][5])
    else
      Cnt = Cnt + Vlist[i][5]
    end
    if not VConnectTime or tonumber(VConnectTime) == 0 then
      VConnectTime = Vlist[i][3]
    end
    if not VFb or tonumber(VFb) == 0 then
      VFb = Vlist[i][4]
    end
    if not VBT or VBT == "" then
      VBT = Vlist[i][7]
    elseif Vlist[i][7] ~= "" then
      VBT = VBT .. "/" .. Vlist[i][7]
    end
    VWH = VWH or Vlist[i][10]
    if not VbitRATE or tonumber(VbitRATE) == 0 then
      VbitRATE = Vlist[i][11]
    end
    if tonumber(FFP) == 0 then
      FFP = Vlist[i][12]
    end
    if tonumber(Vlist[i][12]) < tonumber(FFP) and tonumber(Vlist[i][12]) ~= 0 then
      VConnectTime = Vlist[i][3]
      VFb = Vlist[i][4]
      FFP = Vlist[i][12]
    end
    if not M3u8url or M3u8url == "" then
      M3u8url = Vlist[i][14]
    end
  end
  if DelayTime then
    FFP = DelayTime
  end
  if not Cnt or not VUrl or not VDownloadRate or not VConnectTime or tonumber(FFP) == 0 or 30 < tonumber(FFP) or 0 > tonumber(FFP) then
    return -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  end
  VDownloadRate = DecPoint(VDownloadRate / 1024)
  DebugLogId("????????" .. tostring(VDuration) .. "s\t??????????????" .. FFP .. "s\t??????????" .. VConnectTime .. "ms")
  G_cnt = Cnt
  return VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, M3u8url
end
function Info_Video()
  local VId, VDuration, VUrl, VBufferCnt, VBufferTime, VConnectTime, VFirstPKTTime, VDownloadTime, VDownloadRate, VFb, VDlt, VWH, VbitRATE, FFP, Cnt, ret, VWIDTH, VHIGH, _, M3u8url
  local VBT = ""
  local bufftime = 0
  VId = GetAPI_VM2_Video_ID()
  if VId then
    DebugLogId("???id??" .. VId)
  else
    DebugLogId("???id ???????VM2_Video_ID?????????")
    return -1
  end
  if VId >= 0 then
    VDuration = tonumber(GetAPI_VM2_Video_Duration(VId))
    DebugLogId("????????" .. VDuration)
    VWIDTH = GetAPI_VM2_Video_Width(VId)
    VHIGH = GetAPI_VM2_Video_Height(VId)
    VFb = tonumber(GetAPI_VM2_Video_First_PKT_Time(VId))
    VUrl = GetAPI_VM2_Video_URL(VId)
    DebugLogId("?????" .. VUrl)
    VDownloadRate = tonumber(GetAPI_VM2_Video_DL_Rate(VId))
    VConnectTime = tonumber(GetAPI_VM2_Video_Connect_Time(VId))
    VDlt = tonumber(GetAPI_VM2_Video_DL_Time(VId))
    VbitRATE = tonumber(GetAPI_VM2_Video_Bitrate(VId))
    VWH = tostring(VWIDTH) .. "*" .. tostring(VHIGH)
    FFP = tonumber(GetAPI_VM2_Video_Play_Time(VId)) / 1000
    VBufferCnt = GetAPI_VM2_Video_Buffer_Count(VId)
    DebugLogId("VM2??????" .. FFP)
    DebugLogId("??????" .. VFb)
    status, M3u8url = pcall(GetAPI_VM2_Video_M3U8_Addr, VId)
    if status then
      DebugLogId("M3U8?????" .. M3u8url)
    end
    if 0 < tonumber(VBufferCnt) then
      VBT = ""
      Cnt = VBufferCnt
      if Cnt == 1 then
        VBT = ""
        Cnt = 0
      else
        for j = 2, Cnt do
          cnttime = GetAPI_VM2_Video_Buffer_Time(VId, j - 1)
          bufftime = bufftime + cnttime
          if VBT == "" then
            VBT = cnttime
          else
            VBT = VBT .. "/" .. cnttime
          end
        end
      end
      if Cnt ~= 0 then
        Cnt = Cnt - 1
      end
    end
  end
  return VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, 0, M3u8url
end
function Method_Video_sig(strCommand, strCommandImg, TimeOut, FlowStep)
  local VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, ret, LogName
  if strCommand ~= "" and strCommand then
    Method_Touchs(strCommand, "")
  end
  VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate = Method_VideoEX_sig(strCommandImg, TimeOut)
  if VId == -1 then
    ret = 1
  else
    ret = 0
  end
  if G_EngineMode == "Android" then
    if pcall(function()
      local file = io.open("/data/data/com.autosense/files/" .. string.gsub(strCommandImg, "%.", "_") .. ".txt", "rb")
      file:close()
    end) then
      CopyFile("/data/data/com.autosense/files/" .. string.gsub(strCommandImg, "%.", "_") .. ".txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. string.gsub(strCommandImg, "%.", "_") .. ".txt")
      G_vm2flag_new = string.gsub(strCommandImg, "%.", "_") .. ".txt"
    end
  end
  local ResultTable = {}
  if G_MonitorSignal then
    table.insert(ResultTable, "auto_video")
  else
    table.insert(ResultTable, "video")
  end
  table.insert(ResultTable, VId)
  table.insert(ResultTable, VDuration)
  table.insert(ResultTable, VUrl)
  table.insert(ResultTable, VConnectTime)
  table.insert(ResultTable, VFb)
  table.insert(ResultTable, Cnt)
  table.insert(ResultTable, bufftime)
  table.insert(ResultTable, VBT)
  table.insert(ResultTable, VDlt)
  table.insert(ResultTable, VDownloadRate)
  table.insert(ResultTable, VWH)
  table.insert(ResultTable, VbitRATE)
  table.insert(ResultTable, FFP)
  table.insert(ResultTable, packet_loss_rate)
  return ret, ResultTable
end
function Method_Video_auto(strCommand, strCommandImg, TimeOut, FlowStep)
  local VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate, ret, LogName
  local buffrate = 0
  if strCommand ~= "" and strCommand then
    Method_Touchs(strCommand, "")
  end
  VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate = Method_VideoEX_sig(strCommandImg, TimeOut)
  if VId == -1 then
    ret = 1
  else
    ret = 0
    buffrate = tonumber(bufftime) / (tonumber(TimeOut) * 10)
  end
  if G_EngineMode == "Android" then
    if pcall(function()
      local file = io.open("/data/data/com.autosense/files/" .. string.gsub(strCommandImg, "%.", "_") .. ".txt", "rb")
      file:close()
    end) then
      CopyFile("/data/data/com.autosense/files/" .. string.gsub(strCommandImg, "%.", "_") .. ".txt", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. string.gsub(strCommandImg, "%.", "_") .. ".txt")
      G_vm2flag_new = string.gsub(strCommandImg, "%.", "_") .. ".txt"
    end
  end
  local ResultTable = {}
  DebugLogId("??????????????" .. FFP .. "s\t?????????" .. Cnt .. "\t?????????: " .. bufftime .. "ms\t??????????:" .. buffrate .. "%")
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, FFP)
  table.insert(ResultTable, Cnt)
  return ret, ResultTable
end
function Method_VideoEX_sig(strCommandImg, TimeOut)
  local start_touch_time = _cfunc.GetCurTime()
  local endtime
  local VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VWH, VbitRATE, FFP = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  local packet_loss_rate = G_packet_loss_rate or "00.00"
  local VDlt = G_rateTime_url or 0
  local VDownloadRate = G_rate_url or 0
  local Cnt, ret, VWIDTH, VHIGH, cnttime
  local bufftime = 0
  local breakflag
  local startime = GetAPI_OsClock()
  local VBT = ""
  local ret = 0
  local endclock, DelayTime, imgret, picidx
  local ping_tab = {}
  DebugLogId("??????" .. start_touch_time)
  endtime = GetAPI_OsClock()
  local xposed_fpath = "/data/data/com.autosense/files/" .. string.gsub(strCommandImg, "%.", "_") .. ".txt"
  DebugLogId(string.format("xposed_fpath: %s", xposed_fpath))
  if GetAPI_SubTime(endtime, startime) <= tonumber(TimeOut) then
    local wait_time = tonumber(TimeOut) - GetAPI_SubTime(endtime, startime)
    DebugLogId("??????????????????????????" .. wait_time .. "s")
    GetAPI_Sleep(wait_time + 1)
    DebugLogId("????????")
  end
  local start_time_table, end_time_table, play_time_table = getVideoValueTable(xposed_fpath, start_touch_time)
  Cnt = #end_time_table
  local start_number = 1
  DebugLogId("??????????" .. #start_time_table)
  DebugLogId("???????????" .. #end_time_table)
  local cnt_reduce = 0
  for i = start_number, Cnt do
    do
      local buff_time_once = 0
      if pcall(function()
        tonumber(end_time_table[i])
      end) then
        if pcall(function()
          tonumber(start_time_table[i])
        end) then
          buff_time_once = tonumber(end_time_table[i]) - tonumber(start_time_table[i])
        end
      end
      bufftime = bufftime + buff_time_once
      if buff_time_once > 0 then
        if VBT == "" then
          VBT = tostring(buff_time_once) .. "-" .. tostring(start_time_table[i]) .. "-" .. tostring(end_time_table[i])
        else
          VBT = VBT .. "/" .. tostring(buff_time_once) .. "-" .. tostring(start_time_table[i]) .. "-" .. tostring(end_time_table[i])
        end
      else
        cnt_reduce = cnt_reduce + 1
      end
    end
  end
  if cnt_reduce > 0 then
    Cnt = Cnt - cnt_reduce
  end
  if start_number == 2 then
    if Cnt == 1 then
      VBT = ""
      Cnt = 0
    end
    if Cnt ~= 0 then
      Cnt = Cnt - 1
    end
    if #end_time_table ~= 0 then
      FFP = (tonumber(end_time_table[1]) - start_touch_time) / 1000
    else
      DebugLogId("???????????????????????")
      return -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    end
  elseif #play_time_table ~= 0 then
    FFP = (tonumber(play_time_table[1]) - start_touch_time) / 1000
  else
    DebugLogId("???????????????????????")
    return -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  end
  if Cnt < 0 then
    return -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  end
  VDlt = VDlt * 1000
  G_cnt = Cnt
  G_view = tonumber(bufftime) / 1000
  DebugLogId("??????????????" .. FFP .. "s\t?????????" .. Cnt .. "\t?????????: " .. bufftime .. "ms")
  return VId, VDuration, VUrl, VConnectTime, VFb, Cnt, bufftime, VBT, VDlt, VDownloadRate, VWH, VbitRATE, FFP, packet_loss_rate
end
function getVideoValueTable(path, start_time)
  local cmd = string.format([[
su -c 'chmod 777 %s'
exit]], path)
  _cfunc.Command(cmd)
  local ret, value = pcall(function()
    local file = io.open(path, "rb")
    value = file:read("*all")
    file:close()
    return Strip(value)
  end)
  if ret then
    do
      local start_time_table = {}
      local end_time_table = {}
      local play_time_table = {}
      string.gsub(value, "buffering_start: ?(%d+)", function(w)
        if tonumber(w) > tonumber(start_time) then
          table.insert(start_time_table, w)
        end
      end)
      string.gsub(value, "buffering_end: ?(%d+)", function(w)
        if tonumber(w) > tonumber(start_time) then
          table.insert(end_time_table, w)
        end
      end)
      string.gsub(value, "play: ?(%d+)", function(w)
        if tonumber(w) > tonumber(start_time) then
          table.insert(play_time_table, w)
        end
      end)
      i = 1
      while i <= #end_time_table do
        if start_time_table[i] then
          if tonumber(end_time_table[i]) < tonumber(start_time_table[i]) then
            table.remove(end_time_table, i)
          else
            i = i + 1
          end
        else
          table.remove(end_time_table, i)
        end
      end
      return start_time_table, end_time_table, play_time_table
    end
  else
    DebugLogId("????????txt???")
    return {}, {}, {}
  end
end
function Method_receive(sock)
  local response, receive_status
  local list = {}
  local timeout = 15
  local startclock = GetAPI_OsClock()
  local response, receive_status
  local list = {}
  local timeout = 15
  local startclock = GetAPI_OsClock()
  while true do
    local endclock = GetAPI_OsClock()
    if timeout < GetAPI_SubTime(endclock, startclock) then
      break
    end
    sock:settimeout(2, "b")
    response, receive_status = sock:receive("*l")
    if response then
      if response == "*#*#1234567890*#*#" then
        break
      else
        DebugLogId("response ??" .. response)
        response = string.gsub(response, "http://", "")
        if string.sub(response, 1, 9) ~= "127.0.0.1" then
          table.insert(list, response)
        end
      end
    end
  end
  return list
end
function Method_WlanInfo(wifiName, FlowStep)
  local ret, res, lfile
  local DelayTime = 0
  local ResultContent, ActionValue, ResultDesc, AttachPath, filetab
  local XDtab = {
    "2412",
    "2417",
    "2422",
    "2427",
    "2432",
    "2437",
    "2442",
    "2447",
    "2452",
    "2457",
    "2462",
    "2467",
    "2472"
  }
  res, lfile = Method_WlanInfoEx(wifiName)
  if res < 0 then
    ret = 1
    ResultContent = 0
    ActionValue = 0
  else
    filetab = splittable(lfile, ",")
    DelayTime = filetab[4]
    ResultContent = filetab[2]
    ActionValue = filetab[3]
    ResultDesc = InTable(ActionValue, XDtab)
    ResultDesc = ResultDesc or 0
    AttachPath = 95 + tonumber(DelayTime)
    ret = 0
  end
  local ResultTable = {}
  table.insert(ResultTable, "wifi")
  table.insert(ResultTable, wifiName)
  table.insert(ResultTable, ResultContent)
  table.insert(ResultTable, ActionValue)
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_WlanInfoEx(wifiName)
  local lfile, res, infotab
  local i = 1
  local ret = -1
  local j, breakflag
  for j = 1, 12 do
    res = GetAPI_ScanWlanInfo()
    if string.find(res, "|") then
      breakflag = true
      DebugLogId("???WLAN???:" .. res)
      break
    end
    GetAPI_Sleep(5)
  end
  if breakflag then
    DebugLogId("???wifi??:" .. wifiName)
    res = string.sub(res, 1, -2)
    infotab = splittable(res, "|")
    while i <= #infotab do
      DebugLogId("???wifi???:" .. infotab[i])
      j = string.find(infotab[i], ",")
      if string.sub(infotab[i], 1, j - 1) == wifiName then
        ret = 0
        DebugLogId("?????")
        lfile = infotab[i]
      else
        i = i + 1
          DebugLogId("???WLAN???:???!???????¶ƒ?????wifi???...")
        end
      end
    end
  if ret == -1 then
    G_GlbVocMsg = GetGVM("???¶¬???(WLANINFO)???,?????:%s", {ret})
  end
  return ret, lfile
end
function Method_GetWlanInfo(FlowStep)
  local ret, lfile
  local DelayTime = 0
  local ResultDesc = 0
  local wifiName = "nil"
  local filetab
  local ResultContent = 0
  local ActionValue = 0
  local AttachPath = 0
  for i = 1, 12 do
    ret = GetAPI_WifiCurrConnInfo()
    if ret ~= "" then
      break
    end
    GetAPI_Sleep(1)
  end
  DebugLogId("???¶¬????????:" .. ret)
  filetab = splittable(ret, "|")
  if #filetab < 5 or filetab[4] == "-1" then
    ret = 1
  else
    wifiName = filetab[1]
    DelayTime = filetab[5]
    ResultContent = filetab[2]
    ActionValue = filetab[3]
    ResultDesc = filetab[4]
    AttachPath = 95 + tonumber(DelayTime)
    ret = 0
  end
  local ResultTable = {}
  table.insert(ResultTable, "wifi")
  table.insert(ResultTable, wifiName)
  table.insert(ResultTable, ResultContent)
  table.insert(ResultTable, AttachPath)
  table.insert(ResultTable, DelayTime)
  table.insert(ResultTable, ResultDesc)
  table.insert(ResultTable, ActionValue)
  return ret, ResultTable
end
function Method_ConnectWifi(wifiName, FlowStep)
  local ret, ip, res
  local DelayTime = 0
  res, ip = Method_ConnectWifiEx(wifiName)
  if res < 0 then
    G_GlbVocMsg = GetGVM("???¶¬???(ConnectWifi)???,?????:%s", {res})
    ret = 1
  else
    DelayTime = res
    ret = 0
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_ConnectWifiEx(wifiName)
  local ret, startclock, endclock, NowIp, NewIp, ip
  DebugLogId("????????????wifi...")
  for i = 1, 3 do
    GetAPI_Sleep(1)
    ret = GetAPI_WifiDisconnect()
  end
  if ret == 0 then
    NowIp = GetAPI_DeviceIP()
    DebugLogId("?????????wifi???,???IP?:" .. NowIp)
    startclock = GetAPI_OsClock()
    DebugLogId("???????wifi:" .. wifiName)
    ret = GetAPI_WifiConnect(wifiName)
    DebugLogId("????wifi-" .. wifiName .. "?????:" .. ret)
    while true do
      if ret == 0 then
        local iptab
        NewIp = GetAPI_DeviceIP()
        endclock = GetAPI_OsClock()
        DebugLogId("???IP:" .. NewIp)
        if NewIp ~= NowIp and #NewIp >= 9 then
          ret = GetAPI_SubTime(endclock, startclock)
          ip = NewIp
          break
        end
        if GetAPI_SubTime(endclock, startclock) >= G_timeOut then
          ret = -1
          break
        end
      end
      GetAPI_Sleep(0.25)
    end
  end
  return ret, ip
end
function Method_CheckNet(simflg, netmode, TimeOut, FlowStep)
  local ret, network, picidx
  local startclock = GetAPI_OsClock()
  ret, network, picidx = Method_CheckNetEx(simflg, netmode, TimeOut)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function GetCMD_NetFlag(nflg)
  local retnet
  if G_EngineMode == "IOS" then
    retnet = "UNKNOWN"
  else
    retnet = _cfunc.Command("getprop gsm.network.type")
    local nettb = splittable(retnet, ",")
    retnet = nettb[tonumber(nflg)]
  end
  return retnet
end
function Method_CheckNetEx(simflg, netmode, TimeOut)
  local ret = 1
  local startt, endt, nownetwork, picidx
  local nettb = {}
  startt = GetAPI_OsClock()
  DebugLogId("????????????...")
  while true do
    endt = GetAPI_OsClock()
    if TimeOut <= GetAPI_SubTime(endt, startt) then
      break
    end
    netmode = string.upper(netmode)
    if netmode:find("2G") or netmode:find("3G") or netmode:find("4G") or netmode:find("WIFI") or netmode:find("LAN") then
      nownetwork = GetAPI_NetFlag()
    else
      simflg = simflg or 1
      nownetwork = GetCMD_NetFlag(simflg)
    end
    if nownetwork ~= "UNKNOWN" then
      DebugLogId("????????:" .. nownetwork)
      break
    end
    GetAPI_Sleep(3)
  end
  nettb = splittable(netmode, "|")
  for idx, tarnet in pairs(nettb) do
    if string.upper(tarnet) == string.upper(nownetwork) then
      ret = 0
      picidx = idx
      break
    end
  end
  return ret, nownetwork, picidx
end
function Method_svc_wifi(enable_flag)
  local ret, picidx = 0, 0
  local startclock = GetAPI_OsClock()
  GetAPI_SvcWifi(enable_flag)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_CheckFile(filepath, flag)
  local index = 0
  local ret, nowtype
  local tb = {}
  local startclock = GetAPI_OsClock()
  ret = pcall(function()
    local file = io.open(filepath, "r")
    file:close()
  end)
  if ret then
    nowtype = "Y"
    DebugLogId("???<<" .. filepath .. ">>?????")
  else
    nowtype = "N"
    DebugLogId("???<<" .. filepath .. ">>???????")
  end
  tb = splittable(flag, "|")
  for idx, tartype in pairs(tb) do
    if nowtype == tartype then
      index = idx
      break
    end
  end
  if index ~= 0 then
    ret = 0
  else
    ret = -1
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, index
end
function Method_CaptureScreen()
  local ret = 0
  local startclock = GetAPI_OsClock()
  local picname = os.date("%Y%m%d%H%M%S") .. ".png"
  GetAPI_CaptureImg(G_SysDbgPath .. G_Pflg .. picname)
  table.insert(G_CaptureTab, picname)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_CapturePic(imgname)
  local ret = 0
  local startclock = GetAPI_OsClock()
  local resultflag, pic_exname, pic_path
  if imgname and imgname ~= "" then
    local TempTime = os.date("%Y%m%d%H%M%S")
    local TempIMGtable = splittable(imgname, "_")
    local imgName_tmp = ""
    for i = 1, #TempIMGtable do
      if i == 1 then
        imgName_tmp = TempIMGtable[i]
      else
        imgName_tmp = imgName_tmp .. "_" .. TempIMGtable[i]
      end
    end
    if G_EngineMode == "Android" then
      pic_exname = "_.bmp"
      pic_path = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. pic_exname
      GetAPI_CaptureRectangle(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. pic_exname)
    elseif G_EngineMode == "IOS" then
      pic_exname = "_.png"
      pic_path = "/var/mobile/ua_small.png"
      GetAPI_CaptureRectangle(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. pic_exname, TempIMGtable[1], TempIMGtable[2], TempIMGtable[3], TempIMGtable[4])
    end
    CopyFile(pic_path, string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "hzys_" .. TempTime .. GetVoucTale(G_Id) .. "_" .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_CapturePic" .. pic_exname)
    CopyFile(pic_path, G_SysScpPath .. G_Pflg .. imgName_tmp)
    GetAPI_Deletefile(pic_path)
    G_CaptureImg = "hzys_" .. TempTime .. GetVoucTale(G_Id) .. "_" .. TempIMGtable[1] .. "_" .. TempIMGtable[2] .. "_" .. TempIMGtable[3] .. "_" .. TempIMGtable[4] .. "_CapturePic" .. pic_exname
    resultflag = "auto_capture"
    DebugLogId(string.format("%s: %s", resultflag, G_CaptureImg))
  else
    local picname = os.date("%Y%m%d%H%M%S") .. ".png"
    GetAPI_CaptureImg(G_SysDbgPath .. G_Pflg .. picname)
    table.insert(G_CaptureTab, picname)
    resultflag = "auto"
    DebugLogId(string.format("%s: %s", resultflag, G_SysDbgPath .. G_Pflg .. picname))
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, resultflag)
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
XDBase64 = {}
local string = string
XDBase64.__code = {
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "+",
  "/"
}
XDBase64.__decode = {}
for k, v in pairs(XDBase64.__code) do
  XDBase64.__decode[string.byte(v, 1)] = k - 1
end
function XDBase64.encode(text)
  local len = string.len(text)
  local left = len % 3
  len = len - left
  local res = {}
  local index = 1
  for i = 1, len, 3 do
    local a = string.byte(text, i)
    local b = string.byte(text, i + 1)
    local c = string.byte(text, i + 2)
    local num = a * 65536 + b * 256 + c
    for j = 1, 4 do
      local tmp = math.floor(num / 2 ^ ((4 - j) * 6))
      local curPos = tmp % 64 + 1
      res[index] = XDBase64.__code[curPos]
      index = index + 1
    end
  end
  if left == 1 then
    XDBase64.__left1(res, index, text, len)
  elseif left == 2 then
    XDBase64.__left2(res, index, text, len)
  end
  return table.concat(res)
end
function XDBase64.__left2(res, index, text, len)
  local num1 = string.byte(text, len + 1)
  num1 = num1 * 1024
  local num2 = string.byte(text, len + 2)
  num2 = num2 * 4
  local num = num1 + num2
  local tmp1 = math.floor(num / 4096)
  local curPos = tmp1 % 64 + 1
  res[index] = XDBase64.__code[curPos]
  local tmp2 = math.floor(num / 64)
  curPos = tmp2 % 64 + 1
  res[index + 1] = XDBase64.__code[curPos]
  curPos = num % 64 + 1
  res[index + 2] = XDBase64.__code[curPos]
  res[index + 3] = "="
end
function XDBase64.__left1(res, index, text, len)
  local num = string.byte(text, len + 1)
  num = num * 16
  tmp = math.floor(num / 64)
  local curPos = tmp % 64 + 1
  res[index] = XDBase64.__code[curPos]
  curPos = num % 64 + 1
  res[index + 1] = XDBase64.__code[curPos]
  res[index + 2] = "="
  res[index + 3] = "="
end
function XDBase64.decode(text)
  local len = string.len(text)
  local left = 0
  if string.sub(text, len - 1) == "==" then
    left = 2
    len = len - 4
  elseif string.sub(text, len) == "=" then
    left = 1
    len = len - 4
  end
  local res = {}
  local index = 1
  local decode = XDBase64.__decode
  for i = 1, len, 4 do
    local a = decode[string.byte(text, i)]
    local b = decode[string.byte(text, i + 1)]
    local c = decode[string.byte(text, i + 2)]
    local d = decode[string.byte(text, i + 3)]
    local num = a * 262144 + b * 4096 + c * 64 + d
    local e = string.char(num % 256)
    num = math.floor(num / 256)
    local f = string.char(num % 256)
    num = math.floor(num / 256)
    res[index] = string.char(num % 256)
    res[index + 1] = f
    res[index + 2] = e
    index = index + 3
  end
  if left == 1 then
    XDBase64.__decodeLeft1(res, index, text, len)
  elseif left == 2 then
    XDBase64.__decodeLeft2(res, index, text, len)
  end
  return table.concat(res)
end
function XDBase64.__decodeLeft1(res, index, text, len)
  local decode = XDBase64.__decode
  local a = decode[string.byte(text, len + 1)]
  local b = decode[string.byte(text, len + 2)]
  local c = decode[string.byte(text, len + 3)]
  local num = a * 4096 + b * 64 + c
  local num1 = math.floor(num / 1024) % 256
  local num2 = math.floor(num / 4) % 256
  res[index] = string.char(num1)
  res[index + 1] = string.char(num2)
end
function XDBase64.__decodeLeft1(res, index, text, len)
  local decode = XDBase64.__decode
  local a = decode[string.byte(text, len + 1)]
  local b = decode[string.byte(text, len + 2)]
  local c = decode[string.byte(text, len + 3)]
  local num = a * 4096 + b * 64 + c
  local num1 = math.floor(num / 1024) % 256
  local num2 = math.floor(num / 4) % 256
  res[index] = string.char(num1)
  res[index + 1] = string.char(num2)
end
function XDBase64.urlEncode(s)
  s = string.gsub(s, "([^%w%.%- ])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  return string.gsub(s, " ", "+")
end
function XDBase64.urlDecode(s)
  s = string.gsub(s, "%%(%x%x)", function(h)
    return string.char(tonumber(h, 16))
  end)
  return s
end
local function ocrpic_baidu(pathname)
  local fileread = function(FileName)
    local ReadContent
    pcall(function()
      io.input(FileName)
      ReadContent = io.read("*a")
      io.close()
    end)
    return ReadContent
  end
  if not File_Exists(pathname) then
    return -1
  end
  io.input(pathname)
  local readData = io.read("*a")
  io.close()
  os.execute("rm -r /data/local/tmp/ocrid.txt")
  local imgdata = XDBase64.encode(readData)
  local ocrurl = "https://aip.baidubce.com/rest/2.0/ocr/v1/webimage?access_token=24.d953e743541695090df84c51c41f04cc.2592000.1553837766.282335-11420071"
  local ocrbody = XDBase64.urlEncode(imgdata)
  local curlstr = string.format("/data/local/tmp/curl-7.40.0/bin/curl -o /data/local/tmp/ocrid.txt -k -H \"Content-Type:application/x-www-form-urlencoded\" -d \"image=%s\" %s", ocrbody, ocrurl)
  os.execute(curlstr)
  local ocrret = fileread("/data/local/tmp/ocrid.txt")
  DebugLogId(ocrret)
  return ocrret
end
function mgpic_Ocrhttps(pathname)
  local words = 0
  local ocret = ocrpic_baidu(pathname)
  if ocret ~= -1 then
    local ocrwords = ocret:match("words_result\".*(%b{})") or 0
    if ocrwords ~= 0 then
      words = ocrwords:match(":.*(%b\"\")"):sub(2, -2) or words
    end
  end
  return words
end
local function recOcrTime(flg, ostime, ocrtime, tmpclock)
  if flg == "A" then
    G_mgScriptFlg.A = {
      "A",
      ostime,
      ocrtime,
      tmpclock
    }
  elseif flg == "B" then
    G_mgScriptFlg.B = {
      "B",
      ostime,
      ocrtime,
      tmpclock
    }
  elseif flg == "C" then
    G_mgScriptFlg.C = {
      "C",
      ostime,
      ocrtime,
      tmpclock
    }
  elseif flg == "D" then
    G_mgScriptFlg.D = {
      "D",
      ostime,
      ocrtime,
      tmpclock
    }
  end
  DebugLogId(string.format("REC OCR result: %s %s %s", flg, ostime, ocrtime))
end
local function cjy_ScorePic(pic_name)
  if pic_name then
    return "??????????(???)?????????????ID"
  end
  local aUser, aPass, aSoftid = G_PICUSER, G_PICPSW, G_PICID
  local aCodetype = 1006
  local fileread = function(FileName)
    local ReadContent
    pcall(function()
      io.input(FileName)
      ReadContent = io.read("*a")
      io.close()
    end)
    return ReadContent
  end
  local function getScore(aUser, aPass)
    local ret = -1
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
  local tifen = getScore(aUser, aPass)
  local pictxt = ""
  if tifen > 20 then
    local file_path = string.format("%s/%s", path, pic_name)
    pictxt = upPic(aUser, aPass, aCodetype, aSoftid, file_path)
  else
    print("???????????????????????????????ß‘??????")
  end
  return pictxt
end
function Method_Voucher(posPram, ocrTflg)
  local ret = 0
  local startclock = GetAPI_OsClock()
  local ImgTmpTb = splittable(posPram, ",")
  local timeOut = ImgTmpTb[2] and tonumber(ImgTmpTb[2]) or G_timeOut
  local userPram = not ImgTmpTb[2] and ImgTmpTb[1]
  ret, view_str = Dump_get_view(userPram, timeOut)
  if ret ~= -1 then
    ret = 0
  end
  DebugLogId(string.format("??????????: ret = %s\ttext = %s", ret, view_str))
  if ocrTflg and ocrTflg ~= "" then
    recOcrTime(ocrTflg, 0, view_str, 0)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_CaptureOcr(posPram, ocrTflg)
  local ret = 0
  local startclock = GetAPI_OsClock()
  local function matchPic(picPram, pic_path)
    DebugLogId(string.format("%s: %s", picPram, pic_path))
    local pic_name
    if picPram and picPram:match("%d+_%d+_%d+_%d+") then
      local tmptb = {}
      for k in picPram:gmatch("%d+") do
        table.insert(tmptb, k)
      end
      local tmpx1, tmpx2, tmpy1, tmpy2 = tmptb[1], tmptb[2], tmptb[3], tmptb[4]
      local TempTime = os.date("%Y%m%d%H%M%S")
      local tmpclock = os.time()
      if G_EngineMode == "Android" then
        pic_name = string.format("%s_%s_%s_%s_CapturePic.bmp", tmpx1, tmpx2, tmpy1, tmpy2)
        DebugLogId("Android.pic_name" .. pic_name)
        GetAPI_CaptureRectangle(pic_path .. pic_name)
      else
        pic_name = string.format("%s_%s_%s_%s_CapturePic.png", tmpx1, tmpx2, tmpy1, tmpy2)
        GetAPI_CaptureRectangle(pic_path .. pic_name, tmpx1, tmpx2, tmpy1, tmpy2)
      end
    end
    return pic_name, tmpclock, TempTime
  end
  local pic_path = string.format("%s%s", string.sub(G_SysDbgPath, 1, -2), G_Pflg)
  local pictxt
  if posPram:match("???????") then
    local pic_name = matchPic(ocrTflg, pic_path)
    if pic_name then
      pictxt = cjy_ScorePic(pic_path .. pic_name)
      G_Captcha = pictxt
      GetAPI_Deletefile(pic_path .. pic_name)
    end
  else
    local pic_name, tmpclock, TempTime = matchPic(posPram, pic_path)
    local all_pic = pic_path .. pic_name
    pictxt = mgpic_Ocrhttps(all_pic)
    if ocrTflg and ocrTflg:match("regex") then
      local regexs = ocrTflg:match("regex.-(%b'')") or ""
      regexs = regexs:sub(2, -2)
      local check_txt = ""
      if ocrTflg:match("check") then
        check_txt = ocrTflg:match("check.-(%b'')") or ""
        check_txt = check_txt:sub(2, -2)
      else
        if G_INIContList then
          DebugLogId(string.format("G_INIContList : %s", G_INIContList[1] or "nil"))
        end
        check_txt = SCRIPT_VIEW_VALUE or ""
      end
      DebugLogId(string.format("check.regex(%s) : %s\t%s", regexs, check_txt, pictxt))
      if regexs == "A==B" then
        ret = tostring(pictxt) == tostring(check_txt) and 0 or -1
      elseif regexs == "A!=B" then
        ret = tostring(pictxt) == tostring(check_txt) and -1 or 0
      elseif regexs ~= "" then
        DebugLogId(string.format("regex format error, ret = 0 : %s", regexs))
        ret = 0
      end
      DebugLogId(string.format("check.result : %s", ret))
    else
      if pictxt == 0 then
        DebugLogId(string.format("PIC OCR FALSE !!!\t%s", all_pic))
        ret = -1
      end
      if ocrTflg and ocrTflg ~= "" then
        recOcrTime(ocrTflg, TempTime, pictxt, tmpclock)
      else
        SCRIPT_VIEW_VALUE = pictxt
        DebugLogId(string.format("??OCR???,????????!\t%s", SCRIPT_VIEW_VALUE))
      end
    end
    local voc_pic = string.format("hzys_%s%s_%s", TempTime or "", GetVoucTale(G_Id), pic_name)
    CopyFile(all_pic, pic_path .. voc_pic)
    CopyFile(all_pic, G_SysScpPath .. G_Pflg .. voc_pic)
    GetAPI_Deletefile(all_pic)
    G_CaptureImg = voc_pic
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto_capture")
  table.insert(ResultTable, DelayTime)
  table.insert(ResultTable, pictxt)
  return ret, ResultTable, pictxt
end
function Method_DiffOcr(diflg)
  local ret, index = 0, 1
  local logflg = function(flg)
    DebugLogId("?? mg ???????")
    if flg == "A" then
      DebugLogId(table.concat(G_mgScriptFlg.A, "\t"))
      return G_mgScriptFlg.A
    end
    if flg == "B" then
      DebugLogId(table.concat(G_mgScriptFlg.B, "\t"))
      return G_mgScriptFlg.B
    end
    if flg == "C" then
      DebugLogId(table.concat(G_mgScriptFlg.C, "\t"))
      return G_mgScriptFlg.C
    end
    if flg == "D" then
      DebugLogId(table.concat(G_mgScriptFlg.D, "\t"))
      return G_mgScriptFlg.D
    end
  end
  local minTsec = function(TMS)
    local getSims = function(Timer)
      local _, ts = Timer:gsub(":", "")
      if ts == 1 then
        return 60
      elseif ts == 2 then
        return 3600
      else
        return 1
      end
    end
    local st1 = TMS:match("%d+") or 1
    local rc = getSims(TMS)
    local MTime = tonumber(st1) * getSims(TMS)
    local st2 = TMS:match(":(%d+)") or 1
    return MTime + tonumber(st2)
  end
  local startclock = GetAPI_OsClock()
  local mgDiFlg = splittable(diflg, "-")
  local mgTimetb_B = logflg(mgDiFlg[1])
  local mgTimetb_A = logflg(mgDiFlg[2])
  local ocrT1 = mgTimetb_A[3]
  local ocrT2 = mgTimetb_B[3]
  local picT1 = mgTimetb_A[4]
  local picT2 = mgTimetb_B[4]
  local sTimer = minTsec(ocrT1)
  local eTimer = minTsec(ocrT2)
  local DelayValue = eTimer - sTimer - (picT2 - picT1) or 0.1
  DelayValue = math.abs(DelayValue)
  local endclock = GetAPI_OsClock()
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayValue)
  return ret, ResultTable, index
end
function Method_readini(strCommand, strCommandImg, numflag)
  local ret = -1
  local index = 0
  local inilist, iniall = Readini(strCommand)
  local comcontent
  local startclock = GetAPI_OsClock()
  if numflag == 0 then
    comcontent = iniall
  elseif tonumber(numflag) > #inilist then
    DebugLogId("???????????<<" .. tostring(numflag) .. ">>??????????????<<" .. tostring(#inilist) .. ">>", "???????")
  else
    comcontent = inilist[tonumber(numflag)]
  end
  local ImgsTab = splittable(strCommandImg, "|")
  for idx, CompImage in pairs(ImgsTab) do
    if CompImage == comcontent then
      index = idx
      ret = 0
      break
    end
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, index
end
function Readini(filepath)
  local fileini = io.open(filepath, "r")
  local list = {}
  local element
  if fileini then
    line = fileini:read("*l")
    if line then
      list = splittable(line, "\t")
    end
  else
    DebugLogId("????????°§???????????????ß’??????")
  end
  fileini:close()
  fileini2 = io.open(filepath, "r")
  element = fileini2:read("*l")
  fileini2:close()
  return list, element
end
function Method_FlowCalculation(Process, FileSize, CalFlag)
  local ret = 0
  local DLFlow, ULFlow, DLFlowex, ULFlowex = 0, 0, 0, 0
  local cpu, memory = 0, 0
  local cpu_aver, memory_aver = 0, 0
  local FileName, fcpu, fmemory, allULFlow, allDLFlow
  Process = string.gsub(Process, " ", "")
  if CalFlag == 0 then
    FileName = os.date("%Y%m%d%H%M%S") .. ".txt"
    table.insert(G_CaptureTab, FileName)
    G_FileName = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. FileName
    GetAPI_perf_monitor(G_FileName, Process, CalFlag)
    if not File_Exists(G_FileName) then
      local file = io.open(G_FileName, "a")
      file:close()
      DebugLogId("????????????????,???????!")
    end
    DebugLogId("???????????,???????°§??:" .. G_FileName)
  elseif G_FileName then
    DebugLogId("???????????,???????°§??:" .. G_FileName)
    GetAPI_perf_monitor(G_FileName, Process, CalFlag)
    GetAPI_Sleep(2)
    ret, cpu, memory, DLFlow, ULFlow, fcpu, fmemory, allULFlow, allDLFlow, cpu_aver, memory_aver = Method_FlowCalculationEx(G_FileName, Process)
    G_FileName = nil
  else
    DebugLogId("¶ƒ?????????????...")
    ret = 1
  end
  if FileSize and FileSize ~= "" and tonumber(FileSize) then
    DLFlowex = DecPoint(100 * tonumber(DLFlow) / tonumber(FileSize))
    ULFlowex = DecPoint(100 * tonumber(ULFlow) / tonumber(FileSize))
    DLFlowex = DLFlowex / 100
    ULFlowex = ULFlowex / 100
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, cpu)
  table.insert(ResultTable, memory)
  table.insert(ResultTable, DLFlow)
  table.insert(ResultTable, ULFlow)
  table.insert(ResultTable, DLFlowex)
  table.insert(ResultTable, ULFlowex)
  table.insert(ResultTable, cpu_aver)
  table.insert(ResultTable, memory_aver)
  table.insert(ResultTable, allDLFlow)
  table.insert(ResultTable, allULFlow)
  return ret, ResultTable
end
function Method_FlowCalculationEx(G_FileName, Process)
  local ret, cpu, memory, DLFlow, ULFlow, allDLFlow, allULFlow = 1, 0, 0, 0, 0, 0, 0
  local count, cpuT, MemoryT = 0, 0, 0
  local filetab, upfl, dlfl, allupfl, alldlfl, temptab, allmemory
  local fcpu, fmemory = 0, 0
  local fcpuT, fmemoryT = 0, 0
  local memory_aver, cpu_aver = 0, 0
  filetab = ReadFileToTable(G_FileName)
  if #filetab > 0 then
    for i = 1, #filetab do
      if string.find(filetab[i], Process) then
        temptab = splittable(filetab[i], " ")
        if tonumber(temptab[4]) > 100 then
          temptab[4] = 0
        end
        if 100 < tonumber(temptab[5]) then
          temptab[5] = 0
        end
        cpuT = cpuT + tonumber(temptab[4])
        MemoryT = MemoryT + tonumber(temptab[5])
        count = count + 1
        cpu = FindMax(temptab[4], cpu)
        memory = FindMax(temptab[5], memory)
        DebugLogId("cpu=" .. cpu .. ",memory=" .. memory)
        upfl = upfl or temptab[6]
        dlfl = dlfl or temptab[7]
        ULFlow = tonumber(temptab[6]) - tonumber(upfl)
        DLFlow = tonumber(temptab[7]) - tonumber(dlfl)
      elseif string.find(filetab[i], "real") then
        temptab = splittable(filetab[i], " ")
        if 100 < tonumber(temptab[3]) then
          temptab[3] = 0
        end
        if tonumber(temptab[4]) > 100 then
          temptab[4] = 0
        end
        allupfl = allupfl or temptab[7]
        alldlfl = alldlfl or temptab[8]
        allULFlow = tonumber(temptab[7]) - tonumber(allupfl)
        allDLFlow = tonumber(temptab[8]) - tonumber(alldlfl)
        fcpu = FindMax(temptab[3], fcpu)
        fcpu = fcpu / 100
        fmemory = FindMax(temptab[4], fmemory)
        allmemory = GetAPI_GetMemInfo()
        fmemory = allmemory * fmemory / 100
        DebugLogId("??cpu=" .. fcpu .. ",??memory=" .. fmemory .. ",??????????:" .. allULFlow .. ",??????????:" .. allDLFlow)
      end
    end
    if count ~= 0 then
      memory_aver = MemoryT / count
      cpu_aver = cpuT / count
    end
    allmemory = GetAPI_GetMemInfo()
    memory = DecPoint(allmemory * memory / 100)
    memory_aver = DecPoint(allmemory * memory_aver / 100)
    cpu = cpu / 100
    cpu_aver = cpu_aver / 100
    DebugLogId("?????????:cpu??°¬??:" .. cpu .. "*100%,CPU???????:" .. cpu_aver .. "*100%,?????°¬??:" .. memory .. "KB,??????????:" .. memory_aver .. "KB,????????:" .. ULFlow .. "KB,????????:" .. DLFlow .. "KB")
    if memory > 0 or cpu > 0 or ULFlow > 0 or DLFlow > 0 then
      ret = 0
    end
  else
    DebugLogId("?????????...")
  end
  ReorganizationFlowDocument(G_FileName, allmemory)
  return ret, cpu, memory, DLFlow, ULFlow, fcpu, fmemory, allULFlow, allDLFlow, cpu_aver, memory_aver
end
function ReorganizationFlowDocument(fileName, allmemory)
  local tmp_table = ReadFileToTable(fileName)
  local str_ret = ""
  for i = 1, #tmp_table do
    tmp_table_x = splittable(tmp_table[i], " ")
    if tmp_table_x[1] == "app" then
      tmp_table_x[5] = tostring(DecPoint(tonumber(tmp_table_x[5]) * tonumber(allmemory) / 100))
    elseif tmp_table_x[1] == "real" then
      tmp_table_x[4] = tostring(DecPoint(tonumber(tmp_table_x[4]) * tonumber(allmemory) / 100))
    end
    for j = 1, #tmp_table_x do
      str_ret = str_ret .. tmp_table_x[j] .. " "
    end
    str_ret = str_ret .. "\n"
  end
  file = io.open(fileName, "w")
  file:write(str_ret)
  file:close()
end
function Method_AdbCommand(command, imgs, paraflag1)
  local DelayTime, value
  local ret = 0
  local picidx = 0
  local TimeOut = G_timeOut
  if command == "" then
    ret = 1
    DebugLogId("???????????...", "???????")
  else
    DebugLogId("?????????:" .. command)
    if string.find(command, "&&") then
      GetAPI_CommandEx(command)
      value = ""
    else
      value = GetAPI_Command(command)
      DebugLogId("adb???????:" .. tostring(value))
    end
    if string.find(value, "result:(%w+)") then
      _, _, G_Captcha = string.find(value, "result:(%w+)")
      DebugLogId("??????????:" .. G_Captcha)
    end
  end
  local stime = GetAPI_OsClock()
  if imgs == "" then
    print("No pic compare")
  else
    CompImgTab = splittable(imgs, ",")
    if CompImgTab[2] and tonumber(CompImgTab[2]) then
      TimeOut = tonumber(CompImgTab[2])
    end
    ret, picidx = CheckActionResults(CompImgTab[1], TimeOut)
  end
  local etime = GetAPI_OsClock()
  DelayTime = GetAPI_SubTime(etime, stime)
  DebugLogId("command?????????" .. DelayTime)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_AdbVersion(package_name, imgs, paraflag1)
  local version
  local client_name = package_name
  local value
  local ret = 1
  local picidx = 0
  local ResultTable = {"auto"}
  local stime = GetAPI_OsClock()
  if command == "" then
    ret = 1
    DebugLogId("??????????...", "???????")
  else
    DebugLogId("????????∑⁄???????????:" .. package_name)
    value = GetAPI_Command("dumpsys package " .. package_name)
    package_name = string.gsub(package_name, "%.", "%%.")
    local _, _, ret_pack = string.find(value, "Package *%[ *" .. package_name .. " *%](.+)")
    if ret_pack then
      value_change = string.gsub(ret_pack, "\r", "\n")
      _, _, version = string.find(value_change, [[
versionName=([^
]+)]])
      if version then
        DebugLogId("?????∑⁄:" .. version)
        if imgs == version then
          ret = 0
        else
          DebugLogId("?????∑⁄????????????????∑⁄???" .. imgs .. ",?????????∑⁄???" .. version)
          ret = 1
        end
      else
        DebugLogId("????????????" .. client_name .. "???????¶ƒ?????????")
      end
    else
      DebugLogId("????????????" .. client_name .. "???????¶ƒ?????????")
    end
  end
  local etime = GetAPI_OsClock()
  DelayTime = GetAPI_SubTime(etime, stime)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Performance(testps, testmode, testtime)
  local ret, cpuret, memoryret
  local stime = GetAPI_OsClock()
  ret, memoryret, cpuret = Method_PerformanceEx(testps, testmode, testtime)
  cpuret = cpuret / 100
  DebugLogId("???¶¬???????:" .. memoryret .. ",CPU?:" .. cpuret)
  local etime = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(etime, stime)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  table.insert(ResultTable, "")
  table.insert(ResultTable, memoryret)
  table.insert(ResultTable, cpuret)
  return ret, ResultTable
end
function Method_PerformanceEx(testps, testmode, testtime)
  local ret = 0
  local cpumode, memorymode, startt, endt, ret1, ret2
  local max1 = 0
  local max2 = 0
  if testps == "" then
    ret = 1
  else
    DebugLogId("?????????????...")
    if string.find(testmode, "CPU") then
      cpumode = true
    end
    if string.find(testmode, "memory") then
      memorymode = true
    end
    startt = GetAPI_OsClock()
    while true do
      endt = GetAPI_OsClock()
      if GetAPI_SubTime(endt, startt) > tonumber(testtime) then
        break
      end
      if cpumode then
        ret1 = GetAPI_GetProcCpuPercent(testps)
        if max1 < ret1 then
          max1 = ret1
        end
      end
      if memorymode then
        ret2 = GetAPI_GetProcMemInfo(testps)
        if max2 < ret2 then
          max2 = ret2
        end
      end
      GetAPI_Sleep(5)
    end
    DebugLogId("??????????????...")
  end
  if memorymode and max2 == 0 then
    ret = 1
  end
  return ret, max2, max1
end
function Method_modifyfile(path)
  local ret
  local startclock = GetAPI_OsClock()
  local filein = io.open(path, "rb")
  local element = filein:read("*all")
  local randomstring = randomnum(1000000000, 9999999999)
  filein:close()
  local SecondFileElement = string.sub(element, 11, -1)
  local NewFileContect = randomstring .. SecondFileElement
  local fileout = io.open(path, "wb")
  fileout:write(NewFileContect)
  fileout:close()
  local endclock = GetAPI_OsClock()
  if element ~= NewFileContect then
    ret = 0
  else
    ret = -1
  end
  local ResultTable = {}
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_RemoveCache(process, times, FlowStep)
  local ret = 0
  local startclock = GetAPI_OsClock()
  Method_RemoveCacheEx(process)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_RemoveCacheEx(process)
  local j, i
  local DeletePathtab = {}
  if string.find(process, "/") then
    DeletePathtab = splittable(process, "|")
  elseif G_EngineMode == "IOS" then
    DebugLogId("???¶ƒ???...")
  else
    table.insert(DeletePathtab, "/data/data/" .. process .. "/cache")
    table.insert(DeletePathtab, "/mnt/sdcard/android/data/" .. process .. "/cache")
  end
  for j = 1, 3 do
    for j = 1, #DeletePathtab do
      DebugLogId("?????:" .. DeletePathtab[j])
      GetAPI_DeleteDir(DeletePathtab[j])
      GetAPI_Sleep(1)
    end
  end
end
function Method_PACKET(CapRole, CapName, paraflag1)
  local ret = 0
  local picidx, res, path
  local PacketPath = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. CapName .. ".pcap"
  DebugLogId("????°§????" .. PacketPath)
  CapRole = Strip(CapRole)
  if G_EngineMode ~= "IOS" then
    path = "/data/data/com.autosense/files/ser/commandd /data/data/com.autosense/files/ser/tcpdump"
    if paraflag1 == 0 then
      if CapRole == "" then
        DebugLogId("????" .. path .. " tcpdump -X -i any -p -s 0 -vv -w " .. PacketPath)
        _cfunc.Command("su\n" .. path .. " tcpdump -X -i any -p -s 0 -vv -w " .. PacketPath .. [[

exit]])
      else
        _cfunc.Command("su\n" .. path .. " tcpdump " .. CapRole .. " " .. PacketPath .. [[

exit]])
      end
      _cfunc.Command("su\n" .. "chmod 777 " .. string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. CapName .. ".pcap" .. [[

exit]])
      table.insert(G_packet, CapName .. ".pcap")
      G_package_name = CapName .. ".pcap"
      G_packetflag = true
    else
      DebugLogId("???????")
      picidx = GetAPI_KillProcess("tcpdump")
      G_packetflag = false
    end
  else
    print("ios????¶…???")
    ret = -1
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, 0)
  return ret, ResultTable, picidx
end
function Method_get_http_info(strCommand, strCommandImg, flag, retitle)
  local picidx, ret = 0, 0
  local path1 = "/mnt/sdcard/packet.log"
  local path2 = "/mnt/sdcard/packet_log.txt"
  local table_ret = {}
  if flag == 1 then
    file = io.open(path1, "w")
    file:close()
    file = io.open(path2, "w")
    file:write("G_PackageName\tTitle\tServersIp\tMethod\tTime_Visit\tRequestHeadSize\tRequestBodySize\tTimeTotal\tDNS\tTIP\tFirstPacketTime\tSSlTime\tCode\tResponseHeadSize\tResponseBodySize\tURL\n")
    file:close()
  elseif flag == 2 then
    file = io.open(path1, "w")
    file:close()
  else
    local content = ReadPlogToTable(path1)
    file = io.open(path2, "a")
    for i, j in pairs(content) do
      local ress, URL, method, time_visit, requestHeadSize, requestBodySize, TimeTotal, dns, TIP, FirstPacketTime, sslTime, responseHeadSize, responseBodySize, serversIp, code, PackageName = pcall(Method_get_http_info_Ex, j)
      if ress and G_PackageName == PackageName then
        file:write(G_PackageName .. "\t" .. retitle .. "\t" .. serversIp .. "\t" .. method .. "\t" .. time_visit .. "\t" .. requestHeadSize .. "\t" .. requestBodySize .. "\t" .. TimeTotal .. "\t" .. dns .. "\t" .. TIP .. "\t" .. FirstPacketTime .. "\t" .. sslTime .. "\t" .. code .. "\t" .. responseHeadSize .. "\t" .. responseBodySize .. "\t" .. URL .. "\n")
      end
    end
    file:close()
  end
end
function Method_get_http_info_Ex(j)
  local _, _, ele = string.find(j, "\"overview\":%[(.-)\"%],")
  local start_num, end_num, URL = string.find(ele, "\"(.-)\"")
  local next_ele = string.sub(ele, end_num, -1)
  local tmp_table = _xsplit(next_ele, ",")
  local method = string.gsub(tmp_table[2], "\"", "")
  local time_visit = string.gsub(tmp_table[3], "\"", "")
  local requestHeadSize = string.gsub(tmp_table[4], "\"", "")
  local requestBodySize = string.gsub(tmp_table[5], "\"", "")
  local TimeTotal = string.gsub(tmp_table[6], "\"", "")
  local dns = string.gsub(tmp_table[7], "\"", "")
  local TIP = string.gsub(tmp_table[8], "\"", "")
  local FirstPacketTime = string.gsub(tmp_table[9], "\"", "")
  local sslTime = string.gsub(tmp_table[10], "\"", "")
  local responseHeadSize = string.gsub(tmp_table[12], "\"", "")
  local responseBodySize = string.gsub(tmp_table[13], "\"", "")
  local serversIp = string.gsub(tmp_table[14], "\"", "")
  local code = string.gsub(tmp_table[11], "\"", "")
  local _, _, PackageName = string.find(j, "PackageName\":\"(.-)\"")
  PackageName = PackageName or "nil"
  return URL, method, time_visit, requestHeadSize, requestBodySize, TimeTotal, dns, TIP, FirstPacketTime, sslTime, responseHeadSize, responseBodySize, serversIp, code, PackageName
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
function Method_get_http_info_ex_old(tab, path, retitle)
  file = io.open(path, "a")
  DebugLogId("???????")
  for i, j in pairs(tab) do
    local _, _, URL = string.find(j, "\"URL\":\"(.-)\"")
    local _, _, PackageName = string.find(j, "\"PackageName\":\"(.-)\"")
    local localHost = GetAPI_DeviceIP()
    local _, _, ServerIpAddress = string.find(j, "\"ServerIpAddress\":\"(.-)\"")
    local _, _, Method = string.find(j, "\"Method\":\"(.-)\"")
    local _, _, Size = string.find(j, "\"Size\":\"(.-)\"")
    local _, _, TotalTime = string.find(j, "\"TotalTime\":\"(.-)\"")
    local _, _, Code = string.find(j, "\"Code\":\"(.-)\"")
    if PackageName == nil then
      PackageName = "nil"
    end
    if ServerIpAddress == nil then
      ServerIpAddress = "nil"
    end
    if Method == nil then
      Method = "nil"
    end
    if Size == nil then
      Size = "nil"
    end
    if TotalTime == nil then
      TotalTime = "nil"
    end
    file:write(PackageName .. "\t" .. localHost .. "\t" .. ServerIpAddress .. "\t" .. Method .. "\t" .. Size .. "\t" .. TotalTime .. "\t" .. Code .. "\t" .. URL .. "\n")
  end
  file:close()
end
function GetAPI_getHttpInfo(tab, strCommand, strCommandImg)
  local table_ret = {}
  local table_ip = {}
  for i, j in pairs(tab) do
    local _, _, url = string.find(j, "\"URL\":\"(.-)\"")
    local _, _, packageName = string.find(j, "\"PackageName\":\"(.-)\"")
    local strCommand_table = splittable(strCommand, "|")
    if comTabtoStr(url, strCommand_table) and packageName ~= strCommandImg then
      table.insert(table_ret, j)
      local _, _, ServerIpAddress = string.find(j, "\"ServerIpAddress\":\"(.-)\"")
      if ServerIpAddress ~= nil then
        table.insert(table_ip, ServerIpAddress)
      end
    elseif packageName == strCommandImg then
      table.insert(table_ret, j)
      local _, _, ServerIpAddress = string.find(j, "\"ServerIpAddress\":\"(.-)\"")
      if ServerIpAddress ~= nil then
        table.insert(table_ip, ServerIpAddress)
      end
    end
  end
  for i, j in pairs(tab) do
    if comTabtoStr(url, table_ip) then
      table.insert(table_ret, j)
    end
  end
  return table_ret
end
function Method_getview(strCommand, strCommandImg, TimeOut)
  local ret, picidx = 0, 0
  local first_time = 0
  local view_str = ""
  local startclock = GetAPI_OsClock()
  if strCommand and strCommand ~= "" then
    ret, first_time = Method_ClickPubEx(strCommand)
  end
  if ret == 0 then
    ret, picidx, view_str = Method_getviewEx(strCommandImg, TimeOut)
    G_view = view_str
    DebugLogId("???????????G_view:" .. G_view)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  table.insert(ResultTable, view_str)
  return ret, ResultTable, picidx
end
function Method_GetTime()
  local ret = 0
  local startclock = GetAPI_OsClock()
  G_GetTime = os.time()
  DebugLogId("?????????" .. os.date("%Y-%m-%d %H:%M:%S", G_GetTime) .. "????????????" .. G_GetTime)
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_EngineUpdate(udurl, udmode, FlowStep)
  local ret
  local startclock = GetAPI_OsClock()
  DebugLogId("??????????...")
  ret = Method_EngineUpdateEx(udurl, udmode)
  DebugLogId("??????????...")
  local endclock = GetAPI_OsClock()
  local ActionEndTime = os.date("%Y-%m-%d %H:%M:%S")
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  if ret ~= 0 then
    G_GlbVocMsg = GetGVM("????(ENGINEUD)???,??????????:%s", {ret})
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_FileUpdate(udurl, udmode, FlowStep)
  local ret
  local startclock = GetAPI_OsClock()
  if not udmode or udmode == "" then
    ret = -1
  else
    DebugLogId("??????????...")
    ret = Method_FileUpdateEx(udurl, udmode)
    DebugLogId("??????????...")
  end
  local endclock = GetAPI_OsClock()
  local ActionEndTime = os.date("%Y-%m-%d %H:%M:%S")
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  if ret ~= 0 then
    G_GlbVocMsg = GetGVM("????(FileUD)???,??????????:%s", {ret})
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_EngineUpdateEx(source, goal)
  local ret
  source = source or "BasicEngine.lua"
  local UDpath = G_SysScpPath .. "/" .. source
  local ENpath
  if G_EngineMode == "Android" then
    ENpath = "/data/local/tmp/c/engine/" .. source
  elseif G_EngineMode == "IOS" then
    ENpath = "/usr/local/lib/lua/5.1/" .. source
  end
  ret = CopyFile(UDpath, ENpath)
  return ret
end
function Method_FileUpdateEx(source, goal)
  local ret, UDpath
  local ENpath = goal
  local FLpath = string.match(ENpath, "(.+)/[^/]*%.%w+$")
  if string.find(source, "/") then
    UDpath = source
  else
    UDpath = G_SysScpPath .. "/" .. source
  end
  if not File_Exists(FLpath) then
    os.execute(string.format("mkdir -p %s", FLpath))
    DebugLogId("???????ß”?????,????????????:" .. FLpath)
  end
  ret = CopyFile(UDpath, ENpath)
  return ret
end
local richfram = ZXYXDSZ:_new()
function richfram:Infofname(lpath)
  local iofnstb = getPathFiles(lpath, "ltr")
  for k, v in pairs(iofnstb) do
    if v:match("%.txt") then
      local fname = v:reverse():match("(.-)%s")
      self.ftxtname = fname:reverse() or nil
      break
    end
  end
end
function richfram:InfoMain()
  local richfp = "/storage/emulated/0/richinfodata"
  self:Infofname(richfp)
  local newftxt = self.ftxtname and string.format("%s/%s", richfp, self.ftxtname)
  if newftxt then
    DebugLogId(string.format("rich info ???: %s", newftxt))
  else
    DebugLogId(string.format("¶ƒ???? richinfo ??????? ??????"))
    local relog = _cfunc.Command("ls -l " .. richfp)
    DebugLogId("richinfodata ????????? ??\n" .. relog)
    return
  end
  local lfpname = "/mnt/sdcard/RecordPerformanceInfo/richinfo.txt"
  _cfunc.Command(string.format("cp %s %s", newftxt, lfpname))
  DebugLogId(string.format("???rich???????: %s", lfpname))
end
function Method_PerformanceManager(seflg, psname)
  local ret, picidx = 0, 0
  if G_EngineMode ~= "IOS" then
    local fpath = "/mnt/sdcard/RecordPerformanceInfo/"
    if seflg == "start" then
      psname = psname or ""
      if psname == "" then
        DebugLogId("??????? ????????????")
        return
      end
      G_Perfsflag = true
      local fname = string.format("perfs_%s.csv", psname:match("%w+", 4) or psname, os.time())
      ExecScriptJava("PerformanceManager:getInstance():stopRecordPerformanceInfo", "")
      _cfunc.Command(string.format("mkdir -p %s", fpath))
      DebugLogId(string.format("???????????: %s\t???????°§??:%s%s", psname, fpath, fname))
      local perfPram = string.format("\"%s\", \"%s\",\"%s\"", psname, fpath, fname)
      ExecScriptJava("PerformanceManager:getInstance():startRecordPerformanceInfo", perfPram)
      local relog = _cfunc.Command("ls -l " .. fpath)
      DebugLogId("?????????????????.start:\n" .. relog)
    else
      richfram:InfoMain()
      DebugLogId(string.format("???????????, ???????°§??:%s", fpath))
      ExecScriptJava("PerformanceManager:getInstance():stopRecordPerformanceInfo", "")
      _cfunc.Sleep(3000)
      local relog = _cfunc.Command("ls -l " .. fpath)
      DebugLogId("?????????????????.end??\n" .. relog)
      local pmfiles = getPathFiles(fpath)
      if #pmfiles > 0 then
        _cfunc.Command(string.format("mkdir -p %sperfs", G_SysDbgPath))
        for k, v in pairs(pmfiles) do
          if string.find(v, "csv") or string.find(v, "txt") then
            local fpname = string.format("%s%s", fpath, v)
            local lfpname = string.format("%sperfs/%s", G_SysDbgPath, v)
            _cfunc.Command(string.format("cp %s %s", fpname, lfpname))
            DebugLogId(string.format("????????????: %s", lfpname))
          end
        end
        GetAPI_DeleteDir(fpath)
        _cfunc.Command("rm -rf " .. fpath)
      end
    end
  else
    print("ios????¶…???")
    ret = -1
  end
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, 0)
  return ret, ResultTable, picidx
end
function Method_UUHTTP(urlstr, pramvalue)
  local ret, picidx = 0, 1
  local times = 1
  local hturltab, hturl, httype
  local startclock = GetAPI_OsClock()
  hturltab = splittable(urlstr, ",")
  hturl = hturltab[1]
  if hturltab[3] then
    times = tonumber(hturltab[3])
    httype = hturltab[2]
  elseif hturltab[2] then
    if tonumber(hturltab[2]) then
      times = tonumber(hturltab[2])
      httype = "get"
    else
      httype = hturltab[2]
    end
  else
    httype = "get"
  end
  local pramStr = ""
  local pramType = ""
  if httype == "get" then
    pramStr = pramvalue:match("%b{}"):sub(2, -2) or ""
    pramType = "text"
  else
    pramStr = pramvalue:match("%b{}"):sub(2, -2) or ""
    pramType = pramvalue:match("(.-):{")
  end
  local regexs = pramvalue:match("regex:{(.*)}") or "???ßµ?????"
  if urlstr:match("http") then
    for i = 1, times do
      ret = UU_HttpMain(hturl, httype, pramStr, pramType, regexs) or 0
      if ret == 0 then
        DebugLogId(string.format("??%s??UUHTTP??????", i))
        break
      elseif i == times then
        DebugLogId(string.format("??%s??UUHTTP???????,?????????????", i))
      else
        DebugLogId(string.format("??%s??UUHTTP???????,1??????", i))
        GetAPI_Sleep(1)
      end
    end
  else
    DebugLogId("????URL???????,????......")
    ret = -1
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function MGMethod_HTTP(cmddurl, scvalue)
  local srcpath = "/data/local/tmp/c/mode"
  local json = dofile(string.format("%s/%s", srcpath, "dkjson.lua"))
  local ret, picidx = 0, 1
  local startclock = GetAPI_OsClock()
  if scvalue:match("regex") and cmddurl:match("http") then
    ret = mgkv_HttpMain(cmddurl, scvalue) or 0
  else
    ret = -1
  end
  DebugLogId(string.format("MGHTTP.mgkv_HttpMain: %s", ret))
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function MGMethod_TCPDUMP(dumpCmd, jsonIni)
  local ret, picidx = 0, 1
  local process_keys = function(jsonkey)
    local keystb = {}
    for k, v in jsonkey:gmatch(",?(.-):'(.-)'") do
      keystb[k:lower()] = v
    end
    return keystb
  end
  local startclock = GetAPI_OsClock()
  dumpCmd = dumpCmd:match("%b{}") and dumpCmd:match("%b{}"):sub(2, -2) or nil
  local strImg = jsonIni:sub("-5")
  local timeOut = strImg and strImg:match(",(%d+)") or G_timeOut
  jsonIni = jsonIni:match("%b{}") and jsonIni:match("%b{}"):sub(2, -2) or nil
  if jsonIni and jsonIni:match("client") or dumpCmd and dumpCmd:match("regex") then
    DebugLogId(string.format("MGHTTP.jsonInis: %s.", tostring(jsonIni)))
    DebugLogId(string.format("MGHTTP.dumpCmd: %s", tostring(dumpCmd)))
    local fname = "/sdcard/video_dump.txt"
    local dumpUserIni = {}
    if jsonIni then
      local jsonInitb = process_keys(jsonIni)
      for k, v in pairs(jsonInitb) do
        dumpUserIni[k] = v
      end
    end
    if dumpCmd then
      local dumpCmdtb = process_keys(dumpCmd)
      for k, v in pairs(dumpCmdtb) do
        dumpUserIni[k] = v
      end
    end
    if dumpUserIni.regex then
      ret = MgMain_TcpDump(dumpUserIni, fname, timeOut) or 0
    elseif dumpUserIni.client then
      DebugLogId(string.format("MgMain.timeOut: %s", timeOut))
      local clients = lower(dumpUserIni.client)
      if clients == "mg" or clients == "tx" or clients == "yk" or clients == "aqy" then
        ret = MgMain_TcpDump(dumpUserIni, fname, timeOut) or 0
      else
        DebugLogId(string.format("?????????????????? %s", clients))
        ret = -1
      end
    else
      local errtmp = "\t\t\t--java api\n\t\t\t{\"[1],[MGDUMP],[{regex:'.ts?'}],[],[????tcpdump?ß›??url????]\"},\n\t\t\t{\"[1],[TOUCH],[500,500],[],[???????]\"},\t  \n\t\t\t{\"[1],[MGDUMP],[],[{client:'mg',name:'???????',type:'ts',resolution:'1080'},80],[????tcpdump?ß›??url??????]\"},\n\t\t\t--??????°¬???\n\t\t\t{\"[1],[MGDUMP],[{regex:''}],[],[????tcpdump?ß›??url????]\"},\n\t\t\t{\"[1],[TOUCH],[500,500],[],[???????]\"},\t  \n\t\t\t{\"[1],[MGDUMP],[{regex:'.ts?',extra:'m'}],[{client:'tx',name:'txds',type:'ts',resolution:'1080',cut:'00:10:00-00:20:00'},400],[????tcpdump?ß›??url??????]\"},\n\t\t\t"
      DebugLogId(string.format("?????????¶œ???????°¬???? \n%s", errtmp))
      ret = -1
    end
  else
    ret = -1
  end
  DebugLogId(string.format("MGHTTP.mgwh_DumpMain: %s", ret))
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_ShowHow(randomV, Testime)
  local ret, picidx = 0, 1
  local startclock = GetAPI_OsClock()
  local sradm = randomV:match("%d+") or 2
  local eradm = randomV:match(",(%d+)") or 10
  local val = randomV:match(",%d+,(%d+%.?[%d+]?)") or 1
  local Tvalues = math.random(sradm, eradm) / 1000 + math.random(sradm, eradm) / 100 + math.random(sradm, eradm) / 10 + val
  Testime = Testime or 1.86
  DebugLogId(string.format("random: %s\t%s\t%s", sradm, eradm, val))
  GetAPI_Sleep(Testime)
  local endclock = GetAPI_OsClock()
  local DelayTime = Tvalues or GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_Interval(seflg, intrlname, logs)
  local ret, picidx = 0, 1
  local startclock = GetAPI_OsClock()
  local function upIntervalAction(actstb)
    local perfiles = string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "interval.txt"
    local perfActions = ReadFileToTable(perfiles)
    local tmpname = {}
    for k, v in pairs(perfActions) do
      local Odatatb = _xsplit(v, "\t")
      if Odatatb[2] == actstb.name and (tonumber(Odatatb[3]) == 0 or tonumber(Odatatb[4]) == 0) then
        DebugLogId(string.format("perfinfo : %s", table.concat(Odatatb, "\t")))
        Odatatb[1] = actstb.flg or Odatatb[1]
        Odatatb[2] = actstb.name or Odatatb[2]
        Odatatb[3] = tonumber(Odatatb[3]) == 0 and actstb.stime or Odatatb[3]
        Odatatb[4] = tonumber(Odatatb[4]) == 0 and actstb.etime or Odatatb[4]
        Odatatb[5] = actstb.rounds or Odatatb[5]
        Odatatb[6] = actstb.status or Odatatb[6]
        DebugLogId(string.format("  >> >>  : %s", table.concat(Odatatb, "\t")))
        perfActions[k] = table.concat(Odatatb, "\t")
        wrfile(perfiles, perfActions, "\n")
        break
      end
    end
  end
  local actstb = {}
  local rounds = G_Id:match("%d+_%d+_(%d+)")
  seflg = string.lower(seflg) or ""
  if seflg:match("start") then
    actstb.flg = "perf"
    actstb.name = intrlname
    actstb.stime = os.date("%Y-%m-%d %H:%M:%S")
  else
    actstb.name = intrlname
    actstb.etime = os.date("%Y-%m-%d %H:%M:%S")
    actstb.status = "00"
  end
  upIntervalAction(actstb)
  local endclock = GetAPI_OsClock()
  local DelayTime = Tvalues or GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Method_SCREEN(seflg, fname, logs)
  local ret, picidx = 0, 1
  local startclock = GetAPI_OsClock()
  if G_EngineMode == "Android" then
    local ver = G_Id:match("^.*_(.*)")
    if tonumber(ver:match("%d")) >= 5 then
      DebugLogId(string.format("??SCREEN??: ??%s??,[%s],[%s]%s", seflg, fname or "???????", logs or "5????1M", fname:match("%d") or ""))
      if seflg:match("start") then
        G_RSflag = true
        RecordMode = 0
        local landscape = fname:match("%d")
        GetAPI_RecordScreenManager("start", 5, _, _, 0, landscape)
      else
        GetAPI_RecordScreenManager("end")
        VoucRecordScreen("cpcp???")
      end
    else
      DebugLogId(string.format("?????????, ??????∑⁄: %s", ver))
      ret = -1
    end
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = Tvalues or GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
DevEdt = "3.0.1"
function Device_Init(G_Id, G_DeviceName, SysParms, UsrParms)
  local res, devcount
  OrderedFlag = nil
  G_ScriptStart = GetAPI_OsClock()
  res, devcount = pcall(_G[string.format("DeviceInit_%s", G_DeviceName)], G_Id, SysParms, UsrParms)
  return devcount
end
function Device_SwitchNetwork(G_DeviceName)
  local ret
  ret = pcall(_G[string.format("Device_SwitchNetwork_%s", G_DeviceName)])
end
function Device_SimpleInit()
  local devcount = 1
  G_ScriptStart = GetAPI_OsClock()
  return devcount
end
function Device_UnInit(G_Id, G_DeviceName, SysParms, UsrParms)
  pcall(_G[string.format("DeviceUnInit_%s", G_DeviceName)], G_Id, SysParms, UsrParms)
  G_ScriptEnd = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(G_ScriptEnd, G_ScriptStart)
  DebugLogId("???????????:" .. DelayTime)
end
function Device_SecondInit(G_DeviceName)
  pcall(_G[string.format("DeviceSecondInit_%s", G_DeviceName)], G_DeviceName)
  return 0
end
function Device_WAP_VisitPageAUTO(URL, URLImage, paraflag1)
  local ret, ResultTable, res, picidx
  if G_EngineMode == "IOS" then
    res, ret, ResultTable, picidx = pcall(_G[string.format("VisitPage_%sEx_AUTO", G_DeviceName)], URL, URLImage, paraflag1)
  else
    ret, ResultTable, picidx = Method_Wap_SIG(URL, URLImage, paraflag1)
  end
  return ret, ResultTable, picidx
end
function Device_OpenAPP_Auto(APPName, APPImage, paraflag1)
  local ret, ResultTable, picidx
  ret, ResultTable, picidx = Method_OpenAPPEx(APPName, APPImage, paraflag1)
  return ret, ResultTable, picidx
end
function Device_ExecuteTargetResult(APPName, APPImage, paraflag1)
  local ResultTable = {"auto", paraflag1}
  local picidx = 0
  return paraflag1, ResultTable, picidx
end
function Device_TouchsByBuffer(strCommand, strCommandImg, CompType, BuffType)
  local ret, ResultTable, picidx
  ret, ResultTable, picidx = Method_TouchsByBuffer(strCommand, strCommandImg, CompType, BuffType)
  return ret, ResultTable, picidx
end
function Device_Rate(strConnamd, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  ret, ResultTable, picidx = Method_Touchs_Rate(strConnamd, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_Interactive(strConnamd, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  ret, ResultTable, picidx = Method_Interactive(strConnamd, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_Interactive_recv(strCommand, strCommandImg, imei)
  local ret, ResultTable
  local picidx = 0
  ret, ResultTable, picidx = Method_Interactive_recv(strCommand, strCommandImg, imei)
  return ret, ResultTable, picidx
end
function Device_Input(InputContent, InputImg, paraflag1)
  local ret, res, ResultTable, is, ie
  local picidx = 0
  is, ie = string.find(InputContent, "MNUM")
  if is then
    InputContent = GetAPI_MobileNum()
  end
  is, ie = string.find(InputContent, "NTIME")
  if is then
    InputContent = GetAPI_OsClock()
  end
  if InputContent == "?????" and G_Captcha then
    InputContent = G_Captcha
    DebugLogId("?????:" .. InputContent)
  end
  ret, ResultTable, picidx = Method_Input(InputContent, InputImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_rate_url(strCommand, strCommandImg, paraflag1)
  local ret = -1
  local picidx = 0
  local startclock = GetAPI_OsClock()
  local res, file_size = pcall(GetAPI_url_down, strCommand, tonumber(strCommandImg))
  if res and file_size > 0 then
    ret = 0
  else
    ret = -1
    DebugLogId("Device_rate_url func fail : " .. file_size)
    file_size = 0
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local rate = DecPoint(file_size / DelayTime / 1024)
  local ResultTable = {
    "auto",
    DelayTime,
    rate,
    file_size,
    "rate"
  }
  G_rate_url = rate
  G_rateTime_url = DelayTime
  return ret, ResultTable, picidx
end
function Device_InputString(InputContent, InputImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  InputContent = string.find(InputContent, "MNUM") and GetAPI_MobileNum() or InputContent
  InputContent = string.find(InputContent, "NTIME") and GetAPI_OsClock() or InputContent
  if InputContent == "?????" and G_Captcha then
    InputContent = G_Captcha
    DebugLogId(string.format("?????:%s\t%s", InputContent, #InputContent))
    ret, ResultTable, picidx = Method_InputString(InputContent, InputImg, paraflag1)
  elseif InputContent == "?????" and G_Captcha then
    InputContent = G_Captcha
    DebugLogId(string.format("?????:%s\t%s", InputContent, #InputContent))
    DebugLogId("???????????")
    for j = 1, #InputContent do
      ret = GetAPI_InputString(string.sub(InputContent, j, j))
      GetAPI_Sleep(1)
    end
    ret, ResultTable, picidx = Method_InputString(string.sub(InputContent, #InputContent, #InputContent), InputImg, paraflag1)
  else
    ret, ResultTable, picidx = Method_InputString(InputContent, InputImg, paraflag1)
  end
  return ret, ResultTable, picidx
end
function Device_modifyfile(strCommand, strCommandImg, paraflag1)
  local ret
  local picidx = 0
  ret, ResultTable = Method_modifyfile(strCommand)
  return ret, ResultTable, picidx
end
function Device_Touchs(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local TimeOut = G_timeOut
  local picidx = 0
  local strImg = strCommandImg:sub("-4")
  TimeOut = strImg:match(",(%d+)") or G_timeOut
  if strImg:match(",(%d+)") or not strCommandImg then
    strCommandImg = strCommandImg:gsub(",%d+", "")
  end
  ret, ResultTable, picidx = Method_Touchs(strCommand, strCommandImg, tonumber(TimeOut))
  return ret, ResultTable, picidx
end
function Device_get_area(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  strCommandImg = ImgTmpTb[1]
  if ImgTmpTb[2] and tonumber(ImgTmpTb[2]) then
    TimeOut = tonumber(ImgTmpTb[2])
  end
  ret, ResultTable, picidx = Method_get_area(strCommand, strCommandImg, TimeOut)
  return ret, ResultTable, picidx
end
function Device_judge(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local TimeOut = G_timeOut
  local picidx = 0
  ImgTmpTb = splittable(strCommand, ",")
  strCommand = ImgTmpTb[1]
  if ImgTmpTb[2] and tonumber(ImgTmpTb[2]) then
    TimeOut = tonumber(ImgTmpTb[2])
  end
  ret, ResultTable, picidx = Method_judge(strCommand, strCommandImg, TimeOut)
  return ret, ResultTable, picidx
end
function Device_loop(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ret, ResultTable, picidx = Method_loop(strCommand, paraflag1)
  return ret, ResultTable, picidx
end
function Device_break(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ret, ResultTable, picidx = Method_break()
  return ret, ResultTable, picidx
end
function Device_pageturn(strCommand, strCommandImg, paraflag1)
  GetAPI_CaptureRectangle(G_SysScpPath .. G_Pflg .. paraflag1)
  local ret, ResultTable, picidx = Device_Touchs(strCommand, strCommandImg)
  if G_Imgtime and G_first_time then
    G_Imgtime = G_Imgtime + G_first_time
  elseif G_first_time then
    G_Imgtime = G_first_time
  end
  if G_Imgtime then
    DebugLogId("?????:" .. ResultTable[2])
    ResultTable[2] = tonumber(ResultTable[2]) - G_Imgtime
    DebugLogId("????????¶¡?????:" .. G_Imgtime)
    DebugLogId("??????????:" .. ResultTable[2])
  end
  if ret == 0 then
    ret, _, _ = Device_TouchsByBuffer("", paraflag1, -1, 0)
  end
  return ret, ResultTable, picidx
end
function Device_packet_loss(strCommand, strCommandImg, paraflag1)
  local tmp_table_num_size = splittable(strCommandImg, ",")
  local num = 4
  local packet_size = 32
  if #tmp_table_num_size == 2 and Strip(tmp_table_num_size[2]) ~= "" then
    num = tonumber(tmp_table_num_size[1])
    packet_size = tonumber(tmp_table_num_size[2])
  elseif #tmp_table_num_size == 1 then
    packet_size = tonumber(tmp_table_num_size[1])
  end
  DebugLogId("ping??url??" .. strCommand .. "\tnum: " .. num .. "\tpacket_size: " .. packet_size)
  local ret_ping, pvalue = GetAPI_Ping(strCommand, num, packet_size)
  local ping_tab = {}
  DebugLogId("ret_ping??" .. ret_ping)
  local tmp_tab = splittable(ret_ping, ",")
  for i = 1, #tmp_tab do
    if tmp_tab[i] ~= "" then
      table.insert(ping_tab, tonumber(tmp_tab[i]))
    end
  end
  pcall(function()
    local file_ping = io.open(string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "ping.txt", "a")
    file_ping:write(pvalue .. "\r\n")
    file_ping:close()
  end)
  if ping_tab ~= {} then
    ping_sum = 0
    for i = 1, #ping_tab do
      ping_sum = ping_sum + ping_tab[i]
    end
    packet_loss_rate = DecPoint(1 - ping_sum / #ping_tab)
  end
  G_packet_loss_rate = tostring(packet_loss_rate * 100)
  return 0, {"auto", packet_loss_rate}, 0
end
function Device_video_playback(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  strCommandImg = ImgTmpTb[1]
  if ImgTmpTb[2] and tonumber(ImgTmpTb[2]) then
    TimeOut = tonumber(ImgTmpTb[2])
  end
  ret, ResultTable, picidx = Method_video_Playback(strCommand, strCommandImg, TimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_ENERGY(strCommand, paraflag1)
  local ret, ResultTable, ImgTmpTb, TimeOut
  local picidx = 0
  ret, ResultTable = Method_energy(strCommand, paraflag1)
  return ret, ResultTable, picidx
end
function Device_CycTouchs(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  strCommandImg = ImgTmpTb[1]
  if ImgTmpTb[2] and tonumber(ImgTmpTb[2]) then
    TimeOut = tonumber(ImgTmpTb[2])
  end
  ret, ResultTable, picidx = Method_TouchsCross(strCommand, strCommandImg, TimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_Title(strCommand, strCommandImg, paraflag1)
  local ret
  local ResultTable = {
    "TITLE",
    strCommand,
    paraflag1
  }
  local picidx = 0
  if string.upper(strCommand) == "Y" then
    ret = 0
  else
    ret = 1
  end
  return ret, ResultTable, picidx
end
function Device_ClearLog(strCommand, strCommandImg, paraflag1)
  local ret = 0
  local ResultTable = {"auto"}
  local picidx = 0
  GetAPI_ClearLog()
  return ret, ResultTable, picidx
end
function Device_SMS_ClearSMSSIG(strCommand, strCommandImg, paraflag1)
  local ret = 0
  local ResultTable = {"auto"}
  local picidx = 0
  GetAPI_ClearSms()
  return ret, ResultTable, picidx
end
function Device_SMS_SendSMSSIG(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, res
  local picidx = 0
  local parmTab, parmSPOrder, parmDestCode
  parmTab = splittable(strCommand, ",")
  parmSPOrder = parmTab[1]
  if parmSPOrder == "?????" then
    parmSPOrder = G_Captcha
  end
  if #parmTab > 2 then
    parmDestCode = string.match(strCommand, "[,]([^?]*)")
  else
    parmDestCode = parmTab[2]
  end
  if G_EngineMode == "IOS" then
    res, ret, ResultTable = pcall(_G[string.format("SendSMS_%s", G_DeviceName)], parmSPOrder, parmDestCode, paraflag1)
  else
    ret, ResultTable = Method_SendSMS_SIG(parmSPOrder, parmDestCode, paraflag1)
  end
  return ret, ResultTable, picidx
end
function Device_SMS_RecvSMSSIG(strCommand, strCommandImg, paraflag1, paraflag)
  local ret, ResultTable
  local picidx = 0
  local ReceiveContent, parmRecvCont
  local parmTimeOut = G_timeOut
  parmTab = splittable(strCommandImg, ",")
  parmRecvCont = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  parmRecvCont = string.gsub(parmRecvCont, "/", ",")
  ret, ResultTable, picidx = Method_RecvSMS_SIG(parmRecvCont, parmTimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_SMS_ReplySMSSIG(SPOrder, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  if SPOrder == "?????" and G_Captcha then
    SPOrder = G_Captcha
  end
  if paraflag1 == 1 then
    if G_EngineMode == "IOS" then
      res, ret, ResultTable = pcall(_G[string.format("SendSMS_%s", G_DeviceName)], SPOrder, G_RecvNumber, "??????????")
    else
      ret, ResultTable = Method_SendSMS_SIG(SPOrder, G_RecvNumber, "??????????")
    end
  else
    if not G_recvcontent then
      G_recvcontent = "?????????..."
    end
    if G_EngineMode == "IOS" then
      res, ret, ResultTable = pcall(_G[string.format("SendSMS_%s", G_DeviceName)], G_recvcontent, SPOrder, "??????????")
    else
      ret, ResultTable = Method_SendSMS_SIG(G_recvcontent, SPOrder, "??????????")
    end
  end
  return ret, ResultTable, picidx
end
function Device_UpdateEngine(strCommand, strCommandImg, paraflag1, paraflag)
  local picidx = 0
  local udurl, udmode, ret, ResultTable
  ret, ResultTable = Method_EngineUpdate(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_UpdateFile(strCommand, strCommandImg, paraflag1, paraflag)
  local picidx = 0
  local udurl, udmode, ret, ResultTable
  ret, ResultTable = Method_FileUpdate(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_DnsTest(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  local DnsUrl
  DnsUrl = strCommand
  ret, ResultTable = Method_Dns(DnsUrl, paraflag1)
  return ret, ResultTable, picidx
end
function Device_PingTest(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, PingUrl
  local pingtimes = 4
  local pingvalue = 32
  local pvaluetab
  local picidx = 0
  PingUrl = strCommand
  local tmp_table_num_size = splittable(strCommandImg, ",")
  if #tmp_table_num_size == 2 and Strip(tmp_table_num_size[2]) ~= "" then
    pingtimes = tonumber(tmp_table_num_size[1])
    pingvalue = tonumber(tmp_table_num_size[2])
  elseif #tmp_table_num_size == 1 then
    pingvalue = tonumber(tmp_table_num_size[1])
  end
  ret, ResultTable = Method_Ping(PingUrl, pingtimes, pingvalue, paraflag1)
  return ret, ResultTable, picidx
end
function Device_TraceRoute(strCommand, strCommandImg, paraflag1)
  local ret
  local picidx = 0
  local Routime = 300
  G_TraceRoute = 1
  if strCommandImg ~= "" and tonumber(strCommandImg) then
    Routime = tonumber(strCommandImg)
  end
  pvalue = _cfunc.Command("ping -c 4 " .. strCommand)
  _, _, ip = string.find(pvalue, "[(??](.-)[)??]")
  DebugLogId("???¶¬????IP??????" .. ip)
  local startclock = GetAPI_OsClock()
  trace = _cfunc.Command("busybox traceroute " .. ip .. " > /mnt/sdcard/traceroute.txt", Routime)
  DebugLogId(trace)
  if trace == "" then
    ret = 0
  else
    ret = 1
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable, picidx
end
function Device_TCPTest(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  local Dtimes = 1
  ret, ResultTable = Method_TCP(strCommand, Dtimes, paraflag1)
  return ret, ResultTable, picidx
end
function Device_HttpDownload(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local picidx = 0
  local Dtimes = 1
  ret, ResultTable = Method_HttpDownload(strCommand, Dtimes, paraflag1)
  return ret, ResultTable, picidx
end
function Device_MonitorTest(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, DId, temptab, DownUrl, RawUrl
  local picidx = 0
  local i
  temptab = splittable(G_CycUrl, "\t")
  DId = temptab[1]
  DownUrl = temptab[2]
  if string.find(DownUrl, "https://") then
    RawUrl = DownUrl
  end
  if string.find(DownUrl, "[Hh][Tt][Tt][Pp]") then
    i = string.find(DownUrl, "//")
    DownUrl = string.sub(DownUrl, i + 2, -1)
  end
  if string.sub(DownUrl, -1) == "/" then
    DownUrl = string.sub(DownUrl, 1, -2)
  end
  ret, ResultTable = Method_Monitor(DownUrl, DId, RawUrl)
  return ret, ResultTable, picidx
end
function Device_VideoTest(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local TimeOut = G_timeOut
  local ImgTmpTb
  local picidx = 0
  if strCommandImg ~= "" then
    ImgTmpTb = splittable(strCommandImg, ",")
    if ImgTmpTb[2] == "" or ImgTmpTb[2] == nil then
      TimeOut = ImgTmpTb[1]
      strCommandImg = ""
    else
      TimeOut = ImgTmpTb[2]
      strCommandImg = ImgTmpTb[1]
    end
  end
  ret, ResultTable = Method_Video(strCommand, strCommandImg, TimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_VideoTest_sig(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local TimeOut = G_timeOut
  local ImgTmpTb
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  if ImgTmpTb[2] ~= "" and ImgTmpTb[2] ~= nil then
    TimeOut = ImgTmpTb[2]
    strCommandImg = ImgTmpTb[1]
  end
  ret, ResultTable = Method_Video_sig(strCommand, strCommandImg, TimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_VideoTest_Auto(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable
  local TimeOut = G_timeOut
  local ImgTmpTb
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  if ImgTmpTb[2] ~= "" and ImgTmpTb[2] ~= nil then
    TimeOut = ImgTmpTb[2]
    strCommandImg = ImgTmpTb[1]
  end
  ret, ResultTable = Method_Video_auto(strCommand, strCommandImg, TimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_WlanInfo(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_WlanInfo(strCommand, paraflag1)
  return ret, ResultTable, picidx
end
function Device_GetWlanInfo(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_GetWlanInfo(paraflag1)
  return ret, ResultTable, picidx
end
function Device_ConnectWlan(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_ConnectWifi(strCommand, paraflag1)
  return ret, ResultTable, picidx
end
function Device_CheckNet(strCommand, strCommandImg, paraflag1)
  local picidx
  local parmTimeOut = G_timeOut
  local ret, ResultTable
  local parmTab = splittable(strCommandImg, ",")
  local parmCommandImg = parmTab[1]
  if parmTab[2] and tonumber(parmTab[2]) then
    parmTimeOut = tonumber(parmTab[2])
  end
  ret, ResultTable, picidx = Method_CheckNet(strCommand, parmCommandImg, parmTimeOut, paraflag1)
  return ret, ResultTable, picidx
end
function Device_svc_wifi(strCommand, strCommandImg, paraflag1)
  local picidx, ret, ResultTable
  ret, ResultTable, picidx = Method_svc_wifi(strCommand)
  return ret, ResultTable, picidx
end
function Device_CheckFile(strCommand, strCommandImg, paraflag1)
  local picidx, TimeOut, ret, ResultTable
  ret, ResultTable, picidx = Method_CheckFile(strCommand, strCommandImg)
  return ret, ResultTable, picidx
end
function Device_KillProcess(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_KillProcess(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_CaptureImg(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_CapturePic(strCommandImg)
  return ret, ResultTable, picidx
end
function Device_ImgOcr(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_CaptureOcr(strCommand, strCommandImg)
  return ret, ResultTable, picidx
end
function Device_DiffOcr(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_DiffOcr(strCommand, strCommandImg)
  return ret, ResultTable, picidx
end
function Device_Voucher(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  if strCommand and strCommand ~= "" then
    if strCommand:find("%=") then
      ret, ResultTable = Method_Voucher(strCommand, strCommandImg)
    else
      ret, ResultTable = Method_CaptureOcr(strCommand, strCommandImg)
    end
  end
  return ret, ResultTable
end
function Device_readini(strCommand, strCommandImg, paraflag1)
  local picidx
  local numflag = 0
  local ret, ResultTable
  local CompImgTab = splittable(strCommandImg, ",")
  if CompImgTab[2] and tonumber(CompImgTab[2]) then
    numflag = tonumber(CompImgTab[2])
  end
  ret, ResultTable, picidx = Method_readini(strCommand, CompImgTab[1], numflag)
  return ret, ResultTable, picidx
end
function Device_readinicyc(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local splitflag, ret, ResultTable
  ret, ResultTable, picidx = Method_readinicyc(strCommand)
  return ret, ResultTable, picidx
end
function Device_FlowCalculation(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_FlowCalculation(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_AdbCommand(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable, picidx = Method_AdbCommand(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_AdbVersion(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable, picidx = Method_AdbVersion(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_Performance(strCommand, strCommandImg, paraflag1)
  local temptab, testtime, testmode, testps
  local picidx = 0
  testps = strCommand
  temptab = splittable(strCommandImg, ",")
  temptab[1] = string.lower(temptab[1])
  if string.find(temptab[1], "cpu") and string.find(temptab[1], "memory") then
    testmode = "CPU|memory"
  elseif string.find(temptab[1], "cpu") then
    testmode = "CPU"
  elseif string.find(temptab[1], "memory") then
    testmode = "memory"
  else
    testmode = "CPU|memory"
  end
  if temptab[2] and tonumber(temptab[2]) then
    testtime = tonumber(temptab[2])
  else
    testtime = 300
  end
  DebugLogId("???¶¬?????:" .. testmode .. ",???????:" .. testtime .. ",???????:" .. testps)
  ret, ResultTable = Method_Performance(testps, testmode, testtime)
  return ret, ResultTable, picidx
end
function Device_RemoveCache(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_RemoveCache(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_deleteString(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable, picidx = Method_deleteString(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_getview(strCommand, strCommandImg, paraflag1)
  local ret, ResultTable, ImgTmpTb
  local TimeOut = G_timeOut
  local picidx = 0
  ImgTmpTb = splittable(strCommandImg, ",")
  strCommandImg = ImgTmpTb[1]
  if ImgTmpTb[2] and tonumber(ImgTmpTb[2]) then
    TimeOut = tonumber(ImgTmpTb[2])
  end
  ret, ResultTable, picidx = Method_getview(strCommand, strCommandImg, TimeOut)
  return ret, ResultTable, picidx
end
function Device_PACKET(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_PACKET(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function Device_GetTime(strCommand, strCommandImg, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_GetTime(strCommand, strCommandImg, paraflag1)
  return ret, ResultTable, picidx
end
function MGDevice_http(urlCommand, jsonCommand, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = MGMethod_HTTP(urlCommand, jsonCommand, paraflag1)
  return ret, ResultTable, picidx
end
function MGDevice_tcpdump(dumpCommand, jsonIni, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = MGMethod_TCPDUMP(dumpCommand, jsonIni, paraflag1)
  return ret, ResultTable, picidx
end
function Device_UUhttp(urlCommand, PramsCommand, paraflag1)
  local picidx = 0
  local ret, ResultTable
  ret, ResultTable = Method_UUHTTP(urlCommand, PramsCommand, paraflag1)
  return ret, ResultTable, picidx
end
function Device_ShowHow(randomStr, testTime, paraflag1)
  local picidx = 0
  local ret, ResultTable
  math.randomseed(tostring(os.time()):reverse():sub(1, 7))
  ret, ResultTable = Method_ShowHow(randomStr, testTime, paraflag1)
  return ret, ResultTable, picidx
end
ApiEdt = "3.0.7"
function GetAPI_UusensePath()
  local retpath
  if G_EngineMode == "IOS" then
    retpath = "/var/mobile/uusense/"
  elseif G_EngineMode == "Android" then
    retpath = "/data/local/tmp/c/"
  end
  return retpath
end
function GetAPI_OsClock()
  local td, tdtb, retosval
  if G_EngineMode == "IOS" then
    retosval = GetCurTime()
  elseif G_EngineMode == "Android" then
    retosval = _cfunc.GetCurTime()
  elseif G_EngineMode == "MacIOS" then
    retosval = GetCurTime()
  end
  return retosval
end
function GetAPI_SubTime(e, s)
  local ArguMentList, rettime, rettimestr, retval, ostime, osstr, idx, tale
  if G_EngineMode == "IOS" then
    retval = (e - s) / 1000
  elseif G_EngineMode == "Android" then
    retval = (e - s) / 1000
  elseif G_EngineMode == "MacIOS" then
    retval = (e - s) / 1000
  end
  retval = DecPoint(retval, 3)
  return retval
end
function GetAPI_VenderCode()
  local code
  if string.upper(TestMode) == "WLAN" then
    code = "hzys-wlan"
  else
    code = "hzys"
  end
  return code
end
function GetAPI_DevType()
  local retdtype
  for i = 1, 3 do
    if G_EngineMode == "IOS" then
      retdtype = DevType()
    elseif G_EngineMode == "MacIOS" then
      local iostype = IOSPTYPE
      retdtype = DevType()
      retdtype = iostype[retdtype] or "MAC"
    elseif G_EngineMode == "Android" then
      retdtype = _cfunc.DevType()
    end
    if retdtype and retdtype ~= "" then
      break
    end
  end
  return retdtype
end
function GetApi_GetUidByPackageName(packageName)
  ret = _cfunc.Command("ps|grep " .. packageName)
  end_str = string.find(ret, " ")
  return string.gsub(string.sub(ret, 1, end_str), "_", ""), string.sub(ret, 1, end_str)
end
function GetAPI_DevCode()
  local retimei
  if G_EngineMode == "IOS" then
    retimei = DevCode()
  elseif G_EngineMode == "MacIOS" then
    retimei = DevCode()
  elseif G_EngineMode == "Android" then
    retimei = _cfunc.DevCode()
  end
  return retimei
end
function GetAPI_SvcWifi(enable_flag)
  enable_flag = tonumber(enable_flag)
  if G_EngineMode == "IOS" then
    print("svc wifi")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.SetWifiEnable(enable_flag)
  end
end
function GetAPI_NetFlag()
  local retnet = "UNKNOWN"
  if G_EngineMode == "IOS" then
    retnet = DevNetType()
    retnet = tonumber(retnet)
    if retnet == 1 then
      retnet = "2G"
    elseif retnet == 2 then
      retnet = "3G"
    elseif retnet == 3 then
      retnet = "WIFI"
    elseif retnet == 4 then
      retnet = "4G"
    end
  elseif G_EngineMode == "MacIOS" then
    retnet = pcall(DevNetType) and DevNetType() or "MAC"
    retnet = not retnet:match("no") or "UNKNOWN" or retnet
  elseif G_EngineMode == "Android" then
    retnet = _cfunc.DevNetType()
    retnet = tonumber(retnet)
    if retnet == 1 then
      retnet = "2G"
    elseif retnet == 2 then
      retnet = "3G"
    elseif retnet == 3 then
      retnet = "WIFI"
    elseif retnet == 4 then
      retnet = "4G"
    elseif retnet == 5 then
      retnet = "LAN"
    else
      _cfunc.Print(string.format("ZXYZXY: Get DevNetType error %s", retnet))
    end
  end
  if retnet == 0 then
    retnet = "UNKNOWN" or retnet
  end
  return tostring(retnet):upper()
end
function GetAPI_DeviceIP()
  local retip = ""
  if G_EngineMode == "IOS" then
    retip = GetIp()
  elseif G_EngineMode == "Android" then
    retip = _cfunc.GetIp()
  elseif G_EngineMode == "MacIOS" then
    retip = GetIP()
  end
  if retip == "" or not retip then
    retip = "127.0.0.1"
  end
  return retip
end
function GetAPI_PublicIP()
  local publicIP
  local urlIP = "http://autoapi.uusense.com/uapi/agent/getip"
  if G_EngineMode == "MacIOS" then
    publicIP = MacIOSF:PublicIP(urlIP)
  elseif G_EngineMode == "Android" then
    local curlp = "/data/local/tmp/curl-7.40.0/bin"
    local urlexc = string.format("%s/curl -s %s", curlp, urlIP)
    local httpstr = _cfunc.Command(urlexc)
    local retlogs = httpstr:match("{.*}") or "nil"
    DebugLogId(string.format("PublicIp : %s", retlogs))
    publicIP = retlogs:match("ip.-(%d+.%d+.%d+.%d+)") or retlogs or "nil"
  end
  return publicIP
end
function GetAPI_MobileNum()
  local retnum = ""
  if G_EngineMode == "IOS" then
    retnum = DevMsim()
  elseif G_EngineMode == "Android" then
    retnum = _cfunc.DevMsim()
  elseif G_EngineMode == "MacIOS" then
    retnum = MacIOSF:MobileNum()
  end
  if not retnum or retnum == "" then
    retnum = "nil"
  end
  retnum = string.gsub(retnum, " ", "")
  return retnum
end
function GetAPI_TestMode()
  if string.find(G_SysParms, "PLPHONE") then
    return "PLPHONE"
  elseif string.find(G_SysParms, "PCPHONE") then
    return "PCPHONE"
  else
    return "INPHONE"
  end
end
function GetAPI_url_down(url, timeOut)
  local buf_lenth = 0
  local r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12 = GetAPI_HttpVisit(url, timeOut)
  DebugLogId("GetAPI_url_down.GetAPI_HttpVisit?????,??????r1=" .. r1 .. ".  r10=" .. r10)
  local _, _, ret_code = string.find(r10, "HTTP%/1%.[01] (%d+) *")
  if ret_code == "200" then
    _, _, buf_lenth = string.find(r10, "Content%-Length: *(%d-)[\r\n]")
    DebugLogId("???????????????" .. buf_lenth)
    buf_lenth = tonumber(buf_lenth)
  elseif string.sub(ret_code, 1, 1) == "3" then
    _, _, url = string.find(r12, "[Ll]ocation: *(.-)[\n\r]")
    buf_lenth = GetAPI_url_down(url, timeOut)
  end
  return buf_lenth
end
function GetAPI_Location()
  local retadd = 0
  if G_EngineMode == "IOS" then
    retadd = GetProvinceCode() .. "," .. GetCityCode()
  elseif G_EngineMode == "Android" then
    retadd = _cfunc.GetProviceCode() .. "," .. _cfunc.GetCityCode()
  end
  return retadd
end
function GetAPI_ScriptRoot()
  local ArguMentList, retdir
  ArguMentList = splittable(G_SysParms, "|")
  if G_EngineMode == "IOS" then
    if DebugFlag then
      retdir = "/var/mobile/uusense/scriptpic"
    else
      retdir = ScriptRoot() .. ArguMentList[5]
    end
  elseif G_EngineMode == "MacIOS" then
    retdir = ScriptRoot()
  elseif G_EngineMode == "Android" then
    if DebugFlag then
      retdir = "/data/local/tmp/c/pic"
    else
      retdir = _cfunc.ScriptRoot() .. "/" .. ArguMentList[5]
    end
  end
  return retdir
end
function GetAPI_ScriptContent()
  local scriptpath = "."
  local ArguMentList, file, scriptcontent
  ArguMentList = splittable(G_SysParms, "|")
  if G_EngineMode == "IOS" then
    if DebugFlag then
      scriptpath = "/var/mobile/uusense/scriptpic"
    else
      scriptpath = ScriptRoot() .. ArguMentList[5]
    end
  elseif G_EngineMode == "Android" then
    if DebugFlag then
      scriptpath = "/data/local/tmp/c"
    else
      scriptpath = _cfunc.ScriptRoot() .. "/" .. ArguMentList[5]
    end
  elseif G_EngineMode == "MacIOS" then
    scriptpath = ScriptRoot()
    DebugLogId("ScriptRoot: " .. scriptpath)
  end
  if TestMode == "Monitor" then
    file = io.open(scriptpath .. "/alarm.lua", "r")
  else
    file = io.open(scriptpath .. "/script.lua", "r")
  end
  scriptcontent = file:read("*all")
  file:close()
  return scriptcontent
end
function GetAPI_ResultPath()
  local ArguMentList, retdir
  ArguMentList = splittable(G_SysParms, "|")
  if G_EngineMode == "IOS" then
    retdir = ResultRoot() .. G_Id .. "/"
  elseif G_EngineMode == "MacIOS" then
    retdir = ResultRoot()
    if retdir:sub(-1, -1) ~= "/" then
      retdir = retdir .. "/" or retdir
    end
  elseif G_EngineMode == "Android" then
    retdir = _cfunc.ResultRoot() .. "/" .. ArguMentList[2] .. "/" .. ArguMentList[3] .. "/" .. ArguMentList[4] .. "/"
  end
  return retdir
end
function GetAPI_signalPath()
  local retdir = "/"
  if G_EngineMode == "IOS" then
    retdir = "/var/mobile/"
  elseif G_EngineMode == "Android" then
    retdir = string.format("/data/local/tmp/c/result/%s/", G_Id:match("(.*)_%d+"))
  end
  return retdir
end
function GetAPI_DebugPath()
  local retdir
  if G_EngineMode == "IOS" then
    retdir = "/var/mobile/uusense/result/" .. G_Id .. "/"
  elseif G_EngineMode == "Android" then
    retdir = string.format("/data/local/tmp/c/result/%s/", G_Id)
  end
  return retdir
end
function GetAPI_DelResultPath()
  local retdir
  if G_EngineMode == "IOS" then
    retdir = "/var/mobile/uusense/result/"
  elseif G_EngineMode == "MacIOS" then
    retdir = ResultRoot()
    if retdir:sub(-1, -1) ~= "/" then
      retdir = retdir .. "/" or retdir
    end
  elseif G_EngineMode == "Android" then
    retdir = "/data/local/tmp/c/result/"
  end
  return retdir
end
function GetAPI_EnginePath()
  local retdir
  if G_EngineMode == "IOS" then
    retdir = "/usr/local/lib/lua/5.1/"
  elseif G_EngineMode == "Android" then
    retdir = "/data/local/tmp/c/engine/"
  end
  return retdir
end
function GetAPI_EnginePicPath()
  local retdir = "/"
  if G_EngineMode == "IOS" then
    retdir = "/var/mobile/uusense/pic"
  elseif G_EngineMode == "Android" then
    retdir = "/data/local/tmp/c/engine/pic"
  end
  return retdir
end
function GetAPI_Sleep(Delay)
  if G_EngineMode == "IOS" or G_EngineMode == "MacIOS" then
    Sleep(Delay * 1000)
  elseif G_EngineMode == "Android" then
    _cfunc.Sleep(Delay * 1000)
  end
end
function GetAPI_KillProcess(ps)
  if G_EngineMode == "IOS" then
    KillProcess(ps)
  elseif G_EngineMode == "Android" then
    _cfunc.Command("am force-stop " .. ps)
    _cfunc.KillProcess(ps)
    if ps == "logcat" then
      GetAPI_KillProcess_byPID("logcat")
    end
    if ps == "monkey" then
      GetAPI_KillProcess_byPID("monkey")
    end
  elseif G_EngineMode == "MacIOS" then
    KillProcess(ps)
  end
end
function GetAPI_KillProcess_byPID(pkgname)
  local tmpstr = string.format("ps|grep %s", pkgname)
  local tmp_pidstr = _cfunc.Command(tmpstr)
  for pidstring in string.gmatch(tmp_pidstr, "([^\n]*)[\n\r]") do
    for i in string.gmatch(pidstring, "([^ ]*)") do
      if i == pkgname then
        local _, _, pid = string.find(pidstring, "( %d+)")
        _cfunc.Command(string.format("kill -9 %s", pid))
      end
    end
  end
end
function GetAPI_WriteContentToTxt(str, path, writeModel)
  local file = io.open(path, writeModel)
  local time = GetAPI_OsClock()
  local DataLog = "[" .. os.date("%Y-%m-%d %H:%M:%S", string.sub(time, 1, -4)) .. "." .. string.sub(time, -3, -1) .. "]\t" .. str .. "\t\n"
  file:write(DataLog)
  file:close()
end
function GetAPI_Dump(value_table, non_flag, and_flag)
  GetAPI_KillProcess("uiautomator")
  pcall(function()
    local file = io.open("/data/local/tmp/dump.xml", "w")
    file:close()
    local file = io.open("/data/local/tmp/uubootstrap/dump/dump.xml", "w")
    file:close()
  end)
  local command = "uiautomator runtest UUBootstrap.jar -c io.appium.android.bootstrap.Bootstrap -e output true -e isDumper true -e dumpPath /data/local/tmp"
  local Ret_dump = _cfunc.Command(command)
  GetAPI_KillProcess("uiautomator")
  local _, _, file_path = string.find(Ret_dump, "Dump Source At:(.-)\"")
  if file_path then
    file_path = string.gsub(file_path, "\\", "")
    DebugLogId("dump???°§????" .. file_path)
  else
    GetAPI_WriteContentToTxt(_cfunc.Utf8ToGbk(Ret_dump), string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump_err_log.txt", "a")
    DebugLogId(string.format("dump???°§???????? : %s", _cfunc.Utf8ToGbk(Ret_dump)))
  end
  local ret, dump_content = pcall(function()
    local file = io.open(file_path .. "/dump.xml", "r")
    local content = file:read("*all")
    file:close()
    CopyFile(file_path .. G_Pflg .. "dump.xml", string.sub(G_SysDbgPath, 1, -2) .. G_Pflg .. "dump.xml")
    GetAPI_Deletefile(file_path .. G_Pflg .. "dump.xml")
    return content
  end)
  if ret and dump_content ~= "" then
    for i in string.gmatch(dump_content, "<node(.-)>") do
      for j = 1, #value_table do
        if TabInStr(value_table[j], i, 1) then
          local i_gbk = _cfunc.Utf8ToGbk(i)
          if not i_gbk or i_gbk == "" then
            i_gbk = i
          end
          DebugLogId("???????????????????????" .. i_gbk)
          if not non_flag or non_flag == false then
            return j, i
          else
            return -1, ""
          end
        end
      end
    end
  end
  if not non_flag or non_flag == false then
    return -1, ""
  else
    return 0, ""
  end
end
function GetAPI_att_cbt(strcommand)
  DebugLogId("?????" .. strcommand)
  local tmp_table = splittable(strcommand, "|")
  local value_type_table = {}
  local value_table = {}
  if tmp_table[#tmp_table] == "" then
    tmp_table[#tmp_table] = nil
  end
  for i = 1, #tmp_table do
    tmp_table[i] = splittable(tmp_table[i], "' ")
    local tmp_value_table = {}
    for j = 1, #tmp_table[i] do
      local tmp_value = ""
      for k in string.gmatch(tmp_table[i][j], "(.-)=") do
        tmp_value = k
      end
      for k in string.gmatch(tmp_table[i][j], "='(.*)") do
        if string.sub(k, -1, -1) == "'" then
          k = string.sub(k, 1, -2)
        end
        tmp_value = tmp_value .. "=\"" .. k .. "\""
      end
      DebugLogId("???????" .. tmp_value)
      tmp_value = transferred(tmp_value)
      table.insert(tmp_value_table, tmp_value)
    end
    table.insert(value_table, tmp_value_table)
  end
  return value_table
end
function transferred(value)
  value = string.gsub(value, "%(", "%%(")
  value = string.gsub(value, "%)", "%%)")
  value = string.gsub(value, "%[", "%%[")
  value = string.gsub(value, "%]", "%%]")
  value = string.gsub(value, "%+", "%%+")
  value = string.gsub(value, "%-", "%%-")
  value = string.gsub(value, "%*", "%%*")
  value = string.gsub(value, "%?", "%%?")
  value = string.gsub(value, "%^", "%%^")
  value = string.gsub(value, "%$", "%%$")
  return value
end
function GetAPI_att_cbt_get_view(strcommand)
  local tmp_table = splittable(strcommand, "|")
  local value_type_table = {}
  local value_table = {}
  if tmp_table[#tmp_table] == "" then
    tmp_table[#tmp_table] = nil
  end
  for i = 1, #tmp_table do
    tmp_table[i] = splittable(tmp_table[i], "' ")
    local tmp_value_table = {}
    for j = 1, #tmp_table[i] do
      local tmp_value = ""
      for k in string.gmatch(tmp_table[i][j], "(.-)=") do
        tmp_value = k
      end
      for k in string.gmatch(tmp_table[i][j], "='(.*)") do
        if string.sub(k, -1, -1) == "'" then
          k = string.sub(k, 1, -2)
        end
        tmp_value = tmp_value .. "=\".*" .. k .. "%w+"
      end
      table.insert(tmp_value_table, tmp_value)
    end
    table.insert(value_table, tmp_value_table)
  end
  return value_table
end
function GetAPI_Key(keyvalue, keytype, keydelay)
  local keyvalueint
  if TestMode and string.upper(TestMode) == "MONITOR" then
    keydelay = 0 or keydelay
  end
  if G_EngineMode == "IOS" then
    Key(keyvalue, keytype)
  elseif G_EngineMode == "MacIOS" then
    local retk = MacIOSF:key(keyvalue)
    if not retk then
      DebugLogId(string.format("KEY[%s]:\t%s !!", keyvalue, "false"))
    end
  elseif G_EngineMode == "Android" then
    keydelay = G_re and 0 or keydelay
    keyvalueint = Key_Value(keyvalue)
    _cfunc.Key(keyvalueint, keytype)
  end
  GetAPI_Sleep(keydelay)
end
function Key_Value(keyvalue)
  local Value1 = {
    "F",
    "B",
    "CALL",
    "ENDCALL",
    "UP",
    "DOWN",
    "LEFT",
    "RIGHT",
    "CENTER",
    "VOUP",
    "VODOWN",
    "POWER",
    "CAMERA",
    "TAB",
    "SYM",
    "ENTER",
    "DEL",
    "FOCUS",
    "M",
    "NOT",
    "SEARCH",
    "MUTE",
    "PAGEUP",
    "PAGEDOWN",
    "O",
    "VOMUTE"
  }
  local Value2 = {
    3,
    4,
    5,
    6,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    61,
    63,
    66,
    67,
    80,
    82,
    83,
    84,
    91,
    92,
    93,
    108,
    164
  }
  local ret = InTable(string.upper(keyvalue), Value1)
  return Value2[ret]
end
function GetAPI_Touch(touchx, touchy, touchtype, touchdelay)
  if G_EngineMode == "IOS" then
    if touchtype == 3 then
      Touch(touchx, touchy, 1)
      Sleep(150)
      Touch(touchx, touchy, 2)
    else
      Touch(touchx, touchy, touchtype)
    end
  elseif G_EngineMode == "MacIOS" then
    MacIOSF:TouchPIO(touchx, touchy, touchtype, touchdelay)
    if touchtype == 2 then
      return
    end
  elseif G_EngineMode == "Android" then
    local temptable = {}
    if touchx > 0 and touchx < 1 then
      touchx = math.ceil(touchx * G_now_width)
      touchy = math.ceil(touchy * G_now_height)
      DebugLogId("????????ß≥(" .. G_now_width .. "*" .. G_now_height .. "),?????????(" .. touchx .. "," .. touchy .. ")")
    elseif DScreen and G_click_coor == true then
      temptable = splittable(DScreen, "*")
      touchx = math.ceil(touchx * G_now_width / tonumber(temptable[1]))
      touchy = math.ceil(touchy * G_now_height / tonumber(temptable[2]))
      DebugLogId("DScreen not nil,After conversion: touchx=" .. touchx .. ",touchy=" .. touchy)
    end
    _cfunc.Touch(touchx, touchy, touchtype)
  end
  if not touchdelay then
    GetAPI_Sleep(2)
  else
    DebugLogId("??????" .. touchdelay)
    GetAPI_Sleep(touchdelay)
  end
end
function GetAPI_Move(touchax, touchay, touchbx, touchby, touchdelay, movtime)
  if G_EngineMode == "IOS" then
    Move(touchax, touchay, touchbx, touchby)
    Sleep(touchdelay * 1000)
  elseif G_EngineMode == "MacIOS" then
    MacIOSF:MovePIO(touchax, touchay, touchbx, touchby, movtime)
    Sleep(touchdelay * 1000)
  elseif G_EngineMode == "Android" then
    local temptable = {}
    if touchax > 0 and touchax < 1 then
      touchax = math.ceil(touchax * G_now_width)
      touchay = math.ceil(touchay * G_now_height)
      touchbx = math.ceil(touchbx * G_now_width)
      touchby = math.ceil(touchby * G_now_height)
      DebugLogId("????????ß≥(" .. G_now_width .. "*" .. G_now_height .. "),????????(" .. touchax .. "," .. touchay .. ")-->(" .. touchbx .. "," .. touchby .. ")")
    elseif DScreen and G_click_coor == true then
      temptable = splittable(DScreen, "*")
      touchax = math.ceil(touchax * G_now_width / tonumber(temptable[1]))
      touchay = math.ceil(touchay * G_now_height / tonumber(temptable[2]))
      touchbx = math.ceil(touchbx * G_now_width / tonumber(temptable[1]))
      touchby = math.ceil(touchby * G_now_height / tonumber(temptable[2]))
      DebugLogId("DScreen not nil,After conversion: touchax=" .. touchax .. ",touchay=" .. touchay .. ",touchbx=" .. touchbx .. ",touchby=" .. touchby)
    end
    _cfunc.Move(touchax, touchay, touchbx, touchby)
    _cfunc.Sleep(touchdelay * 1000)
  end
end
function GetAPI_DoubleMove(touchax, touchay, touchbx, touchby, touchcx, touchcy, touchdx, touchdy, touchdelay)
  if G_EngineMode == "IOS" then
    print("DBMove...")
    Sleep(touchdelay * 1000)
  elseif G_EngineMode == "MacIOS" then
    DoubleMove(touchax, touchay, touchbx, touchby, touchcx, touchcy, touchdx, touchdy, 0.5)
    Sleep(touchdelay * 1000)
  elseif G_EngineMode == "Android" then
    DebugLogId("After conversion: toucha=" .. touchax .. "," .. touchay .. ",touchb=" .. touchbx .. "," .. touchby)
    DebugLogId("After conversion: touchc=" .. touchcx .. "," .. touchcy .. ",touchd=" .. touchdx .. "," .. touchdy)
    _cfunc.DoubleMove(touchax, touchay, touchbx, touchby, touchcx, touchcy, touchdx, touchdy)
    _cfunc.Sleep(touchdelay * 1000)
  end
end
function GetAPI_MatchScreen(imgFile, conflag)
  local imgret = -1
  local stclock = GetAPI_OsClock()
  if not File_Exists(imgFile) then
    return -2, 0
  end
  if G_EngineMode == "IOS" then
    local tmplib = splittable(imgFile, "/")
    local tmptb = splittable(tmplib[#tmplib], "_")
    local onetime = G_OnecTime or 500
    imgret = BinaryMatchScreen(imgFile, tonumber(tmptb[1]), tonumber(tmptb[2]), tonumber(tmptb[3]), tonumber(tmptb[4]), onetime)
    imgret = imgret == 1 and 0 or 1
  elseif G_EngineMode == "MacIOS" then
    imgret = MacIOSF:JPEG_match(imgFile)
  elseif G_EngineMode == "Android" then
    imgret = _cfunc.MatchScreen(imgFile)
  end
  endclock = GetAPI_OsClock()
  G_Imgtime = GetAPI_SubTime(endclock, stclock)
  if string.find(imgFile, "_NOMATCH_") or conflag and conflag == true then
    imgret = imgret == 0 and 1 or 0
    DebugLogId("NOMATCH????,imgret:" .. imgret .. "\t" .. G_Imgtime)
  else
    DebugLogId("imgret:" .. imgret .. "\t\t" .. G_Imgtime)
  end
  return imgret, G_Imgtime
end
function GetAPI_MatchScreen2(imgFile, flag, conflag)
  local imgret = -1
  local tmptb, tmpteb, tmplib, tmpretlist, retx
  local startclock = GetAPI_OsClock()
  if G_EngineMode == "IOS" then
    local onetime = G_OnecTime or 500
    local capret = CaptureLocal("/var/mobile/match.png", onetime)
    tmpteb = splittable(imgFile, "|")
    for i = 1, #tmpteb - 1 do
      if capret ~= 0 then
        imgret = -1
        DebugLogId(string.format("CaptureLocal: ret=%s\ttime=%s", capret, onetime))
        break
      end
      tmplib = splittable(tmpteb[i], "/")
      tmptb = splittable(tmplib[#tmplib], "_")
      imgret = BinaryMatchFile("/var/mobile/match.png", tmpteb[i], tonumber(tmptb[1]), tonumber(tmptb[2]), tonumber(tmptb[3]), tonumber(tmptb[4]), 3000)
      if imgret == 1 then
        imgret = i
        break
      else
        imgret = -1
      end
    end
  elseif G_EngineMode == "Android" then
    if flag == 0 then
      imgret = _cfunc.MatchScreen2(imgFile, 0)
      imgret = tonumber(imgret)
    else
      local _, tmppicreturn = _cfunc.MatchScreen2(imgFile, 1)
      imgret = 1
      DebugLogId("tmppicreturn??" .. tmppicreturn)
      tmpretlist = splittable(tmppicreturn, "|")
      for i = 1, #tmpretlist do
        if tonumber(tmpretlist[i]) == -1 then
          imgret = -1
          break
        end
      end
    end
    DebugLogId(string.format("GetAPI_MatchScreen2: ???????\t%s", imgret))
  elseif G_EngineMode == "MacIOS" then
    local tmpteb = splittable(imgFile, "|")
    for i = 1, #tmpteb - 1 do
      startclock = GetAPI_OsClock()
      imgret = MacIOSF:JPEG_match(tmpteb[i])
      if imgret == 0 then
        imgret = i
        break
      end
    end
  end
  local endclock = GetAPI_OsClock()
  G_Imgtime = GetAPI_SubTime(endclock, startclock)
  if string.find(imgFile, "_NOMATCH_") or conflag and conflag == true then
    if not tmpretlist then
      imgret = imgret == -1 and 1 or -1
      DebugLogId("NOMATCH????,imgsret:" .. imgret .. "\t" .. G_Imgtime)
    else
      imgret = 1
      for i = 1, #tmpretlist do
        if tonumber(tmpretlist[i]) == 0 then
          imgret = -1
          break
        end
      end
    end
  else
    DebugLogId("imgsret:" .. imgret .. "\t\t" .. G_Imgtime)
  end
  return imgret
end
function GetAPI_MatchFileImg(fullimg, imgFile)
  local imgret = -1
  local tmptb, tmplib
  if G_EngineMode == "IOS" then
    tmplib = splittable(imgFile, "/")
    tmptb = splittable(tmplib[#tmplib], "_")
    imgret = BinaryMatchFile(fullimg, imgFile, tonumber(tmptb[1]), tonumber(tmptb[2]), tonumber(tmptb[3]), tonumber(tmptb[4]), 30000)
    if imgret == 1 then
      imgret = 0
    else
      imgret = 1
    end
  elseif G_EngineMode == "Android" then
    imgret = _cfunc.MatchBmp(imgFile, fullimg)
  elseif G_EngineMode == "MacIOS" then
    DebugLogId("MacIOS ???:  to do list ")
    imgret = 0
  end
  DebugLogId("imgret=" .. imgret)
  return imgret
end
function GetAPI_MatchScreenEX(imgFile, tempimg, ScriptPath, CompImage, conflag)
  local imgret, resx, resy = -1, -1, -1
  local startclock = GetAPI_OsClock()
  if G_EngineMode == "IOS" then
    DebugLogId("IOS??????")
    tempimg = ScriptPath .. G_Pflg .. "full.png"
    GetAPI_CaptureImg(tempimg, 11)
    imgret, resx, resy = match(tempimg, imgFile, tempimg)
  elseif G_EngineMode == "Android" then
    local touchax, touchay = 0, 0
    local rp_x, rp_y = 0, 0
    local touchbx, touchby = G_now_width, G_now_height
    if CompImage and CompImage ~= "" then
      touchax, touchay, touchbx, touchby, rp_x, rp_y = GetAPI_getCoorByResPow(CompImage, G_now_width, G_now_height)
      tempimg = ScriptPath .. G_Pflg .. tostring(touchax) .. "_" .. tostring(touchay) .. "_" .. tostring(touchbx) .. "_" .. tostring(touchby) .. "_" .. "tmp.bmp"
      GetAPI_CaptureRectangle(tempimg)
    else
      GetAPI_CaptureImg(tempimg, 11)
    end
    imgret, resx, resy = _cfunc.match_resize(tempimg, imgFile, rp_x, rp_y, tempimg, 0, 0)
  elseif G_EngineMode == "MacIOS" then
    imgret = MacIOSF:JPEG_fuzzily(imgFile)
  end
  local endclock = GetAPI_OsClock()
  G_Imgtime = GetAPI_SubTime(endclock, startclock)
  imgret = tonumber(imgret) >= 90 and 0 or -1
  if string.find(imgFile, "_NOMATCH_") or conflag and conflag == true then
    imgret = imgret ~= 0 and 0 or -1
    DebugLogId("NOMATCH????,imgsret:" .. imgret .. "\t" .. G_Imgtime)
  else
    DebugLogId("imgret=" .. imgret .. "    " .. resx .. "," .. resy .. "\t" .. G_Imgtime)
  end
  return imgret, resx, resy
end
function GetAPI_getCoorByResPow(CompImage, now_width, now_height)
  local coor_table = splittable(CompImage, "_")
  local rp_x, rp_y
  local touchax, touchay, touchbx, touchby = tonumber(coor_table[1]), tonumber(coor_table[2]), tonumber(coor_table[3]), tonumber(coor_table[4])
  if DScreen then
    temptable = splittable(DScreen, "*")
    touchax = math.ceil(touchax * now_width / tonumber(temptable[1]))
    touchay = math.ceil(touchay * now_height / tonumber(temptable[2]))
    touchbx = math.ceil(touchbx * now_width / tonumber(temptable[1]))
    touchby = math.ceil(touchby * now_height / tonumber(temptable[2]))
    touchax = touchax - G_Fuzzy_Offset
    touchay = touchay - G_Fuzzy_Offset
    touchbx = touchbx + G_Fuzzy_Offset
    touchby = touchby + G_Fuzzy_Offset
    if touchax < 0 then
      touchax = 0 or touchax
    end
    if touchay < 0 then
      touchay = 0 or touchay
    end
    if now_width < touchbx then
      touchbx = now_width or touchbx
    end
    if now_height < touchby then
      touchby = now_height or touchby
    end
    rp_x = math.ceil(tonumber(temptable[1]) * (touchbx - touchax) / now_width)
    rp_y = math.ceil(tonumber(temptable[2]) * (touchby - touchay) / now_height)
  end
  return touchax, touchay, touchbx, touchby, rp_x, rp_y
end
function GetAPI_ClearSms()
  if G_EngineMode == "IOS" then
    ClearSms()
  elseif G_EngineMode == "Android" then
    _cfunc.ClearSms()
  elseif G_EngineMode == "MacIOS" then
    DebugLogId("MacIOS.ClearSms")
  end
end
function GetAPI_ClearLog()
  if G_EngineMode == "IOS" then
    local fb = io.open("/var/mobile/autosense.log", "wb")
    fb:close()
  elseif G_EngineMode == "Android" then
    _cfunc.Command("rm /data/data/com.autosense/files/ser/log/d20*.log")
    _cfunc.Command("rm /data/data/com.autosense/files/log/f20*.log")
    _cfunc.Command("rm /data/data/com.autosense/files/daemproc/log/screxecd2*.log")
    _cfunc.Command("echo > /data/data/com.autosense/files/daemproc/log/signalstrength.log")
    _cfunc.Command("rm -r /data/log/*")
    _cfunc.ClearSms()
  elseif G_EngineMode == "MacIOS" then
    DebugLogId("MacIOS.ClearLog")
  end
end
function GetAPI_SendSms(SPOrder, DestCode)
  local retval
  if G_EngineMode == "IOS" then
    retval = 1
  elseif G_EngineMode == "Android" then
    retval = 0
    _cfunc.SendSms(DestCode, SPOrder)
  elseif G_EngineMode == "MacIOS" then
    DebugLogId("MacIOS.SendSms")
  end
  return retval
end
function GetAPI_RecvSms(TimeOut, CompContent, FlowStep)
  local retval, retidx
  if G_EngineMode == "IOS" then
    if G_RelDeviceName == "IPHONE5" or G_RelDeviceName == "IPHONE6" then
      retval, retidx = RecvSms(CompContent, TimeOut * 1000, "CallBack_SmsIosEx")
    else
      retval, retidx = RecvSms(CompContent, TimeOut * 1000, "CallBack_SmsIos")
    end
  elseif G_FileDeviceName == "SMN9008" then
    retval, retidx = _cfunc.RecvSms(TimeOut, CompContent, "CallBack_SmsAndroid")
  elseif G_EngineMode == "Android" then
    retval, retidx = CallBack_SmsAndroidEx(TimeOut, CompContent)
  end
  if FlowStep == 2 and G_Captcha then
    DebugLogId("????????...")
    UpLoad_Identify()
  end
  return retval, retidx
end
function GetAPI_CreateDumpDir()
  local info
  if not pcall(function()
    local f = io.open("/data/local/tmp/uubootstrap/dump/dump.xml")
    f:close()
  end) then
    GetAPI_CommandEx("mkdir /data/local/tmp/uubootstrap")
    GetAPI_CommandEx("mkdir /data/local/tmp/uubootstrap/dump")
    pcall(function()
      local ffx = io.open("/data/local/tmp/uubootstrap/dump/dump.xml", "w")
      ffx:close()
    end)
  end
  local list = GetAPI_Command("ls -l /data/local/tmp")
  for uustr in string.gmatch(list, "([^\n]*)[\n\r]") do
    for i in string.gmatch(uustr, "([^ ]*)") do
      if i == "uubootstrap" then
        info = string.match(uustr, [[
([^
]-) ]])
      end
    end
  end
  if info ~= "drwxrwxrwx" then
    GetAPI_CommandEx("su && chmod 777 /data/local/tmp/uubootstrap")
    GetAPI_CommandEx("su && chmod 777 /data/local/tmp/uubootstrap/dump")
    GetAPI_CommandEx("su && chmod 777 /data/local/tmp/uubootstrap/dump/dump.xml")
    local fx = io.open("/mnt/sdcard/dump.xml", "w")
    fx:close()
    GetAPI_CommandEx("su && chmod 777 /mnt/sdcard/dump.xml")
  end
end
function GetAPI_CommandEx(command)
  DebugLogId("start command " .. command)
  if G_FileDeviceName ~= "SMG9008V" and G_FileDeviceName ~= "SMG9008W" and G_FileDeviceName ~= "SMG9009W" then
    os.execute(command)
    os.execute("exit")
  elseif G_EngineMode == "Android" then
    command = string.gsub(command, "&&", "\n")
    _cfunc.Command(command .. [[

exit]])
  end
  DebugLogId("completed command " .. command)
end
function CallBack_SmsAndroidEx(TimeOut, InputSMSMessgae)
  local startime, endtime, OutputSMSMessgae, OutputList, InputSMSList, Outputsourcecode, Outputrecvcontent, InputValue, Inputsourcecode, Inputkeyword
  local retval, listensucidx = -1, -1
  local breakflag, tempnum
  InputSMSList = splittable(InputSMSMessgae, "|")
  startime = GetAPI_OsClock()
  DebugLogId("--------------------??????????????--------------------")
  while true do
    endtime = GetAPI_OsClock()
    if GetAPI_SubTime(endtime, startime) >= tonumber(TimeOut) then
      DebugLogId("???????,???")
      break
    end
    OutputSMSMessgae = _cfunc.PopSms()
    if OutputSMSMessgae ~= "" then
      OutputList = splittable(OutputSMSMessgae, "|")
      Outputsourcecode = OutputList[1]
      Outputrecvcontent = OutputList[4]
      G_GlbVocMsg = GetGVM("???(%s)????,?????", {Outputsourcecode})
      G_GlbVocMsg = GetGVM("%s", {Outputrecvcontent})
      for i = 1, #InputSMSList do
        InputValue = splittable(InputSMSList[i], "-")
        if #InputValue == 1 and tempnum then
          Inputsourcecode = tempnum
          Inputkeyword = InputValue[1]
        elseif #InputValue == 2 then
          Inputsourcecode = InputValue[1]
          tempnum = Inputsourcecode
          Inputkeyword = InputValue[2]
        else
          DebugLogId("?????????????...", "???????")
          return -1, -1
        end
        DebugLogId("????????:" .. Inputsourcecode .. ",???????:" .. Inputkeyword)
        DebugLogId("????????:" .. Outputsourcecode .. ",???????:" .. Outputrecvcontent)
        if findword(Outputsourcecode, Inputsourcecode) and findword(Outputrecvcontent, Inputkeyword) then
          retval = 0
          listensucidx = i
          DebugLogId("??????????????????????" .. Outputsourcecode)
          G_RecvNumber = Outputsourcecode
          G_recvcontent = Outputrecvcontent
          DebugLogId("--------------------???????????????--------------------")
          FindCaptcha(Outputrecvcontent, Inputkeyword)
          breakflag = true
          break
        else
          DebugLogId("??????????????")
          DebugLogId("--------------------???????????????--------------------")
        end
      end
    end
    if breakflag then
      break
    end
    _cfunc.Sleep(3000)
  end
  return retval, listensucidx
end
function CallBack_SmsAndroid(OutputSMSMessgae, InputSMSMessgae)
  local i = 1
  local InputSMSList, InputValue, Inputsourcecode, Inputkeyword, OutputList, Outputsourcecode, Outputrecvcontent, retval, tempnum
  listensucidx = 0
  DebugLogId("--------------------??????????????--------------------")
  OutputList = splittable(OutputSMSMessgae, "|")
  Outputsourcecode = OutputList[1]
  Outputrecvcontent = OutputList[4]
  InputSMSList = splittable(InputSMSMessgae, "|")
  G_GlbVocMsg = GetGVM("???(%s)????,?????", {Outputsourcecode})
  G_GlbVocMsg = GetGVM("%s", {Outputrecvcontent})
  while i <= #InputSMSList do
    InputValue = splittable(InputSMSList[i], "-")
    if #InputValue == 1 and tempnum then
      Inputsourcecode = tempnum
      Inputkeyword = InputValue[1]
    elseif #InputValue == 2 then
      Inputsourcecode = InputValue[1]
      tempnum = Inputsourcecode
      Inputkeyword = InputValue[2]
    else
      DebugLogId("?????????????...", "???????")
      return -1, -1
    end
    DebugLogId("????????:" .. Inputsourcecode .. ",???????:" .. Inputkeyword)
    DebugLogId("????????:" .. Outputsourcecode .. ",???????:" .. Outputrecvcontent)
    if findword(Outputsourcecode, Inputsourcecode) and findword(Outputrecvcontent, Inputkeyword) then
      retval = 0
      listensucidx = i
      DebugLogId("??????????????????????" .. Outputsourcecode)
      G_RecvNumber = Outputsourcecode
      G_recvcontent = Outputrecvcontent
      DebugLogId("--------------------???????????????--------------------")
      FindCaptcha(Outputrecvcontent, Inputkeyword)
      break
    else
      retval = -1
      listensucidx = -1
      DebugLogId("??????????????")
      DebugLogId("--------------------???????????????--------------------")
    end
    i = i + 1
  end
  return retval, listensucidx
end
function CallBack_SmsIosEx(Recvcode, RecvContent, CompContent)
  local i = 1
  local CompList, Compcode, Compkeyword, CompValue, retval, tempnum
  listensucidx = 0
  DebugLogId("--------------------??????????????--------------------")
  CompList = splittable(CompContent, "|")
  G_GlbVocMsg = GetGVM("???(%s)????,?????", {Recvcode})
  G_GlbVocMsg = GetGVM("%s", {RecvContent})
  while i <= #CompList do
    CompValue = splittable(CompList[i], "-")
    if #CompValue == 1 and tempnum then
      Compcode = tempnum
      Compkeyword = CompValue[1]
    elseif #CompValue == 2 then
      Compcode = CompValue[1]
      tempnum = Compcode
      Compkeyword = CompValue[2]
    else
      DebugLogId("?????????????...", "???????")
      return -1, -1
    end
    DebugLogId("????????:" .. Compcode .. ",???????:" .. Compkeyword)
    DebugLogId("????????:" .. Recvcode .. ",???????:" .. RecvContent)
    if findword(Recvcode, Compcode) and findword(RecvContent, Compkeyword) then
      retval = 0
      listensucidx = i
      DebugLogId("??????????????????????" .. Recvcode)
      G_RecvNumber = Recvcode
      G_recvcontent = RecvContent
      DebugLogId("--------------------???????????????--------------------")
      FindCaptcha(RecvContent, Compkeyword)
      break
    else
      retval = -1
      listensucidx = -1
      DebugLogId("??????????????")
      DebugLogId("--------------------???????????????--------------------")
    end
    i = i + 1
  end
  return retval, listensucidx
end
function CallBack_SmsIos(Recvcode, RecvContent, CompContent)
  local i = 1
  local CompList, Compcode, Compkeyword, CompValue, retval, tempnum, a
  listensucidx = 0
  DebugLogId("--------------------??????????????--------------------")
  G_GlbVocMsg = GetGVM("???(%s)????,?????", {Recvcode})
  G_GlbVocMsg = GetGVM("%s", {RecvContent})
  while true do
    CompList = splittableEx(CompContent, "|", i)
    if not CompList then
      break
    end
    a = string.find(CompList, "-")
    if a then
      Compcode = string.sub(CompList, 1, a - 1)
      tempnum = Compcode
      Compkeyword = string.sub(CompList, a + 1, -1)
    elseif tempnum then
      Compcode = tempnum
      Compkeyword = CompList
    else
      DebugLogId("?????????????...", "???????")
      return -1, -1
    end
    DebugLogId("????????:" .. Compcode .. ",???????:" .. Compkeyword)
    DebugLogId("????????:" .. Recvcode .. ",???????:" .. RecvContent)
    if findword(Recvcode, Compcode) and findword(RecvContent, Compkeyword) then
      retval = 0
      listensucidx = i
      DebugLogId("??????????????????????" .. Recvcode)
      G_RecvNumber = Recvcode
      G_recvcontent = RecvContent
      DebugLogId("--------------------???????????????--------------------")
      FindCaptcha(RecvContent, Compkeyword)
      break
    else
      retval = -1
      listensucidx = -1
      DebugLogId("??????????????")
      DebugLogId("--------------------???????????????--------------------")
    end
    i = i + 1
  end
  return retval, listensucidx
end
function GetAPI_OpenBrowser(URL)
  local retval
  if G_EngineMode == "IOS" then
    print("visiturl")
  elseif G_EngineMode == "Android" then
    URL = URL:find("://") or "http://" .. URL or URL
    retval = _cfunc.OpenBrowser(URL)
  end
  return retval
end
function GetAPI_Open_App(APPName)
  local APPNameTb, APPAutoTb
  local retval = 0
  APPNameTb = {
    "????",
    "MM???",
    "?????",
    "?????",
    "139????",
    "12580",
    "????",
    "?????",
    "??????",
    "?????",
    "?????",
    "???",
    "?«¨????",
    "?????",
    "??????",
    "??????",
    "?????",
    "?????",
    "???",
    "???",
    "UC"
  }
  APPAutoTb = {
    "cn.com.fetion|cn.com.fetion.activity.LaunchActivity",
    "com.aspire.mm|com.aspire.mm.app.HotSaleActivity",
    "com.ophone.reader.ui|com.cmread.bplusc.bookshelf.LocalMainActivity",
    "com.chinamobile.contacts.im|com.chinamobile.contacts.im.LoadingPage",
    "cn.cj.pe|cn.cj.pe.activity.PeSplashActivity",
    "cn.com.umessage.client12580|cn.com.umessage.client12580.presentation.view.StartActivity",
    "com.autonavi.cmccmap|com.autonavi.minimap.Splashy",
    "com.hisunflytone.android|com.cmdm.android.controller.InitActivity",
    "com.whty.wicity.china|com.whty.wicity.china.home.WicityHomeNewActivity",
    "com.cmcc.mobilevideo|com.cmcc.mobilevideo.StartActivity",
    "cn.emagsoftware.gamehall|cn.emagsoftware.gamehall.GameHallShowcase",
    "com.iflytek.cmcc|com.iflytek.viafly.SplashActivity",
    "cmccwm.mobilemusic|cmccwm.mobilemusic.ui.activity.PreSplashActivityMigu",
    "com.newspaper.client|com.cmread.bplusc.reader.ui.mainscreen.MainScreen",
    "com.youku.phone|com.youku.phone.ActivityWelcome",
    "com.qiyi.video|com.qiyi.video.WelcomeActivity",
    "cn.cmvideo.isj|com.cmcc.mobilevideo.StartActivity",
    "com.cmcc.mobilevideo|com.cmcc.mobilevideo.StartActivity",
    "com.tencent.qqlive|com.tencent.qqlive.ona.activity.WelcomeActivity",
    "com.sohu.sohuvideo|com.sohu.sohuvideo.FirstNavigationActivityGroup",
    "com.UCMobile|com.UCMobile.main.UCMobile"
  }
  local function getPsId(APPName, APPNameTb)
    if string.find(APPName, "|") then
      indata = APPName
    elseif InTable(APPName, APPNameTb) then
      local i = InTable(APPName, APPNameTb)
      indata = APPAutoTb[i]
    else
      DebugLogId("??????????????????!", "???????")
      return 1
    end
    return indata
  end
  if G_EngineMode == "IOS" then
    DebugLogId("?????...")
  elseif G_EngineMode == "Android" then
    local indata = getPsId(APPName, APPNameTb)
    if indata == 1 then
      return 1
    end
    local tmptb = splittable(indata, "|")
    DebugLogId("????????1:" .. tmptb[1])
    DebugLogId("????????2:" .. tmptb[2])
    _cfunc.OpenApplication(tmptb[1], tmptb[2])
  elseif G_EngineMode == "MacIOS" then
    local bundleID = APPName
    DebugLogId(string.format("????APP: ", bundleID))
    OpenApplication(bundleID)
  end
  return retval
end
function GetAPI_OpenAutosense()
  if G_EngineMode == "Android" then
    _cfunc.OpenApplication("com.autosense", "com.autosense.ui.activity.MainActivity")
  end
end
function GetAPI_CaptureImg(AllPath, tempflag)
  local cret
  if G_EngineMode == "IOS" then
    cret = CaptureLocal("/var/mobile/a.png", 5000)
    if cret ~= 0 then
      DebugLogId(string.format("CaptureLocal: ret=%s\ttime=%s", cret, 5000))
    end
    CopyFile("/var/mobile/a.png", AllPath)
  elseif G_EngineMode == "MacIOS" then
    tempflag = tempflag or 2
    DebugLogId("mac jpeg : " .. tempflag .. "\t" .. AllPath)
    for i = 1, 3 do
      cret = CaptureAsJpg(AllPath, tempflag)
      cret = math.floor(cret)
      if cret == 0 then
        break
      end
      DebugLogId("mac jpeg cret : " .. cret)
    end
  elseif G_EngineMode == "Android" then
    if tempflag then
      cret = _cfunc.Capture(AllPath)
    else
      DebugLogId(string.format("???jpg?????: %s", AllPath))
      cret = _cfunc.CaptureAsJpg(AllPath, 50)
    end
  end
  return cret
end
function GetAPI_CreateDir(Dir)
  local cret
  if G_EngineMode == "IOS" then
    cret = CreateDir(Dir)
  elseif G_EngineMode == "MacIOS" then
    cret = CreateDir(Dir)
  elseif G_EngineMode == "Android" then
    cret = _cfunc.CreateDir(Dir)
  end
  return cret
end
function GetAPI_DeleteDir(Dir)
  local cret
  if G_EngineMode == "IOS" then
    cret = DeleteDir(Dir)
  elseif G_EngineMode == "MacIOS" then
    cret = DeleteFile(Dir)
  elseif G_EngineMode == "Android" then
    cret = _cfunc.DeleteDir(Dir)
  end
  return cret
end
function GetAPI_Deletefile(Delpath)
  local cret
  if G_EngineMode == "IOS" then
    cret = DeleteFile(Delpath)
  elseif G_EngineMode == "MacIOS" then
    cret = DeleteFile(Delpath)
  elseif G_EngineMode == "Android" then
    cret = _cfunc.DeleteFile(Delpath)
  end
  return cret
end
function GetAPI_Zip(zipname, zuhestr)
  local zipret = -2
  if G_EngineMode == "IOS" then
    zuhestr = string.sub(zuhestr, 1, -2)
    zipret = Zip(zipname, zuhestr)
  elseif G_EngineMode == "Android" then
    zipret = _cfunc.Zip(zipname, zuhestr)
  end
  return zipret
end
function GetAPI_Unzip(zipname, zuhestr)
  local zipret
  if G_EngineMode == "IOS" then
    zipret = Unzip(zipname, zuhestr)
  elseif G_EngineMode == "Android" then
    zipret = _cfunc.Unzip(zipname, zuhestr)
  end
  return zipret
end
function GetAPI_ExecSql(excsql, DBName)
  local retval
  if G_EngineMode == "IOS" then
    retval = ExecSql(excsql, DBName)
  elseif G_EngineMode == "Android" then
    retval = _cfunc.ExecSql(excsql, DBName)
  end
  return retval
end
function GetAPI_DnsInfo(DnsUrl)
  local Dnstime, DnsIP
  if G_EngineMode == "IOS" then
    print("DNS")
  elseif G_EngineMode == "Android" then
    Dnstime, DnsIP = _cfunc.Dns(DnsUrl)
  end
  return Dnstime, DnsIP
end
function GetAPI_PingInfo(Purl, Ptimes, Ppcgsize)
  local ret, pvalue, ping_avgtime = -1, 0, 0
  if G_EngineMode == "IOS" then
    ret, pvalue = Ping(Purl, Ptimes, Ppcgsize)
  elseif G_EngineMode == "Android" then
    pvalue, ping_avgtime = GetAPI_Ping_CMD(Purl, Ptimes, Ppcgsize)
    if pvalue and pvalue ~= "" then
      ret = 0
    else
      DebugLogId("the ping return value is empty from --> " .. Purl)
      ret = 1
    end
  end
  DebugLogId("ping???????" .. pvalue .. ping_avgtime)
  return ret, pvalue, ping_avgtime
end
function GetAPI_Ping_CMD(Purl, Ptimes, Ppcgsize)
  local rec_packet = 0
  local trans_packet = 0
  local ping_time, ping_ttl = {}, {}
  local ret, ping_content, _, ping_avgtime
  GetAPI_Deletefile("rm -r /data/local/tmp/c/ping_test.txt")
  local cmdstr = string.format("ping -c %s -s %s %s > /data/local/tmp/c/ping_test.txt", Ptimes, Ppcgsize, Purl)
  _cfunc.Command(cmdstr)
  local starttime = GetAPI_OsClock()
  while true do
    local endtime = GetAPI_OsClock()
    if GetAPI_SubTime(endtime, starttime) > 60 then
      DebugLogId("Ping?????????")
      break
    end
    ret, ping_content = pcall(function()
      local file = io.open("/data/local/tmp/c/ping_test.txt", "r")
      local content = file:read("*all")
      file:close()
      return content
    end)
    if string.find(ping_content, "rtt min/avg/max/mdev") then
      GetAPI_Sleep(1)
      _, _, _, ping_avgtime = string.find(ping_content, "rtt min/avg/max/mdev = (.-)/(.-)/")
      break
    end
  end
  DebugLogId("??????ping????????" .. ping_content)
  for i, j, k in string.gmatch(ping_content, "icmp_seq=(%d+) *ttl=(%d+) *time=(.-) *ms") do
    table.insert(ping_time, k)
    table.insert(ping_ttl, j)
  end
  for i, k in string.gmatch(ping_content, "(%d+) -packets *transmitted, *(%d+) *received") do
    trans_packet = tonumber(i)
    rec_packet = tonumber(k)
  end
  local ret_p = ""
  if rec_packet == trans_packet then
    for i = rec_packet, 1, -1 do
      ret_p = ret_p .. tostring(i) .. "," .. ping_time[i] .. "," .. ping_ttl[i] .. ",0|"
    end
  elseif rec_packet == 0 then
    for i = tonumber(Ptimes), 1, -1 do
      ret_p = ret_p .. tostring(i) .. ",-1,0,0|"
    end
  else
    for i = rec_packet, 1, -1 do
      ret_p = ret_p .. tostring(i) .. "," .. ping_time[i] .. "," .. ping_ttl[i] .. ",0|"
    end
    local tmp_ret_p = ""
    for i = Ptimes, rec_packet + 1, -1 do
      tmp_ret_p = tmp_ret_p .. tostring(i) .. ",-1,0,0|"
    end
    ret_p = tmp_ret_p .. ret_p
  end
  return ret_p, ping_avgtime
end
function GetAPI_Ping(Purl, Ptimes, Ppcgsize)
  local ret, pvalue = GetAPI_PingInfo(Purl, Ptimes, Ppcgsize)
  local ret_ping = ""
  if ret ~= 0 then
    pvalue = ""
    for i = Ptimes, 1, -1 do
      pvalue = pvalue .. tostring(i) .. ",-1,0,0|"
    end
  end
  if string.sub(pvalue, -1, -1) == "|" then
    pvalue = string.sub(pvalue, 1, -2)
  end
  local tmp_ping_table = splittable(pvalue, "|")
  for i = 1, #tmp_ping_table do
    local tmp_tratime_tab = splittable(tmp_ping_table[i], ",")
    if tmp_tratime_tab[2] == -1 or tmp_tratime_tab[2] == "-1" or tmp_tratime_tab[2] == "0" or tmp_tratime_tab[2] == 0 then
      ret_ping = ret_ping .. "0,"
    else
      ret_ping = ret_ping .. "1,"
    end
  end
  if string.sub(ret_ping, -1, -1) == "," then
    ret_ping = string.sub(ret_ping, 1, -2)
  end
  return ret_ping, pvalue
end
function GetAPI_HttpClient(HUrl, DownUrl, url, TimeOut)
  local r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, ret, result, restb
  if G_EngineMode == "IOS" then
    ret, result, r11 = DL_Page(url)
    if ret == 0 then
      r1 = 6
    else
      r1 = 0
    end
    restb = splittable(result, "|")
    r10 = restb[1]
    r4 = restb[2]
    r3 = restb[4]
    r6 = restb[6]
    r7 = restb[7]
    r12 = r11
  elseif G_EngineMode == "Android" then
    if TimeOut then
      r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12 = _cfunc.HttpClient2(HUrl, DownUrl, tonumber(TimeOut))
    else
      r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12 = _cfunc.HttpClient2(HUrl, DownUrl)
    end
  end
  return r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12
end
function GetAPI_FileLength(Path)
  local ret
  for i = 1, 6 do
    if G_EngineMode == "IOS" then
      ret = GetFileLength(Path)
    elseif G_EngineMode == "MacIOS" then
      ret = GetFileLength(Path)
    elseif G_EngineMode == "Android" then
      ret = _cfunc.GetFileLength(Path)
    end
    if ret > 0 then
      break
    end
    GetAPI_Sleep(5)
  end
  return ret
end
function GetAPI_VM2_Start()
  local ip, port
  local cache = 2
  port = PortFlag and 8088 or 80
  if G_EngineMode == "IOS" then
    require("lua_vm2")
    ip = GetIp()
    VM2_Start(ip, port, cache)
  elseif G_EngineMode == "Android" then
    ip = _cfunc.GetIp()
    DebugLogId("ip: " .. ip)
    _cfunc.VM2_Start(ip, 8088, cache)
  end
end
function GetAPI_VM2_Stop()
  if G_EngineMode == "IOS" then
    VM2_Stop()
  elseif G_EngineMode == "Android" then
    _cfunc.VM2_Stop()
  end
end
function GetAPI_GetFileName(str)
  local idx = str:match(".*/([^/]*%.%w+) *$")
  if idx then
    return idx
  else
    return str
  end
end
function GetAPI_VM2_Video_ID()
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_ID()
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_ID()
  end
  return ret
end
function GetAPI_VM2_Video_Force_Check()
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Force_Check()
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Force_Check()
  end
end
function GetAPI_VM2_Video_Duration(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Duration(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Duration(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Buffer_Count(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Buffer_Count(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Buffer_Count(Id)
  end
  return ret
end
function GetAPI_VM2_Video_URL(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_URL(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_URL(Id)
  end
  return ret
end
function GetAPI_VM2_Video_M3U8_Addr(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_M3U8_Addr(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_M3U8_Addr(Id)
  end
  return ret
end
function GetAPI_deleteString(times)
  _cfunc.Backspace(times)
end
function GetAPI_VM2_Video_DL_Rate(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_DL_Rate(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_DL_Rate(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Connect_Time(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Connect_Time(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Connect_Time(Id)
  end
  return ret
end
function GetAPI_VM2_Video_First_Frame_PTS(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_First_Frame_PTS(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_First_Frame_PTS(Id)
  end
  return ret
end
function GetAPI_VM2_Video_DL_Time(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_DL_Time(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_DL_Time(Id)
  end
  return ret
end
function GetAPI_VM2_Video_First_PKT_Time(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_First_PKT_Time(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_First_PKT_Time(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Width(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Width(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Width(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Set_Play_Point()
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Set_Play_Point()
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Set_Play_Point()
  end
end
function GetAPI_VM2_Video_Play_Time(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Play_Time(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Play_Time(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Height(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Height(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Height(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Bitrate(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Bitrate(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Bitrate(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Reset(Id)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Reset(Id)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Reset(Id)
  end
  return ret
end
function GetAPI_VM2_Video_Buffer_Time(Id, i)
  local ret
  if G_EngineMode == "IOS" then
    ret = VM2_Video_Buffer_Time(Id, i)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.VM2_Video_Buffer_Time(Id, i)
  end
  return ret
end
function GetAPI_FtpGet(FUrl, account, password, DLName)
  local ret, DLPath, filesize
  if G_EngineMode == "IOS" then
    print("FtpGet")
  elseif G_EngineMode == "Android" then
    DLPath = "/data/local/tmp/c/" .. DLName
    ret = _cfunc.FtpGet(FUrl, account, password, DLPath, DLName)
    GetAPI_Sleep(5)
    filesize = GetAPI_FileLength(DLPath)
  end
  return ret, filesize
end
function GetAPI_FtpPut(FUrl, account, password, DLPath)
  local ret, filesize
  if G_EngineMode == "IOS" then
    print("FtpPut")
  elseif G_EngineMode == "Android" then
    filesize = GetAPI_FileLength(DLPath)
    GetAPI_Sleep(5)
    DebugLogId("???????:" .. FUrl .. "," .. account .. "," .. password .. "," .. DLPath)
    ret = _cfunc.FtpPut(FUrl, account, password, DLPath, ".")
  end
  return ret, filesize
end
function GetAPI_ScanWlanInfo()
  local ret
  if G_EngineMode == "IOS" then
    print("GetScanWlanInfo")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.GetScanWlanInfo()
  end
  return ret
end
function GetAPI_DnsIp()
  local ret
  if G_EngineMode == "IOS" then
    print("GetDns")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.GetDns()
  end
  return ret
end
function GetAPI_ChangeDns(Dns)
  local ret
  if G_EngineMode == "IOS" then
    print("ChangeDns")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.ChangeDns(Dns)
  end
  return ret
end
function GetAPI_BtDownload(downpath, downname)
  local ret
  if G_EngineMode == "IOS" then
    print("BtDownload")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.BtDownload(downpath, downname)
  end
  return ret
end
function GetAPI_WifiDisconnect()
  local ret
  if G_EngineMode == "IOS" then
    print("WifiDisconnect")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.WifiDisconnect()
  end
  return ret
end
function GetAPI_WifiConnect(wifiname)
  local ret
  if G_EngineMode == "IOS" then
    print("WifiConnect")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.WifiConnect(wifiname)
  end
  return ret
end
function GetAPI_WifiCurrConnInfo()
  local ret
  if G_EngineMode == "IOS" then
    print("WifiCurrConnInfo")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.WifiCurrConnInfo()
  end
  return ret
end
function GetAPI_InputString(content)
  local ret = -1
  if G_EngineMode == "IOS" then
    content = GbkToUtf8(content)
    ret = Keys(content)
  elseif G_EngineMode == "MacIOS" then
    ret = Text(content)
    if ret ~= 0 then
      DebugLogId(string.format("MacIOS.Text() : %s", ret))
    end
    ret = math.floor(ret)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.Text(content)
  end
  return ret
end
function GetAPI_Input(content, MobType)
  local ret = -1
  if G_EngineMode == "IOS" then
    content = GbkToUtf8(content)
    ret = Keys(content)
    Sleep(100)
  elseif G_EngineMode == "MacIOS" then
    ret = Text(content)
    if ret ~= 0 then
      DebugLogId(string.format("MacIOS.Text() : %s", ret))
    end
    ret = math.floor(ret)
  elseif G_EngineMode == "Android" then
    ret = _cfunc.Text(content)
  end
  return ret
end
function GetAPI_GPSInfo()
  local x, y = 0, 0
  local ret = "nil,nil"
  if G_EngineMode == "IOS" then
    print("Text")
  elseif G_EngineMode == "Android" then
    x, y = _cfunc.Location()
    if x and y then
      ret = x .. "," .. y
    end
  end
  return ret
end
function GetAPI_TestInfoPath()
  local filepath
  if G_EngineMode == "IOS" then
    filepath = "/var/mobile/uusense/TestInfo.ini"
  elseif G_EngineMode == "Android" then
    filepath = "/data/local/tmp/c/TestInfo.ini"
  end
  return filepath
end
function GetAPI_NetworkInfo()
  local NetInfo, Nutf = " ", " "
  if G_EngineMode == "IOS" then
    DebugLogId("IOS??????????????????")
  elseif G_EngineMode == "Android" then
    NetInfo = _cfunc.GetNetworkOperator()
    if tonumber(NetInfo) == 46000 then
      Nutf = "?ß€????GSM"
    elseif tonumber(NetInfo) == 46001 then
      Nutf = "?ß€????GSM"
    elseif tonumber(NetInfo) == 46002 then
      Nutf = "?ß€????TD"
    elseif tonumber(NetInfo) == 46003 then
      Nutf = "?ß€?????CDMA"
    elseif tonumber(NetInfo) == 46004 then
      Nutf = "?ß€?????????"
    elseif tonumber(NetInfo) == 46005 then
      Nutf = "?ß€?????CDMA"
    elseif tonumber(NetInfo) == 46006 then
      Nutf = "?ß€????WCDMA"
    elseif tonumber(NetInfo) == 46007 then
      Nutf = "?ß€????TD-S"
    elseif tonumber(NetInfo) == 46011 then
      Nutf = "?ß€?????FDD-LTE"
    else
      Nutf = "nil"
    end
  elseif G_EngineMode == "MacIOS" then
    local CNMNC = {
      ["00"] = "China Mobile",
      ["01"] = "China Unicom",
      ["03"] = "China Telecom",
      ["08"] = "China Mobile",
      ["09"] = "China Unicom",
      ["20"] = "China Tietong"
    }
    local Binfotb = DevBrandInfo()
    Nutf = CNMNC[Binfotb.MNC] or Binfotb.Name
    NetInfo = string.format("%s%s", Binfotb.MCC, Binfotb.MNC)
    NetInfo = NetInfo ~= "" and NetInfo or Binfotb.ISOCountryCode or "nils"
    if Nutf == "" or not Nutf then
      Nutf = "nil"
    end
  end
  return NetInfo, Nutf
end
function GetAPI_DeviceTraffic(Process)
  local ret1, ret2
  if G_EngineMode == "IOS" then
    print("GetAPI_DeviceTraffic")
  elseif G_EngineMode == "Android" then
    if Process == "" then
      ret1, ret2 = _cfunc.GetDeviceTraffic()
    else
      ret1, ret2 = _cfunc.GetApplicationTraffic(Process)
    end
  end
  return ret1, ret2
end
function GetAPI_Command(command)
  local value = ""
  if G_EngineMode == "IOS" then
    print("command")
  elseif G_EngineMode == "Android" then
    value = _cfunc.Command(command)
  end
  return value
end
function GetAPI_Makepack(msg, val)
  local length, pack
  if val then
    length = string.len(val) + 12
    pack = string.format("%08d%s%s", length, msg, val)
  else
    length = 12
    pack = string.format("%08d%s", length, msg)
  end
  DebugLogId("???????????" .. pack)
  return pack
end
function GetAPI_GetDevicesInfo()
  if G_EngineMode == "IOS" then
    DebugLogId("DeviceName:" .. G_DeviceName)
  elseif G_EngineMode == "Android" then
    local now_width, now_height = _cfunc.GetDisplayWidth(), _cfunc.GetDisplayHeight()
    local code = GetAPI_DevCode()
    local net_model = GetAPI_NetFlag()
    local ip_addr = GetAPI_DeviceIP()
    local phone_num = GetAPI_MobileNum()
    local proxy = GetAPI_DevProxyInfo()
    local _, Operator = GetAPI_NetworkInfo()
    G_now_width = tostring(now_width)
    G_now_height = tostring(now_height)
    DebugLogId(string.format("?ıÙ????:%s\t?ıÙ????%s\t??????????(??*??)??%s*%s", G_DeviceName, code, G_now_width, G_now_height))
    DebugLogId(string.format("????????: %s\t?????????: %s\t???ip: %s\t?????: %s", phone_num, net_model, ip_addr, Operator))
    if net_model == "2G" or net_model == "3G" or net_model == "4G" then
      DebugLogId("??????????:" .. proxy)
    end
  elseif G_EngineMode == "MacIOS" then
    DebugLogId(string.format("DeviceName : %s\tDeviceImei : %s", IOSPTYPE[WDATYPE] or "mac", G_DeviceImei))
    local net_model = GetAPI_NetFlag()
    local ip_addr = GetAPI_DeviceIP()
    local phone_num = GetAPI_MobileNum()
    local _, Operator = GetAPI_NetworkInfo()
    DebugLogId(string.format("NetworkInfo: %s\tNetFlag: %s\tDeviceIP: %s\tMobileNum: %s", Operator, net_model, ip_addr, phone_num))
  end
end
function GetAPI_GetProcCpuPercent(testps)
  local ret
  if G_EngineMode == "IOS" then
    print("GetProcCpuPercent")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.GetProcCpuPercent(testps)
  end
  return ret
end
function GetAPI_Switch_input(flag)
  if flag and flag == true then
    G_input_method = _cfunc.Command("settings get secure default_input_method")
    if G_input_method ~= "com.uusense.tools.inputmethod/.service.UUInputMethodService" then
      _cfunc.Command("ime set com.uusense.tools.inputmethod/.service.UUInputMethodService")
    end
  elseif G_input_method and G_input_method ~= _cfunc.Command("settings get secure default_input_method") then
    _cfunc.Command("ime set " .. G_input_method)
  end
end
function GetAPI_GetProcMemInfo(testps)
  local ret
  if G_EngineMode == "IOS" then
    print("GetProcMemInfo")
  elseif G_EngineMode == "Android" then
    _, ret = _cfunc.GetProcMemInfo(testps)
  end
  return ret
end
function GetAPI_perf_monitor(File, Process, flag)
  if flag == 0 then
    if G_EngineMode == "IOS" then
      print("start_perf_monitor")
    elseif G_EngineMode == "Android" then
      _cfunc.start_perf_monitor(File, Process, 3)
    end
  elseif G_EngineMode == "IOS" then
    print("stop_perf_monitor")
  elseif G_EngineMode == "Android" then
    _cfunc.stop_perf_monitor()
  end
end
function GetAPI_GetMemInfo()
  local r1
  if G_EngineMode == "IOS" then
    print("GetAPI_GetMemInfo")
  elseif G_EngineMode == "Android" then
    r1 = _cfunc.GetMemInfo()
  end
  return r1
end
function GetAPI_DevProxyInfo()
  local netret
  if G_EngineMode == "IOS" then
    netret = ""
  elseif G_EngineMode == "Android" then
    local net = GetAPI_NetFlag()
    if net ~= "WIFI" then
      local NetInfo = GetAPI_NetworkInfo()
      local Proxy = _cfunc.DevIsUseProxy()
      Proxy = tonumber(Proxy)
      if tonumber(NetInfo) == 46003 then
        if Proxy == 1 then
          netret = "CTWAP"
        elseif Proxy == 2 then
          netret = "CTNET"
        else
          DebugLogId("??????????" .. netret)
          netret = "UNKNOWN"
        end
      elseif Proxy == 1 then
        netret = "CMWAP"
      elseif Proxy == 2 then
        netret = "CMNET"
      else
        DebugLogId("??????????" .. netret)
        netret = "UNKNOWN"
      end
    else
      netret = "LAN"
    end
  end
  return netret
end
function GetAPI_SwitchSim(card)
  local r1 = 1
  local ret
  if G_EngineMode == "IOS" then
    print("GetAPI_SwitchSim")
  elseif G_EngineMode == "Android" then
    ret = _cfunc.SwitchSim(card)
    if tonumber(ret) and tonumber(ret) == 0 then
      r1 = tonumber(ret)
    end
  end
  return r1
end
function GetAPI_start_signal_monitor(filename, oncetime)
  if G_EngineMode == "IOS" then
    start_signal_monitor(filename, oncetime)
  elseif G_EngineMode == "Android" then
    _cfunc.start_signal_monitor(filename, oncetime)
  end
end
function GetAPI_stop_signal_monitor()
  if G_EngineMode == "Symbian" then
    print("stop_signal_monitor")
  elseif G_EngineMode == "IOS" then
    stop_signal_monitor()
  elseif G_EngineMode == "Android" then
    _cfunc.stop_signal_monitor()
  end
end
function GetAPI_MonitorSignal(s_flg)
  if G_EngineMode ~= "Android" then
    DebugLogId(string.format("G_EngineMode~=\"Android\", not support !!!"))
    return
  end
  local sig_path = "/data/data/com.autosense/files/"
  if s_flg:match("start") then
    DebugLogId(string.format("startMonitorSignalStrength: %sjava_sig.txt", sig_path))
    _cfunc.LuaScriptJavaExec(string.format("com_autosense_extra_LuaCommonManager:getInstance():startMonitorSignalStrength(\"%sjava_sig.txt\")", sig_path))
  else
    DebugLogId(string.format("stopMonitorSignalStrength"))
    _cfunc.LuaScriptJavaExec("com_autosense_extra_LuaCommonManager:getInstance():stopMonitorSignalStrength()")
    local cmd = string.format([[
su -c 'chmod 777 %sjava_sig.txt'
exit]], sig_path)
    local logs = _cfunc.Command(cmd)
    DebugLogId(string.format(":%s.", logs))
  end
end
function GetAPI_CaptureRectangle(img, x1, y1, x2, y2)
  local start_clock = GetAPI_OsClock()
  local ret
  if G_EngineMode == "Symbian" then
    print("CaptureRectangle")
  elseif G_EngineMode == "IOS" then
    if not x1 then
      tmplib = splittable(img, "/")
      tmptb = splittable(tmplib[#tmplib], "_")
      x1, y1 = tonumber(tmptb[1]), tonumber(tmptb[2])
      x2, y2 = tonumber(tmptb[3]), tonumber(tmptb[4])
    end
    DebugLogId(string.format("???????: %s,%s,%s,%s", x1, y1, x1 + x2 - 1, y1 + y2 - 1))
    ret = CaptureArea(img, tonumber(x1), tonumber(y1), tonumber(x1) + tonumber(x2) - 1, tonumber(y1) + tonumber(y2) - 1, 10000)
    DebugLogId("??????? :" .. ret)
  elseif G_EngineMode == "Android" then
    _cfunc.CaptureRectangle(img)
  elseif G_EngineMode == "MacIOS" then
    local s1, _, t1, t2, t3, t4 = string.find(img, "/(%d+)_(%d+)_(%d+)_(%d+)")
    img = string.sub(img, 1, s1) .. t1 .. "_" .. t2 .. "_" .. t3 .. "_" .. t4 .. "_tmp.jpeg"
    DebugLogId("MAC???: " .. img)
    ret = CaptureRectangle(img)
  end
  local end_clock = GetAPI_OsClock()
  local capt_time = GetAPI_SubTime(end_clock, start_clock)
  DebugLogId("????????" .. capt_time)
  return capt_time
end
function auto_WaitEx(Imgs)
  local i, ScriptPath, imgFile, imgret, imgidx, ss, se, ImgsTab, idx, CompImage, tempimg, resx, resy
  local ImgFileName = ""
  imgret = 1
  imgidx = 0
  ImgsTab = splittable(Imgs, "|")
  ss = GetAPI_OsClock()
  ScriptPath = G_SysScpPath
  tempimg = ScriptPath .. G_Pflg .. "temp.bmp"
  GetAPI_CaptureImg(tempimg, 11)
  for idx, CompImage in pairs(ImgsTab) do
    if string.match(string.lower(CompImage), "engine") then
      ScriptPath = G_SysEngPath
    else
      ScriptPath = G_SysScpPath
    end
    imgFile = ScriptPath .. G_Pflg .. CompImage
    imgret, resx, resy = GetAPI_MatchScreenEX(imgFile, tempimg)
    if imgret == 0 then
      ImgFileName = auto_PicReturn(CompImage, resx, resy)
      imgidx = idx
      break
    end
  end
  return imgret, imgidx, ImgFileName
end
function GetAPI_URLCombination(httpmode, url, body)
  local i = string.find(url, "/")
  if i then
    return string.format("%s %s HTTP/1.1\r\nHOST:%s\r\nContent-Length:%s\r\nContent-Type: application/json; charset=UTF-8\r\nConnection:Close\r\n\r\n%s", httpmode, string.sub(url, i, -1), string.sub(url, 1, i - 1), #body, body), string.sub(url, 1, i - 1)
  end
end
function GetAPI_getCoordinate(strCommand)
  local long_click_flag = false
  local swipe_flag = false
  local start_num = 2
  if string.sub(strCommand, 1, 1) == "<" then
    long_click_flag = true
    strCommand = string.sub(strCommand, 2, -2)
  elseif string.sub(strCommand, 1, 1) == "(" then
    swipe_flag = true
    strCommand = string.sub(strCommand, 2, -2)
  end
  local command_tab = splittable(strCommand, ",")
  local ret, str_Command = GetAPI_getCoordinateEx(command_tab[1])
  local str_Command_swipe
  if ret ~= -1 then
    if swipe_flag == true then
      ret, str_Command_swipe = GetAPI_getCoordinateEx(command_tab[2])
      if ret ~= -1 then
        str_Command = str_Command .. "," .. str_Command_swipe
        start_num = 3
      else
        return -1, "0,0"
      end
    end
    for i = start_num, #command_tab do
      str_Command = str_Command .. "," .. command_tab[i]
    end
    if long_click_flag == true then
      str_Command = "<" .. str_Command .. ">"
    end
    if swipe_flag == true then
      str_Command = "(" .. str_Command .. ")"
    end
    return ret, str_Command
  end
  return -1, "0,0"
end
function GetAPI_getCoordinateEx(str)
  local start_clock = GetAPI_OsClock()
  local value_table = GetAPI_att_cbt(str)
  local ret, dump_content
  while true do
    local end_clock = GetAPI_OsClock()
    if GetAPI_SubTime(end_clock, start_clock) > tonumber(G_ClickTimeOut) then
      DebugLogId(string.format("%s??????????????!", tonumber(G_ClickTimeOut)))
      return -1, "0,0"
    end
    local single_start_clock = GetAPI_OsClock()
    ret, dump_content = GetAPI_Dump(value_table)
    local single_end_clock = GetAPI_OsClock()
    local single_clicltime = GetAPI_SubTime(single_end_clock, single_start_clock)
    local coordinate
    if ret ~= -1 then
      local x_coo, y_coo = dump_Coordinate(dump_content)
      local str_Command = x_coo .. "," .. y_coo
      return ret, str_Command
    else
      DebugLogId("viewret:-1" .. "\t\t" .. single_clicltime)
      if G_UIAutoClick then
        UI_AutoClickOpen(pkgname, 7)
      end
    end
  end
end
function dump_Coordinate(dump_content)
  local tmp_coordinate_tab = {}
  local _, _, tmp_coordinate = string.find(dump_content, "bounds=\"%[(.-)\"")
  for i in string.gmatch(tmp_coordinate .. "[", "(.-)%]%[") do
    table.insert(tmp_coordinate_tab, i)
  end
  tmp_coordinate_tab[1] = splittable(tmp_coordinate_tab[1], ",")
  tmp_coordinate_tab[2] = splittable(tmp_coordinate_tab[2], ",")
  local x_coo = tostring(math.ceil((tonumber(tmp_coordinate_tab[1][1]) + tonumber(tmp_coordinate_tab[2][1])) / 2))
  local y_coo = tostring(math.ceil((tonumber(tmp_coordinate_tab[1][2]) + tonumber(tmp_coordinate_tab[2][2])) / 2))
  return x_coo, y_coo
end
function GetAPI_getXpath(strCommand, flag)
  local start_time = GetAPI_OsClock()
  local ret, dump_content
  local command_tab = splittable(strCommand, ",")
  local value_table = GetAPI_att_cbt(command_tab[1])
  local rp_x, rp_y = 0, 0
  local direction = ""
  if flag ~= 3 then
    direction = command_tab[2]
    if string.lower(direction) == "ver" then
      direction = "0"
    elseif string.lower(direction) == "hor" or string.lower(direction) == "left" then
      direction = "1"
    elseif string.lower(direction) == "right" then
      direction = "2"
    elseif string.lower(direction) == "up" then
      direction = "3"
    elseif string.lower(direction) == "down" then
      direction = "4"
    end
  else
    tmp_table_rp = splittable(DScreen, "*")
    rp_x = tonumber(command_tab[2]) / tonumber(tmp_table_rp[1])
    rp_y = tonumber(command_tab[3]) / tonumber(tmp_table_rp[2])
  end
  while true do
    local end_clock = GetAPI_OsClock()
    if GetAPI_SubTime(end_clock, start_time) > tonumber(G_ClickTimeOut) then
      DebugLogId(string.format("%s??????????????!", tonumber(G_ClickTimeOut)))
      return -1, "", "-1", 0, 0, 0
    end
    local single_start_clock = GetAPI_OsClock()
    ret, dump_content = GetAPI_Dump(value_table)
    local single_end_clock = GetAPI_OsClock()
    local G_Imgtime = GetAPI_SubTime(single_end_clock, single_start_clock)
    DebugLogId("?????" .. G_Imgtime)
    if ret ~= -1 then
      local end_time = GetAPI_OsClock()
      local time_first = GetAPI_SubTime(end_time, start_time)
      DebugLogId("????????Xpath?????" .. time_first)
      local _, _, tmp_Xpath = string.find(dump_content, "xpath=\"(.-)\"")
      tmp_Xpath = string.gsub(string.gsub(tmp_Xpath, "%(", "\\("), "%)", "\\)")
      return ret, tmp_Xpath, direction, time_first, tostring(rp_x), tostring(rp_y)
    end
  end
end
function GetAPI_SetTask(ttid, flag)
  local Url = "a.netsense.cn/api/http/task_set"
  local httpmode = "POST"
  local body
  if flag == 0 then
    body = string.format("{\"ttid\":\"%s\",\"set_status\":\"start\"}", ttid)
  else
    body = string.format("{\"ttid\":\"%s\",\"set_status\":\"stop\"}", ttid)
  end
  local contect, host = GetAPI_URLCombination("POST", Url, body)
  local ret, _, _, _, _, _, _, _, _, _, bodyconcent = _cfunc.HttpClient2(host, contect)
  ret = ret == 6 and 0 or -1
  return ret
end
function GetAPI_DeviceStatus(imei)
  local Url = "a.netsense.cn/api/http/device_select"
  local httpmode = "POST"
  local body = string.format("{\"device_sn\":\"%s\"}", imei)
  local contect, host = GetAPI_URLCombination("POST", Url, body)
  local ret, ttid, Status, bodyconcent
  ret, _, _, _, _, _, _, _, _, _, bodyconcent = _cfunc.HttpClient2(host, contect)
  if ret == 6 then
    _, _, Status = string.find(bodyconcent, "\"status\":\"(%d-)\"")
    _, _, ttid = string.find(bodyconcent, "\"ttid\":\"(%d-)\"")
    return Status, ttid
  else
    return "-1", "-1"
  end
end
function GetAPI_URLSentSms(imei, sms)
  local Url = "a.netsense.cn/api/http/sent_sms"
  local httpmode = "POST"
  local body = string.format("{\"device_sn\":\"%s\",\"content\":\"%s\"}", imei, sms)
  local ret, bodyconcent
  local contect, host = GetAPI_URLCombination("POST", Url, body)
  ret, _, _, _, _, _, _, _, _, _, bodyconcent = _cfunc.HttpClient2(host, contect)
  if bodyconcent then
    DebugLogId("??????????????âÿ" .. bodyconcent)
  else
    DebugLogId("??????????????âÿnull")
  end
  ret = ret == 6 and 0 or 1
  return ret
end
function GetAPI_URLGetSms(imei, timeout)
  local Url = "a.netsense.cn/api/http/get_sms"
  local httpmode = "POST"
  local body = string.format("{\"device_sn\":\"%s\"}", imei)
  local ret, bodyconcent, res
  local contect, host = GetAPI_URLCombination("POST", Url, body)
  local startclock = GetAPI_OsClock()
  while true do
    if timeout < GetAPI_SubTime(GetAPI_OsClock(), startclock) then
      ret = -1
      break
    end
    res, _, _, _, _, _, _, _, _, _, bodyconcent = _cfunc.HttpClient2(host, contect)
    if res == 6 then
      DebugLogId("????????????âÿ" .. bodyconcent)
      _, _, ret = string.find(bodyconcent, "\"message\":\"(%-?%d-)\"")
      if ret then
        DebugLogId("??????????????????" .. ret)
      else
        DebugLogId("??????????????????nil")
      end
      ret = tonumber(ret)
      if ret == 0 or ret == -1 then
        break
      end
    else
      DebugLogId("????????????âÿnull")
    end
    GetAPI_Sleep(3)
  end
  return ret
end
function auto_PicReturn(ImgName, resx, resy)
  local x1, y1, x2, y2, retx, rety, ImgsTab, ImgFileName
  ImgsTab = splittable(ImgName, "_")
  x1 = tonumber(ImgsTab[1])
  y1 = tonumber(ImgsTab[2])
  x2 = tonumber(ImgsTab[3])
  y2 = tonumber(ImgsTab[4])
  retx = x2 - x1 + resx
  rety = y2 - y1 + resy
  ImgFileName = tostring(resx) .. "_" .. tostring(resy) .. "_" .. tostring(retx) .. "_" .. tostring(rety) .. "_android_" .. os.date("%Y%m%d%H%M%S") .. ".bmp"
  GetAPI_CaptureRectangle(G_SysScpPath .. G_Pflg .. ImgFileName)
  return ImgFileName
end
function GetAPI_auto_FileZIP()
  local lsret, FileName, FileALLName
  local FileList = {}
  local FileALLName = ""
  if G_EngineMode == "Android" then
    GetAPI_Deletefile(G_SysScpPath .. G_Pflg .. "script.zip")
    lsret = GetAPI_Command("ls " .. G_SysScpPath)
    lsret = string.gsub(lsret, "\r", "\n")
    lsret = string.gsub(lsret, "\n", "|")
    FileList = splittable(lsret, "|")
    for i, FileName in pairs(FileList) do
      if FileName ~= "temp.bmp" and FileName ~= "" then
        FileALLName = FileALLName .. G_SysScpPath .. G_Pflg .. FileName .. "|"
      end
    end
    DebugLogId("FileALLName:" .. FileALLName)
    GetAPI_Zip(G_SysScpPath .. G_Pflg .. "script.zip", FileALLName)
  else
    print("?????®¥???")
  end
end
function GetApi_inter(from_imei, to_imei, flag)
  local r1, r12, status, _
  local content = string.format("from_imei=%s&apikey=2dcbd425ce1d281865ebec6088125622&type=%s&to_imei=%s", from_imei, flag, to_imei)
  local PostUrl = "api.netsense.cn"
  local PostContent = string.format("POST /receive/phone HTTP/1.1\r\nHOST:api.netsense.cn\r\nAccpt:*/*\r\nContent-type:application/x-www-form-urlencoded\r\nContent-Length:%s\r\nConnection:Close\r\n\r\n%s", #content, content)
  DebugLogId(PostContent)
  for i = 1, 5 do
    r1, _, _, _, _, _, _, _, _, _, _, r12 = GetAPI_HttpClient(PostUrl, PostContent, PostUrl)
    DebugLogId("??" .. i .. "?¶≤?" .. r12)
    if string.find(r12, "\"status\":(%d+)") then
      _, _, status = string.find(r12, "\"status\":(%d+)")
      break
    end
  end
  return status, r12
end
function GetAPI_HttpVisit(url, TimeOut)
  local i, k, HUrl, DUrl, ret, r2, r3, r4, r5, r6, r7, r8, r9, head, body, all
  if string.find(url, "//") then
    k = string.find(url, "//")
    url = string.sub(url, k + 2, -1)
  end
  i = string.find(url, "/")
  if i then
    HUrl = string.sub(url, 1, i - 1)
    DUrl = string.format("GET /%s HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", string.sub(url, i + 1, -1), string.sub(url, 1, i - 1))
  else
    HUrl = url
    DUrl = string.format("GET / HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", url)
  end
  DebugLogId("???¶¬??????:" .. url)
  ret, r2, r3, r4, r5, r6, r7, r8, r9, head, body, all = GetAPI_HttpClient(HUrl, DUrl, url, TimeOut)
  return ret, r2, r3, r4, r5, r6, r7, r8, r9, head, body, all
end
function GetAPI_RecordScreenManager(seflg, frameRate, bitRate, process, recMode, landscape)
  local fpath = "/mnt/sdcard/RecordScreenManager/"
  local fname = string.format("%s_%s.mp4", G_FileDeviceName, G_Id:match(".*_%d?"))
  if seflg == "start" then
    pcall(function()
      _cfunc.LuaScriptJavaExec("com_autosense_extra_RecordScreenManager:getInstance():stopRecordScreen()")
    end)
    _cfunc.Command(string.format("mkdir -p %s", fpath))
    bitRate = bitRate or 1
    recMode = recMode or 1
    frameRate = frameRate or 5
    landscape = landscape or 2
    if not process then
      DebugLogId(string.format("?????????: ???: %s \t????: %sM \t?????: %s  (1:???0:???)\t%s\t?õ•°§??: %s", frameRate, bitRate, recMode, landscape == 1 and "1????" or "????", fpath))
    end
    UI_AutoClickOpen(nil, 7)
    _cfunc.Command(string.format("mkdir -p %s", fpath))
    bitRate = tonumber(bitRate) * 1024 * 1024 or 1048576
    _cfunc.LuaScriptJavaExec(string.format("com_autosense_extra_RecordScreenManager:getInstance():startRecordScreen(\"%s\",\"%s\",%s,%s,%s,%s)", fpath, fname, frameRate, bitRate, recMode, landscape))
    _cfunc.Sleep(3000)
  else
    local fpath = string.format("%s%sscreen%s", string.sub(G_SysDbgPath, 1, -2), G_Pflg, G_Pflg)
    if not process then
      DebugLogId(string.format("??????????: %s", fpath))
    end
    _cfunc.LuaScriptJavaExec("com_autosense_extra_RecordScreenManager:getInstance():stopRecordScreen()")
    _cfunc.Sleep(3000)
  end
end
function VoucRecordScreen(mflg)
  local fpath = "/mnt/sdcard/RecordScreenManager/"
  local pmfiles = getPathFiles(fpath)
  if #pmfiles > 0 then
    GetAPI_RecordScreenManager(nil, nil, nil, "process")
    _cfunc.Command(string.format("mkdir -p %sscreen", G_SysDbgPath))
    for k, v in pairs(pmfiles) do
      if string.find(v, "mp4") then
        local fpname = string.format("%s%s", fpath, v)
        local lfpname = string.format("%sscreen/%s", G_SysDbgPath, v)
        _cfunc.Command(string.format("cp %s %s", fpname, lfpname))
        DebugLogId(string.format("???????????: %s", lfpname))
      end
    end
    GetAPI_DeleteDir("/mnt/sdcard/RecordScreenManager/")
    _cfunc.Command("rm -rf /mnt/sdcard/RecordScreenManager/")
    if not mflg then
      GetAPI_RecordScreenManager("start", G_FrameRate, G_BitRate, "process")
    end
  end
end
function ATC_SetIni(atcId)
  if not G_WebTurl or not atcId then
    error("ATC Test Pram atcId or url err")
  end
  local atcurl = string.format("%s/uapi/agent/getAtc", G_WebTurl)
  local atcpost = string.format("{\"data\": {\"atcId\": %s}} ", atcId)
  local curlPath = (cmd_exists("curl") ~= 0 or not "curl") and File_Exists("/data/local/tmp/curl-7.40.0/bin/curl") and "/data/local/tmp/curl-7.40.0/bin/curl"
  local json = dofile(string.format("/data/local/tmp/c/mode/%s", "dkjson.lua"))
  local rate, loss, delay = 0, 0, 0
  if curlPath then
    local atcjson = _cfunc.Command(string.format("%s -d '%s' %s", curlPath, atcpost, atcurl))
    DebugLogId(string.format([[
ATCJSON GET :
%s]], atcjson))
    atcjson = atcjson:match("%b{}")
    atcjson = json.decode(atcjson)
    atcjson = json.encode(atcjson.data)
    atcjson = atcjson:gsub("\"", "\\\"")
    local atcshape = string.format("-H \"Content-Type: application/json\" -H \"Accept: application/json; indent=2\" -d \"%s\" http://192.168.0.1:8000/api/v1/shape/", atcjson)
    local shapestr = _cfunc.Command(string.format("%s %s", curlPath, atcshape))
    DebugLogId(string.format([[
add shape json ini
%s]], shapestr:match("%b{}")))
    local shapedjson = shapestr:match("%b{}")
    if shapedjson:match("down") and shapedjson:match("up") then
      G_ATCID = atcpost
    else
      DebugLogId(string.format([[
add shape json ini error !!! 
%s]], shapestr))
      error(string.format([[
add shape json ini error !!! 
%s]], shapestr))
    end
  end
  return rate, loss, delay
end
function ExecScriptJava(jclassName, pramsfmt)
  local javaExtra = string.format("com_autosense_extra_%s(%s)", jclassName, pramsfmt)
  DebugLogId(string.format("EXTRA_%s:(%s)", jclassName, pramsfmt or ""))
  local rets, prs = pcall(_cfunc.LuaScriptJavaExec, javaExtra)
  if not rets then
    DebugLogId(string.format("EXTRA_%s: %s", jclassName, tostring(prs)))
  end
end
MonEdt = "3.0.1"
function GetTestContent()
  local urlTab = {}
  local DLPath, DLID, a, ret, UrlList, Line, UrlLine, tempfalg, DLURL
  local Turl = "a.netsense.cn"
  local i, j, num, imei, concent, tempab, contou, Dlu, DEVICECODE
  local codetab = {
    "15067117690"
  }
  if string.upper(TestMode) == "MONITOR" then
    ret, DEVICECODE = Device_Rag()
    if ret == 0 then
      Turl = "autoapi.uusense.com"
      DLURL = string.format("GET /monitorapps/api/get_tasks?DEVICECODE=%s HTTP/1.1\r\nHOST:autoapi.uusense.com\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", DEVICECODE)
    else
      error("Device_Rag error...")
    end
  else
    a = string.find(G_Id, "_")
    DLID = string.sub(G_Id, 1, a - 1)
    DebugLogId("????ID:" .. DLID)
    DLURL = string.format("GET /apps/task_parameter?tid=%s HTTP/1.1\r\nHOST:a.netsense.cn\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", DLID)
    Dlu = string.format("a.netsense.cn/apps/task_parameter?tid=%s", DLID)
  end
  for k = 1, 5 do
    ret, _, _, _, _, _, _, _, _, contou, concent = GetAPI_HttpClient(Turl, DLURL, Dlu)
    if ret == 6 then
      break
    end
    GetAPI_Sleep(10)
  end
  DebugLogId("??????????:" .. ret)
  if concent then
    DebugLogId("????????" .. concent)
  end
  if ret ~= 6 then
    error("DownLoad error...")
  end
  tempab = splittable(concent, "\n")
  for jj = 1, #tempab do
    tempab[jj] = string.gsub(tempab[jj], " ", "")
    tempab[jj] = string.gsub(tempab[jj], "\r", "")
    if tempab[jj] ~= "----------" and tempab[jj] ~= "" and tempab[jj] ~= "notesttask" then
      DebugLogId("???????:" .. tempab[jj])
      table.insert(urlTab, tempab[jj])
    end
  end
  if #urlTab <= 0 then
    DebugLogId("????????...???????????????")
    error("DownLoad error...")
  end
  return urlTab
end
function Device_Rag()
  local ret, concent, Turl, DLURL, uploadinfo, DEVICECODE, DEVNETTYPE, PROVCODE, DEVICETYPE
  DebugLogId("?ıÙ?????")
  DEVICECODE = GetAPI_DevCode()
  uploadinfo = MakePattern(uploadinfo, "DEVICECODE:" .. DEVICECODE)
  DEVNETTYPE = GetAPI_NetFlag()
  uploadinfo = MakePattern(uploadinfo, "DEVNETTYPE:" .. DEVNETTYPE)
  PROVCODE = GetAPI_Location()
  uploadinfo = MakePattern(uploadinfo, "PROVCODE:" .. PROVCODE)
  DEVICETYPE = GetAPI_DevType()
  uploadinfo = MakePattern(uploadinfo, "DEVICETYPE:" .. DEVICETYPE)
  Turl = "autoapi.uusense.com"
  DLURL = string.format("GET /monitorapps/api/device_register HTTP/1.1\r\nHOST:autoapi.uusense.com\r\nAccpt:*/*\r\n%sContent-Length:0\r\nConnection:Close\r\n\r\n", uploadinfo)
  ret, _, _, _, _, _, _, _, _, _, concent = GetAPI_HttpClient(Turl, DLURL)
  DebugLogId(DLURL)
  DebugLogId("?ıÙ??????,???:" .. ret .. "\t0=???,6=???")
  DebugLogId(concent)
  if string.find(concent, "ok") then
    ret = 0
  else
    ret = -1
  end
  return ret, DEVICECODE
end
function Method_Monitor(DownUrl, DId, RawUrl)
  local ret
  local startclock = GetAPI_OsClock()
  if RawUrl then
    ret = Method_MonitorEx_Https(RawUrl, DId)
  else
    ret = Method_MonitorEx(DownUrl, DId)
  end
  local endclock = GetAPI_OsClock()
  local DelayTime = GetAPI_SubTime(endclock, startclock)
  local ResultTable = {}
  table.insert(ResultTable, "auto")
  table.insert(ResultTable, DelayTime)
  return ret, ResultTable
end
function Method_MonitorEx(DownUrl, DId)
  local i, HUrl, DUrl, Ttime, Dnstime, DnsIP, uploadinfo, DeviceCode, DevNetType, IPAddress, DeviceType, ProvCode
  local Result = 1
  local pingret, pingres, pingrett, ret, res, ree, conret, Fbtime, sendtime, DLName, DLret, Filesize, inp, Content, Contt
  local j = 1
  local k = 1
  local cc
  local etab = {
    "?????????",
    "????????????",
    "?????????????",
    "?????????",
    "??????",
    "????????",
    "???????",
    "???????",
    "?????????",
    "???????????????",
    "???????????????????????",
    "??????????????????????ß’???",
    "????????????",
    "??????????????????????",
    "System busy",
    "?????????"
  }
  local erflag, Header, HTTPReturn, num, dlrt, btcontent, allcontent, phonetype
  local dltype = "GET"
  local Turl = "autoapi.uusense.com"
  if DownUrl == "www.118100.cn" or DownUrl == "3g.118100.cn/?jump3g=100&st=p8_1A_0_3/3/0_dt_0" then
    phonetype = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 4.0.20506)"
  else
    phonetype = "Mozilla/5.0 Mobile"
  end
  uploadinfo = Get_DevicePram(DownUrl, DId)
  DebugLogId("?????????????????...")
  local hdlurl = string.format("GET /apps/postheader/get_header?domain_id=%s HTTP/1.1\r\nHOST:monitor.netsense.cn\r\nUser-Agent:Mozilla/5.0 Mobile\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", DId)
  local hdlret, hdlcont, Postflag
  for kk = 1, 3 do
    hdlret, _, _, _, _, _, _, _, _, _, hdlcont = GetAPI_HttpClient("monitor.netsense.cn", hdlurl)
    if tonumber(hdlret) == 6 then
      hdlcont = Strip(hdlcont)
      if hdlcont ~= "----------" then
        hdlcont = string.gsub(hdlcont, "----------", "")
        Postflag = true
      end
      break
    end
  end
  local hdtab
  local hdcont = ""
  if Postflag then
    hdlcont = Strip(hdlcont)
    if #hdlcont > 0 then
      dltype = "POST"
      hdlcont = string.gsub(hdlcont, " ", "")
      hdlcont = string.gsub(hdlcont, "\r\n", "\r")
      hdlcont = string.gsub(hdlcont, "\n", "\r")
      hdtab = splittable(hdlcont, "\r")
      for kk = 1, #hdtab do
        hdcont = hdcont .. hdtab[kk] .. "\r\n"
      end
      if G_CMReadJSESSIONID then
        _, _, cc = string.find(hdcont, "JSESSIONID[^%w]*(%w+)")
        if cc then
          hdcont = string.gsub(hdcont, cc, G_CMReadJSESSIONID)
        end
      end
      if G_CMReadtokenId then
        _, _, cc = string.find(hdcont, "tokenId[^%w]*(%w+)")
        if cc then
          hdcont = string.gsub(hdcont, cc, G_CMReadtokenId)
        end
      end
    end
  end
  i = string.find(DownUrl, "/")
  if i then
    HUrl = string.sub(DownUrl, 1, i - 1)
    DUrl = string.format("%s /%s HTTP/1.1\r\nHOST:%s\r\nUser-Agent:%s\r\nAccpt:*/*\r\n%sContent-Length:0\r\nConnection:Close\r\n\r\n", dltype, string.sub(DownUrl, i + 1, -1), string.sub(DownUrl, 1, i - 1), phonetype, hdcont)
  else
    HUrl = DownUrl
    DUrl = string.format("%s / HTTP/1.1\r\nHOST:%s\r\nUser-Agent:%s\r\nAccpt:*/*\r\n%sContent-Length:0\r\nConnection:Close\r\n\r\n", dltype, DownUrl, phonetype, hdcont)
  end
  DebugLogId("???????:" .. DownUrl)
  DebugLogId("HUrl:" .. HUrl)
  DebugLogId("DUrl:" .. DUrl)
  DebugLogId("???????...")
  for k = 1, 2 do
    dlrt, Ttime, Dnstime, conret, sendtime, Fbtime, DLret, IPAddress, DnsIP, Content, btcontent, allcontent = GetAPI_HttpClient(HUrl, DUrl, DownUrl)
    DebugLogId("???????...")
    uploadinfo = MakePattern(uploadinfo, "IPAddress:" .. IPAddress)
    num = GetAPI_MobileNum()
    if num == "" then
      num = "0"
    end
    uploadinfo = MakePattern(uploadinfo, "DLRET:" .. dlrt)
    uploadinfo = MakePattern(uploadinfo, "PHONENUMBER:" .. num)
    uploadinfo = MakePattern(uploadinfo, "DNS:" .. DnsIP)
    uploadinfo = MakePattern(uploadinfo, "HTTPCONNECT:" .. conret)
    if tonumber(Dnstime) and tonumber(conret) and tonumber(sendtime) and tonumber(Fbtime) and tonumber(DLret) then
      DLret = tonumber(Dnstime) + tonumber(conret) + tonumber(sendtime) + tonumber(Fbtime) + tonumber(DLret)
    else
      DLret = 0
    end
    uploadinfo = MakePattern(uploadinfo, "HTTPDELAY:" .. DLret)
    uploadinfo = MakePattern(uploadinfo, "HTTPFRISTTIME:" .. Fbtime)
    if tonumber(dlrt) == 6 then
      _, _, HTTPReturn = string.find(Content, "[Hh][Tt][Tt][Pp][/][^ ]*[ ]*(%w+)")
    else
      HTTPReturn = "000"
    end
    if HTTPReturn ~= "000" then
      break
    end
  end
  HTTPReturn = HTTPReturn or "001"
  if btcontent then
    _, _, cc = string.find(btcontent, "JSESSIONID[^%w]*(%w+)")
    if cc then
      G_CMReadJSESSIONID = cc
    end
    _, _, cc = string.find(btcontent, "tokenId[^%w]*(%w+)")
    if cc then
      G_CMReadtokenId = cc
    end
  end
  uploadinfo = MakePattern(uploadinfo, "HTTPRETURN:" .. HTTPReturn)
  Header = string.gsub(Content, "\r\n", "#uusense#")
  Header = string.gsub(Header, "\n", "#uusense#")
  Header = string.gsub(Header, "\r", "#uusense#")
  uploadinfo = MakePattern(uploadinfo, "HEADER:" .. Header)
  Filesize = string.len(allcontent)
  uploadinfo = MakePattern(uploadinfo, "FILESIZE:" .. Filesize)
  DebugLogId("????????????????...")
  DebugLogId("??????:" .. HTTPReturn)
  if not HTTPReturn then
    Result = 1
  elseif string.sub(HTTPReturn, 1, 1) == "4" or string.sub(HTTPReturn, 1, 1) == "5" or string.sub(HTTPReturn, 1, 1) == "7" then
    Result = 2
  elseif string.sub(HTTPReturn, 1, 1) == "3" then
    Result = 0
  elseif HTTPReturn == "000" or HTTPReturn == "001" then
    Result = 2
  else
    Contt = allcontent
    while j <= #etab do
      if string.find(Contt, etab[j]) then
        erflag = true
        break
      end
      j = j + 1
    end
    if erflag then
      Result = 2
    elseif Filesize == 0 then
      Result = 2
    else
      Result = 0
    end
  end
  if Result == 2 then
    if HTTPReturn == "000" then
      local dlrt1
      dlrt1 = GetAPI_HttpClient("www.baidu.com", "GET / HTTP/1.1\r\nHOST:www.baidu.com\r\nUser-Agent:Mozilla/5.0 Mobile\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", "www.baidu.com")
      if tonumber(dlrt1) == 6 then
        Result = 2
      else
        Result = 1
      end
    end
    ree, pingrett = GetAPI_PingInfo(HUrl, 3, 32)
    DebugLogId("PING:" .. HUrl .. "...?????:" .. pingrett)
    ret, pingret = GetAPI_PingInfo("3g.baidu.com", 3, 32)
    DebugLogId("PING???...?????:" .. pingret)
    res, pingres = GetAPI_PingInfo("3g.qq.com", 3, 32)
    DebugLogId("PINGQQ...?????:" .. pingres)
    ret = CheckPingRes(pingret, 3)
    res = CheckPingRes(pingres, 3)
    if HTTPReturn ~= "000" then
      if ret == 0 or res == 0 then
        Result = 2
      else
        Result = 1
      end
    end
    uploadinfo = MakePattern(uploadinfo, "PING:" .. HUrl .. "|" .. pingrett .. ",3g.baidu.com|" .. pingret .. ",3g.qq.com|" .. pingres)
  elseif Result == 0 and conret > 5000 then
    ree, pingrett = GetAPI_PingInfo(HUrl, 3, 32)
    DebugLogId("PING:" .. HUrl .. "...?????:" .. pingrett)
    ret, pingret = GetAPI_PingInfo("3g.baidu.com", 3, 32)
    DebugLogId("PING???...?????:" .. pingret)
    res, pingres = GetAPI_PingInfo("3g.qq.com", 3, 32)
    DebugLogId("PINGQQ...?????:" .. pingres)
    uploadinfo = MakePattern(uploadinfo, "PING:" .. HUrl .. "|" .. pingrett .. ",3g.baidu.com|" .. pingret .. ",3g.qq.com|" .. pingres)
    ret = CheckPingRes(pingret, 3)
    res = CheckPingRes(pingres, 3)
    if ret == -2 or res == -2 then
      Result = 1
    else
      Result = 4
    end
  end
  DebugLogId("???¶¬??????...??????:" .. Result)
  uploadinfo = MakePattern(uploadinfo, "RESULT:" .. Result)
  uploadinfo = string.format("POST /monitorapps/api/put_result HTTP/1.1\r\nHOST:autoapi.uusense.com\r\nAccpt:*/*\r\n%sContent-Length:0\r\nConnection:Close\r\n\r\n", uploadinfo)
  DebugLogId("???????????...")
  GetAPI_HttpClient("autoapi.uusense.com", uploadinfo)
  DebugLogId("??????????????...")
  return 0
end
function Method_MonitorEx_Https(RawUrl, DId)
  local Httpsflag = 1
  local Turl = "autoapi.uusense.com"
  local uploadinfo
  local Result = 1
  local errflgtab = {
    "?????????",
    "????????????",
    "?????????????",
    "?????????",
    "??????",
    "????????",
    "???????",
    "???????",
    "?????????",
    "???????????????",
    "???????????????????????",
    "??????????????????????ß’???",
    "????????????",
    "??????????????????????",
    "System busy",
    "?????????"
  }
  uploadinfo = Get_DevicePram(RawUrl, DId)
  DebugLogId("???????????????????...")
  local hesderpath = string.format("/monitorapps/postheader/get_header?domain_id=%s", DId)
  local hdlret, header_cont = Get_MonitorPram(Turl, hesderpath, Httpsflag)
  DebugLogId("?????????????:\t" .. header_cont)
  DebugLogId("????????????????????...")
  local bodypath = string.format("/monitorapps/postheader/get_body?domain_id=%s", DId)
  local hdlret, body_cont = Get_MonitorPram(Turl, bodypath, Httpsflag)
  DebugLogId("?????????????:\t" .. body_cont)
  DebugLogId(string.format("???????(%s): %s", DId, RawUrl))
  local HTTPReturn, Filesize, Ttime, Dnstime, conret, sendtime, Fbtime, DLret, IPAddress, DnsIP, Content, btcontent, allcontent = GetAPI_HttpsClient(RawUrl, header_cont, body_cont)
  Ttime = Ttime or os.date()
  DebugLogId("???????..." .. Ttime)
  uploadinfo = MakePattern(uploadinfo, "IPAddress:" .. IPAddress)
  uploadinfo = MakePattern(uploadinfo, "DLRET:" .. 6)
  local num = GetAPI_MobileNum()
  if num == "" then
    num = "0"
  end
  uploadinfo = MakePattern(uploadinfo, "PHONENUMBER:" .. num)
  uploadinfo = MakePattern(uploadinfo, "DNS:" .. DnsIP)
  uploadinfo = MakePattern(uploadinfo, "HTTPCONNECT:" .. conret)
  uploadinfo = MakePattern(uploadinfo, "HTTPDELAY:" .. DLret)
  uploadinfo = MakePattern(uploadinfo, "HTTPFRISTTIME:" .. Fbtime)
  if btcontent then
    _, _, cc = string.find(btcontent, "JSESSIONID[^%w]*(%w+)")
    if cc then
      G_CMReadJSESSIONID = cc
    end
    _, _, cc = string.find(btcontent, "tokenId[^%w]*(%w+)")
    if cc then
      G_CMReadtokenId = cc
    end
  end
  uploadinfo = MakePattern(uploadinfo, "HTTPRETURN:" .. HTTPReturn)
  local Header = Content:gsub("\r\n", "#uusense#"):gsub("\n", "#uusense#"):gsub("\r", "#uusense#")
  uploadinfo = MakePattern(uploadinfo, "HEADER:" .. Header)
  uploadinfo = MakePattern(uploadinfo, "FILESIZE:" .. Filesize)
  DebugLogId("????????????????...")
  DebugLogId(string.format([[
uploadinfo: 
%s]], uploadinfo))
  DebugLogId("??????:" .. HTTPReturn)
  if not HTTPReturn then
    Result = 1
  elseif string.sub(HTTPReturn, 1, 1) == "4" or string.sub(HTTPReturn, 1, 1) == "5" or string.sub(HTTPReturn, 1, 1) == "7" then
    Result = 2
  elseif string.sub(HTTPReturn, 1, 1) == "3" then
    Result = 0
  elseif HTTPReturn == "000" or HTTPReturn == "001" then
    Result = 2
  else
    local Contt = allcontent
    local erflag = false
    for i = 1, #errflgtab do
      if string.find(Contt, errflgtab[i]) then
        erflag = true
        break
      end
    end
    Result = erflag and 2 or 0
  end
  if Result == 2 then
    if HTTPReturn == "000" then
      local dlrt1
      dlrt1 = GetAPI_HttpClient("www.baidu.com", "GET / HTTP/1.1\r\nHOST:www.baidu.com\r\nUser-Agent:Mozilla/5.0 Mobile\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", "www.baidu.com")
      if tonumber(dlrt1) == 6 then
        Result = 2
      else
        Result = 1
      end
    end
    local ree, pingrett = GetAPI_PingInfo(HUrl, 3, 32)
    DebugLogId("PING:" .. HUrl .. "...?????:" .. pingrett)
    local ret, pingret = GetAPI_PingInfo("3g.baidu.com", 3, 32)
    DebugLogId("PING???...?????:" .. pingret)
    local res, pingres = GetAPI_PingInfo("3g.qq.com", 3, 32)
    DebugLogId("PINGQQ...?????:" .. pingres)
    local ret = CheckPingRes(pingret, 3)
    local res = CheckPingRes(pingres, 3)
    if HTTPReturn ~= "000" then
      if ret == 0 or res == 0 then
        Result = 2
      else
        Result = 1
      end
    end
    uploadinfo = MakePattern(uploadinfo, "PING:" .. HUrl .. "|" .. pingrett .. ",3g.baidu.com|" .. pingret .. ",3g.qq.com|" .. pingres)
  elseif Result == 0 and tonumber(conret) > 5000 then
    local ree, pingrett = GetAPI_PingInfo(HUrl, 3, 32)
    DebugLogId("PING:" .. HUrl .. "...?????:" .. pingrett)
    local ret, pingret = GetAPI_PingInfo("3g.baidu.com", 3, 32)
    DebugLogId("PING???...?????:" .. pingret)
    local res, pingres = GetAPI_PingInfo("3g.qq.com", 3, 32)
    DebugLogId("PINGQQ...?????:" .. pingres)
    uploadinfo = MakePattern(uploadinfo, "PING:" .. HUrl .. "|" .. pingrett .. ",3g.baidu.com|" .. pingret .. ",3g.qq.com|" .. pingres)
    local ret = CheckPingRes(pingret, 3)
    local res = CheckPingRes(pingres, 3)
    if ret == -2 or res == -2 then
      Result = 1
    else
      Result = 4
    end
  end
  DebugLogId("???¶¬??????...??????:" .. Result)
  uploadinfo = MakePattern(uploadinfo, "RESULT:" .. Result)
  uploadinfo = string.format("POST /monitorapps/api/put_result HTTP/1.1\r\nHOST:%s\r\nAccpt:*/*\r\n%sContent-Length:0\r\nConnection:Close\r\n\r\n", Turl, uploadinfo)
  DebugLogId("???????????...")
  GetAPI_HttpClient(Turl, uploadinfo)
  DebugLogId("??????????????..." .. Turl)
  return 0
end
function Get_DevicePram(Url, DId)
  local uploadinfo, DeviceCode, DevNetType, DeviceType, ProvCode
  uploadinfo = MakePattern(uploadinfo, "DOMAINID:" .. DId)
  uploadinfo = MakePattern(uploadinfo, "Domain:" .. Url)
  DeviceCode = GetAPI_DevCode()
  uploadinfo = MakePattern(uploadinfo, "DEVICECODE:" .. DeviceCode)
  DevNetType = GetAPI_NetFlag()
  uploadinfo = MakePattern(uploadinfo, "DEVNETTYPE:" .. DevNetType)
  DeviceType = GetAPI_DevType()
  uploadinfo = MakePattern(uploadinfo, "DEVICETYPE:" .. DeviceType)
  ProvCode = GetAPI_Location()
  uploadinfo = MakePattern(uploadinfo, "PROVCODE:" .. ProvCode)
  DebugLogId("????ıÙ???????...")
  return uploadinfo
end
function Get_MonitorPram(Turl, pathurl, Httpsflag)
  local hdlurl = string.format("GET %s HTTP/1.1\r\nHOST:%s\r\nUser-Agent:Mozilla/5.0 Mobile\r\nAccpt:*/*\r\nContent-Length:0\r\nConnection:Close\r\n\r\n", pathurl, Turl)
  local hdlret, hdlcont, Postflag
  for kk = 1, 3 do
    hdlret, _, _, _, _, _, _, _, _, _, hdlcont = GetAPI_HttpClient(Turl, hdlurl)
    if tonumber(hdlret) == 6 then
      hdlcont = Strip(hdlcont)
      if hdlcont ~= "----------" then
        hdlcont = string.gsub(hdlcont, "----------", "")
        Postflag = true
      end
      break
    end
  end
  if Httpsflag then
    hdlcont = string.gsub(hdlcont, "\n", "")
    hdlcont = string.gsub(hdlcont, "%-", "", 10)
    hdlcont = string.gsub(hdlcont, "\r", "")
    hdlcont = string.gsub(hdlcont, " ", "")
  end
  return hdlret, hdlcont, Postflag
end
function GetAPI_HttpsClient(RawUrl, header, body)
  local retvalue, retcontent = Curl_HttpsClient(RawUrl, header, body)
  local httptb = splittable(retvalue, ":")
  local HTTPReturn = httptb[1]
  local IPAddress = httptb[13]
  local DnsIP = httptb[12]
  local conret = httptb[6] * 1000
  local DLret = httptb[3] * 1000
  local Filesize = httptb[15]
  local Fbtime = httptb[8] * 1000
  local Dnstime = httptb[4] * 1000
  local sendtime = httptb[3] * 1000 - httptb[4] * 1000 - httptb[5] * 1000
  DebugLogId(string.format("??????%s", HTTPReturn))
  DebugLogId(string.format("HTTP????????%s ms", conret))
  DebugLogId(string.format("????????%s ms", DLret))
  DebugLogId(string.format("?????ß≥??%s", Filesize))
  DebugLogId(string.format("IP?????%s", IPAddress))
  DebugLogId(string.format("DNS?????%s", DnsIP))
  DebugLogId(string.format("DNS??????%s ms", Dnstime))
  DebugLogId(string.format("???????%s ms", sendtime))
  DebugLogId(string.format("retcontent ??%s ", retcontent))
  local Content = retcontent:match("(.*)\r\n\r\n")
  local btcontent = retcontent:match("\r\n\r\n(.*)")
  local allcontent = retcontent
  return HTTPReturn, Filesize, Ttime, Dnstime, conret, sendtime, Fbtime, DLret, IPAddress, DnsIP, Content, btcontent, allcontent
end
function Curl_HttpsClient(pramurl, header, body)
  local curlPathstr
  if File_Exists("/data/local/tmp/curl-7.40.0/bin/curl") then
    curlPathstr = "/data/local/tmp/curl-7.40.0/bin/curl"
  elseif cmd_exists("curl") == 0 then
    DebugLogId(string.format("?????Autosense¶ƒ???curl??ÔÖ????????????ÔÖ??????ß”??????????"))
    curlPathstr = "curl"
  else
    error("not found curl exit !! ")
  end
  _cfunc.Command(string.format("am force-stop %s", curlPathstr))
  local curlpram = con_pram()
  curlPram = string.format("-s -w \"ZXYXDTEST\"%s", curlpram)
  DebugLogId(string.format([[
header.parm:
%s]], header))
  DebugLogId(string.format([[
body.parm:
%s]], body))
  if header ~= "" then
    curlPram = string.format("%s -H \"%s\"", curlPram, header)
  end
  if body ~= "" then
    curlPram = string.format("%s -X POST -d '%s'", curlPram, body)
  end
  curlPram = string.format("%s %s -i %s -k", curlPathstr, curlPram, pramurl)
  DebugLogId(string.format("curl(https): %s", curlPram))
  local testlog = _cfunc.Command(curlPram)
  local httpvalue = testlog:match("ZXYXDTEST(.*)")
  local httpret = testlog:match("(.*)ZXYXDTEST")
  DebugLogId("????????" .. httpvalue)
  DebugLogId("??????âÿ" .. httpret)
  return httpvalue, httpret
end
function con_pram()
  local curlpram = string.format("%s", "%{http_code}")
  curlpram = string.format("%s:%s", curlpram, "%{content_type}")
  curlpram = string.format("%s:%s", curlpram, "%{time_total}")
  curlpram = string.format("%s:%s", curlpram, "%{time_namelookup}")
  curlpram = string.format("%s:%s", curlpram, "%{time_connect}")
  curlpram = string.format("%s:%s", curlpram, "%{time_appconnect}")
  curlpram = string.format("%s:%s", curlpram, "%{time_pretransfer}")
  curlpram = string.format("%s:%s", curlpram, "%{time_starttransfer}")
  curlpram = string.format("%s:%s", curlpram, "%{size_request}")
  curlpram = string.format("%s:%s", curlpram, "%{size_header}")
  curlpram = string.format("%s:%s", curlpram, "%{time_redirect}")
  curlpram = string.format("%s:%s", curlpram, "%{remote_ip}")
  curlpram = string.format("%s:%s", curlpram, "%{local_ip}")
  curlpram = string.format("%s:%s", curlpram, "%{scheme}")
  curlpram = string.format("%s:%s", curlpram, "%{size_download}")
  curlpram = string.format("%s:%s", curlpram, "%{speed_download}")
  curlpram = string.format("%s:%s", curlpram, "%{ssl_verify_result}")
  curlpram = string.format("%s:%s", curlpram, "%{url_effective}")
  return curlpram
end
function UU_HttpMain(hturl, httype, pramStr, pramType, regexs)
  local function sendHttp(hurl, sendata, stype)
    local curlp = "/data/local/tmp/curl-7.40.0/bin"
    DebugLogId(string.format("??????: %s", hurl))
    local urlexc = ""
    if string.lower(stype) == "post" then
      DebugLogId(string.format("????????: %s", sendata))
      urlexc = string.format("%s/curl -X POST -d \"%s\" -k %s", curlp, sendata, hurl)
    else
      DebugLogId(string.format("????????: %s", sendata))
      urlexc = string.format("%s/curl -d \"%s\" -k %s", curlp, sendata, hurl)
    end
    DebugLogId(string.format("curl????: %s", urlexc))
    local httpstr = _cfunc.Command(urlexc)
    return httpstr
  end
  local function getsdata(httype, pramStr, pramType)
    pramType = string.lower(pramType)
    httype = string.lower(httype)
    if httype == "get" then
      pramType = "text" or pramType
    end
    if pramType == "xml" then
      return string.format("%s", pramStr)
    elseif pramType == "text" then
      return string.format("%s", pramStr)
    elseif pramType == "json" then
      return string.format("{%s}", pramStr)
    end
  end
  local sendata = getsdata(httype, pramStr, pramType)
  DebugLogId(string.format("???????: %s", sendata))
  DebugLogId(string.format("ßµ??????: %s", regexs))
  local httplog = sendHttp(hturl, sendata, httype)
  if httplog and httplog ~= "" then
    DebugLogId(string.format("httplog:%s", httplog))
    if regexs == "???ßµ?????" or regexs == "" then
      DebugLogId("????ßµ??!")
      return 0
    elseif string.find(httplog, regexs) then
      DebugLogId("?????????!")
      return 0
    else
      return -1
    end
  else
    DebugLogId("http?????")
    return -1
  end
end
function url_overview(logdata, userurl, json)
  DebugLogId(string.format("packetdata[%s] to overview : %s", #logdata, userurl))
  local overview = _xsplit(logdata, "{\"overview")
  for k, v in ipairs(overview) do
    overview[k] = "{\"overview" .. v
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
function MG_CheckEKV(retlog, UEKVstr, EIDstr)
  local getUKV = function(EKVstr)
    local i = 0
    local EKVstrtb = {}
    for k, v in EKVstr:gmatch(",?(%w+[%p]?%w+):(%w+)") do
      EKVstrtb[k] = v
      i = i + 1
    end
    return EKVstrtb, i
  end
  local pairstb = function(k, usertb)
    for i, v in pairs(usertb) do
      if i == k then
        return v
      end
    end
    return nil
  end
  local ret = -1
  local EKVstrtb, ui = getUKV(UEKVstr)
  if retlog.msg.Events then
    DebugLogId(string.format("Events OK, check EID"))
    if retlog.msg.Events[1].EID == EIDstr then
      DebugLogId(string.format("EID OK, ???ßµ?? EKV?: %s", UEKVstr))
      if retlog.msg.Events[1].TDT then
        local ki = 0
        for k, v in pairs(retlog.msg.Events[1].TDT) do
          if type(v) == "table" then
            local mgv = pairstb(v.EK, EKVstrtb)
            if mgv then
              local equal, eret = "??", "false"
              if mgv == v.EV then
                ki = ki + 1
                equal, eret = "==", "OK"
              end
              DebugLogId(string.format("User check  [%s] ? [%s] --> result [UV:%s %s EV:%s]\t%s", v.EK, mgv, mgv, equal, v.EV, eret))
            end
            if ki == ui then
              break
            end
          end
        end
        if ki ~= ui then
          return 1
        end
        if ki == ui then
          return 0
        end
      else
        DebugLogId("??????????[msg][Events][1][TDT]??")
      end
    else
      DebugLogId("¶ƒ??[msg][Events][1][EID]???????: " .. EIDstr)
    end
  else
    DebugLogId("?? [msg][Events][1][EID]??????????ßµ??")
  end
  return ret
end
function mgkv_HttpMain(cmddurl, scstr)
  local json = dofile(string.format("/data/local/tmp/c/mode/%s", "dkjson.lua"))
  local getpkglog = function(pktf)
    local files = io.open(pktf, "rb")
    local fdata = files:read("*all")
    files:close()
    local file = io.open("/mnt/sdcard/packet_log.txt", "a+")
    file:write(fdata .. "\n")
    file:close()
    return fdata
  end
  local function uncode_mgdata(hturl, urlpacket, type)
    local curlp = "/data/local/tmp/curl-7.40.0/bin"
    DebugLogId(string.format("?????????: %s", hturl))
    local urlexc = ""
    if type then
      local postdata = ""
      for k, v in pairs(urlpacket["postdata params"]) do
        postdata = string.format("%s\"%s\":\"%s\",", postdata, k, v)
      end
      DebugLogId(string.format("????????: {%s}", sendata))
      urlexc = string.format("%s/curl -s -X POST -d '{%s}' %s", curlp, postdata, hturl)
    else
      if not urlpacket["postdata params"].data then
        return "nil"
      end
      local getdata = ""
      for k, v in pairs(urlpacket["postdata params"]) do
        getdata = string.format("%s%s=%s&", getdata, k, v)
      end
      DebugLogId(string.format("????????: {%s}", getdata:sub(1, -2)))
      urlexc = string.format("%s/curl -s -d \"%s\" %s", curlp, getdata:sub(1, -2), hturl)
    end
    DebugLogId(string.format("????????:%s", urlexc))
    local httpstr = _cfunc.Command(urlexc)
    DebugLogId(string.format("????logs: \n%s", httpstr))
    if #httpstr < 6 then
      DebugLogId(string.format([[
ret: 
%s]], httpstr or "nil"))
      httpstr = httpstr or "{Command return nil}"
    end
    local retpram = httpstr:match("{.*}") or "nil"
    DebugLogId(string.format("????????: \n%s", retpram))
    G_mgScriptFlg.RESPONSE = _cfunc.Utf8ToGbk(retpram)
    DebugLogId("?????????????????<RESPONSE>")
    return retpram
  end
  local version = _cfunc.Command(string.format("dumpsys package %s |grep '%s'", "com.forys.network", "versionName"))
  local installTime = _cfunc.Command(string.format("dumpsys package %s |grep '%s'", "com.forys.network", "firstInstallTime"))
  DebugLogId(string.format("[network].version: %s  installtime: %s", version:gsub("\n", ""), installTime))
  local function httpPKstr(urlpacket, enurl, EKVstr, EIDstr)
    local httpstr = "nil"
    for i = #urlpacket, 1, -1 do
      if urlpacket[i] and urlpacket[i]["postdata params"] then
        httpstr = uncode_mgdata(enurl, urlpacket[i]) or "nil"
        if httpstr ~= "nil" then
          if httpstr:match("Events") then
            local httplog = json.decode(httpstr)
            local mgret = MG_CheckEKV(httplog, EKVstr, EIDstr)
            DebugLogId(string.format("Check[%s] EKV str : %s", i, mgret))
            httpstr = mgret
          else
            DebugLogId(string.format("?? [msg][Events][1][EID]??????????ßµ??:\n%s", httpstr))
          end
        end
        if httpstr == 0 then
          return 0
        end
      else
        return "nil"
      end
      _cfunc.Sleep(500)
    end
    return httpstr
  end
  scstr = scstr:gsub("%s", "")
  local regex_rules = scstr:match("%b''") or ""
  DebugLogId(string.format("find regex rules value : [%s]", regex_rules))
  local EIDstr = regex_rules:match("EID%p(.-),")
  if not EIDstr then
    DebugLogId(string.format("not found EID, ????: %s", regex_rules))
    return 1
  end
  local EKVstr = regex_rules:match(string.format("%s,(.*)'", EIDstr))
  if not EKVstr then
    DebugLogId(string.format("not found User kv, ????: %s", regex_rules))
    return 1
  end
  local pktf = "/mnt/sdcard/packet.log"
  local enurl = G_mgKVENURL or "nil"
  local userurl = cmddurl or "nil"
  local httpstr = "nil"
  for i = 1, 3 do
    _cfunc.Sleep(3000)
    if not File_Exists(pktf) then
      local lslogtmp = _cfunc.Command("ls /mnt/sdcard/ -l |grep log")
      DebugLogId(string.format("¶ƒ??????????? (???????????????????): \n%s", lslogtmp))
      return 1
    end
    local logdata = getpkglog(pktf)
    local urlpacket = url_overview(logdata, userurl, json)
    DebugLogId(string.format("???packet,????? url.view: %s ??", #urlpacket or ""))
    httpstr = httpPKstr(urlpacket, enurl, EKVstr, EIDstr)
    if httpstr == "nil" then
      local psnettmp = _cfunc.Command("ps |grep com.forys.network")
      DebugLogId(string.format("send postdata is null, ????: %s:%s", pktf, psnettmp))
      httpstr = -1
    elseif httpstr == 0 then
      break
    elseif httpstr == 1 then
      break
    elseif httpstr == -1 then
      DebugLogId(string.format("¶ƒ???? EID: %s?????", EIDstr))
    end
  end
  DebugLogId(string.format("-- MG [%s] EKV check done : %s   (0:?????????:?????) --", EIDstr, httpstr))
  return httpstr
end
function _rmRepeat(str_tb)
  local tmp = {}
  for k, v in pairs(str_tb) do
    tmp[v] = true
  end
  local str_tb = {}
  for key, val in pairs(tmp) do
    table.insert(str_tb, key)
  end
  return str_tb
end
function new_proce_dumps(nfname, regkey)
  local function process_dumpurls(filename)
    local tcpdps = _cfunc.Command("ps|grep tcpdump")
    DebugLogId(tcpdps)
    DebugLogId(filename)
    local ofname = filename
    local myfile, e = io.open(ofname, "rb")
    if nil == myfile then
      DebugLogId(string.format("opened file fail,err:%s", e))
      _cfunc.Sleep(1000)
      local tcpdls = _cfunc.Command(string.format("ls /data/local/tmp/ -l"))
      DebugLogId(string.format([[
ls /data/local/tmp/ :
%s]], tcpdls))
      return
    end
    local all_lines = myfile:read("*all")
    myfile:close()
    DebugLogId(string.format("cat file : \t%s", ofname))
    local all_tb = _xsplit(all_lines, [[

	
]])
    DebugLogId(string.format("all_tb file : %s", #all_tb))
    local tmp_dumps = {}
    for i, v in pairs(all_tb) do
      table.insert(tmp_dumps, v)
    end
    local all_dumps = {}
    for k, v in pairs(tmp_dumps) do
      local uris, host = v:match("GET%s(/.-)%s.*Host:%s(.-)%c")
      if uris and host then
        table.insert(all_dumps, host .. uris)
      else
      end
    end
    return all_dumps
  end
  local regkey_or = function(all_dumps, regkey)
    local dumps_or = {}
    local regkey_fmt = _xsplit(regkey, "|")
    for k, v in pairs(all_dumps) do
      for s, t in pairs(regkey_fmt) do
        t = t:gsub("%.", "%%."):gsub("%?", "%%?")
        if v:match(t) then
          table.insert(dumps_or, v)
          break
        end
      end
    end
    return dumps_or
  end
  local regkey_and = function(all_dumps, regkey)
    local dumps_and = {}
    local regkey_fmt = _xsplit(regkey, "&")
    for k, v in pairs(all_dumps) do
      local flg = true
      for s, t in pairs(regkey_fmt) do
        t = t:gsub("%.", "%%."):gsub("%?", "%%?")
        if not v:match(t) then
          flg = false
          break
        end
      end
      if flg then
        table.insert(dumps_and, v)
      end
    end
    return dumps_and
  end
  local regkey_out = function(all_dumps, regkey)
    local dumps_and = {}
    local regkey_fmt = _xsplit(regkey, ",")
    for k, v in pairs(all_dumps) do
      local flg = true
      for s, t in pairs(regkey_fmt) do
        t = t:gsub("%.", "%%."):gsub("%?", "%%?")
        if v:match(t) then
          flg = false
          break
        end
      end
      if flg then
        table.insert(dumps_and, v)
      end
    end
    return dumps_and
  end
  if regkey.regex then
    local all_dumps = process_dumpurls(nfname)
    if not all_dumps then
      return -1
    end
    DebugLogId(string.format("??????%s??????", #all_dumps))
    local dump_regkey
    if regkey.regex and regkey.regex:match("|") then
      DebugLogId("process or >>> " .. regkey.regex)
      local regkey = regkey.regex
      dump_regkey = regkey_or(all_dumps, regkey)
    elseif regkey.regex and regkey.regex:match("&") then
      DebugLogId("process and >>> " .. regkey.regex)
      local regkey = regkey.regex
      dump_regkey = regkey_and(all_dumps, regkey)
    elseif regkey.regex then
      DebugLogId("def process or >>> " .. regkey.regex)
      local regkey = regkey.regex
      dump_regkey = regkey_or(all_dumps, regkey)
    end
    if regkey.regex then
      DebugLogId(string.format("????[regex]??????????%s??", #dump_regkey))
    end
    all_dumps = regkey.extra and dump_regkey or all_dumps
    if regkey.extra and regkey.extra:match("|") then
      DebugLogId("process or >>> " .. regkey.extra)
      local regkey = regkey.extra
      dump_regkey = regkey_or(all_dumps, regkey)
    elseif regkey.extra and regkey.extra:match("&") then
      DebugLogId("process and >>> " .. regkey.extra)
      local regkey = regkey.extra
      dump_regkey = regkey_and(all_dumps, regkey)
    elseif regkey.extra then
      DebugLogId("def process or >>> " .. regkey.extra)
      local regkey = regkey.extra
      dump_regkey = regkey_or(all_dumps, regkey)
    end
    if regkey.extra then
      DebugLogId(string.format("????[extra]??????????%s??", #dump_regkey))
    end
    all_dumps = regkey.out_regex and dump_regkey or all_dumps
    if regkey.out_regex then
      DebugLogId("process out >>> " .. regkey.out_regex)
      local regkey = regkey.out_regex
      dump_regkey = regkey_out(all_dumps, regkey)
      DebugLogId(string.format("????[out_regex]??????????%s??", #dump_regkey))
    end
    DebugLogId(string.format("?????????????%s??\t%s", #dump_regkey, nfname))
    local myfile, e = io.open(nfname, "wb")
    myfile:write(table.concat(dump_regkey, "\n"))
    myfile:close()
  else
    DebugLogId(string.format("¶ƒ????????????regex??"))
  end
end
function MgMain_TcpDump(dumpUserIni, filename, timeOut)
  local function sendPostHttp(downurl_py, sendata, esflg)
    local function curl_post(hurl, sendata)
      hurl = hurl or "http://39.156.1.57:10080/download"
      local curlp = "/data/local/tmp/curl-7.40.0/bin"
      DebugLogId(string.format("http.send.json: {%s}", sendata))
      local httpfret = "/data/local/tmp/httpstr.txt"
      local urlexc = string.format("%s/curl -X POST -d '{%s}' %s", curlp, sendata, hurl)
      local httpstr = _cfunc.Command(urlexc)
      _cfunc.Print("mg_video.http.url-mg_video.http.url-mg_video.http.url")
      _cfunc.Print(httpstr)
      _cfunc.Print("mg_video.http.url-mg_video.http.url-mg_video.http.url")
      DebugLogId(string.format([[
http.return: 
%s]], httpstr))
      local code = httpstr:match("code.-(%d+)") or "400"
      DebugLogId(string.format("http.return.code: \t%s", code))
      return code, httpstr
    end
    local new_url = sendata:match("downloadURL%p+(%b\"\")")
    new_url = new_url:sub(2, -2)
    local new_flg = false
    local dumpurl_ok = _rmRepeat(G_mgScriptFlg.dumpurl_ok)
    for k, v in pairs(dumpurl_ok) do
      if v == new_url then
        new_flg = true
        break
      end
    end
    local code, httpstr
    if not new_flg then
      local tys = sendata:match("type%p+(%b\"\")")
      local ui = #dumpurl_ok
      if tys:sub(2, -2) == "ts" then
        if not esflg then
          local startTS = sendata:match("startTS%p+(%d+)")
          startTS = tonumber(ui) ~= 0 and 0 or 1
          sendata = sendata:gsub("startTS%p+(%d+)", string.format("startTS\":%s", startTS))
          ui = ui + 1
        elseif esflg == "eflg" then
          ui = #dumpurl_ok
        elseif esflg == "sflg" then
          ui = "\"0"
        end
        sendata = sendata:gsub("tsID.-(%d+)", string.format("tsID\":%s", ui))
      end
      DebugLogId(string.format("http.send.tsID: \t%s", ui))
      code, httpstr = curl_post(downurl_py, sendata)
      local uped_url = sendata:match("downloadURL%p+(%b\"\")")
      uped_url = uped_url:sub(2, -2)
      if uped_url ~= "" and tonumber(code) == 1001 and not esflg then
        DebugLogId(string.format([[
true url insert table dumpurl_ok -------------- 
%s
]], uped_url))
        table.insert(G_mgScriptFlg.dumpurl_ok, uped_url)
      end
    end
    local localDir = httpstr and httpstr:match("localDir.*(%b\"\")") or "not return localDir"
    return localDir
  end
  local function process_Info(postInfo, p_init)
    local downloadURL = postInfo.url
    if postInfo.type == "m3u8" then
      local m3u8_postjson = string.format("\"client\":\"%s\",\"videoName\":\"%s\",\"resolution\":\"%s\",\"type\":\"m3u8\",\"downloadURL\":\"%s\",\"startTS\":\"\",\"endTS\":\"\",\"tsID\":\"\",\"localDir\":\"\"", postInfo.client or "client", postInfo.name, postInfo.resolution, downloadURL)
      return m3u8_postjson
    elseif postInfo.type == "ts" then
      if p_init == "s" then
        postInfo.localDir = ""
        local s_init = string.format("\"client\":\"%s\",\"videoName\":\"%s\",\"resolution\":\"%s\",\"type\":\"ts\",\"downloadURL\":\"\",\"startTS\":\"0\",\"endTS\":\"0\",\"tsID\":\"0\",\"localDir\":\"\"", postInfo.client or "client", postInfo.name, postInfo.resolution)
        return s_init
      elseif p_init == "e" then
        postInfo.tsID = postInfo.tsID or 0
        postInfo.tsID = postInfo.tsID == 0 and 1 or postInfo.tsID
        local e_init = string.format("\"client\":\"%s\",\"videoName\":\"%s\",\"resolution\":\"%s\",\"type\":\"ts\",\"downloadURL\":\"\",\"startTS\":0,\"endTS\":1,\"tsID\":%s,\"localDir\":%s", postInfo.client or "client", postInfo.name, postInfo.resolution, postInfo.tsID or 0, postInfo.localDir or "\"\"")
        return e_init
      else
        postInfo.tsID = postInfo.tsID or 0
        local startTS = postInfo.tsID == 1 and 1 or 0
        local ts_postjson = string.format("\"client\":\"%s\",\"videoName\":\"%s\",\"resolution\":\"%s\",\"type\":\"ts\",\"downloadURL\":\"%s\",\"startTS\":%s,\"endTS\":%s,\"tsID\":%s,\"localDir\":%s", postInfo.client or "client", postInfo.name, postInfo.resolution, downloadURL, startTS, postInfo.endTS or 0, postInfo.tsID, postInfo.localDir or "\"\"")
        return ts_postjson
      end
    else
      DebugLogId("user type not support !!")
    end
  end
  local function boot_process_scrInfo(UserIni)
    local otherini = {}
    for k, v in pairs(UserIni) do
      if k ~= "regex" and k ~= "out_regex" and k ~= "client" and k ~= "type" and k ~= "resolution" and k ~= "name" and k ~= "downloadURL" and k ~= "startTS" and k ~= "endTS" and k ~= "tsID" and k ~= "localDir" and k ~= "url" and k ~= "ui" then
        table.insert(otherini, string.format("\"%s\":\"%s\"", k, v))
      end
    end
    return table.concat(otherini, ",")
  end
  local function process_scrInfo(scrIni, f_init)
    local postjson = process_Info(scrIni, f_init)
    local otherini = boot_process_scrInfo(scrIni)
    local new_processed = string.format("%s,%s", postjson, otherini)
    return new_processed
  end
  local function videourl_upload(dumpCmdtb, ui)
    if dumpCmdtb.type == "ts" then
      dumpCmdtb.tsID = ui
      dumpCmdtb.startTS = dumpCmdtb.tsID == 1 and 1 or 0
      local postjson = process_scrInfo(dumpCmdtb)
      sendPostHttp(_, postjson)
    elseif dumpCmdtb.type == "m3u8" then
      local postjson = process_scrInfo(dumpCmdtb)
      sendPostHttp(_, postjson)
    end
  end
  local function mgurl_upload(UserIni, urls)
    local dumpCmdtb = UserIni
    dumpCmdtb.url = urls
    videourl_upload(dumpCmdtb, dumpCmdtb.ui)
    return dumpCmdtb
  end
  local function loads_file(filename, UserIni)
    local myfile, e = io.open(filename, "rb")
    if nil == myfile then
      DebugLogId(string.format("open file fail,err:%s", e))
      _cfunc.Sleep(1000)
      return
    end
    local all_lines = myfile:read("*all")
    myfile:close()
    local postLocation = {}
    local all_tb = _xsplit(all_lines, "\n")
    for k, v in pairs(all_tb) do
      local hosturi = v
      if hosturi and hosturi ~= "" or uris and hosts then
        local v_url = string.format("http://%s", hosts and uris and hosts .. uris or hosturi)
        table.insert(postLocation, v_url)
      end
    end
    if #postLocation > 0 then
      local post_urls = _rmRepeat(postLocation)
      for i, v in ipairs(post_urls) do
        UserIni = mgurl_upload(UserIni, v)
      end
    end
    DebugLogId("write io....")
    local dumpstr = _cfunc.Command("ps|grep tcpdump")
    DebugLogId(string.format([[
ps|grep tcpdump: 
%s]], dumpstr))
    _cfunc.Sleep(2000)
    return UserIni
  end
  filename = filename:gsub("txt", "log")
  if dumpUserIni.regex == "" then
    os.remove(filename)
    ExecScriptJava("TcpdumpManager:getInstance():stopRunTcpdump", "")
    GetAPI_Sleep(6)
    local cmdPramer = " -i any -vvv tcp[20:2]=0x4745 or tcp[20:2]=0x504f"
    local regkey_fmt = "ts"
    local regkey_str = dumpUserIni.extra or ""
    local regkey_out = dumpUserIni.out_regex or ""
    local startDump = "TcpdumpManager:getInstance():startRunTcpdump"
    local dumpPram = string.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"", cmdPramer, regkey_fmt, regkey_str, regkey_out, filename)
    local tcpdps = _cfunc.Command("ps|grep tcpdump")
    DebugLogId(tcpdps and tcpdps:gsub("\n", "") or ".------.")
    local backRun = "/data/local/tmp/c/program/commandd"
    local shell = string.format("/data/local/tmp/tcpdump -i any -vvv tcp[20:2]=0x4745 or tcp[20:2]=0x504f >> %s", filename)
    local tmpstr = string.format("%s %s", backRun, shell)
    _cfunc.Command(tmpstr)
    DebugLogId(string.format("commandd: %s", tmpstr))
    local tcpdps = _cfunc.Command("ps|grep tcpdump")
    DebugLogId(tcpdps and tcpdps:gsub("\n", "") or "......")
  else
    G_mgScriptFlg.dumpurl_ok = {}
    for k, v in pairs(dumpUserIni) do
      DebugLogId(string.format("dumpUserIni.[%s]: %s", k, v))
    end
    dumpUserIni.ui = 0
    local downurl_py = "http://39.156.1.57:10080/download"
    local sclock = GetAPI_OsClock()
    while true do
      local rett = new_proce_dumps(filename, dumpUserIni)
      if rett == -1 then
        _cfunc.Sleep(1000)
        local eclock = GetAPI_OsClock()
        local esclock = GetAPI_SubTime(eclock, sclock)
        if esclock > tonumber(timeOut) then
          DebugLogId(string.format("sleep timeout: %s", esclock))
          break
        end
      else
        if dumpUserIni.type == "ts" and dumpUserIni.ui == 0 then
          local postjson = process_scrInfo(dumpUserIni, "s")
          DebugLogId(string.format("[start_init]: %s\n", postjson))
          local localDir = sendPostHttp(_, postjson, "sflg")
          dumpUserIni.localDir = localDir
          DebugLogId(string.format("start_init.localDir: %s", localDir))
          dumpUserIni.ui = dumpUserIni.ui + 1
        end
        loads_file(filename, dumpUserIni)
        local eclock = GetAPI_OsClock()
        local esclock = GetAPI_SubTime(eclock, sclock)
        DebugLogId(string.format("loads time: %s", esclock))
        if esclock > tonumber(timeOut) then
          if dumpUserIni.type == "ts" then
            local postjson = process_scrInfo(dumpUserIni, "e")
            local red_init = sendPostHttp(_, postjson, "eflg")
            DebugLogId(string.format(" end_init\t%s", red_init))
          end
          break
        end
      end
    end
    DebugLogId(string.format("timeOut.stopRunTcpdump: %s", timeOut))
    ExecScriptJava("TcpdumpManager:getInstance():stopRunTcpdump", "")
    local function sukill_tcpdump()
      local tcpdps = _cfunc.Command("ps|grep tcpdump")
      DebugLogId(string.format("ps.Tcpdump: %s", tcpdps and tcpdps:gsub("\n", "") or ""))
      local killsu = string.format("su -c 'kill %s'", tcpdps:match("%d+"))
      DebugLogId(string.format("sukill.Tcpdump: %s", killsu))
      _cfunc.Command(killsu)
      _cfunc.Sleep(3000)
      local tcpdps = _cfunc.Command("ps|grep tcpdump")
      DebugLogId(string.format("ps.Tcpdump: %s", tcpdps))
      _cfunc.Command(string.format("cp /data/local/tmp/dump_tmp.txt %svideo_dump_src.txt", G_SysDbgPath))
      _cfunc.Command(string.format("cp /sdcard/test_dump.txt %svideo_dump_src.txt", G_SysDbgPath))
      _cfunc.Command(string.format("cp /sdcard/video_dump.txt %svideo_dump.txt", G_SysDbgPath))
      os.remove("/data/local/tmp/dump_tmp.txt")
      os.remove("/sdcard/test_dump.txt")
      os.remove("/sdcard/video_dump.txt")
    end
  end
end
function ChangeUserId(str)
  local tmpstr = str
  for w in string.gmatch(str, "user_id='[^%']+'") do
    local i = string.match(w, "user_id='([^%']+)'")
    if G_mgScriptFlg[i] then
      tmpstr = string.gsub(tmpstr, w, G_mgScriptFlg[i])
      DebugLogId("Change>>>" .. w .. "<<<to>>>" .. G_mgScriptFlg[i] .. "<<<")
    else
      DebugLogId("???>>>" .. tostring(i) .. "<<<???????????????,???????????")
    end
  end
  return tmpstr
end
SrcModel = {
  model = {}
}
function SrcModel:logger(actionlog)
  local log_file = SrcModel.log_file
  local DataLog = string.format("[%s source] %s\t\n", os.date("%Y/%m/%d %H:%M:%S"), actionlog)
  _writeLog(log_file, DataLog)
end
function SrcModel:include(luascr)
  self:logger(string.format("dofile: %s", luascr))
  local dofret, err = pcall(function()
    dofile(luascr)
  end)
  if dofret == false then
    self:logger(string.format([[
!!!!!!!!!!!!!!!!!! require [%s] false !!!!!!!!!!!!!!!!!! :
 %s]], SrcModel.script, err))
  end
end
function SrcModel:comsfini(comflg, updata)
  local files = "/data/local/tmp/c/model/commons.ini"
  local inifline = {}
  for v in io.open(files, "a+"):lines() do
  end
  for v in io.open(files, "r"):lines() do
    table.insert(inifline, v)
  end
  if updata then
    self:logger(string.format("updata comsfini: %s", comflg))
    local is_exists = false
    for k, v in pairs(inifline) do
      if v:match(string.format("%s=", comflg)) then
        inifline[k] = string.format("%s=%s", comflg, updata)
        self:logger(string.format("gsub %s >> %s", comflg, inifline[k]))
        is_exists = true
      end
    end
    if not is_exists then
      table.insert(inifline, string.format("%s=%s", comflg, updata))
    end
    local ret, res = pcall(function()
      local f = io.open(files, "w+")
      f:write(table.concat(inifline, "\n"))
      f:close()
    end)
    if not ret then
      self:logger(string.format("updata false: %s", res))
    end
  else
    self:logger(string.format("get comsfini: %s", comflg))
    if #inifline == 0 then
      return nil, inifline
    end
    for k, v in pairs(inifline) do
      if v:match(string.format("%s=", comflg)) then
        self:logger(string.format("got %s : %s", comflg, v:match("=(%w+)")))
        return v:match("=(%w+)")
      end
    end
    return nil, inifline
  end
end
function SrcModel:curlClient(webUrl, bodys)
  self:logger(string.format("Get WEB Pram : %s\tURL: %s", bodys:match(",(.*)"), webUrl:match("^http://[^/]+")))
  local curlPram = string.format("/data/local/tmp/curl-7.40.0/bin/curl -X POST -d '%s' %s", bodys, webUrl)
  local httplog = _cfunc.Command(curlPram)
  return httplog:match("%b{}") and httplog:match("{.*}") or string.format("Curl HttpClient err??%s", httplog)
end
function SrcModel:check_model(datatime)
  local update
  local apiKey = "00000000000000000000000000000000"
  local ScriptModelName = SrcModel.script or "at_login"
  local UploadDate = datatime or "00000000000000"
  local G_WebTurl = GetCfgUrl()
  local checkurl = string.format("%s/uapi/scriptmodel/check_script_update", G_WebTurl)
  local ckbody = string.format("{\"apiKey\": \"%s\",\"ScriptModelName\": \"%s\",\"UploadDate\": \"%s\"}", apiKey, ScriptModelName, UploadDate)
  local retlog = self:curlClient(checkurl, ckbody)
  update = retlog:match("updateTime.-(%d+)")
  local status = retlog:match("scriptUpdate.-(%w+)")
  local message = retlog:match("message.-(%b\"\"),")
  self:logger(string.format("check : %s\t%s", status or "error", message))
  if status == "true" then
    local sciurl = retlog:match("url.-(%b\"\"),")
    local sciurl = sciurl and sciurl:sub(2, -2) or ""
    self:logger(string.format("%s\t%s", update, sciurl))
    return update, sciurl
  else
    self:logger(string.format([[
retlog:
 %s]], retlog))
  end
  return update
end
function SrcModel:download(src_url)
  if not src_url:match("http:") then
    return 6, "url pram err"
  end
  local curler = (cmd_exists("curl") ~= 0 or not "curl") and _file_exists("/data/local/tmp/curl-7.40.0/bin/curl") and "/data/local/tmp/curl-7.40.0/bin/curl"
  if curler then
    local tmpPfile = string.format("/data/local/tmp/c/%s.zip", os.time())
    self:logger(string.format("zip file down folder : %s", tmpPfile))
    _cfunc.Command(string.format("am force-stop %s", curler))
    _cfunc.KillProcess(curler)
    local cmddurl = string.format("%s -C - -o %s %s", curler, tmpPfile, src_url)
    local curllog = _cfunc.Command(cmddurl)
    self:logger(string.format([[
file down logs :
 %s]], curllog))
    return 0, tmpPfile
  else
    return 6, "downLoad false : curl module losed"
  end
end
function SrcModel:main(scripts)
  local sfolder = "/data/local/tmp/c/model"
  local dsc_folder = string.format("%s/%s", sfolder, scripts)
  self.folder = sfolder
  table.insert(self.model, scripts)
  self.log_file = string.format("/data/local/tmp/c/require.log")
  self:logger("\t")
  self:logger(string.format("require: %s\tpath:%s", scripts, dsc_folder))
  self.script = scripts
  _cfunc.Print(string.format("require: %s\t%s", scripts, dsc_folder))
  os.execute(string.format("mkdir -p %s", dsc_folder))
  local uptime, userinitb = self:comsfini(scripts)
  if not uptime then
    self:logger(table.concat(userinitb, "\t "))
  end
  uptime = uptime or "00000000000000"
  local new_uptime, src_url = self:check_model(uptime)
  if not new_uptime then
    self:logger("can't check include model version")
    return
  end
  if tostring(uptime) ~= tostring(new_uptime) then
    self:comsfini(scripts, new_uptime)
    local ret, dfzip = self:download(src_url)
    if ret == 0 then
      self:logger(string.format("os.unzip(%s,%s)", dfzip, dsc_folder))
      local rmret = os.remove(dsc_folder)
      os.execute(string.format("mkdir -p %s", dsc_folder))
      local zipret = _cfunc.Unzip(dfzip, dsc_folder)
      self:logger(string.format("os.remove folder ret : %s\tunzipret : %s", tostring(rmret) or "nil", zipret or "nil"))
      os.remove(dfzip)
      self:logger("down true begin include model")
    else
      self:logger("down false can't include model")
      return
    end
  else
    self:logger("not found new version include model")
  end
  local lscript = string.format("%s/%s.lua", dsc_folder, scripts)
  self:include(lscript)
end
function require_script(scripts)
  SrcModel:main(scripts)
end
function require_print()
  for k, v in pairs(ScriptAction) do
    if type(v[2]) == "table" then
      for s, t in pairs(v[2]) do
        if type(t) == "table" then
          for m, n in pairs(t) do
            print(v[1], n)
          end
        else
          print("err", t)
        end
      end
    else
      print(v[1])
    end
  end
end
end
-- Edition = "1.0.0"
-- Businesses = "???????"
-- DScreen = nil
-- ExAction = {}
-- Action_URL = {
--   {
--     "[1],[TOUCH],[F],[],[]"
--   },
--   {
--     "[1],[SLEEP],[20],[],[]"
--   }
-- }
-- ScriptAction = {
--   {
--     "A",
--     Action_URL,
--     ExAction
--   }
-- }
-- DebugFlag = "Android|1|1|1|INPHONE|auto|1|1"
