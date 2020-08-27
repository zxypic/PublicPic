#coding=utf8
import json,sys
import sqlite3

# reload(sys)
# sys.setdefaultencoding( "utf-8" )

class CrtSQLite(object):
    def __init__(self,dbname):
        crt_task_info = '''CREATE TABLE IF NOT EXISTS task_info (
                taskId INT, testTaskName TEXT, optType int,scriptId INT,scriptUrl TEXT,
                startDate int, endDate int, exeBeginTime TEXT, exeEndTime TEXT,
                exeType int, interval int, iterationNum int, startIterationNumber int
                );'''
        crt_scripts = '''CREATE TABLE IF NOT EXISTS scripts (
                scriptId INT, scriptName TEXT, scriptType int,scriptUrl TEXT,
                uploadDate int, scriptMaxRunTime int, targetId int, scriptVersion int,
                scriptCacheUrl TEXT
                );'''
        crt_apps = '''CREATE TABLE IF NOT EXISTS apps (
                scriptId INT, appCheck int, appPackageName TEXT, appUrl TEXT, appMd5 TEXT,
                appVersion TEXT, appVersionCode TEXT, appLastUpdateTime TEXT, appCacheUrl TEXT
                );'''
        run_tasks = '''CREATE TABLE IF NOT EXISTS run_tasks (
                taskId INT, testTaskName TEXT, optType int,scriptId INT,scriptUrl TEXT,
                startDate int, endDate int, exeBeginTime TEXT, exeEndTime TEXT,
                exeType int, interval int, iterationNum int, startIterationNumber int
                );'''
        create_dic = []
        create_dic.append(crt_task_info)
        create_dic.append(crt_scripts)
        create_dic.append(crt_apps)
        create_dic.append(run_tasks)    # 保存需要运行的任务 有必要么
        self.create_dic = create_dic
        self.dbname = dbname or "AtestB.db"

    def db_init(self):  # 初始化db task_info、apps、scripts
        conn = sqlite3.connect(self.dbname)
        try:
            for cre in self.create_dic:
                conn.execute(cre)
                print(cre)
        except Exception as e:
            print("Create table failed")
            print(e)
            return False
        conn.close()

    def sql_set_task(self,tasktb):   # 插入任务信息 for
        # self.db_init()  # 初始化单独 ？
        conn = sqlite3.connect(self.dbname)
        for task in tasktb:
            conn.execute(
                'INSERT INTO task_Info VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',task
                )
        conn.commit()
        conn.close()

    def excset_script(self,scriptb):
        pass

    def sql_set_task_many(self,task_data):   # 插入任务信息 多项
        conn = sqlite3.connect(self.dbname)
        conn.executemany(
                'INSERT INTO task_Info VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',task_data
            )
        conn.commit()
        conn.close()
    def sql_quire_runtask(self):
        conn = sqlite3.connect(self.dbname)
        # rows = conn.execute('SELECT taskId FROM task_info')
        # taskrows = rows.fetchall()
        taskrows = []
        # 获取未完成的按次任务 不含重复项  新增+启动
        for row in conn.execute('SELECT DISTINCT * FROM task_info WHERE optType=3 OR optType=1 AND exeType=2 AND startIterationNumber<=iterationNum'):
            taskrows.append(row)
        conn.close()
        return taskrows

    def sql_quire_taskid(self,taskid):
        conn = sqlite3.connect(self.dbname)
        taskrows = []
        # 单条id的信息，给uodata用
        '''SELECT * FROM task_info WHERE STRFTIME('%s', endDate) - STRFTIME('%s', datetime('now','localtime'))<24*60*60;'''
        for row in conn.execute('SELECT DISTINCT * FROM task_info WHERE optType=3 OR optType=1 AND startIterationNumber<=iterationNum'):
            taskrows.append(row)
        conn.close()
        return taskrows

    def sql_updata_task(self):
        conn = sqlite3.connect(self.dbname)
        conn.execute(
            'UPDATE task_info SET optType=3 WHERE optType=1;'
        )
        conn.commit()
        conn.close()


# DVDB = CrtSQLite("./local/taskB.db")
# print(DVDB.dbname)
# DVDB.db_init()
# runrows = DVDB.sql_quire_runtask()

# for task in runrows:
#     print(task[0],task[2],task[5],task[6],task[7],task[8])
    # AND exeType=2 
    
# 更新任务状态： 
#     轮次 + 1 
#     任务run表 dele for id

# DVDB.sql_updata_task()

# DVDB.sql_set_task(taskstb)
# DVDB.sql_set_task_many(taskstb)



