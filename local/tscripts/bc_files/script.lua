-------------------------------------------------------------------
-- ������Խű�demo 0510pm16
-------------------------------------------------------------------
dofile("/data/local/tmp/c/engine/BasicEngine.lua")    --����Android����
-------------------------------------------------------------------
-------------------------------------------------------------------
Businesses = "�Զ��������"
Edition = "1.0.0"

function losgin(user, pass, flag)
    if uu.touch("[227,331][341_21_341_46_android.bmp]", "222") then
        inout("asdfasd")
    end
    ret = uu.touch("[][{text:'����'}]", "ָ��")
    if ret then

    end

    if uu.touch("[][{text:'����'}]", "ָ��") then

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
    -- {"[1]", "[ENGINEUD],[BasicEngine.lua][]", "[ָ��]"},
    { "[1]", "[Click],[{index:'1',text:'�ݲ�����',id:'dialog_button'}][{index:'1',text:'homepage',id:'dialog_button'}|,60]", "[ָ��]" }, --��ʱʱ���Զ�������

    { "[1]", "[Swipe],[1][{index:'0',id:'search_layout'}]", "[ָ��]" }, --ͨ��id��������
    { "[1]", "[Text],[][������]", "[ָ��]" }, --�ı�����
    { "[1]", "[Click],[][{text:'����'}]", "[ָ��]" }, --����ı�
    { "[1]", "[Click],[][{id:'btn_play'}]", "[�����������]" }, --���id
    { "[1]", "[SLEEP],[3][]", "[ָ��]" }, --��ͣ
    { "[1]", "[Click],[][{index:'0',id:'swback'}]", "[ָ��]" },
    { "[1]", "[Click],[][{index:'4',text:'ȡ��',id:'search_action'}]", "[ָ��]" },
    { "[1]", "[Assert],[][{text:'*����'}]", "[ҳ��������]" }, --ģ���ı�ƥ��
    { "[1]", "[TOUCH],[B|F][]", "[����]" }, --��������
    { "[1]", "[TOUCH],[227,731][341_21_341_46_android.bmp]", "[����]" }, --ͼƬ���
    { "[1]", "[INPUT],[NUM][]", "[�������]" }, --��������
    { "[1]", "[KILLPS],[com.qq.reader][]", "[�˳��Ķ�����]" }, --ɱ����
    { "[1]", "[COMMAND],[ls /data/local/tmp][]", "[����Ŀ¼]" }, --ִ��shell���� 
    { "[1]", "[SENDSMS],[101][10658830]", "[���Ͷ���ָ��]" }, --���Ͷ��� 
    { "[1]", "[GETINI],[/data/local/reg_num.txt][1]", "[��ȡע���˻�]" }, --��ȡ���������˻��ļ�
    { "[1]", "[TOUCH],[][341_21_341_46_android.bmp|14_321_41_86_android.bmp]", "[�жϵ�ǰ�ʺ�״̬]" }, --�����ж�
    { "[11]", "[TOUCH],[227,331][341_21_341_46_android.bmp]", "[δ��½]" },
    { "[11]", "[TOUCH],[77,531][341_21_341_46_android.bmp]", "[δ��½]" },
    { "[12]", "[TOUCH],[626,71][341_21_341_46_android.bmp]", "[�ѵ�½]" },
    { "[12]", "[TOUCH],[127,31][341_21_341_46_android.bmp]", "[�ѵ�½]" },
}
app_musi = {
    { "[1]", "[TOUCH],[B|F][]", "[����]" }, --��������
    { "[1]", "[Click],[][{index:'0',id:'b6c'}]", "[ָ��]" },
    { "[1]", "[Click],[][{index:'1',id:'b7y'}]", "[ָ��]" },
    { "[1]", "[Click],[][{text:'������¼'}]", "[ָ��]" },
    { "[1]", "[Click],[][{index:'0',text:'�ֻ���/����/��ͨ��֤',id:'sso_login_username_edt'}]", "[ָ��]" },
    { "[1]", "[SLEEP],[3][]", "[]" },

    { "[1]", "[INPUT],[15928142624][]", "[�����ֻ���]" },
    { "[1]", "[Click],[][{index:'2',id:'sso_login_password_edt'}]", "[ָ��]" },
    { "[1]", "[SLEEP],[3][]", "[]" },
    { "[1]", "[INPUT],[u258147@2017][]", "[��������]" },
    { "[1]", "[Click],[][{index:'3',text:'��¼',id:'sso_login_btn'}]", "[ָ��]" },
    { "[1]", "[Click],[][{index:'0',text:'�ҵ�'}]", "[ָ��]" },
    { "[1]", "[Click],[][{index:'0',id:'cka'}]", "[ָ��]" },
}


ScriptAction = {
    { "A", app_musi }, ---URL}
}
DebugFlag = "Android|1|1|1|local|auto|1|1"
