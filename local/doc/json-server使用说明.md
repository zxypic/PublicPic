> 搭建本地的数据接口，创建json文件，便于调试调用
> get数据时，使用在线Getman即可满足需求，比较简单，post数据时无法满足需求
> https://blog.csdn.net/lhjuejiang/article/details/81475993

### 环境搭建
- 安装
    `npm install -g json-server`
    
- 建立项目文件夹

- 初始化 package.json 
    `npm init --yes`
    
- 安装json-server
    `npm i json-server --save`
    
### 编辑项目信息
> 打开package.json，修改一下"scripts"中的内容

![image-20190705140706773](http://ww1.sinaimg.cn/large/006tNc79gy1g4oximmsifj30ou0gm40i.jpg)

### 准备数据 db.json
  > 必须为标准json，不得使用单引号, 必须有id属性
  > 每个节点即为一个接口，并默认支持restful，get\post\del访问，下例即提供 posts、comments、profile三个接口
  > 对应操作后db.json数据会有对应新增、删掉等动作

  ![image-20190705141414180](http://ww4.sinaimg.cn/large/006tNc79gy1g4oxpztw25j30rw0amdh6.jpg)


### 启动json-server 服务
  >  scripts 的使用自行百度
  `npm run json:server`, 启动后会列出当前接口资源，如下：

![image-20190705141001967](http://ww1.sinaimg.cn/large/006tNc79gy1g4oxlmfk0gj30s00eswg2.jpg)

### 参数解释
- --static    设置静态文件，当做静态服务器使用
`json-server --static ./public`
- --watch     监控 json文件数据，不用重启
`json-server --watch db.json `
- --port      指定端口
`json-server --watch db.json --port 3004`
> 支持同时使用
`json-server --watch db.json --static ./public --port 3004`
- --routes    指定server路由
`json-server db.json --routes routes.json`
```json
// routes.json
{
  "/api/*": "/$1",
  "/:resource/:id/show": "/:resource/:id",
  "/posts/:category": "/posts?category=:category",
  "/articles\\?id=:id": "/posts/:id"
}
```


### 接口浏览

- http://localhost:3000/db 访问的是db.json文件下的所有内容； 
- http://localhost:3000/layoutList?categoryName= 模拟接口参数可筛选该目录下内容 
- 分页查询 参数为 _start, _end, _limit，并可添加其它参数筛选条件 
如：http://localhost:3000/posts?_start=6&_limit=3 
http://localhost:3000/posts?_start=3&_end=6 
- 排序 参数为_sort, _order ，如：
> http://localhost:3000/posts?_sort=id&_order=asc 
> http://localhost:3000/posts?_sort=user,views&_order=desc,asc 
- 操作符 _gte, _lte, _ne, _like 
> _gte大于，_lte小于， _ne非， _like模糊查询 
- q全局搜索（模糊查询）

- **localhost:3000** 浏览当前server主页
![image-20190705141158035](http://ww1.sinaimg.cn/large/006tNc79gy1g4oxnn4sk4j310j0u0dji.jpg)

#### get示例
> 获取所有用户信息
http://localhost:3000/users
> 获取id为1的用户信息
http://localhost:3000/users/1
> 获取公司的所有信息
http://localhost:3000/companies
> 获取单个公司的信息
http://localhost:3000/companies/1
> 获取所有公司id为3的用户
http://localhost:3000/companies/3/users
> 根据公司名字获取信息
http://localhost:3000/companies?name=Google
> 根据多个名字获取公司信息
http://localhost:3000/companies?name=Google&name=Apple
> 获取一页中只有两条数据
http://localhost:3000/companies?_page=1&_limit=2
> 升序排序  desc降序  asc升序
http://localhost:3000/companies?_sort=name&_order=asc
> 获取年龄为30以及30以上的
http://localhost:3000/users?age_gte=30
> 获取年龄为30到40之间的
http://localhost:3000/users?age_gte=30&age_gte=40
> 搜索用户信息
http://localhost:3000/users?q=d

### faker.js
> 如果要自己瞎编API数据的话也是比较烦恼，用faker.js就可以轻松解决这个问题啦!他可以帮助你自动生成大量fake的json数据，作为后端数据~
`npm install faker`

用javascript生成一个包含50个客户数据的json文件：
```javascript
//customers.jsvar faker = require('faker')

functiongenerateCustomers () {
  var customers = []

  for (var id = 0; id < 50; id++) {
    var firstName = faker.name.firstName()
    var lastName = faker.name.firstName()
    var phoneNumber = faker.phone.phoneNumberFormat()

    customers.push({
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phoneNumber
    })
  }

  return { "customers": customers }
}

// 如果你要用json-server的话，就需要export这个生成fake data的functionmodule.exports = generateCustomers
```