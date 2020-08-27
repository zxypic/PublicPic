
import tornado.web
import tornado.ioloop
import tornado.options
import requests

from tornado import gen
from tornado.concurrent import run_on_executor
from concurrent.futures import ThreadPoolExecutor

import time

class genHandle(tornado.web.RequestHandler):
    executor = ThreadPoolExecutor(2)

    @gen.coroutine
    def get(self):
        print("Untitled get...")
        res = yield self.sleeps()
        # self.sleeps()
        self.write("get return {}".format(res))
        self.finish()

    @run_on_executor
    def sleeps(self):
        time.sleep(5)
        return 5

class helloHandle(tornado.web.RequestHandler):
    def get(self):
        print("now handle ...")
        self.write("i hope just now see you")

class reqHandle(tornado.web.RequestHandler):
    def get(self):
        res = requests.post("http://autoapi.uusense.com/uapi/agent/getip")
        return self.write(res.text)

settings = {
    "debug":True,
    "template_path":"template"
}
application = tornado.web.Application(
    {
        (r"/gen",genHandle),
        (r"/hello",helloHandle),
        (r"/req",reqHandle),
    },**settings
)


if __name__ == "__main__":
    tornado.options.parse_command_line()
    application.listen(9900)
    # http_server = tornado.httpserver.HTTPServer(application)
    tornado.ioloop.IOLoop.instance().start()