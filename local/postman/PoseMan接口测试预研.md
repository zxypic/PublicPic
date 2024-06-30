- 参考链接： <https://www.jianshu.com/p/5dd299c23eb0>
- 开发者 https://github.com/postmanlabs/postman-collection/

#### 前提

- 接口分类：
  - HTTP接口：http协议，路径区分，多种报文参数格式，post、get、json
  - WebServer接口：soap协议，xml格式，SoapUI
  - RESfull接口：
- 接口测试必要性：
  - 系统复杂度、传统测试效率低下、前后端分离，使绕过前端更容易
- 接口测试范围：
  - 功能、性能、安全；重点在数据交换、传递、控制，处理次数
  - 数据入口、数据出口
- 常用数据提交：
  - url传参、uri传参
  - Form-data传参
  - x-www-form-urlencoded传参
  - raw 传参 
  - binary 传参 
- 常见关注指标：
  - 状态码
  - 响应时长ms
  - Response
- 典型场景：
  - 数据驱动式测试
  - 单接口功能测试
  - req、res修改

#### 接口文档示例

- 接口说明
- 调用的url
- 请求方法（get、post）
- 请求参数，参数类型、请求参数说明
- 返回参数说明
- 返回示例 

####NewMan测试

- 已有功能
  - json格式参数
  - 命令行调用执行
  - 支持mac、windows (npm安装)
  - 支持直接生成报告结果(json、html···)
  - js脚本功能式断言
- 可行性说明
  - 实施等同工具集成，多个json参数交互，逻辑复杂，维护困难
  - 有较成熟使用方式
  - Jenkins集成已有案例
- 待测试功能
  - 环境变量维护(跨api接口、跨集合更新)
  - 测试集合调度
  - 测试结果颗粒度(可见性需求)
  - 改造后与postman原始工具的契合度(直接影响使用)