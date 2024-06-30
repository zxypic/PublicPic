
## 性能测试
> 分为 负载测试和压力测试
- 负载测试（Load Testing）：
    负载测试是一种主要为了测试软件系统是否达到需求文档设计的目标，
    譬如软件在一定时期内，最大支持多少并发用户数，软件请求出错率等，测试的主要是软件系统的性能。
- 压力测试（Stress Testing）：
    压力测试主要是为了测试硬件系统是否达到需求文档设计的性能目标，
    譬如在一定时期内，系统的cpu利用率，内存使用率，磁盘I/O吞吐率，网络吞吐量等，压力测试和负载测试最大的差别在于测试目的不同。

## Gatling介绍
> Gatling是一个使用Scala编写的开源的高性能负载测试框架，它主要用于对服务器进行负载等测试，并分析和测量服务器的各种性能指标。
> 目前仅支持http协议，可以用来测试web应用程序和RESTful服务。

### Gatling特点
- 使用Akka Actors和Async IO，并发测试性能更高
- 基于一套开源的Gatling DSL API，使用Scala代码，脚本易维护
- 支持录制(recoder)并生成测试脚本，从而可以方便的生成测试脚本，对开发友好的DSL
- 支持实时生成Html动态轻量报表，从而使报表更易阅读和进行数据分析，包括一个Web Recorder和酷炫的测试报告(Html)。
- Gatling专为持续负载测试而设计，支持Jenkins，以便于进行持续集成
- 支持导入HAR（Http Archive）并生成测试脚本
- 支持Maven，Eclipse，IntelliJ等，以便于开发
- 支持插件，从而可以扩展其功能，比如可以扩展对其他协议的支持
- 开源免费
- 只要底层协议（如 HTTP）能够以非阻塞的方式实现，Gatling 的架构就是异步的。这种架构可以将虚拟用户作为消息而不是专用线程来实现。因此，运行数千个并发的虚拟用户不是问题。

### Gatling VS Jmeter
Jmeter是目前非常成熟的负载测试工具，支持相当多的协议，支持插件，可以轻松的扩展。
而Gatling性能上更有优势，并且使用Scala DSL代替xml做配置，相比jmeter要更灵活，而且更容易修改和维护。
关于Jmeter和Gatling的一个比较好的对比可以参见infoq的文章
同时，Gatling也对Maven和Gradle这样的构建工具比较友好，易于集成到Jenkins中，轻松加入到CI流程中。
> TIPS: 在实际使用中建议版本化管理gatling的配置，使用maven插件或gradle插件形成对应的maven/gradle工程项目管理，更容易，而且容量更小，升级gatling也会更方便，减少了很多手工的操作。

![Gatling_VS_Jmeter](https://raw.githubusercontent.com/zxypic/PublicPic/master/Gatling/Gatling_VS_Jmeter.jpg)

### 校验判断
> 依赖于 scala 语言
- 条件判断- doif 会在判断成立的情况下执行特定的操作链
- 条件判断- doIfEquals 判断两个值相等
- 条件判断- doIfOrElse和doIfEqualsOrElse 判断成立执行第一个操作链，判断不成了是执行第二个操作链
- 条件判断- doSwitch、doSwitchOrElse
- 随机判断- randomSwitch和randomSwitchOrElse, 设置的概率值必须小于100%,命中概率不相等
- 随机执行，命中概率相等 uniformRandomSwitch
- 循环判断- roundRobinSwitch


### 依赖&组成
- Gatling bin
- java-home 必须 JDK1.8
- Scala script
- Maven 可选实践

### Gatling目录结构
```
├── bin         gatling(运行测试)、recorder(录制脚本UI工具[不推荐使用])
├── conf        关于Gatling自身的一些配置。
├── gatling-tests
├── lib         自身依赖的库文件。
├── results     存放测试报告的。
├── target      编译后的.scala脚本和class文件;
└── user-files  测试场景.scala脚本
```
> 当运行gating脚本的时候，其会扫描user-files目录下的所有文件，列出其中所有的Simulation(一个测试类，里面可以包含任意多个测试场景)。选择其中一个Simulation，然后填写Simulation ID和运行描述，这个都是为报告描述服务的。


### 部分截图
- 命令行运行结果(有手动选择项回车，可使用tomcat解决选择项问题)
![命令行效果](https://raw.githubusercontent.com/zxypic/PublicPic/master/Gatling/gatling_cmd.jpg)

- 生成的结果报告
![html_report](https://raw.githubusercontent.com/zxypic/PublicPic/master/Gatling/gatling_html_result.jpg)

- UI录制工具(浏览器代理)
![recorder](https://raw.githubusercontent.com/zxypic/PublicPic/master/Gatling/Gatling录制.jpg)


- 脚本示例
```scala
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
class BaiduSimulation extends Simulation {
  //设置请求的根路径
  val httpConf = http.baseURL("https://www.baidu.com")
  /*
    运行100秒 during 默认单位秒,如果要用微秒 during(100 millisecond)
   */
  val scn = scenario("BaiduSimulation").during(100){
    exec(http("baidu_home").get("/"))
  }
  //设置线程数
//  setUp(scn.inject(rampUsers(500) over(10 seconds)).protocols(httpConf))
  setUp(scn.inject(atOnceUsers(10)).protocols(httpConf))
}
```

## 总体一览
- Gatling稳定性比Jmeter好
- Gatling脚本维护简单, 已有Jenkins插件
- 脚本语言的转换&学习  xml-->scala
- Gatling执行时需要编译class, 比较慢
- Gatling报告更优化, Jmeter也支持开关设置定制化
- Gatling支持协议较少, Jmeter协议支持广泛
- Gatling不支持分布式测试, Jmeter通过jmeter.properties remote_host 完成
- Gatling支持同时压多台机器: `.baseURLs("http://10.0.0.1",“http://10.0.0.2")`
- 都支持java扩展、支持代理
- 实践 postman做单个接口，手动填写为Jmeter参数后保存为jmx脚本
- Jmeter支持docker部署节点测试, 单台agent或server

- 需要研究 tomcat 或 Maven 的使用, 命令行选择、Maven 是专门用于构建和管理Java相关项目的工具。
- Jmeter使用shell脚本负责前后条件
- 接口调试功能均偏弱, PostMan > Jmeter > Gatling


## 参考链接
- Gatling压测示例 https://www.jianshu.com/p/7f7a57a8c2bb
- 脚本编写 https://xiuxiuing.gitee.io/blog/2018/09/18/gatlingcode/
- 简单对比 https://blog.csdn.net/smooth00/article/details/80014622
- 深度对比 https://yq.aliyun.com/articles/135029
- 基本使用 https://blog.csdn.net/Csunshine211/article/details/82732518
- scala语法 https://blog.csdn.net/qq_37142346/article/details/80977744

-------

## 关于Scala
> Scalable Language 的简写，是一门多范式的编程语言
> Twitter宣布他们已经把大部分后端程序从Ruby迁移到Scala(2009年)
> Wattzon已经公开宣称，其整个平台都已经是基于Scala基础设施编写的。

### Scala 特性
- 面向对象特性
> Scala是一种纯面向对象的语言，每个值都是对象。对象的数据类型以及行为由类和特质描述。
> 类抽象机制的扩展有两种途径：一种途径是子类继承，另一种途径是灵活的混入机制。这两种途径能避免多重继承的种种问题。
- 函数式编程
> Scala也是一种函数式语言，其函数也能当成值来使用。Scala提供了轻量级的语法用以定义匿名函数，支持高阶函数，允许嵌套多层函数，并支持柯里化。Scala的case class及其内置的模式匹配相当于函数式编程语言中常用的代数类型。
更进一步，程序员可以利用Scala的模式匹配，编写类似正则表达式的代码处理XML数据。
- 静态类型
> Scala具备类型系统，通过编译时检查，保证代码的安全性和一致性。类型系统具体支持以下特性：
泛型类、协变和逆变、标注、类型参数的上下限约束、
把类别和抽象类型作为对象成员、复合类型、引用自己时显式指定类型、视图、多态方法
- 扩展性
> Scala的设计秉承一项事实，即在实践中，某个领域特定的应用程序开发往往需要特定于该领域的语言扩展。Scala提供了许多独特的语言机制，可以以库的形式轻易无缝添加新的语言结构：
任何方法可用作前缀或后缀操作符
可以根据预期类型自动构造闭包。
- 并发性
> Scala使用Actor作为其并发模型，Actor是类似线程的实体，通过邮箱发收消息。Actor可以复用线程，因此可以在程序中可以使用数百万个Actor,而线程只能创建数千个。在2.10之后的版本中，使用Akka作为其默认Actor实现。

### 基础语法

- 变量定义: var 
    ```scala
     var lsn = 5
     var str:String = "your name"
     val a,b,c = 1
    ```

- 条件语句
    > 与其他编程语言有很大的区别，if语句有返回值。if和else条件语句的最后一行就是if语句的返回值。
    ```scala
    scala> val aa=25
    aa: Int = 25

    scala> if (aa>20) "more than" else "less than"
    res1: String = more than
    ```
- 循坏语句
    > while语句和Java中一样，可以参考Java或者C++等其他语言的while语句来使用。
    > for循环语句有点类似于python中for循环，不过，写法上有点区别, 没有提供break等终止循环的语句
    ```scala
        scala> val n:Int=10
        n: Int = 10

        scala> var tmp=0
        tmp: Int = 0
        scala> for(i <- 1 to 10)
            | tmp+=i

        scala> println(tmp)
        55
    ```
    ```scala
        scala> for(c <- "Hello ")
                    println(c)
        H
        e
        l
        l
        o
    ```
    > 高级的for循坏
    ```scala
    for(i=0;i<10;i++){
        for(j=0;j<10;j++){
        //循环体
        }
        }
    // 例如
    for(i <- 1 to 10;j <- 1 to 10)
    if(j==9)
        println(i*j)
    else
        print(i*j+" ")
    ```
    > if 守卫
    ```scala
    for(i <- 1 to 10 if i%2==0)
        print(i+" ")
    ```
- 函数定义: def
    > 每个参数必须指定参数类型，在函数体中有返回值时，与Java等其他语言不同的时，scala中不需要使用return来返回，默认的函数体最后一行的表达式就是函数的返回值，也可以不用定义函数返回值的具体返回类型，scala可以进行自动类型推断，具体定义形式看下面Demo：
    ```scala
    def func(name:String,age:Int)={
    println("my name is "+name+",i am "+age+"years old.")
    }
    func("shinelon",19)
    //> my name is shinelon,i am 19years old.
    ```
    > 默认值与变长参数示例
    ```scala
    def func(name:String,age:Int=19)={
        println("my name is "+name+",i am "+age+"years old.")
    }
    func("shinelon")

    def func(nums:Int*):Int={
        if(nums.length==0) 0
    else nums.head+func(nums.tail:_*)
    }
    func(1,2,3,4,5)

    //>> res3: Int = 15
    ```
- 函数调用: 类java
    `“Hello World”.distinct()`
    `可以写为“Hello World”,distinct`