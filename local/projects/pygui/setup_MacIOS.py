"""
This is a setup.py script generated by py2applet

Usage:
    python setup.py py2app
"""

from setuptools import setup

APP = ['MacIOS_GUI.py']
APP_NAME = "MacIOS"
DATA_FILES = []
OPTIONS = {
    'argv_emulation': True,
    'iconfile': 'app.icns',
    'plist': {
        'CFBundleName': APP_NAME,
        'CFBundleDisplayName': APP_NAME,
        'CFBundleGetInfoString': "Making xuyang",
        'CFBundleIdentifier': "com.autosense.osx.uu",
        'CFBundleVersion': "18.12.14.15",
        'CFBundleShortVersionString': "0.1.1",
        'NSHumanReadableCopyright': u"Copyright (C) 2018, Hangzhou Uusense Technology Inc, All Rights Reserved"
    },
    'packages': ['rumps'],
}

setup(
    name=APP_NAME,
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
