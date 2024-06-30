# -*- coding: utf-8 -*-

# 请求地址
# 入口配置
# 2019/02/14 上午11:29 @xndery

import sys
sys.path.append("./sense")
sys.path.append(".")
import configparser
import os,random,time
import datetime
import logging
import shutil,zipfile,hashlib
import uuid,socket,json
from sense.COMMON import AgentCommon
from urllib import request
from requests import post

logger = logging.getLogger("xtc")

class MyError(Exception):
    '''
    '''

class HttpAgent(object):

    def __init__(self,is_first=False):
        self.CFG = CfgAgent()
        self.COM = AgentCommon()
        self.device_init()
        self.is_first = is_first
        self.scriptpath = './scripts'
        logger.info("[address]: " + self.address)

    def device_init(self):
        self.imei = self.CFG.mac_imei()
        self.address = self.CFG.url_host() 

    def device_register(self):
        dev_content = self.CFG.dev_info()
        url = self.CFG.url_register()
        logger.info("[dev_serial]: " + dev_content['serial'])

        postdata = self.request_postdata(dev_content)
        #logger.info("url=" + str(url) + ",postdata=" + str(postdata))
        result = self.https_request(url, postdata)
        success, data = self.process_jsoned_result(result)
        logger.info("注册设备服务器返回：" + str(data))
        return success, data

    def get_tasks(self):
        taskurl = self.CFG.url_gettask()
        postdata = self.request_postdata({'serial': self.imei,
                                          'lastOptId': '1' if self.is_first else '0'})
        #logger.info("获取任务  taskurl=" + taskurl + ", postdata=" + str(postdata))
        result = self.https_request(taskurl,postdata)
        ret, data = self.process_jsoned_result(result)
        if ret and self.is_first:
            logger.info("First get ztest tasks finish")
            self.is_first = False
        return ret, data

    def get_script(self,scriptId):  # 检查更新
        getOneScriptUrl = self.CFG.url_onescript()
        nowtime = time.strftime('%Y%m%d%H%M%S', time.localtime())   # TODO 永远下载
        postdata = self.request_postdata({'scriptId': scriptId, 'updateDate': '1'})
        logger.info(getOneScriptUrl,postdata)
        result = self.https_request(getOneScriptUrl,postdata)
        ret, data = self.process_jsoned_result(result)
        if ret and self.is_first:
            logger.info("First get PYOS script finish")
            self.is_first = False
        return ret, data

    def script_download(self,scriptinfo):
        urlpath = scriptinfo['scriptUrl']
        LocalPath = os.path.join(self.scriptpath,scriptinfo['scriptId'] + '.zip')
        logger.info("download script {} : {} LocalPath={}".format(scriptinfo['scriptId'],urlpath,LocalPath))
        request.urlretrieve(urlpath,LocalPath)
        logger.info("下载脚本成功/失败 上报, 下载成功则解压")
        try:
            self.COM.unzipfile(LocalPath,os.path.join(self.scriptpath,scriptinfo['scriptId']))
            self.COM.mk_dir(os.path.join(self.scriptpath,scriptinfo['scriptId'],'result'))
            return 0
        except :
            return 1

    def result_isUpload(self,zipfile_path):
        url = self.CFG.url_isupload()
        file_md5 = self.COM.calcmd5(zipfile_path)
        postdata = self.request_postdata({'md5': file_md5})
        result = self.https_request(url, postdata)
        json_val = json.loads(result)
        retneed = json_val['data']['allowUpload']
        logger.info("check whether is need upload : {}\tmd5: {}".format(json_val['data'],file_md5))
        # ret = 0,已经存在, 删掉处理
        # ret = 1,需要上传
        # ret = 2,其它异常情况，暂不处理
        return int(retneed)

    def status_upload(self,status_act):
        url = self.CFG.url_status()
        #logger.info(url)
        status = {'serial': self.imei}
        status.update(status_act)
        #logger.info(status)
        postdata = self.request_postdata(status)
        result = self.https_request(url, postdata)
        logger.info("upload status : {}\ttaskId: {}".format(status['action'],status['taskIds']))

    def result_upload(self,zipf_path):
        url = self.CFG.url_upload()
        zipf_path_exist = os.path.isfile(zipf_path)
        logger.info("url=" + url + ",zipf_path=" +  zipf_path)
        logger.info("zipf_path_exist=" + str(zipf_path_exist))
        fmd5 = self.COM.calcmd5(zipf_path)
        files = {'file': (zipf_path, open(zipf_path, 'rb'), 'multipart/form-data')}
        data = {'md5':fmd5}
        res = post(url,data=data,files=files)
        try :
            json_val = json.loads(res.text)
            zipid = json_val['data']['zipId']
            logger.info("上传结果成功 : {}".format(zipid))
            return 1
        except :
            logger.info("上传结果失败，信息={}".format(res.text))
            return 0

    def request_postdata(self, addtions):
        postdata = {}
        if addtions and isinstance(addtions, dict):
            postdata["data"] = addtions
        return postdata

    def process_jsoned_result(self, result):
        ret = False
        data = ''
        if not result:
            return ret, data
        json_val = json.loads(result)
        if json_val['status']==0:
            data = json_val['data']
        else:
            ret = True
            data = json_val['data']
        return ret, data

    def https_request(self, url, postdata=None):
        result = ''
        try:
            postdata = json.dumps(postdata)
            req = request.Request(url, data=postdata.encode('utf-8'))
            res = request.urlopen(req)
            self.check_error(res)
            result = res.read().decode('utf-8')
            #logger.info('http content({}): {}'.format(res.status,result))
        except Exception as e:
            logger.info('http error: {}'.format(e))
        return result

    def check_error(self, res):
        if res.status != 200:
            #raise HTTPError('return status {}'.format(res.status))
            raise MyError('return status {}'.format(res.status))

    def process_tasks_info(self,taskInfo): # 处理json任务信息
        taskLists = taskInfo['taskLists']
        logger.info("task 数量: {}".format(len(taskLists)))
        taskListCreate = []
        for tasks in taskLists:
            if not (tasks['optType'] == "1"):
                continue
            taskIter = []
            taskIter.append(tasks['taskId'])
            taskIter.append(tasks['testTaskName'])
            taskIter.append(tasks['optType'])   # 1`=新增任务；`2`=暂停任务；`3`=启动任务；`4`=删除任务
            #taskIter.append(tasks['optId'])
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
            taskListCreate.append(tuple(taskIter))
        return taskListCreate

    def process_script_info(self,scrinfo): # 处理json脚本信息
        logger.info("------------------------------")
        logger.info(scrinfo)
        logger.info("------------------------------")
        logger.info("script process id : {}\tname : {}\tMaxRunTime : {}".format(scrinfo['scriptId'],scrinfo['scriptName'],scrinfo['scriptMaxRunTime']))
        scriptList = []
        scriptList.append(scrinfo['scriptId'])      # 脚本类型
        scriptList.append(scrinfo['scriptName'])    # 脚本名称
        scriptList.append(scrinfo['scriptType'])    # 脚本类型
        scriptList.append(scrinfo['scriptUrl'])     # 脚本地址
        scriptList.append(scrinfo['uploadDate'])    # 脚本上传时间
        scriptList.append(scrinfo['scriptMaxRunTime'])  # 脚本最大运行时间
        scriptList.append(scrinfo['scriptVersion'])     # 脚本版本
        scriptList.append(scrinfo['scriptCacheUrl'])    # 脚本缓存地址
        return tuple(scriptList) 

    def process_u2db_datetime(self,sdtime):
        dbdate=""
        if len(sdtime)>=14 and not ":" in sdtime:  
            n,y,r,h,m,s = sdtime[:4],sdtime[4:6],sdtime[6:8],sdtime[8:10],sdtime[10:12],sdtime[-2:]
            dbdate = datetime.datetime(int(n),int(y),int(r),int(h),int(m),int(s))
        else:
            logger.info("value : {} format error (%Y%m%d%H%M%S)".format(sdtime))
            dbdate = datetime.datetime().now()
        return dbdate

class CfgAgent(object):
    device_type = "PYOS"

    def __init__(self):
        self.cfgpath = "./setting.cfg" 
        self.host = "http://autoapi.uusense.com"
        # self.host = "http://172.28.3.75"
        self.DEV_IMEI = self.mac_imei() or "0123456789"
        self.DEV_NAME = self.mac_name() or "咸的Pro"

    def dev_info(self):
        info={
                "deviceType": self.device_type,
                "serial": self.DEV_IMEI, 
                "deviceName": self.DEV_NAME,
                "agentVersion": "0.0.1",
                "provCode": "200",
                "cityCode": "7550",
                "osType": "PC",
                "deviceBrand": "电脑"
            }
        return info

    def mac_imei(self):
        mac_address = uuid.UUID(int=uuid.getnode()).hex[-12:]
        return ":".join([mac_address[e:e + 2] for e in range(0, 11, 2)])

    def mac_name(self):
        hostname = socket.gethostname()
        return hostname

    # get remote host
    def mac_host(self):
        host = '219.218.154.250'  # For YTU
        return host

    def mac_local_ip(self):
        # ip = socket.gethostbyname(hostname)
        try:
            csock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            csock.connect(('8.8.8.8', 80))
            (addr, port) = csock.getsockname()
            csock.close()
            return addr
        except socket.error:
            return '127.0.0.1'

    def url_host(self):
        return self.host

    def url_register(self):
        uapi = "/uapi/agent/deviceRegister"
        return self.host + uapi

    def url_gettask(self):
        uapi = "/uapi/agent/gettasks"
        return self.host + uapi

    def url_onescript(self):
        uapi = "/uapi/agent/getOneScript"
        return self.host + uapi

    def url_isupload(self):
        uapi = "/uapi/agent/isReUpload"
        return self.host + uapi

    def url_upload(self):
        uapi = "/uapi/agent/uploadResult"
        return self.host + uapi

    def url_status(self):
        uapi = "/uapi/agent/uploadDeviceStatus"
        return self.host + uapi

class ResultAgent(object):

    def __init__(self):
        CFG = CfgAgent()
        self.dev_imei = CFG.mac_imei() or "0123456789"
        self.device_net = "Lan"
        self.app_ver = "1.0.1"
        # logger.info(self.dev_imei)

    def cre_header(self,pram_data):
        logger.info("-----")
        Prams_taskId = pram_data['taskid']  # web任务参数获取 任务编号
        Businesses = pram_data['Businesses']
        device_type = CfgAgent.device_type
        device_imei = self.dev_imei
        device_ip = "127.0.0.1"
        script_ver = "v1.0"

        resHeader = []
        resHeader.append("hzys")
        resHeader.append(device_type)
        resHeader.append(device_imei)
        resHeader.append("0,0")
        resHeader.append(device_ip)
        resHeader.append("18500000000")
        resHeader.append(str(Prams_taskId))
        resHeader.append(Businesses)
        resHeader.append(script_ver)
        resHeader.append("NA")
        resHeader.append(self.device_net)
        resHeader.append(self.app_ver)
        return '\t'.join(resHeader)

    def cre_title(self,pram_data):
        Prams_Round = pram_data['startNum']
        titleName = pram_data['title']
        stime = pram_data['stime']
        ret = pram_data['ret'] or "03" or random.randint(1, 21)
        titlestr = []
        titlestr.append('auto')
        titlestr.append(self.app_ver)
        titlestr.append(titleName)
        titlestr.append('PCPHONE')
        nowtime = time.strftime('%Y%m%d%H%M%S', time.localtime())   
        titlestr.append(stime)   # 开始时间
        titlestr.append(nowtime)
        titlestr.append(str(Prams_Round))
        titlestr.append('0')
        titleValue = "{0}\t{1:.3f}|3{2}".format(ret, random.uniform(0, 11), "|NA" * 8)
        titlestr.append(titleValue)
        titlestr.append(self.device_net)
        titlestr.append('0')
        titlestr.append('0')
        return '\t'.join(titlestr)

if __name__ == "__main__":
    agent = HttpAgent()
    ret, _ = agent.device_register()
    #logger.info("设备注册成功！")
    if ret:
        from sqlite_syn import sqlite_handle
        handle = sqlite_handle()
        if not os.path.isfile(handle.dbname):
            handle.db_init()
        ret,taskinfo = agent.get_tasks()
        logger.info("任务获取完成,")
        logger.info(taskinfo)
        if ret:
            logger.info("处理任务信息json2dict")
            taskList = agent.process_tasks_info(taskinfo)
            handle.insert_task(taskList)
        taskrows = handle.query_runtask()   # 待运行任务
        logger.info(taskrows)
