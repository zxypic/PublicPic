
### wins调用其它程序

### doc
https://www.cnblogs.com/hushaojun/p/9812057.html

#### os.system
> os.system('notepad python.txt')

#### ShellExecute
> import win32api
> win32api.ShellExecute(0, 'open', luaf, prams, upath, 0)

ShellExecute(hwnd, op , file , params , dir , bShow )
其参数含义如下所示。
hwnd：父窗口的句柄，如果没有父窗口，则为0。
op：要进行的操作，为“open”、“print”或者为空。
file：要运行的程序，或者打开的脚本。
params：要向程序传递的参数，如果打开的为文件，则为空。
dir：程序初始化的目录。
bShow：是否显示窗口。
以下实例使用ShellExecute函数运行其他程序。
> win32api.ShellExecute(0, 'open', 'notepad.exe', 'python.txt','',1)

#### CreateProcess
> 此函数是非阻塞方式
CreateProcess(appName, commandLine , processAttributes , threadAttributes , bInheritHandles ,dwCreationFlags , newEnvironment , currentDirectory , startupinfo )
其参数含义如下。
appName：可执行的文件名。
commandLine：命令行参数。
processAttributes：进程安全属性，如果为None，则为默认的安全属性。
threadAttributes：线程安全属性，如果为None，则为默认的安全属性。
bInheritHandles：继承标志。
dwCreationFlags：创建标志。
newEnvironment：创建进程的环境变量。
currentDirectory：进程的当前目录。
startupinfo ：创建进程的属性。
以下实例使用win32process.CreateProcess函数运行记事本程序。
```python
>>> import win32process
# 打开记事本程序，获得其句柄
>>> handle = win32process.CreateProcess('c:\\windows\\notepad.exe','', None , None , 0 ,win32process. CREATE_NO_WINDOW , None , None ,win32process.STARTUPINFO())
# 使用TerminateProcess函数终止记事本程序
>>> win32process.TerminateProcess(handle[0],0)
# 导入win32event模块
>>> import win32event
# 创建进程获得句柄
>>> handle = win32process.CreateProcess('c:\\windows\\notepad.exe','', None , None , 0 ,win32process. CREATE_NO_WINDOW , None , None ,win32process.STARTUPINFO())
# 等待进程结束
>>> win32event.WaitForSingleObject(handle[0], -1)
0 # 进程结束的返回值
```