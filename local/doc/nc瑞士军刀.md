# nc 使用指南

# 端口占用
> 采用 tcp 占用时提示，完成类似功能  
`nc -l 3718`

# 端口扫描
- 示例 
```shell
# 扫描某机器 21-30 哪些端口是开放的：
nc -n 127.0.0.1 -z 1230-1234 -v 

# 输出如下
nc: connectx to 127.0.0.1 port 1230 (tcp) failed: Connection refused
nc: connectx to 127.0.0.1 port 1231 (tcp) failed: Connection refused
nc: connectx to 127.0.0.1 port 1232 (tcp) failed: Connection refused
nc: connectx to 127.0.0.1 port 1233 (tcp) failed: Connection refused
nc: connectx to 127.0.0.1 port 1234 (tcp) failed: Connection refused
```

# tcp/udp连通性测试
> 可以抓包分析三次握手, 也支持收发消息，默认创建tcp连接，使用 -u 参数建立udp连接
- 开启一个tcp监听   
`nc -l 1342`
- 连接 tcp  
`nc 127.0.0.1 1342`
- 开启 udp 
`nc -v -u 182.3.226.35 80`

# http 连通性测试
1. 输入 `nc www.baidu.com 80`
2. 输入 HEAD / HTTP/1.1 
3. 敲两个回车即可查看web相关信息
``` shell 
$ nc www.baidu.com 80 
HEAD / HTTP/1.1

HTTP/1.1 302 Found
Connection: Keep-Alive
Content-Length: 17931
Content-Type: text/html
Date: Thu, 27 Jun 2019 08:12:10 GMT
Etag: "54d9748e-460b"
Server: bfe/1.0.8.18

```


# 参数说明

|参数|说明|
|--- |---|
| -n | 直接使用ip地址，而不使用域名
| -z | 指定端口范围
| -v | 输出详细信息
| -u | 建立udp连接
| -b | 允许广播消息
| -D | 开启socket调试模式
| -k | 禁止从标准输入读取内容


