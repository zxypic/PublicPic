# 环境准备

## 说明
> 由于单机压测受cpu、内存、网络io等限制，会出现服务器压力还没上去，压测端由于模拟压力太大已经死机的情况，此时应该使用多台机同时负载的机制；  
> 单个agent控制多个agent_server, 同时并发以达到服务器压力要求

## 事项
- 基本环境配置尝试  ok
- 远程调用运行  ok
- 增加shell脚本方式启动 
- 增加docker方式agent
- 代码集成功能支持

## 环境
- 版本
jmeter 5.1.1
java jdk 1.8
- 配置
1. 由server（控制机）和agent（压力机）组成，agent搭建在linux（centos 6.5）服务器环境下，server搭建在windows（server 2012）环境下。
2. 压力测试瓶颈大都在带宽上面，需要保证压力机的带宽要比服务器的带宽高，不然压力上不去。
3. 需要保证agent和server都在一个网络中，且在多网卡环境需要保证启动的网卡都在一个网段。
4. 需要保证server和agent之间的时间同步。
5. 关闭防火墙。
6. java、jmeter环境变量自行配置

- 启动
1. 执行启动命令 `jmeter-server -Djava.rmi.server.hostname=本机ip`
2. agent配置 jmeter.properties 文件 `remote_host` 多个机器使用 , 分开 （记得带端口）
3. 在 控制机 启动图形界面 选择某个终端，或手动配置 jmeter.properties
4. 实际使用中建议增加启动shell脚本，参考: https://www.jianshu.com/p/5c04792c31b6  


# 简单接口测试
- 常用概念
    - 线程组
    - 简单控制器
    - cookies管理
    - csv数据文件设置
    - 查看结果树
    - 聚合报告
    - 图形结果
    - HTTP代理服务器
    - 设置手机代理端口
    - 开启录制操作


# 命令行执行
> `jmeter -n -t test_local.jmx -l test.csv -e -o ./zxyzxy`
> 参考地址 https://blog.csdn.net/k3108001263/article/details/84999301
> jmeter -n -t test.jmx  -l test.jtl  -J ip=192.168.199.177 -J num_threads=3000  -J ramp_time=60 -J duration=1200  

|参数 |说明 |备注
|----|----|
| -n | 无窗口 |
| -t | 指定用例文件 |
| -l | 指定输出结果文件路径, 每次请求的数据文件 |
| -e | 生成测试报告 |
| -o | 指定报告输出路径，可在浏览器查看的html报告 |
| -r | 启动远程server | 需在 `jmeter property` 提前配置 远程 host, 在non-gui模式下生效
| -R | 启动远程server | 忽略 `jmeter property` 配置, 在non-gui模式下生效
| -X | 测试结束时,退出 | 在non-gui模式下生效
| -q | 其它配置文件 | 如JVM参数等等
| -p | 本地属性文件 | 默认-p jmeter.properties 
| -S | JAVA系统属性文件 | 
| -J | JMeter 本地属性 |  {argument}={value}


# 报告说明

# 常见问题
- ssl密匙无效
`rmi_keystore.jks (No such file or directory)`
    - 禁用SSL: 修改jmeter.properties 文件，server.rmi.ssl.disable=true， 所有agent都需要设置此项
    - 拥有RMI over SSL的有效密钥库
> server.rmi.ssl.disable=true 

# Docker Compose
> 使用 Docker Compose 可以轻松、高效的管理容器，它是一个用于定义和运行多容器 Docker 的应用程序工具
> https://www.jianshu.com/p/658911a8cff3

- 安装  
`pip3 install docker-compose`, 使用 docker-compose -v 查看版本 是否安装成功
- 使用


# 相关链接
- 搭建Jmeter容器集群平台  https://blog.csdn.net/smooth00/article/details/80174900
- 使用jmeter 对APP进行压力测试  https://blog.csdn.net/qq_30463497/article/details/82594267
- Jmeter分布式压测和监控实践    https://www.jianshu.com/p/5c04792c31b6
- Jmeter分布式部署测试-----远程连接多台电脑做压力性能测试   https://www.cnblogs.com/whitewasher/p/6946207.html