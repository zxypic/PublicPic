#coding=utf8
import rumps
import urllib
import json,sys
# reload(sys)
# sys.setdefaultencoding( "utf-8" )

class AutosenseIOSApp(rumps.App):

    def __init__(self,_):
        self.configure()

    def configure(self):
        menus = []
        menus.append("Device List")
        menus.append(rumps.MenuItem("Edit Config ...", key=','))
        super(AutosenseIOSApp, self).__init__(type(self).__name__, menu=menus)
        self.icon = 'app.icns'

    @rumps.timer(60)
    def location(self, _):
        title = ''
        url = "https://api.map.baidu.com/location/ip?ak=uFdtjZNA62UtZUi2tjdGXjIaxOt947nM"
        j = json.loads( urllib.urlopen( url ).read() )
        title = title + j['content']['address_detail']['province'] + '|' + j['content']['address_detail']['city']
        self.title = title

    @rumps.clicked("Edit Config ...")
    def Config(self, _):
        window              = rumps.Window(dimensions=(320,120),ok=u"确定",cancel="Cancel",)
        window.title        = 'Dietary Restrictions'
        window.message      = 'Information regarding dietary restrictions.'
        window.default_text = 'mlh.get_dietary_users()'
        window.run()

    @rumps.clicked('Start Server')
    def button(self, sender):
        sender.title = 'Server: Off' if 'On' in sender.title else 'Server: On'
        rumps.notification("MacIOS USB Device", None, "UDID: 358520080883866\nOS: iPhone10,4")

    @rumps.clicked("Preferences")
    def prefs(self, _):
        rumps.alert("jk! no preferences available!")

    @rumps.clicked("Silly button")
    def onoff(self, sender):
        print(sender.state)
        sender.state = not sender.state
    
    @rumps.clicked("Say hi")
    def sayhi(self, _):
        rumps.Window("I can't think of a good example app...").run()


if __name__ == "__main__":
    AutosenseIOSApp("MacAutoIOS").run()
    # app = rumps.App("AutosenseIOSApp", icon='demo.icns')
    # app.menu = [
    #     'Attendees',
    #     {
    #         'MLH': {
    #             "Guides":   ["Organiser", "Sanctions", "Code of Conduct"],
    #             "Contacts": ["Info", "Slack", "Incidents"],
    #             "Website":  []
    #         }
    #     },
    #     None,
    #     'About',
    #     None
    # ]
    # app.run()