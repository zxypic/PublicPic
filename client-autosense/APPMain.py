# -*- coding: utf-8 -*-

# 所有配置文件信息
# 请求地址 auto.uusense.com
# 入口配置 setting.cfg
# 2019/02/14 上午11:29 @xndery
import os,time,sys
import envoy
import logging
# import sense

from sense.AgentHelp import HttpAgent,ResultAgent
from sense.sqlite_syn import sqlite_handle
from sense.COMMON import AgentCommon

logging.basicConfig(format='%(asctime)s %(filename)s %(funcName)s [line: %(lineno)d] %(levelname)s : %(message)s',)
logger = logging.getLogger("xtc")
logger.setLevel(logging.DEBUG)

class MainClient(object):

    def __init__(self):
        #self.scriptRoot = sys.path[0] + os.sep + "scripts"
        #self.resultRoot = sys.path[0] + os.sep + "results"
        self.scriptRoot = "./scripts"
        self.resultRoot = "./results"        
        self.common = AgentCommon()
        self.agent = HttpAgent()
        self.agent_result = ResultAgent()
        self.handle = sqlite_handle()
        # self.common = sense.COMMON.AgentCommon()
        # self.agent = sense.AgentHelp.HttpAgent()
        # self.agent_result = sense.AgentHelp.ResultAgent()
        # self.handle = sense.sqlite_syn.sqlite_handle()
        self.init_path()

    def init_path(self):
        self.common.mk_dirs(self.scriptRoot)
        self.common.mk_dirs(self.resultRoot)

    def startMain(self,status_app):
        logger.info("app status: {}\t(1:run 0:stop)".format(status_app))
        if status_app ==0 :
            return 

        ret, _ = self.agent.device_register()
        if ret:
            logger.info("设备注册成功！")
        else:
            logger.error("设备失败！！！")
            # TODO 重试
            return

        if not os.path.isfile(self.handle.dbname):
            self.handle.db_init()
            logger.info("db init ok ")
        if ret:
            # for n in range(1) :
            while True:
                logger.info("=============================start====================================")
                ret,taskinfo = self.agent.get_tasks()   # 获取任务， taskinfo为json格式数据
                logger.info("获取新任务完成, ret=" + str(ret))
                if ret:
                    self.task_update(taskinfo) # 更新db任务
                time.sleep(3)
                taskrows = self.handle.query_runtask()   # 取出任务
                if taskrows:
                    self.tasks_run(taskrows)  # 运行脚本
                    self.status_upload({'action':20,'taskIds':[self.taskid]})    # 上报状态    TODO 每个任务的self.taskid都不一样，为啥最后执行一次
                else:
                    logger.info("no task running....")
                logger.info("==============================end======================================\n")
                time.sleep(10)

    def task_update(self,taskinfo):   
        lit = taskinfo["taskLists"]
        for t in lit:
            logger.info("获取到的任务: " + str(t))
        #获取到多个任务呢？？？ TODO
        self.taskid = taskinfo['taskLists'][0]['taskId']
        self.status_upload({'action':14,'taskIds':[self.taskid]})    # 上报状态
        logger.info("上报获取到新任务  " + str(self.taskid))
        #logger.info(taskinfo)
        #logger.info("上报获取到新任务")
        #logger.info("处理任务信息 json2dict")

        taskList = self.agent.process_tasks_info(taskinfo)
        logger.info("新增的任务数量：" + str(len(taskList)))
        if len(taskList) > 0:
            #TODO 必须先判断是否已添加， 可能会重复获取到任务
            self.handle.insert_task(taskList)

        task_lists = taskinfo['taskLists']
        #todo 根据optId排序执行
        for task in task_lists:
            # 1`=新增任务；`2`=暂停任务；`3`=启动任务；`4`=删除任务
            optType = task["optType"]
            if optType == "2":
                self.handle.update_task_run_status(task["taskId"], "2")
            elif optType == "3":
                self.handle.update_task_run_status(task["taskId"], "3")
            elif optType == "4":
                self.handle.del_task_byid(task["taskId"])
            elif optType == "1":
                #已在上方插入数据库
                pass
            else:
                logger.error("未知操作类型 " + str(optType))
                logger.error("未知操作类型 " + str(task))

    def tasks_run(self,taskrows):
        logger.info("待执行的task信息：" + str(taskrows))
        for row in taskrows:
            self.taskid = str(row[0])        # 任务ID
            self.scriptid = str(row[3]) or "1"    # 脚本ID
            self.scriptName = os.path.join(self.scriptRoot,self.scriptid + '.zip')  
            # iterationType  重复类型，0=不限，1=每天，2=每周，3=每月，默认1
            # taskId, testTaskName, optType,scriptId,scriptUrl, startDate , endDate , exeBeginTime , exeEndTime ,exeType , interval , iterationNum , startIterationNumber 
            #(205937, 'pyclient-test', 1, 107864, 'http://202.105.193....69910.zip', 20191006000000, 20201231235959, '000000', '235959', 2, 1, 1, 1)
            self.scriptMaxRunTime = " xx " or str(row[6])     #最大执行时间, 待从脚本中获取
            self.startINumber = str(row[12])    # 开始轮次
            self.iterationNum = str(row[11])    #总的执行轮次

            if not os.path.isfile(self.scriptName):
                self.script_updata(self.scriptid)    # 更新脚本 TODO 更新、脚本下载异常处理

            self.status_upload({'action':18,'taskIds':[self.taskid],'taskNumber':self.startINumber,'scriptMaxRunTime':self.scriptMaxRunTime})    # 上报状态
            logger.info("run task taskId= {} and scriptId= {} and startNum= {} and MaxRunTime = {}".format(self.taskid,self.scriptid,self.startINumber,self.scriptMaxRunTime))
            logger.info("script zip: {}".format(self.scriptName))
            try:
                logger.info("script main(): {}".format(os.path.join(self.scriptRoot,self.scriptid,'script.py')))
                self.script_run()   # 调起脚本
            except Exception as msg:
                logger.info("脚本运行异常:{}".format(msg))
            self.process_dbinfo()    # 更新任务信息 TODO 更新
            self.process_result()    # 上传结果

    def script_updata(self,scriptId):
        ret,scriptinfo = self.agent.get_script(scriptId)
        if ret:
            ret = self.agent.script_download(scriptinfo)   # TODO 检查更新
            if ret == 0:
                self.status_upload({'action':16,'taskIds':[self.taskid],'scriptFileName':scriptinfo['scriptName']})    # 上报状态
                scriptList = self.agent.process_script_info(scriptinfo)
                handle = sqlite_handle()
                handle.insert_script_one(scriptList)
                logger.info("scriptlist insert db ok")
            else:
                logger.info("下载脚本异常")
                self.status_upload({'action':17,'taskIds':[self.taskid],'scriptFileName':scriptinfo['scriptName']})    # 上报状态
        else:
            logger.error("update script failed")

    def status_upload(self,action_dic):
        self.agent.status_upload(action_dic)

    def script_run(self):
        self.result_path = os.path.join(self.resultRoot, self.taskid, self.startINumber)
        self.debug_path = os.path.join(self.result_path, "FILE")
        self.common.mk_dirs(self.result_path)   # 创建结果目录 
        self.common.mk_dirs(self.debug_path)   # 创建日志目录 
        ''' 调用三方 py 脚本 运行，并负责结果文件至 FILE目录，生成 result.txt文件 '''
        #cmd_line = 'python {}'.format(os.path.join(self.scriptRoot,self.scriptid,'script.py'))
        cmd_line = "python " + self.scriptRoot + "/" + self.scriptid + "/script.py"
        logger.info("************************* script run start *****************************************************")
        logger.info("执行的cmd=" + cmd_line)
        r = envoy.run(cmd_line)
        run_info = []
        run_info.append("status_code={}".format(r.status_code))
        run_info.append("std_err={}".format(r.std_err))
        run_info.append("std_out={}".format(r.std_out))
        self.write_debug_info(run_info)
        logger.info("执行完成 status_code={} \t std_err={}".format(r.status_code,r.std_err))
        logger.info("执行完成 std_out=" + r.std_out)
        self.result_new()
        logger.info("*************************  script run end  *****************************************************")

        
        #report_path = os.path.join(self.scriptRoot,self.scriptid,'result') # TODO 这里路径有啥用
        #logger.info("report_path={}".format(report_path))
        #self.common.cp_dir(report_path, os.path.join(self.result_path,'FILE'))
        #self.common.rm_dir(report_path)  #TODO 是否一定要删除？

    def write_debug_info(self, infos):
        debug_info_file = os.path.join(self.debug_path, "debug.txt")
        with open(debug_info_file,'w',encoding='gbk') as r:
            for info in infos:
                r.write(info + "\n")

    def result_new(self):
        logger.info("result_path={}".format(self.result_path))
        pram_result={}
        pram_result.update({'taskid':self.taskid})
        pram_result.update({'startNum':self.startINumber})
        pram_result.update({'title':"测试指标-BBK"})
        pram_result.update({'Businesses':"PY执行业务"})
        pram_result.update({'ret':"00"})
        nowtime = time.strftime('%Y%m%d%H%M%S', time.localtime())   
        pram_result.update({'stime':nowtime})
        header = self.agent_result.cre_header(pram_result)
        logger.info("结果header=" + header)
        #resf = "{}/result.txt".format(self.result_path)
        resf = os.path.join(self.result_path, "result.txt")
        logger.info("结果文件=" + resf)
        with open(resf,'w',encoding='gbk') as r:
            r.write(header)
        for i in range(3):
            title = self.agent_result.cre_title(pram_result)
            logger.info("结果title=" + title)
            with open(resf,'a',encoding='gbk') as r:
                r.write('\n' + title)

    def process_dbinfo(self):
        #logger.info("更新任务信息，已执行轮次+1  taskid={}".format(self.taskid))
        #logger.info("执行sql，更新db中taskid信息")
        #logger.info("检查是否达到删除本任务条件，taskid={}".format(self.taskid))
        #logger.info("执行sql，删除db中taskid信息")
        current_run = int(self.startINumber)
        total_run_count = int(self.iterationNum)
        if current_run >= total_run_count:
            logger.info("运行次数已完成，删除数据库任务信息")
            self.handle.del_task_byid(self.taskid)
        else:
            logger.info("运行次数加一")
            self.handle.update_task_run_count(self.taskid, current_run + 1)

    def process_result(self):
        taskid = self.taskid
        startINum = self.startINumber
        result_path = os.path.join(self.resultRoot,taskid,startINum)   # results/id/num/
        result_zipfn = 'PYOS_{}_{}.zip'.format(taskid,startINum)
        zipf_result = os.path.join(self.resultRoot,result_zipfn)
        self.common.zip_dir(result_path,zipf_result)
        self.status_upload({'action':21,'taskIds':[taskid],"taskNumber":startINum,"resultZipName":zipf_result})
        isret = self.agent.result_isUpload(zipf_result)
        if isret==1:
            ret = self.agent.result_upload(zipf_result)
            if ret ==1:
                self.status_upload({'action':22,'taskIds':[taskid],"taskNumber":startINum,"resultZipName":zipf_result})
                logger.info("upload success, rm taskid result num: {}".format(result_path))
                self.common.rm_dir(os.path.join(self.resultRoot,taskid,startINum))
                logger.info("upload success, rm result zip: {}".format(zipf_result))
                self.common.rm_file(zipf_result)
            else:
                self.status_upload({'action':23,'taskIds':[taskid],"taskNumber":startINum,"resultZipName":zipf_result})
        else:
            logger.info("is not need upload , rm result zip: {}".format(zipf_result))

if __name__ == "__main__":
    client = MainClient()
    client.startMain(1)

