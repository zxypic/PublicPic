from setuptools import setup

APP = ['gui_demo.py']
APP_NAME = "tester"
DATA_FILES = []
OPTIONS = {
    'argv_emulation': True,
    'iconfile': 'demo.icns',
    'plist': {
        'LSUIElement': True,
        'CFBundleName': APP_NAME,
        'CFBundleDisplayName': APP_NAME,
        'CFBundleGetInfoString': "Making xuyang",
        'CFBundleShortVersionString': "0.1.0",
        'NSHumanReadableCopyright': u"Copyright (C) 2018, XuChang Xndery Technology Inc, All Rights Reserved"
    },
    'packages': ['requests','rumps'],
}

setup(
    name=APP_NAME,
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)