

from taskInfo import TaskAction
from usbList import USBFiler
from dbSQLite import CrtSQLite
import os


APPUSB = USBFiler()
udids = APPUSB.Usb_apple()

if len(udids)>0:
    print(udids[0])
    print(udids)
    print("-------TaskInfo.usb.end-------\n")

    print("-------TaskInfo.req:-------\n")
    TaskInfo = TaskAction(None,udids[0])
    TaskInfo = TaskAction(None,"x1234567890abcdef")
    newTaskInfo = TaskInfo.getTaskInfo(TaskInfo.dvimei)
    print(TaskInfo.gettask_url)
    print(TaskInfo.title)

    print("\n-------TaskInfo.SQLite:-------\n")

    TaskDb = CrtSQLite("./local/pyMacIOS/taskB.db")
    print(TaskDb.dbname)
    if not os.path.isfile(TaskDb.dbname):
        TaskDb.db_init()

    if TaskInfo.status==1 :
        print("\n-------TaskInfo.json2db:-------\n")
        taskList = TaskInfo.json2db(newTaskInfo)
        # for pram in taskList:
        #     print(pram)
        TaskDb.sql_set_task(taskList)
        TaskDb.sql_set_task_many(taskList)

    print("\n-------TaskInfo.RUN:-------\n")
    runrows = TaskDb.sql_quire_runtask()   # 已筛好的满足次数条件的任务
    for task in runrows:
        print("RUN: ",task[0],task[2],task[5],task[6],task[7],task[8])


# TaskDb.sql_updata_task()    

# 任务获取&拆分-->保存db  OK
# 获取USB设备   OK
# 更新任务状态、上报消息  TODO
# 时间戳存储格式转换问题 OK

# sdtime = '20181222001000'
# print(sdtime[:4],sdtime[4:6],sdtime[6:8],sdtime[8:10],sdtime[10:12],sdtime[-2:])
# print(time.strftime('%Y-%m-%d %H:%M:%S',(2018,12,22,00,10,00,1,1,1)))
# https://www.cnblogs.com/styier/p/6080669.html 日期计算问题