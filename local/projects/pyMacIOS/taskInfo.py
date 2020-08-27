# coding=utf-8

import time,json
from datetime import date,datetime
# import urllib
from urllib import request

class TaskAction(object):

    def __init__(self,weburl,serial):
        self.weburl = weburl or "autoapi.uusense.com"
        self.dvimei = serial
        taskBody = {"data":{"serial":serial,"lastOptId":"0"}}
        taskUrl = "http://{}/uapi/agent/gettasks".format(self.weburl)
        self.gettask_url = taskUrl
        self.gettask_body = taskBody

    def getTaskInfo(self,serial):   # 接口获取任务信息
        data = json.dumps(self.gettask_body)
        # data = parse.urlencode(data).encode('utf-8')
        req = request.Request(self.gettask_url, data=data.encode('utf-8'))
        retpage = request.urlopen(req).read().decode('utf-8')
        rj = json.loads(retpage)
        title = "imei: {}\tstatus: {}\tmessage: {}".format(self.dvimei, rj['status'], rj['message']) 
        self.title = title
        self.status = rj['status']
        return retpage

    def PostTest(self): # post 例子
        print(self.gettask_urls)
        print(self.gettask_body)
        data = json.dumps(self.gettask_body)
        # data = parse.urlencode(data).encode('utf-8')
        req = request.Request(self.gettask_urls, data=data.encode('utf-8'))
        page = request.urlopen(req).read().decode('utf-8')
        return page

    def json2db(self,taskinfo): # 任务信息入表
        dic_json = json.loads(newTaskInfo)
        taskLists = dic_json['data']['taskLists']   # [0]
        print(len(taskLists))
        taskList = []
        for tasks in taskLists:
            taskIter = []
            taskIter.append(tasks['taskId'])
            taskIter.append(tasks['testTaskName'])
            taskIter.append(tasks['optType'])   # 1`=新增任务；`2`=暂停任务；`3`=启动任务；`4`=删除任务
            taskIter.append(tasks['scriptId'])
            taskIter.append(tasks['scriptUrl'])
            taskIter.append(tasks['startDate'])
            taskIter.append(tasks['endDate'])
            taskIter.append(tasks['exeBeginTime'])
            taskIter.append(tasks['exeEndTime'])
            taskIter.append(tasks['exeType'])       # 1`=按时执行；`2`=按次执行
            taskIter.append(tasks['interval'])      # 间隔时间，单位：分钟，`0`=不间隔
            taskIter.append(tasks['iterationNum'])  # 循环次数
            taskIter.append(tasks['startIterationNumber'])  # 开始执行的轮次编号
            taskList.append(tuple(taskIter))
        return taskList

    def getScriptInfo(self,scriptId):   # 获取脚本更新
        scriptBody = {"data":{"scriptId":scriptId,"updateDate":"0"}}
        scriptUrl = "http://%s/uapi/agent/getOneScript" % self.weburl
        self.gettasks = scriptUrl
        # j = json.loads( urllib.urlopen( taskUrl ).read() )
        req = urllib.Request(url=scriptUrl,data=json.dumps(scriptBody))
        rets = urllib.urlopen(req).read()
        rj = json.loads(rets)
        title = "imei: {}\tstatus: {}\tmessage: {}".format(self.dvimei, rj['status'], rj['message']) 
        self.title = title
        return rets

    def u2db_datetime(self,sdtime):
        dbdate=""
        if len(sdtime)>=14 and not ":" in sdtime:  
            n,y,r,h,m,s = sdtime[:4],sdtime[4:6],sdtime[6:8],sdtime[8:10],sdtime[10:12],sdtime[-2:]
            # str_date = time.strftime('%Y-%m-%d %H:%M:%S',(int(n),int(y),int(r),int(h),int(m),int(s),1,1,1))
            # dbdate = datetime.strptime(str_date,'%Y-%m-%d %H:%M:%S')
            dbdate = datetime(int(n),int(y),int(r),int(h),int(m),int(s))
        else:
            print("value : {} format error (%Y%m%d%H%M%S)".format(sdtime))
            dbdate = datetime.now()
        return dbdate

###############################################
TaskInfo = TaskAction(None,"x1234567890abcdef")
newTaskInfo = TaskInfo.getTaskInfo(TaskInfo.dvimei)
print(TaskInfo.gettask_url)
print(TaskInfo.title)

print("\n-------TaskInfo.SQLite:-------\n")
from dbSQLite import CrtSQLite

TaskDb = CrtSQLite("./local/pyMacIOS/taskB.db")
print(TaskDb.dbname)
import os
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


print("\n-------TaskInfo.end-------")


