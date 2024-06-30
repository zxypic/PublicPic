
#coding=utf8

import subprocess,re

class USBFiler(object):
    def __init__(self):
        self.udid = 'system_profiler SPUSBDataType | grep "Serial Number:.*" | sed s#".*Serial Number: "## '
        self.udid = 'system_profiler SPUSBDataType '

    def process_cmds(self,cmds):
        p = subprocess.Popen(cmds, shell=True, stdout=subprocess.PIPE)
        outlog, err = p.communicate()
        outlog = outlog.decode('utf-8')
        return outlog, err
        
    def getUSBfiler(self):
        output,status = self.process_cmds(self.udid)  
        usbfiler = output.split("Product ID")
        usblist = []
        for usb in usbfiler:
            if 'Serial' in usb:
                infos = {}
                infos['ID'] = re.search("ID.*",usb).group()
                infos['Version'] = re.search("Version.*",usb).group()
                infos['Serial'] = re.search("Serial Number.*",usb).group()
                infos['Manufacturer'] = re.search("Manufacturer.*",usb).group()
                usblist.append(infos)
        return status,usblist
    
    def Usb_apple(self):
        _,usblist = self.getUSBfiler()
        apple_device = []
        for usb in usblist:
            if "Apple" in usb['Manufacturer']:
                print("apple device: %s" % re.search(r": (\w+)",usb['Serial']).group(1))
                apple_device.append(re.search(r": (\w+)",usb['Serial']).group(1))
            else:
                print("other device: %s" % re.search(r": (\w+)",usb['Serial']).group(1))
        return apple_device


# USBdevice = USBFiler()
# apple_device = USBdevice.Usb_apple()


