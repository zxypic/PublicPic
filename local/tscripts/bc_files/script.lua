-------------------------------------------------------------------
-- 拨测测试脚本demo 0510pm16
-------------------------------------------------------------------
dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --引入Android引擎
-------------------------------------------------------------------
-------------------------------------------------------------------
Businesses = "自动拨测测试"
Edition = "1.0.0"

function losgin(user, pass, flag)
    if uu.touch("[227,331][341_21_341_46_android.bmp]", "222") then
        inout("asdfasd")
    end
    ret = uu.touch("[][{text:'搜索'}]", "指标")
    if ret then

    end

    if uu.touch("[][{text:'搜索'}]", "指标") then

    end
    if std.touc(199, 0) then

        std.capture()
        std.compare()
        if timout then
        end
    end
end



action = {
    los
}

Action_DML = {
    -- {"[1]", "[ENGINEUD],[BasicEngine.lua][]", "[指标]"},
    { "[1]", "[Click],[{index:'1',text:'暂不升级',id:'dialog_button'}][{index:'1',text:'homepage',id:'dialog_button'}|,60]", "[指标]" }, --超时时间自定义配置

    { "[1]", "[Swipe],[1][{index:'0',id:'search_layout'}]", "[指标]" }, --通过id滑动操作
    { "[1]", "[Text],[][欢乐颂]", "[指标]" }, --文本输入
    { "[1]", "[Click],[][{text:'搜索'}]", "[指标]" }, --点击文本
    { "[1]", "[Click],[][{id:'btn_play'}]", "[点击立即播放]" }, --点击id
    { "[1]", "[SLEEP],[3][]", "[指标]" }, --暂停
    { "[1]", "[Click],[][{index:'0',id:'swback'}]", "[指标]" },
    { "[1]", "[Click],[][{index:'4',text:'取消',id:'search_action'}]", "[指标]" },
    { "[1]", "[Assert],[][{text:'*听过'}]", "[页面有内容]" }, --模糊文本匹配
    { "[1]", "[TOUCH],[B|F][]", "[返回]" }, --按键操作
    { "[1]", "[TOUCH],[227,731][341_21_341_46_android.bmp]", "[桌面]" }, --图片检查
    { "[1]", "[INPUT],[NUM][]", "[输入号码]" }, --参数输入
    { "[1]", "[KILLPS],[com.qq.reader][]", "[退出阅读进程]" }, --杀进程
    { "[1]", "[COMMAND],[ls /data/local/tmp][]", "[进入目录]" }, --执行shell命令 
    { "[1]", "[SENDSMS],[101][10658830]", "[发送订购指令]" }, --发送短信 
    { "[1]", "[GETINI],[/data/local/reg_num.txt][1]", "[获取注册账户]" }, --读取本地配置账户文件
    { "[1]", "[TOUCH],[][341_21_341_46_android.bmp|14_321_41_86_android.bmp]", "[判断当前帐号状态]" }, --条件判断
    { "[11]", "[TOUCH],[227,331][341_21_341_46_android.bmp]", "[未登陆]" },
    { "[11]", "[TOUCH],[77,531][341_21_341_46_android.bmp]", "[未登陆]" },
    { "[12]", "[TOUCH],[626,71][341_21_341_46_android.bmp]", "[已登陆]" },
    { "[12]", "[TOUCH],[127,31][341_21_341_46_android.bmp]", "[已登陆]" },
}
app_musi = {
    { "[1]", "[TOUCH],[B|F][]", "[返回]" }, --按键操作
    { "[1]", "[Click],[][{index:'0',id:'b6c'}]", "[指标]" },
    { "[1]", "[Click],[][{index:'1',id:'b7y'}]", "[指标]" },
    { "[1]", "[Click],[][{text:'立即登录'}]", "[指标]" },
    { "[1]", "[Click],[][{index:'0',text:'手机号/邮箱/和通行证',id:'sso_login_username_edt'}]", "[指标]" },
    { "[1]", "[SLEEP],[3][]", "[]" },

    { "[1]", "[INPUT],[15928142624][]", "[输入手机号]" },
    { "[1]", "[Click],[][{index:'2',id:'sso_login_password_edt'}]", "[指标]" },
    { "[1]", "[SLEEP],[3][]", "[]" },
    { "[1]", "[INPUT],[u258147@2017][]", "[输入密码]" },
    { "[1]", "[Click],[][{index:'3',text:'登录',id:'sso_login_btn'}]", "[指标]" },
    { "[1]", "[Click],[][{index:'0',text:'我的'}]", "[指标]" },
    { "[1]", "[Click],[][{index:'0',id:'cka'}]", "[指标]" },
}


ScriptAction = {
    { "A", app_musi }, ---URL}
}
DebugFlag = "Android|1|1|1|local|auto|1|1"
