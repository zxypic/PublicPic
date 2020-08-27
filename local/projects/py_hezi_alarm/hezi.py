#coding=utf8

# 处理盒子频繁被系统回收，但不能解决autosense被频繁回收，只能缓解这个问题 
# 1、建立 alarm文件夹，建立adbip.txt
# 2、通过txt设置被测试ip, 单行一个，回车换行
# 3、然后通过进程进行监测
# 4、发现 autosensed不在 则重新启动autosense 
# 

import subprocess,re
import time
from datetime import date,datetime
# import sys
# reload(sys)
# sys.setdefaultencoding('utf-8')

# print("input repeat interval time（min）: ")
print("Processing boxes are frequently recycled by the system : ")
repeat_time = 2

def process_cmdd(cmds):
    p = subprocess.Popen(cmds, shell=True, stdout=subprocess.PIPE)
    outlog, err = p.communicate()
    outlog = outlog.decode('utf-8')
    return outlog, err

def connect_adb(adbip):
    connect_list=[]
    for adb in adbip:
        adbwifi = 'adb connect {}'.format(adb.strip('\n'))
        output,_ = process_cmdd(adbwifi)  
        # print('status:{}\t{}'.format(status, output))
        # output = output.encode('GB18030')
        print('[{}]: {}'.format(datetime.now(),output),end=''),
        if 'connected' in output:
            connect_list.append(adb.strip('\n'))
        # else:
            # print("adb connect failed: {}".format(output))
            # print(output)
            # pass

    return connect_list

def adb_gerp(adb): # 检查adb设备是否开启 autosensed
    autod = 'adb -s {} shell ps|grep autosensed'.format(adb)
    output,_ = process_cmdd(autod)  
    ret = 0
    for line in output.split('\n'):
        if 'autosensed' in line:
            print('[{}]: {}'.format(datetime.now(),line))
            ret = 1
            break
    print('[{}]: ps|grep autosensed: ret={}\t(1:started, other:not found)'.format(datetime.now(),ret))
    if ret != 1:
        stops = 'adb -s {} shell am force-stop com.autosense'.format(adb)
        process_cmdd(stops)  
        print('[{}]: {} am force-stop com.autosense'.format(datetime.now(),adb))    # adb shell am start -n com.autosense/.ui.activity.MainActivity
        time.sleep(2)
        monkeyp = 'adb -s {} shell monkey -p com.autosense 1'.format(adb)
        output,_ = process_cmdd(monkeyp)
        print('[{}]: sleep 10s, wait for autosense start...'.format(datetime.now()))
        time.sleep(15)
        if not 'error' in output:
            lsauto = 'adb -s {} shell ps|grep autosense'.format(adb)
            lsout,_ = process_cmdd(lsauto)  
            print('[{}]: {}'.format(datetime.now(),lsout))
            if 'autosensed' in lsout:
                print('[{}]: >>>> {} rStart OK <<<<'.format(datetime.now(),adb))
            else:
                print('[{}]: >>>> {} rStart False <<<<'.format(datetime.now(),adb))
        # elif 'offline' in output:
        #     print(output,'adb kill-server',subprocess.call('adb kill-server'),shell=True)  
        else:
            print('[{}]: {} adb device: {}'.format(datetime.now(),adb,output))
    else:
        print('[{}]: ****** {} autosensed opend break ******'.format(datetime.now(),adb))
        

while True:
    adbips = []
    with open('./adbip.txt', 'r', encoding='UTF-8') as f: # local/py_hezi_alarm/
        adbips = f.readlines()
    adb_list = connect_adb(adbips)
    adbs,_ = process_cmdd('adb devices')  
    print('[{}]: adb devices:\n{}'.format(datetime.now(),adbs),end=''),
    print('[{}]: ----------adb connected list----------'.format(datetime.now()))
    for adb in adb_list:
        print('[{}]: {}'.format(datetime.now(),adb))
    print('[{}]: ----------adb connected list----------'.format(datetime.now()))
    for adb in adb_list:
        adb_gerp(adb)
    print("=============================================================================sleep10s")
    disc,_ = process_cmdd('adb disconnect')  
    time.sleep(13)
    # time.sleep(repeat_time*60)

