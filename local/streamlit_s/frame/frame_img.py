import cv2
from pathlib import Path
import skvideo.io
import click

class frame_img(object):

    def __init__(self,mpath=False):
        self.mp4 = Path(mpath) if mpath else Path('/Users/xnder/Downloads/IMG_1857.MOV')
        self.fram_path = Path(self.mp4.parent,self.mp4.stem)
        print(self.mp4.absolute())

    def frame_cv(self):
        self.mcv = cv2.VideoCapture(str(self.mp4.absolute()))
        return self.mcv

    def save_img(self):
        vc = self.frame_cv()
        Path(self.fram_path).mkdir(exist_ok=True)
        c=0
        rval = vc.isOpened()
        while rval: 
            c = c + 1
            rval, frame = vc.read()
            if rval:
                cv2.imwrite(str(Path(self.fram_path,'frame_{}.jpg'.format(c))), frame) 
                cv2.waitKey(1)
            else:
                break
        self.get_fps()
        click.secho(f'save : {self.fram_path}  frames : {c} as success', fg="yellow")
    
    def fram_comHist(self, img1, img2, threshold = 0.9):
        """ 图片直方图、归一化处理, compareHist相似度比较 
        直方图反映的是图像像素灰度值的概率分布
        """
        # img1 = cv2.imread(image1)
        H1 = cv2.calcHist([img1], [1], None, [256], [0, 256])
        H1 = cv2.normalize(H1, H1, 0, 1, cv2.NORM_MINMAX, -1)  
        # img2 = cv2.imread(image2)
        H2 = cv2.calcHist([img2], [1], None, [256], [0, 256])
        H2 = cv2.normalize(H2, H2, 0, 1, cv2.NORM_MINMAX, -1)  # 对图片进行归一化处理
        similarity = cv2.compareHist(H1, H2, 0)    # 利用compareHist（）进行比较相似度
        return similarity if similarity >= threshold else None

    def fram_imwrite(self, start_frame=None, end_frame=None):
        video_file = self.mp4
        reader = skvideo.io.FFmpegReader(str(video_file))
        pos_frame = 0
        extract = 0
        last_fram = "None"
        for frame in reader.nextFrame():
            if start_frame and pos_frame <= start_frame:
                # print("continue","pos_frame < start_frame : {}<{}".format(pos_frame, start_frame))
                pos_frame += 1
                continue 
            if end_frame and pos_frame > end_frame:
                print("break","pos_frame > end_frame : {}>{}".format(pos_frame, end_frame))
                break 
            
            """ 相似度进行图片对比，如果出现帧相似则记录为卡顿帧"""
            if not len(last_fram)>5 :
                last_fram = frame   # last fram imgs
                continue
            pos_frame += 1

            matched = self.fram_comHist(last_fram, frame, threshold=0.999)
            last_fram = frame   
            if matched:
                extract = extract + 1
            print("pos({}): extract {}\t{}".format(pos_frame, extract, matched))

        frame_no = end_frame - start_frame
        fps = self.get_fps()
        # 流畅度指标的计算方法，起点到终点的不同帧数/起点到终点的耗时，最终单位转换为帧/秒
        sm1 = (frame_no-extract)/(frame_no*16.66666666)
        sm = fps*(frame_no-extract)/frame_no
        click.secho(f"frame_no : {frame_no}\tfps : {fps}\tsm : {sm} ({sm1})",fg='yellow')
        return sm

    def get_fps(self):
        vc = self.frame_cv()
        fps = vc.get(cv2.CAP_PROP_FPS)
        click.secho(f"Frames per second using video.get(cv2.CAP_PROP_FPS) : {fps}",fg='yellow')
        return round(fps)

    def release(self):
         self.mcv.release()


    def all_save_img(self):
        vpath = Path('/Users/xnder/Downloads/IMG_1857.MOV')
        fram_path = Path(vpath.parent,vpath.stem)
        Path(fram_path).mkdir(exist_ok=True)
        vc = cv2.VideoCapture(str(vpath.absolute()))
        c=0
        rval=vc.isOpened()

        while rval: 
            c = c + 1
            rval, frame = vc.read()
            if rval:
                cv2.imwrite(str(Path(fram_path,'image_{}.jpg'.format(c))), frame) 
                # cv2.waitKey(1)
            else:
                break
        fps = vc.get(cv2.CAP_PROP_FPS)
        print("Frames per second using video.get(cv2.CAP_PROP_FPS) : {0}".format(fps))
        vc.release()
        print('save',fram_path,"frames",c,"as success")



if __name__ == "__main__":
    mfram = frame_img("/Users/xnder/Downloads/0210/VID_20200210_174522.mp4")
#     mfram = frame_img()
    mfram.get_fps() # 获取帧率
#     # mfram.fram_imwrite(340,362)   # 计算帧间流畅度
#     # mfram.save_img()  # 视频拆帧
    mfram.release()