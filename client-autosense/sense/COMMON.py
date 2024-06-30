# -*- coding: utf-8 -*-

# 所有配置文件信息
# 请求地址
# 入口配置
# 2019/01/14 上午11:29 @xndery

import configparser
import os,random,time
import shutil,zipfile,hashlib
import uuid,socket
import platform

class AgentCfg(object):
    def __init__(self):
        self.cfgpath = ""

    #############################################################
    def getter_confdict(self,section):
        conf_filename = self.cfgpath
        if not os.path.exists(conf_filename):
            return {}
        try:
            config = configparser.ConfigParser()
            path = conf_filename
            config.read(path)
            val = {}
            for k, v in config.items(section):
                val.update({k: v})
            return val
        except Exception:
            return {}

    def dev_imei(self):
        dev = self.getter_confdict('DEV')
        return dev['ensolemac']

    def dev_name(self):
        dev = self.getter_confdict('DEV')
        return dev['name']

    def http_host(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['address']

    def http_register(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['deviceregister']
        
    def http_gettask(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['taskquery']

    def http_onescript(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['onescriptquery']

    def http_isupload(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['resultconfirm']

    def http_upload(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['uploadresult']

    def http_status(self):
        HTTP = self.getter_confdict('HTTP')
        return HTTP['devicestatus']

class AgentCommon(object):
    
    def __init__(self):
        pass

    def mk_dir(self,dirname):
        if not os.path.exists(dirname):
            os.mkdir(dirname)

    def mk_dirs(self,dirname):
        if not os.path.exists(dirname):
            os.makedirs(dirname)

    def mv_file(self,sourcefile, desdir, to_dir=True):
        if to_dir and not os.path.exists(desdir):
            os.makedirs(desdir)
        try:
            shutil.move(sourcefile, desdir)
        except shutil.Error:
            pass

    def cp_file(self,src, dst):
        try:
            shutil.copy(src, dst)
        except shutil.Error:
            pass

    def cp_dir(self,src, dst):
        try:
            shutil.copytree(src, dst)
        except shutil.Error:
            pass

    def rm_dir(self,dirname):
        if os.path.exists(dirname):
            shutil.rmtree(dirname, ignore_errors=True)

    def rm_file(self,filename):
        # be care delete important dir
        if os.path.isfile(filename):
            os.remove(filename)

    def unzipfile(self,sourpath, despath):
        fz = zipfile.ZipFile(sourpath)
        for name in fz.namelist():
            fz.extract(name, despath)

    def zip_dir(self,dirname, zipfilename):
        if os.path.isfile(zipfilename):
            os.remove(zipfilename)
        tmp_filename = zipfilename + '.tmp'
        filelist = []
        if os.path.isfile(dirname):
            filelist.append(dirname)
        else:
            for root, dirs, files in os.walk(dirname):
                for name in files:
                    filelist.append(os.path.join(root, name))
        zf = zipfile.ZipFile(tmp_filename, "w", zipfile.zlib.DEFLATED)
        for tar in filelist:
            arcname = tar[len(dirname):]
            zf.write(tar, arcname)
        zf.close()
        zf.close()
        os.rename(tmp_filename, zipfilename)

    def zip_files(self,files, zip_name):
        """
        :param files: list or tuple, must be file_root
        :param zip_name: root
        :return: None
        """
        with zipfile.ZipFile(zip_name, 'w', zipfile.zlib.DEFLATED) as f:
            if isinstance(files, (tuple, list)):
                for file_root in files:
                    if os.path.isfile(file_root):
                        f.write(file_root, os.path.split(file_root)[1])
                    elif os.path.exists(file_root):
                        filelist = []
                        for root, dirs, files in os.walk(file_root):
                            for name in files:
                                filelist.append(os.path.join(root, name))
                        for tar in filelist:
                            arcname = tar[len(os.path.dirname(file_root)):]
                            f.write(tar, arcname)
            else:
                f.write(files, os.path.split(files)[1])

    def sys_platform(self):
        sytem_name = platform.system().lower()
        if sytem_name == 'darwin':
            value = 'mac'
        elif sytem_name == 'linux':
            value = 'linux'
        else:
            value = 'windows'
        return value

    def calcmd5(self,filepath):
        with open(filepath, 'rb') as f:
            md5obj = hashlib.md5()
            while True:
                d = f.read(8096)
                if not d:
                    break
                md5obj.update(d)
        hash_val = md5obj.hexdigest()
        return hash_val



if __name__ == "__main__":
    CFG = AgentCfg()
    # print(CFG.dev_info())
    # print("--------------------")
    # print(CFG.http_host())
    # print(CFG.http_register())
    # print(CFG.dev_imei())
    # print(CFG.dev_name())
    #COM = AgentCommon()
    #COM.mk_dir('result')
    # COM.zip_dir('./results/FILE','./results/104522_1.zip')
    # md5s = COM.calcmd5('./results/104522_1.zip')
    # print(md5s)
    # print("--------------------")
    # new_result = Agent_result()
    # header = new_result.cre_header()
    # print(header)
    # for i in range(3):
    #     title = new_result.cre_title()
    #     print(title)
