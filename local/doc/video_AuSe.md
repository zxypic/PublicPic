#### 视频测试

#### 基于特征图片
> 截取一张图片，作为既定特征的图片，图片比对100ms-300ms，误差20ms

- 图片比对
在测试过程中，不断获取界面截图
当界面截图中找到特征图片时，即为达到特定预期
- 视频流分析
获取视频流进行帧分析，获取来源：网卡、盒子
盒子socket通信时延20-30ms
- 视频采集后分析
高清录屏设备采集设备，进行事后视频帧分析

#### 事件捕捉
基于hook技术分析app特定事件作为特征，进行特定事件捕捉计时
误差取决于系统事件及代码计算

#### 流畅度UI
> adb shell dumpsys gfxinfo < PACKAGE_NAME >
> dumpsys gfxinfo < PACKAGE_NAME > reset 重置丢帧统计

- 参考文献
https://www.jianshu.com/p/7477e381a7ea
https://www.cnblogs.com/danyuzhu11/p/11714220.html
https://www.cnblogs.com/zhengna/p/10032078.html
最后120帧，包含纳秒时间戳

- 详细描述
Graphics info for pid 31148 [com.android.settings]: 表明当前dump的为设置界面的帧信息，pid为31148
Total frames rendered: 105 本次dump搜集了105帧的信息
Janky frames: 2 (1.90%) 105帧中有2帧的耗时超过了16ms，卡顿概率为1.9%
Number Missed Vsync: 0 垂直同步失败的帧
Number High input latency: 0 处理input时间超时的帧数
Number Slow UI thread: 2 因UI线程上的工作导致超时的帧数
Number Slow bitmap uploads: 0 因bitmap的加载耗时的帧数
Number Slow issue draw commands: 1 因绘制导致耗时的帧数
HISTOGRAM: 5ms=78 6ms=16 7ms=4 ... 直方图数据，表面耗时为0-5ms的帧数为78，耗时为5-6ms的帧数为16，同理类推。

在Android 6.0以后为gfxinfo 提供了一个新的参数framestats，其作用可以从最近的帧中提供非常详细的帧信息，以便您可以更准确地跟踪和调试问题。
> adb shell dumpsys gfxinfo < PACKAGE_NAME > framestats
Janky,percentile
计算方式:SM = 帧率(60) * (单位时长总帧数 - 单位时长丢帧数) / 单位时长总帧数
59.43 = 60*(105-1)/105
### 比较完整的帖子

https://www.jianshu.com/p/642f47989c7c

com.youku.taitan.tv

### ffmpeg
视频提取图片： https://www.jianshu.com/p/3538eb261dcc
做图像处理以及视音频文件分离和合成：
https://blog.csdn.net/Tong_T/article/details/92794314