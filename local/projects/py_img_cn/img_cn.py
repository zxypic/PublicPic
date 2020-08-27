
def img_cn_pil():
    from PIL import Image, ImageDraw, ImageFont
    # 字体
    setFont = ImageFont.truetype(r"/Users/xnder/Desktop/Kaiti.ttc", 50)
    # 颜色
    fillColor = "#ff0000"
    # 读取图片
    image = Image.open("/Users/xnder/Desktop/yuantu.png")
    # 创建绘图对象
    draw = ImageDraw.Draw(image)
    width, height = image.size
    # 在图上绘制文字
    draw.text((40, height - 260), u'A陈独秀你坐下！！', font=setFont, fill=fillColor)
    draw.text((20, height - 180), u'弹幕的世界，你不懂', font=setFont, fill=fillColor)
    # 保存图片
    image.save("/Users/xnder/Desktop/yuantu2.png", 'png')

import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont

im = Image.open(r"/Users/xnder/Desktop/yuantu.png")
font = ImageFont.truetype('/Users/xnder/Desktop/Kaiti.ttc', 40)
fillColor = (255,0,0)
position = (100,100)

draw = ImageDraw.Draw(im)
draw.text(position, u'strname 你说啥a', font=font, fill=fillColor)

# 将文件临时保存，并允许绘制显示出来
# img_OpenCV = cv2.cvtColor(np.asarray(im),cv2.COLOR_RGB2BGR) #PIL读取图片和OpenCV读取rgb图片的三个通道顺序不同
# cv2.imshow("print chinese to image",img_OpenCV)
# cv2.waitKey()
# 保存磁盘
im.save("/Users/xnder/Desktop/yuantu_cv.png", 'png')