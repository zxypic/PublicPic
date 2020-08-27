### 遍历统一说明

- 每次遍历单个应用
- H5页面遍历，无法获取元素时采用monkey事件
- 采用广度优先BFS遍历
- 如需遍历过程图片日志等，请在遍历前进行初始化清理（截图、步骤等）
- AutoSense 需开启5555端口方可正常使用


### 本地遍历
> 应用已预安装，且非首次使用 (部分应用有指引操作)
> 首次遍历时，需要安装遍历服务应用，启动时间稍长，请耐心等待，**如有安装弹窗请手动授权**。

1. 使用示例
> 开始遍历应用"腾讯视频"，时长10min
> 以下两条命令配合，且先后顺序不可改变
```shell
am broadcast -a com.uusense.init_ripper -e packageName com.tencent.qqlive -e crawlerType BFS -e testType traversal --ei uiaType 2 --ei duration 10
am broadcast -a com.uusense.run_ripper
```

2. 可配置参数说明
> 其它参数非必要情况，请勿更改。

| 参数 | 说明 | 备注 |
| --- | --- | --- |
| packageName | 待遍历应用包名 | 
| duration | 遍历时长 | 单位: 分钟 |



### web任务遍历
- 单个应用时长默认5min
- 遍历过程会自动下载应用并安装启动
- 使用方式与其它测试基本一致:
    - 上传待测试应用
    - 任务下发时选择`应用遍历测试`
    - 选择待测试终端
    - 测试完成即可查看测试报告

### 遍历备注
> 统一目录:/mnt/sdcard/autosense_ripper_data/
- images : 遍历步骤图片截图 (本地多次调起时注意清理)
- 查看日志: `-s test` & `-s ripper`
- 停止遍历: `am broadcast -a com.uusense.stop_ripper`