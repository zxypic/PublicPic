## 
Starlette 很赞，但它太迷你了，虽然给了开发者很大的自由，但有时，用户要的其实只是一个能快速完成任务的框架。

Sebastián Ramírez 就是出于这个目的开发的 FastAPI，怎么说呢？这个支持库的各个方面都很 Fast。

这个用 Python 开发 API 的新框架具有超高性能，而且可以基于 OpenAPI 标准自动生成交互式文档。默认支持 Swagger UI 与 ReDoc，允许直接从浏览器调用、测试 API，从而提高开发效率。用这个框架开发 API，真的是又快又简单。

该支持库还支持现代 Python 最佳实用功能之一：类型提示。FastAPI 在很多方面都使用了类型提示，其中最酷的一个功能是由 Pydantic 加持的自动数据验证与转换。

FastAPI 基于 Starlette 开发，性能与 NodeJS 和 GO 相当，还自带 WebSocket 与 GraphQL 原生支持。

最后，对于开源支持库而言，它的技术支持文档也非常不错。说真的，去看一下吧！

作者：呆鸟的简书
链接：https://www.jianshu.com/p/d65e913e7f26
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


## 安装
> pip3 install fastapi[all]
`fastapi`、`uvicorn`、`pydantic`、`starlette`

- fastapi 异步请求
- uvicorn ASGI服务器，加载和提供应用程序的服务器。
- pydantic 
    - ujson 更快的JSON
    - email_validator 电子邮件的验证

1. Pydantic提供:
- ujson - 更快的JSON
- email_validator - 电子邮件的验证

2. Starlette提供:
- requests - 如果你想要使用TestClient, 需要导入requests.
- aiofiles - 如果你想使用FileResponse or StaticFiles, 需要导入aiofiles.
- jinja2 - 如果你想使用默认的模板配置，需要导入jinjia2.
- python-multipart -如果要使用request.form（）支持表单“解析”，则为必需。
- itsdangerous -“SessionMiddleware”支持需要。
- pyyaml - 如果需要 SchemaGenerator 支持, 则为必要.
- graphene -如果需要 GraphQLApp 支持, 则为必要.
- ujson - 如果你想使用 UJSONResponse, 则为必要.

3. FastAPI / Starlette提供:
- uvicorn - 加载和提供应用程序的服务器.