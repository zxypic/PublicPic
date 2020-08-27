import rumps
import urllib
import json,sys
# reload(sys)
# sys.setdefaultencoding( "utf-8" )

class AwesomeStatusBarApp(rumps.App):
    def __init__(self):
        super(AwesomeStatusBarApp, self).__init__("Awesome App")

    @rumps.timer(60)
    def location(self, _):
        title = ''
        url = "https://api.map.baidu.com/location/ip?ak=uFdtjZNA62UtZUi2tjdGXjIaxOt947nM"
        j = json.loads( urllib.urlopen( url ).read() )
        title = title + j['content']['address_detail']['province'] + '|' + j['content']['address_detail']['city']
        self.icon = 'app.icns'
        self.title = title

    @rumps.clicked("window")
    def winbtn(self,sender):
        wins = rumps.Window(dimensions=(220,18),cancel = "NO",ok="YES")
        wins.title = 'titles'
        wins.default_text = "some thing Response hwo get it"
        wins.messages = "msg"
        wins.add_button("txt")
        wins.run()
        print(sender.state)

    @rumps.clicked('On')
    def button(self, sender):
        sender.title = 'Off' if sender.title == 'On' else 'On'
        rumps.Window("I can't think of a good example app...").run()

    @rumps.clicked('Start Server')
    def ServerBtn(self, sender):
        sender.title = 'Server: Off' if 'On' in sender.title else 'Server: On'
        rumps.notification("MacIOS Device", "USB Connected", "UDID: 358520080883866\nOS: iPhone10,4")

    @rumps.clicked('Testing')
    def tester(self,sender):
        sender.state = not sender.state
        print(sender.state)

    @rumps.clicked('notification')
    def sayhi(self, _):
        rumps.notification("Awesome title", "amazing subtitle", "message hi!!1")
        # rumps.notification("title", "subtitle", "message", data=None, sound=True, action_button=None, other_button=None, has_reply_button=False, icon=None)

if __name__ == "__main__":
    AwesomeStatusBarApp().run()