### eyes 代码阅读

1. 启动
命令行参数启动，传入port、instance
进入 service.VideoService 函数

2. 初始化
  VideoService启动_device线程(port)
  进入zmq，启动client+server，进行队列处理
  启动_server(instance_num), 进入循坏zmq.socket消息处理
  支持两个消息 `freeze_req` `、find_req` ： 查找和停止
  收到 `find_resp` 开始查找，进入 service.find_image()，传入 `videofile` `templatefile`
  message 包含 `find_req` `、message_id` 、`videofile` 、 `templatefile`

  ![image-20200113172526224](https://tva1.sinaimg.cn/large/006tNbRwgy1gav2862aztj31hq06gabs.jpg)

3. 数据处理
  通过skvideo读取video_file
  template = template_file[0]
  reader = FFmpegReader(video_file)
  循坏每一帧: for frame in reader.nextFrame(), 进入: matched, region, certainty = `aircv_find_wrapper`(frame, template)
  匹配帧与模板图片: find_sift(`frame`, `template`), if matched: 匹配成功则保存图片
  进入 third_party.aircv.sift.find_sift(frame, template)

4. sift识别查找
> find_sift(im_source, im_search, threshold=0.8, rgb=True, good_ratio=FILTER_RATIO)



### 版本要求
opencv-contrib-python==3.4.3.18

## evnv
> 从Python 3.6开始，创建虚拟环境的推荐方法是使用venv模块。 要安装提供venv模块的python3-venv软件包，需要执行命令
`sudo apt install python3-venv` 或者 `sudo apt install python3.6-venv`

需要注意的是，在Python3.3中使用”venv”命令创建的环境不包含”pip”，你需要进行手动安装。
1、创建虚拟环境
`$ python -m venv  `
2、激活虚拟环境
`$ source <venv>/bin/activate `
3、关闭虚拟环境
`$ deactivate`
