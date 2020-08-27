均基于 python3 实现

###py_hezi_alarm:

- 处理盒子频繁被系统回收，但不能解决autosense被频繁回收，只能缓解这个问题 
1、建立 alarm文件夹，建立adbip.txt
2、通过txt设置被测试ip, 单行一个，回车换行
3、然后通过进程进行监测
4、发现 autosensed不在 则重新启动autosense 
 主要基于 subprocess 实现命令行控制

###pyav：
实现视频中音频提取
通过 av 库实现

###pygui:
简单实现app，类似服务端程序
支持定时器，刷新菜单、已上线城市定位刷新至菜单
基于rumps实现gui,通过 setuptools 完成打包问题，
可支持跨平台 windows、macos、Ubuntu

###pyMacIOS：
实现从web获取任务，保存数据库，从数据库中提取任务信息执行
主要库： sqlite3、json、subprocess、urllib、request
暂时未支持任意调度
后续可实现从数据库读出任务信息，执行某功能

###py_img_cn:
给图片添加中文字，效果类似弹幕，
字体需单独提供，暂不支持使用系统字体
库：from PIL import Image, ImageDraw, ImageFont
使用 cv2 绘制图片
pip3 install pillow
